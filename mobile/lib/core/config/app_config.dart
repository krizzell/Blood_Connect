import 'package:flutter/foundation.dart';

enum Environment { development, staging, production }

class AppConfig {
  static const Environment _environment = Environment.development;
  
  static const String appName = 'BloodConnect';
  static const String appVersion = '1.0.0';
  
  static bool get isDevelopment => _environment == Environment.development;
  static bool get isStaging => _environment == Environment.staging;
  static bool get isProduction => _environment == Environment.production;
  static bool get isDebugMode => kDebugMode;

  // API Configuration based on environment
  static String get apiBaseUrl {
    switch (_environment) {
      case Environment.production:
        return 'https://api.bloodconnect.com/api/v1';
      case Environment.staging:
        return 'https://staging-api.bloodconnect.com/api/v1';
      case Environment.development:
      default:
        return 'http://10.0.2.2:8081/api/v1';
    }
  }
}
