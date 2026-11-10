import 'dart:async';
import 'dart:typed_data';

import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import 'capture_result.dart';

/// How long to wait for a GPS fix after the photo is taken.
const Duration kGpsTimeout = Duration(seconds: 15);

/// Takes a live camera photo and a GPS fix for a report.
///
/// Order: location services and permission are checked first (so nobody takes
/// a photo that can never be used), then the camera opens, then the GPS fix is
/// read right after the photo so it reflects where the photo was taken.
///
/// Never throws: every problem comes back as a [CaptureResult.failure] with a
/// message that can be shown to the user. Photos can only come from the camera;
/// the gallery is deliberately not supported.
Future<CaptureResult> captureReportPhoto() async {
  try {
    // 1. Location services and permission, before opening the camera.
    if (!await Geolocator.isLocationServiceEnabled()) {
      return const CaptureResult.failure(
        CaptureFailure.locationServicesOff,
        'Location is turned off. Turn it on to verify where the photo was '
        'taken.',
      );
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      return const CaptureResult.failure(
        CaptureFailure.locationPermissionDeniedForever,
        'Location permission is blocked. Allow it for CleanSpot in your '
        'phone settings.',
      );
    }
    if (permission == LocationPermission.denied) {
      return const CaptureResult.failure(
        CaptureFailure.locationPermissionDenied,
        'CleanSpot needs your location to verify the report.',
      );
    }

    // 2. Camera (live photo only).
    final XFile? photo;
    try {
      photo = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 1280,
        imageQuality: 80,
        requestFullMetadata: false,
      );
    } catch (_) {
      return const CaptureResult.failure(
        CaptureFailure.cameraFailed,
        'Could not open the camera. Check that CleanSpot is allowed to use it.',
      );
    }
    if (photo == null) {
      return const CaptureResult.failure(
        CaptureFailure.cancelled,
        'No photo was taken.',
      );
    }
    final Uint8List bytes = await photo.readAsBytes();
    if (!looksLikeJpeg(bytes)) {
      return const CaptureResult.failure(
        CaptureFailure.notJpeg,
        'The photo could not be read. Please try again.',
      );
    }

    // 3. GPS fix right after the photo.
    final Position position;
    try {
      position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          timeLimit: kGpsTimeout,
        ),
      );
    } on TimeoutException {
      return const CaptureResult.failure(
        CaptureFailure.locationTimeout,
        'Could not get a GPS fix. Move to an open area and try again.',
      );
    } on LocationServiceDisabledException {
      return const CaptureResult.failure(
        CaptureFailure.locationServicesOff,
        'Location is turned off. Turn it on to verify where the photo was '
        'taken.',
      );
    } on PermissionDeniedException {
      return const CaptureResult.failure(
        CaptureFailure.locationPermissionDenied,
        'CleanSpot needs your location to verify the report.',
      );
    } catch (_) {
      return const CaptureResult.failure(
        CaptureFailure.locationUnavailable,
        'Could not read your location. Please try again.',
      );
    }

    if (!isAccuracyAcceptable(position.accuracy)) {
      return CaptureResult.failure(
        CaptureFailure.lowAccuracy,
        'GPS is not accurate enough (about ${position.accuracy.round()} m). '
        'Move to an open area and try again.',
      );
    }

    return CaptureResult.success(
      jpegBytes: bytes,
      latitude: position.latitude,
      longitude: position.longitude,
      accuracyMeters: position.accuracy,
    );
  } catch (_) {
    return const CaptureResult.failure(
      CaptureFailure.cameraFailed,
      'Something went wrong. Please try again.',
    );
  }
}
