import 'dart:io';
import 'package:dotenv/dotenv.dart';

class Config {
  static final DotEnv _env = DotEnv(includePlatformEnvironment: true);

  static String? _botToken;
  static List<int>? _authorizedUsers;

  /// Initialize configuration by loading .env file
  static void init() {
    _env.load();
  }

  /// Get bot token
  static String get botToken {
    _botToken ??= _env['BOT_TOKEN'];

    if (_botToken == null || _botToken!.isEmpty) {
      print('Error: BOT_TOKEN not found in .env file or environment variables');
      print(
        'Please create a .env file with your bot token or set BOT_TOKEN environment variable',
      );
      exit(1);
    }

    return _botToken!;
  }

  /// Get authorized users list
  static List<int> get authorizedUsers {
    if (_authorizedUsers != null) {
      return _authorizedUsers!;
    }

    String? userIds = _env['AUTHORIZED_USERS'];

    if (userIds != null && userIds.isNotEmpty) {
      _authorizedUsers =
          userIds
              .split(',')
              .map((id) => int.tryParse(id.trim()))
              .where((id) => id != null)
              .cast<int>()
              .toList();

      if (_authorizedUsers!.isNotEmpty) {
        return _authorizedUsers!;
      }
    }

    print('Warning: No authorized users configured in AUTHORIZED_USERS');
    print('Please set AUTHORIZED_USERS in your .env file');
    return [];
  }

  /// Print configuration summary
  static void printSummary() {
    print('🔧 Configuration loaded:');
    print('   📊 Authorized users: ${authorizedUsers.length}');
  }
}
