/// Environment Configuration - Config Layer
///
/// Cấu hình môi trường cho Development, Staging, Production.
/// Flavor configuration cho multi-environment setup.
///
/// Location: core/config/
class EnvConfig {
  final String apiBaseUrl;
  final String appName;
  final bool enableLogging;
  final bool enableCrashReporting;

  const EnvConfig({
    required this.apiBaseUrl,
    required this.appName,
    required this.enableLogging,
    required this.enableCrashReporting,
  });

  /// Development environment
  static const EnvConfig development = EnvConfig(
    apiBaseUrl: 'https://stephen-king-api.onrender.com/api',
    appName: 'Stephen King Books (DEV)',
    enableLogging: true,
    enableCrashReporting: false,
  );

  /// Production environment
  static const EnvConfig production = EnvConfig(
    apiBaseUrl: 'https://stephen-king-api.onrender.com/api',
    appName: 'Stephen King Books',
    enableLogging: false,
    enableCrashReporting: true,
  );

  /// Current environment (default: development)
  static const EnvConfig current = development;
}
