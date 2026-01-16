import 'dart:async';
import 'package:flutter/foundation.dart';

/// Utility class for debouncing function calls
/// Useful for search functionality to avoid too many API calls
class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({this.milliseconds = 500});

  /// Run the action after the specified delay
  /// If called again before the delay is over, the timer resets
  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds:  milliseconds), action);
  }

  /// Cancel the pending action
  void cancel() {
    _timer?.cancel();
  }

  /// Dispose the debouncer
  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}