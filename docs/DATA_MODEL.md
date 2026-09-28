# CleanSpot Data Model

This document outlines the Cloud Firestore database collections, document structures, and field definitions for the CleanSpot platform.

---

## Collections Overview

| Collection | Description |
|---|---|
| `users` | User profile information and accumulated points balance. |
| `reports` | Mosquito-breeding site reports submitted by users, including media, geolocation, and verification status. |
| `coupons` | Rewards available for redemption using points. |
| `redemptions` | Records of coupons redeemed by users. |

---

## 1. `users` Collection

Stores user profile and gamification balance data.

- **Document ID**: User UID (matches Firebase Authentication UID)

### Fields

| Field | Type | Description |
|---|---|---|
| `displayName` | `string` | Display name of the user. |
| `pointsBalance` | `int` | Current balance of points accumulated by the user. |
| `createdAt` | `timestamp` | Timestamp when the user account was registered. |

---

## 2. `reports` Collection

Stores reports of potential mosquito-breeding sites submitted by community members.

- **Document ID**: Auto-generated unique ID

### Fields

| Field | Type | Description |
|---|---|---|
| `reporterId` | `string` | UID of the user who submitted the report (references `users`). |
| `photoUrl` | `string` | Firebase Storage download URL for the site photograph. |
| `location` | `GeoPoint` | Geographic coordinates (`latitude`, `longitude`) of the breeding site. |
| `geohash` | `string` | Geohash string computed from the location for radius and proximity queries. |
| `status` | `string` | Status of the report: `'pending'`, `'approved'`, or `'rejected'`. |
| `confirmationCount` | `int` | Number of community/admin confirmations for the report. |
| `createdAt` | `timestamp` | Timestamp when the report was submitted. |
| `lastConfirmedAt` | `timestamp` | Timestamp when the report was last confirmed/verified. |

---

## 3. `coupons` Collection

Stores reward vouchers and coupons available for redemption.

- **Document ID**: Auto-generated unique ID

### Fields

| Field | Type | Description |
|---|---|---|
| `code` | `string` | Coupon or discount code. |
| `value` | `string` | Reward value or discount description (e.g., "$5 Off", "15% Discount"). |
| `pointsCost` | `int` | Point cost required to redeem this coupon. |
| `status` | `string` | Availability status: `'available'` or `'redeemed'`. |

---

## 4. `redemptions` Collection

Stores records of redeemed coupons.

- **Document ID**: Auto-generated unique ID

### Fields

| Field | Type | Description |
|---|---|---|
| `userId` | `string` | UID of the user who redeemed the coupon (references `users`). |
| `couponId` | `string` | ID of the coupon that was redeemed (references `coupons`). |
| `redeemedAt` | `timestamp` | Timestamp when the redemption occurred. |
