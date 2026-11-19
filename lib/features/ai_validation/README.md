# AI photo validation

Checks whether a report photo shows a possible dengue mosquito breeding site,
using Gemini through Firebase AI Logic (Gemini Developer API).

Camera, GPS, the AI check, the duplicate check, the decision and the Report
screen flow are done. The Report screen also saves the result and awards points
(see "Saving the result").

## What is here

| File | Purpose |
|---|---|
| `ai_config.dart` | The Gemini model name (one constant), request timeout, minimum confidence (0.7). |
| `ai_prompts.dart` | System instruction and prompt for the photo check. |
| `ai_validation_service.dart` | `AiValidationService.validatePhoto(Uint8List jpegBytes)`. |
| `validation_result.dart` | `ValidationResult` and `SiteCategory`. |
| `capture_service.dart` | `captureReportPhoto()`: live camera photo plus a GPS fix. |
| `capture_result.dart` | `CaptureResult` (photo + GPS, or why it failed). |
| `duplicate_check.dart` | `isDuplicate(lat, lng)`: is there a valid report within 20 m from the last 7 days? See "Duplicate check". |
| `geohash.dart` | `encode(lat, lng, precision)`, `bounds(hash)`, `neighbours(hash)` (the 8 surrounding cells). No package. |
| `haversine.dart` | `haversineMeters(lat1, lng1, lat2, lng2)`. |
| `report_decision.dart` | `decide(ai, capture, isDuplicate)`: the eligibility rule. |
| `report_check_controller.dart` | Runs validatePhoto, then the duplicate check, then `decide()`. |
| `report_outcome.dart` | `ReportOutcome` and the `onDecision` callback type. |
| `dev_live_test.dart` | Debug-only live test (see Testing). |

## How the Report screen uses it

The whole flow lives in `lib/features/report/report_screen.dart` (form, checking,
approved, rejected). Submit is enabled only after a live camera photo with a
valid GPS fix (within 50 m). Then:

1. **Checking:** `ReportCheckController.check()` runs. The screen shows real
   progress. If the check itself fails (network, quota, App Check, duplicate
   lookup error) the user gets **Try again / Retake photo**; nothing is
   approved on an error.
2. **Approved** or **Rejected** is decided by `decide()`. A report is eligible
   only if the AI says it is a breeding site with confidence of at least 0.7,
   the photo does not look fake, it is not a duplicate, and GPS is within 50 m.

## Saving the result (reports, photo and points)

After the check, `ReportScreen` saves the result itself with
`FirestoreService.submitReport` (`lib/services/firestore_service.dart`). What is
written is decided by `buildReportWritePlan` (`lib/services/report_write_plan.dart`)
and is written in **one write batch**, so it all happens or none of it does:

| Result | `reports/{id}` | `reportPhotos/{id}` | `users/{uid}` points |
|---|---|---|---|
| **Approved** (`status: 'valid'`) | yes | yes (the only place the photo is stored) | `+10` (`kPointsPerValidReport`) on `pointsBalance` and `points` |
| **Rejected** (`status: 'rejected'`) | yes (AI fields and geohash included) | **no** | **no** |

- The `reports` document never contains the photo (no `imageUrl` / `photoUrl`).
  Anything that shows a photo loads it for that one report with
  `FirestoreService.getReportPhoto(reportId)` (cached; placeholder while loading
  or if missing). Lists, the map and the duplicate check read `reports` only; a
  test (`test/services/report_photos_access_test.dart`) fails if that changes.
- `type` and `aiCategory` are saved as wire values (`stagnant_water`, `tire`,
  `blocked_drain`, `container`, `other`, `none`). Older documents with enum names
  (`blockedDrain`) are converted when read.
- `createdAt` is the server's time; `geohash` is `encode(lat, lng, 9)` from
  `geohash.dart`, so the duplicate check can find the report.
- `confirmationCount` is for community "still there" confirmations, not a gate.

**Failures.** `submitReport` never swallows an error. If saving fails the
Approved view shows "Couldn't save your report" with **Retry** (re-runs only the
save, not the AI check) and **Retake photo**, and never claims points were added.
"+10 points added" appears only after the save succeeded. Each outcome gets one
report id; Retry reuses it, and `submitReport` writes nothing (and awards no
points) if that report already exists on the server, so a retry cannot save the
report or the points twice. The "already saved?" check reads from the server
only, so being offline fails the save instead of queueing a write.

## Hook for other code (`onDecision`)

`ReportScreen` also has an optional callback, if something else needs to react
to a result:

```dart
ReportScreen(onDecision: (ReportOutcome outcome) { ... });
```

It is called **once per completed check** with a final approved or rejected
decision, when that decision is made (before the save finishes). It is **not**
called when the check itself failed (the user retries instead). `ReportOutcome`
contains:

- `capture.jpegBytes`, `capture.latitude`, `capture.longitude`,
  `capture.accuracyMeters`: the live photo and GPS fix
