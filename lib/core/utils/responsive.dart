import 'package:flutter/material.dart';

/// Responsive utility class for handling different screen sizes
class Responsive {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double safeAreaHorizontal;
  static late double safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;

  /// Initialize responsive values - call this in build method
  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - safeAreaVertical) / 100;
  }

  /// Check if device is a small phone (width < 360)
  static bool get isSmallPhone => screenWidth < 360;

  /// Check if device is a regular phone (360 <= width < 600)
  static bool get isPhone => screenWidth >= 360 && screenWidth < 600;

  /// Check if device is a large phone/small tablet (600 <= width < 900)
  static bool get isLargePhone => screenWidth >= 600 && screenWidth < 900;

  /// Check if device is a tablet (width >= 900)
  static bool get isTablet => screenWidth >= 900;

  /// Get number of grid columns based on screen width
  static int get gridColumns {
    if (screenWidth < 360) return 2;
    if (screenWidth < 600) return 2;
    if (screenWidth < 900) return 3;
    return 4;
  }

  /// Get card aspect ratio based on screen size
  static double get cardAspectRatio {
    if (screenWidth < 360) return 0.65;
    if (screenWidth < 600) return 0.7;
    return 0.75;
  }

  /// Get horizontal padding based on screen width
  static double get horizontalPadding {
    if (screenWidth < 360) return 12;
    if (screenWidth < 600) return 16;
    return 24;
  }

  /// Get font scale factor
  static double get fontScale {
    if (screenWidth < 360) return 0.85;
    if (screenWidth < 600) return 1.0;
    return 1.1;
  }

  /// Scale value based on screen width (base:  375 - iPhone X width)
  static double scaleWidth(double size) {
    return size * (screenWidth / 375);
  }

  /// Scale value based on screen height (base: 812 - iPhone X height)
  static double scaleHeight(double size) {
    return size * (screenHeight / 812);
  }

  /// Scale font size
  static double scaleFontSize(double size) {
    return size * fontScale;
  }
}

/// Extension for easier responsive sizing
extension ResponsiveExtension on num {
  /// Width percentage
  double get w => Responsive.blockSizeHorizontal * this;

  /// Height percentage
  double get h => Responsive.blockSizeVertical * this;

  /// Safe width percentage
  double get sw => Responsive.safeBlockHorizontal * this;

  /// Safe height percentage
  double get sh => Responsive.safeBlockVertical * this;

  /// Scaled width
  double get ws => Responsive.scaleWidth(toDouble());

  /// Scaled height
  double get hs => Responsive.scaleHeight(toDouble());

  /// Scaled font
  double get sp => Responsive.scaleFontSize(toDouble());
}
