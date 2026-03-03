import 'dart:io';

enum Environment { dev, staging, prod }

class AppEnvironment {
  static Environment current = Environment.prod;

  static String get baseUrl {
    switch (current) {
      case Environment.prod:
        return 'http://localhost:3000';

      case Environment.staging:
        return 'https://staging.api.example.com';

      case Environment.dev:
        // Android emulator dùng 10.0.2.2, iOS dùng localhost
        final host = Platform.isAndroid ? '10.0.2.2' : 'localhost';
        return 'http://$host:3000';
    }
  }
}
