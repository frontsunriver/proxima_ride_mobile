import 'dart:io';
import 'package:flutter/material.dart';

/// Utility class for detecting Android navigation mode and calculating appropriate spacing
class NavigationUtils {
  /// Detects if the device is using 3-button navigation (Android only)
  /// Returns true if 3-button navigation, false if gesture navigation or iOS
  static bool isThreeButtonNavigation(BuildContext context) {
    // iOS doesn't have 3-button navigation, only gesture mode
    if (Platform.isIOS) {
      return false;
    }
    
    // Android detection
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    // 3-button navigation typically has higher bottom padding (48+)
    // Gesture navigation is usually 0-24
    return bottomPadding >= 30;
  }

  /// Returns dynamic bottom padding based on navigation mode and platform
  /// Use this for content that needs to avoid the navigation bar / home indicator
  /// On iOS: Returns safe area padding to avoid home indicator
  /// On Android: Returns conditional padding based on 3-button vs gesture navigation
  static double getBottomPadding(BuildContext context, {double? threeButtonPadding, double? gesturePadding}) {
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    
    if (Platform.isIOS) {
      // On iOS, respect the safe area (home indicator area)
      // Home indicator area is typically ~34px on modern iPhones
      return bottomPadding;
    }
    
    // Android: detect navigation mode
    final isThreeButton = isThreeButtonNavigation(context);
    if (isThreeButton) {
      // 3-button nav: add extra padding plus the nav bar height
      return (threeButtonPadding ?? 80.0);
    } else {
      // Gesture nav: minimal padding
      return (gesturePadding ?? 20.0);
    }
  }

  /// Returns the height box value based on navigation mode
  /// Useful for adding spacing at the bottom of scrollable content
  static double getBottomSpacing(BuildContext context) {
    return getBottomPadding(context, threeButtonPadding: 80.0, gesturePadding: 20.0);
  }

  /// Returns the additional padding to add to base padding for bottom buttons
  /// This should be ADDED to your base padding value
  /// Returns viewPadding.bottom on iOS or 3-button Android, 0 on gesture Android
  static double getAdditionalBottomPadding(BuildContext context) {
    if (Platform.isIOS) {
      // iOS: Add safe area padding for home indicator
      return MediaQuery.of(context).viewPadding.bottom;
    }
    
    // Android: Add padding only for 3-button navigation
    if (isThreeButtonNavigation(context)) {
      return MediaQuery.of(context).viewPadding.bottom;
    }
    
    return 0;
  }

  /// Wraps content with appropriate bottom spacing handling for both platforms
  /// On iOS: Uses SafeArea
  /// On Android: Uses conditional padding based on navigation mode
  static Widget wrapWithBottomSafeArea({
    required BuildContext context,
    required Widget child,
    Color? backgroundColor,
  }) {
    if (Platform.isIOS) {
      // iOS: Use SafeArea which properly handles home indicator
      return SafeArea(
        bottom: true,
        child: child,
      );
    } else {
      // Android: Use conditional padding
      return child;
    }
  }
}