- `validation.category`, `validation.confidence`, `validation.reason`,
  `validation.looksFake`: the AI result
- `isDuplicate`, `decision.eligible`, `decision.reason`, `checkedAt`

Do not save the report again from this callback: the screen already does.

## Duplicate check

`isDuplicate(lat, lng)` in `duplicate_check.dart`:

1. Takes the precision-6 geohash of the point (a cell about 1.2 km x 0.6 km)
   and its 8 neighbours. Together they always cover the 20 m radius.
2. Runs one range query per cell on `reports`, in parallel:
   `orderBy('geohash').startAt([prefix]).endAt([prefix + '\uf8ff'])`. Reads
   come from the **server only**. Offline, the queries fail; they do not
   silently use the cache.
3. Filters the results on the phone (`matchesDuplicate`): `status ==
   'valid'`, `createdAt` within the last 7 days, and Haversine distance
   ≤ 20 m from `location`. Documents missing `createdAt` or `location` are
   ignored.
4. Returns true if anything matches. If any query fails it **throws**, and the
   check controller shows the retryable error. A failed lookup is never treated
   as "not a duplicate".

Only a single-field index on `geohash` is needed, which Firestore creates
automatically. Status and date are filtered on the phone, so no composite index
is needed. Each check reads every report in 9 cells (about 3.3 km x 1.8 km).
That is fine at coursework scale.

## Demo controls

The old "UI FLOW" stage bar and the Simulate Approved/Rejected buttons are hidden
by default. Show them for demos with:

```bash
flutter run --dart-define=DEMO_CONTROLS=true
```

`validatePhoto` never throws. Any failure (network, timeout, quota, App Check
rejection, malformed reply) returns `ValidationResult.error(...)`, which is
never a breeding site and so can never lead to a verified report.

The checks run on the phone, so a determined user could bypass them. That is
acceptable for this coursework project; real enforcement would need Firestore
rules or a server function.

## Testing

### Unit tests

```bash
flutter test test/features/ai_validation
```

### Live test with real photos (needs your own App Check debug token)

Firebase AI Logic requires App Check. Debug builds use the App Check *debug
provider*, which generates a token per app install. Gemini calls from your phone
are rejected until that token is registered in the Firebase console.

1. Run the app once on your phone or emulator:
   ```bash
   flutter run -d <deviceId>
   ```
2. Find your debug token. Look in the `flutter run` output for a line like
   ```
   Enter this debug secret into the allow list in the Firebase Console for your project: <uuid>
   ```
   If it is not in the `flutter run` output, read it from the Android log:
   ```bash
   adb logcat -c            # clear the log, then restart the app
   adb logcat -d | grep -i "debug secret"        # Git Bash
   adb logcat -d | Select-String "debug secret"  # PowerShell
   ```
   On iOS, search the Xcode console for `App Check debug token`.
3. **Send the token privately to the branch owner (Manuja) so they can register
   it** under Firebase console > App Check > Apps > Manage debug tokens. Do not
   commit it, paste it into code, or post it in a public place.
4. The token changes if you uninstall the app or clear its data. Repeat the
   steps above if the AI calls start failing with App Check errors.
5. Put your own `.jpg` or `.jpeg` photos in `assets/dev_samples/`. The folder
   is tracked only through `.gitkeep`; the photos are git-ignored and stay on
   your machine. Good test set: a tyre or pot holding water, a clean room, a
   photo of a screen showing a puddle, and a selfie.
6. Run the live test:
   ```bash
   flutter run -d <deviceId> --dart-define=AI_LIVE_TEST=true
   ```
   The test only runs in debug builds and only with that flag. Each photo's full
   `ValidationResult` is printed with the prefix `AI LIVE TEST`:
   ```bash
   adb logcat -d | grep "AI LIVE TEST"
   ```
   `isError: true` means the call or the reply failed; the error text says why.

### Testing the Report screen without a real camera (emulator)

The emulator camera only shows a virtual scene, which the AI correctly rejects as
fake. To test the whole Report flow with a real photo, use the debug capture
override:

```bash
flutter run -d <deviceId> --dart-define=DEBUG_CAPTURE_ASSET=assets/dev_samples/drain.jpg
```

With this set, tapping **Camera** skips the camera and uses that bundled asset as
the photo. Location services, location permission and the GPS fix (within 50 m)
are still checked for real, so set a location on the emulator first. It only
works in debug builds (`kDebugMode`) and is ignored in profile and release
builds. Leave the flag out for the normal camera. The photo must be a `.jpg`
inside `assets/dev_samples/` (git-ignored, so use your own).

In debug builds the check also prints timings and the AI result, prefixed
`AI TIMING` and `AI RESULT`:

```bash
adb logcat -d | grep -E "AI TIMING|AI RESULT"
```

Sample photos must be **real JPEG data**. A web download saved as `.jpg` is often
really WebP; the app rejects those ("The photo could not be read"). Check with
`file assets/dev_samples/*.jpg` and convert if needed.
