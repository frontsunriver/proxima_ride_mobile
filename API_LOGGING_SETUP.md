# API Logging Setup Guide

## ✅ What's Been Done

### 1. Created API Logger Utility
- **File:** `lib/utils/api_logger.dart`
- Logs all API requests and responses with formatted output
- Shows URL, headers, POST/GET data, and response data
- Color-coded console output (🌐 for API, ✅ for success, ❌ for errors)

### 2. Created Logged GetConnect Wrapper
- **File:** `lib/utils/logged_get_connect.dart`
- Extends GetConnect to automatically log all API calls
- Supports GET, POST, PUT, DELETE methods
- Logs requests before sending and responses after receiving

### 3. Updated Providers (Already Done)
- ✅ `lib/pages/login/LoginProvider.dart`
- ✅ `lib/pages/book_seat/BookSeatProvider.dart`
- ✅ `lib/pages/post_ride/PostRideProvider.dart`

## 📝 How to Update Remaining Providers

For each provider file, make TWO changes:

### Step 1: Add Import Statement
Add this line after other imports:
```dart
import 'package:proximaride_app/utils/logged_get_connect.dart';
```

### Step 2: Replace GetConnect with LoggedGetConnect
Change this line:
```dart
final getConnect = GetConnect(timeout: const Duration(seconds: XXX));
```

To this:
```dart
final getConnect = LoggedGetConnect(timeout: const Duration(seconds: XXX));
```

## 📂 Remaining Provider Files to Update (35 files)

Run this command to update all remaining providers:

### For PowerShell:
```powershell
# Update GetConnect to LoggedGetConnect
Get-ChildItem -Path "lib" -Filter "*Provider.dart" -Recurse | ForEach-Object {
    $content = Get-Content $_.FullName
    $updated = $false
    
    # Check if already has LoggedGetConnect
    if ($content -notmatch "LoggedGetConnect") {
        # Add import if not present
        if ($content -notmatch "logged_get_connect.dart") {
            $content = $content -replace "(import 'package:get/get_connect/connect.dart';)", "`$1`nimport 'package:proximaride_app/utils/logged_get_connect.dart';"
            $updated = $true
        }
        
        # Replace GetConnect with LoggedGetConnect
        $content = $content -replace "GetConnect\(timeout:", "LoggedGetConnect(timeout:"
        
        if ($updated) {
            Set-Content -Path $_.FullName -Value $content
            Write-Host "✅ Updated: $($_.Name)"
        }
    }
}
```

### Or Update Manually:

1. **lib/pages/student_card/StudentCardProvider.dart**
2. **lib/pages/trip_detail/TripDetailProvider.dart**
3. **lib/pages/stages/StageProvider.dart**
4. **lib/pages/search_ride/SearchRideProvider.dart**
5. **lib/pages/review_detail/ReviewDetailProvider.dart**
6. **lib/pages/signup/SignupProvider.dart**
7. **lib/pages/review/ReviewProvider.dart**
8. **lib/pages/profile_photo/ProfilePhotoProvider.dart**
9. **lib/pages/referals/ReferralProvider.dart**
10. **lib/pages/profile_detail/ProfileDetailProvider.dart**
11. **lib/pages/password/PasswordProvider.dart**
12. **lib/pages/old_messages/OldMessagesProvider.dart**
13. **lib/pages/post_ride_again/PostRideAgainProvider.dart**
14. **lib/pages/payment_options/PaymentOptionsProvider.dart**
15. **lib/pages/payout_account/PayoutAccountProvider.dart**
16. **lib/pages/notifications/NotificationProvider.dart**
17. **lib/pages/my_vehicle/MyVehicleProvider.dart**
18. **lib/pages/navigation/navigationProvider.dart**
19. **lib/pages/my_wallet/MyWalletProvider.dart**
20. **lib/pages/my_reviews/MyReviewsProvider.dart**
21. **lib/pages/my_trips/MyTripProvider.dart**
22. **lib/pages/my_phone_number/MyPhoneNumberProvider.dart**
23. **lib/pages/my_passenger/MyPassengerProvider.dart**
24. **lib/pages/messaging_page/MessagingProvider.dart**
25. **lib/pages/contact_us/ContactUsProvider.dart**
26. **lib/pages/location/LocationProvider.dart**
27. **lib/pages/driver_license/DriverLicenseProvider.dart**
28. **lib/pages/deep_trip_detail/DeepTripDetailProvider.dart**
29. **lib/pages/edit_profile/EditProfileProvider.dart**
30. **lib/pages/email_address/EmailAddressProvider.dart**
31. **lib/pages/forget_password/ForgetPasswordProvider.dart**
32. **lib/pages/co_passenger/CoPassengerProvider.dart**
33. **lib/pages/close_my_account/CloseAccountProvider.dart**
34. **lib/pages/add_card/AddCardProvider.dart**
35. **lib/MainProvider.dart**
36. **lib/pages/chat/ChatProvider.dart**

## 🔍 What You'll See in Logs

### GET Request Example:
```
================================================================================
📤 GET REQUEST
URL: https://api.example.com/api/languages
Headers: {Accept: application/json}
================================================================================
```

### POST Request Example:
```
================================================================================
📤 POST REQUEST
URL: https://api.example.com/api/login
Headers: {X-Requested-With: XMLHttpRequest}
POST Data: {
  "email": "user@example.com",
  "password": "******",
  "lang_id": "2"
}
================================================================================
```

### Response Example:
```
================================================================================
✅ RESPONSE
URL: https://api.example.com/api/login
Status Code: 200
Response Body: {
  "status": "Success",
  "token": "abc123...",
  "user": {
    "id": 1,
    "name": "John Doe"
  }
}
================================================================================
```

### Error Example:
```
================================================================================
❌ API ERROR
URL: https://api.example.com/api/login
Error: Connection timeout
================================================================================
```

## 🎯 Benefits

1. **Complete Visibility**: See all API calls in console
2. **Debugging Made Easy**: Track request/response data
3. **Error Tracking**: Quickly identify API failures
4. **Performance Monitoring**: See which APIs are being called
5. **Data Validation**: Verify sent and received data

## 🚀 Quick Test

After updating providers, run the app and perform login:
1. Open the app
2. Try to login
3. Check the console/terminal
4. You'll see detailed API logs!

## 📌 Notes

- Logs appear in both `developer.log` and `print()` for maximum visibility
- Works with Android Studio, VS Code, and terminal
- No performance impact - logging is very fast
- Can be disabled by removing LoggedGetConnect usage

---

**Status**: 3/38 providers updated. Run the PowerShell script or update manually to complete setup!

