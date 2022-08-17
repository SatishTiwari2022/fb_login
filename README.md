# fb_login


Facebook SDK version, used in plugin:

iOS: ^14.1 (CocoaPods)
Android: ^14.1 (Maven)


Minimum requirements

iOS 11.0 and higher.

Android 4.1 and newer (SDK 16).

Also package require Android embedding v2. So if your project was create with Flutter pre 1.12 you should upgrade it

Usage in application
You can:

log in via Facebook;
get access token;
get user profile;
get user profile image url;
get user email (if has permissions);
check if logged in;
log out.
Sample code:

import 'package:flutter_login_facebook/flutter_login_facebook.dart';

// Create an instance of FacebookLogin
final fb = FacebookLogin();

// Log in
final res = await fb.logIn(permissions: [
  FacebookPermission.publicProfile,
  FacebookPermission.email,
]);

// Check result status
switch (res.status) {
  case FacebookLoginStatus.success:
    // Logged in
    
    // Send access token to server for validation and auth
    final FacebookAccessToken accessToken = res.accessToken;
    print('Access token: ${accessToken.token}');

    // Get profile data
    final profile = await fb.getUserProfile();
    print('Hello, ${profile.name}! You ID: ${profile.userId}');

    // Get user profile image url
    final imageUrl = await fb.getProfileImageUrl(width: 100);
    print('Your profile image: $imageUrl');

    // Get email (since we request email permission)
    final email = await fb.getUserEmail();
    // But user can decline permission
    if (email != null)
      print('And your email is $email');

    break;
  case FacebookLoginStatus.cancel:
    // User cancel log in
    break;
  case FacebookLoginStatus.error:
    // Log in failed
    print('Error while log in: ${res.error}');
    break;
}
[Android] Express login
Express Login helps users log in with their Facebook account across devices and platforms. If a person has logged into your app before on any platform, you can use Express Login to log them in with their Facebook account on Android, instead of asking for them to select a login method, which sometimes resulted in creating duplicate accounts or even failing to log in at all.

See documentation.

Example:

import 'package:flutter_login_facebook/flutter_login_facebook.dart';

// Create an instance of FacebookLogin
final fb = FacebookLogin();

// Log in
final res = await fb.expressLogin();

if (res.status == FacebookLoginStatus.success) {
  final FacebookAccessToken accessToken = res.accessToken;
  print('Access token: ${accessToken.token}');
}
Only for Android.

If you targets Android 11 or higher, you should add

<queries>
  <package android:name="com.facebook.katana" />
</queries>


This Sample for IOS
![ezgif com-gif-maker](https://user-images.githubusercontent.com/107614710/185034968-e536beec-de17-4f11-a6e2-47b819d7a3ad.gif)

This Is For Android

![Screen Recording 2022-07-20 at 12 (1)](https://user-images.githubusercontent.com/107614710/185035208-d1b01081-ce42-4a29-ab55-daf8e8bce1be.gif)


