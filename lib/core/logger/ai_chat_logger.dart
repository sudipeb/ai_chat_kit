import 'package:flutter/foundation.dart';

/// Simple package-level logging for AI chat state transitions.
///
/// This logger does not depend on any third-party observer package; it
/// simply prints messages when enabled.
class AIChatLogger {
  static bool enabled = false;

  /// Enables printing state updates to the console.
  static void enable() => enabled = true;

  /// Disables logging.
  static void disable() => enabled = false;

  /// Prints a log message only when logging is enabled.
  static void log(String message) {
    if (!enabled) return;
    // Use debugPrint for proper Flutter debugging output
    debugPrint('[AIChat] $message');
  }
}
