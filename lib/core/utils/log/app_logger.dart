import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter_mvvm_samples/core/env/env.dart';

/// Log levels enum
enum LogLevel {
  debug,
  info,
  warning,
  error,
  fatal,
}

/// A centralized logger utility that can be used throughout the application
/// Supports different log levels and environment-aware logging
class AppLogger {
  AppLogger._();

  static AppLogger? _instance;
  static bool _initialized = false;
  static Env _env = Env.dev;

  /// Initialize the logger with environment configuration
  /// Should be called once at app startup
  static void init(Env env) {
    _env = env;
    _initialized = true;
    _instance ??= AppLogger._();
  }

  /// Get the logger instance
  static AppLogger get instance {
    if (!_initialized) {
      // Fallback initialization if not explicitly initialized
      _initialized = true;
      _instance ??= AppLogger._();
    }
    return _instance!;
  }

  /// Check if logging is enabled for the current environment
  bool get _isLoggingEnabled {
    // In production, you might want to disable debug logs
    // but keep errors. Adjust based on your needs.
    // Currently enabled for all environments
    // To disable in production, change to: return _env != Env.prod;
    return true; // Enable logging for all environments
  }

  /// Get current environment (useful for conditional logging)
  Env get currentEnv => _env;

  /// Debug level logs - detailed information for debugging
  void debug(String message,
      {String? tag, Object? error, StackTrace? stackTrace}) {
    if (!_isLoggingEnabled) return;
    _log(LogLevel.debug, message,
        tag: tag, error: error, stackTrace: stackTrace);
  }

  /// Info level logs - general informational messages
  void info(String message, {String? tag}) {
    if (!_isLoggingEnabled) return;
    _log(LogLevel.info, message, tag: tag);
  }

  /// Warning level logs - warning messages
  void warning(String message,
      {String? tag, Object? error, StackTrace? stackTrace}) {
    if (!_isLoggingEnabled) return;
    _log(LogLevel.warning, message,
        tag: tag, error: error, stackTrace: stackTrace);
  }

  /// Error level logs - error messages
  void error(String message,
      {String? tag, Object? error, StackTrace? stackTrace}) {
    // Always log errors, even in production
    _log(LogLevel.error, message,
        tag: tag, error: error, stackTrace: stackTrace);
  }

  /// Fatal level logs - critical errors that might cause app termination
  void fatal(String message,
      {String? tag, Object? error, StackTrace? stackTrace}) {
    // Always log fatal errors
    _log(LogLevel.fatal, message,
        tag: tag, error: error, stackTrace: stackTrace);
  }

  /// Internal log method
  void _log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final logPrefix = _getLogPrefix(level);
    final tagPrefix = tag != null ? '[$tag] ' : '';
    final logMessage = '$logPrefix$tagPrefix$message';

    if (kDebugMode) {
      // In debug mode, use debugPrint for better console output
      debugPrint(logMessage);
      if (error != null) {
        debugPrint('Error: $error');
      }
      if (stackTrace != null) {
        debugPrint('Stack trace: $stackTrace');
      }
    } else {
      // In release mode, use developer.log for better performance
      developer.log(
        logMessage,
        name: tag ?? 'AppLogger',
        level: _getDeveloperLogLevel(level),
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Get log prefix based on log level
  String _getLogPrefix(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '🐛 [DEBUG] ';
      case LogLevel.info:
        return 'ℹ️ [INFO] ';
      case LogLevel.warning:
        return '⚠️ [WARNING] ';
      case LogLevel.error:
        return '❌ [ERROR] ';
      case LogLevel.fatal:
        return '💥 [FATAL] ';
    }
  }

  /// Convert LogLevel to developer log level
  int _getDeveloperLogLevel(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 700; // developer.Level.FINE
      case LogLevel.info:
        return 800; // developer.Level.INFO
      case LogLevel.warning:
        return 900; // developer.Level.WARNING
      case LogLevel.error:
        return 1000; // developer.Level.SEVERE
      case LogLevel.fatal:
        return 1200; // developer.Level.SHOUT
    }
  }

  /// Log API requests/responses
  void api(String message, {String? tag, Map<String, dynamic>? data}) {
    if (!_isLoggingEnabled) return;
    final logMessage = data != null ? '$message\nData: $data' : message;
    _log(LogLevel.debug, logMessage, tag: tag ?? 'API');
  }

  /// Log network errors
  void networkError(String message,
      {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.error, message,
        tag: tag ?? 'Network', error: error, stackTrace: stackTrace);
  }

  /// Log navigation events
  void navigation(String route, {String? tag}) {
    if (!_isLoggingEnabled) return;
    _log(LogLevel.debug, 'Navigating to: $route', tag: tag ?? 'Navigation');
  }

  /// Log user actions
  void userAction(String action, {String? tag, Map<String, dynamic>? data}) {
    if (!_isLoggingEnabled) return;
    final logMessage = data != null ? '$action\nData: $data' : action;
    _log(LogLevel.info, logMessage, tag: tag ?? 'UserAction');
  }
}

/// Extension methods for easy access to logger
extension LoggerExtension on Object {
  /// Quick access to logger for any class
  AppLogger get log => AppLogger.instance;
}

/// Convenience function for quick logging (similar to print)
void logDebug(String message, {String? tag}) {
  AppLogger.instance.debug(message, tag: tag);
}

void logInfo(String message, {String? tag}) {
  AppLogger.instance.info(message, tag: tag);
}

void logWarning(String message,
    {String? tag, Object? error, StackTrace? stackTrace}) {
  AppLogger.instance
      .warning(message, tag: tag, error: error, stackTrace: stackTrace);
}

void logError(String message,
    {String? tag, Object? error, StackTrace? stackTrace}) {
  AppLogger.instance
      .error(message, tag: tag, error: error, stackTrace: stackTrace);
}

void logFatal(String message,
    {String? tag, Object? error, StackTrace? stackTrace}) {
  AppLogger.instance
      .fatal(message, tag: tag, error: error, stackTrace: stackTrace);
}
