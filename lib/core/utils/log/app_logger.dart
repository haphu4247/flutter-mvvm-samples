import 'package:flutter_mvvm_samples/core/env/env.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Centralized Talker instance for the application
/// Provides advanced error handling and logging capabilities
class AppLogger {
  AppLogger._();

  static Talker? _instance;
  static bool _initialized = false;
  static Env _env = Env.dev;

  /// Initialize Talker with environment configuration
  /// Should be called once at app startup
  static void init(Env env) {
    _env = env;

    // Configure Talker settings based on environment
    final settings = TalkerSettings(
      enabled: env != Env.prod, // Enable in all environments
      useConsoleLogs: true,
      useHistory: true,
      maxHistoryItems: 100,
      // In production, you might want different settings
      // level: _env == Env.prod ? TalkerLogLevel.error : TalkerLogLevel.all,
    );

    // Create Talker instance with settings
    _instance = Talker(
      settings: settings,
    );

    _initialized = true;
  }

  /// Get the Talker instance
  static Talker get instance {
    if (!_initialized || _instance == null) {
      // Fallback initialization if not explicitly initialized
      init(Env.dev);
    }
    return _instance!;
  }

  /// Get current environment
  static Env get currentEnv => _env;

  /// Convenience methods for common logging operations
  static void debug(String message,
      {Object? exception, StackTrace? stackTrace}) {
    instance.debug(message, exception, stackTrace);
  }

  static void info(String message) {
    instance.info(message);
  }

  static void warning(String message,
      {Object? exception, StackTrace? stackTrace}) {
    instance.warning(message, exception, stackTrace);
  }

  static void error(String message,
      {Object? exception, StackTrace? stackTrace}) {
    instance.error(message, exception, stackTrace);
  }

  static void critical(String message,
      {Object? exception, StackTrace? stackTrace}) {
    instance.critical(message, exception, stackTrace);
  }

  /// Log API requests/responses
  static void api(String message, {Map<String, dynamic>? data}) {
    if (data != null) {
      instance.debug('API: $message', [data]);
    } else {
      instance.debug('API: $message');
    }
  }

  /// Handle exceptions with Talker
  static void handleException(Object exception, StackTrace stackTrace,
      {String? message}) {
    if (message != null) {
      instance.handle(exception, stackTrace, message);
    } else {
      instance.handle(exception, stackTrace);
    }
  }
}
