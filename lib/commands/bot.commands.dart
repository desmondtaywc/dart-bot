import 'package:dart_bot/auth.service.dart';
import 'package:dart_bot/commands/protected/protected.commands.dart';
import 'package:dart_bot/commands/public/public.commands.dart';
import 'package:televerse/televerse.dart';

class BotCommands {
  /// Register commands for the bot
  static void registerCommands(Bot bot) {
    /// Public commands
    _registerPublicCommands(bot);

    /// Protected commands
    _registerProtectedCommands(bot);

    /// Global message handler
    _registerGlobalHandler(bot);
  }

  /// Register public commands (no authorization required)
  static void _registerPublicCommands(Bot bot) {
    bot.command('myid', (ctx) async {
      await PublicCommands.getId(ctx);
    });
  }

  /// Register protected commands (authorization required)
  static void _registerProtectedCommands(Bot bot) {
    // Ping command
    bot.command('ping', (ctx) async {
      await ProtectedCommands.ping(ctx);
    });

    // Uptime command
    bot.command('uptime', (ctx) async {
      await ProtectedCommands.uptime(ctx);
    });

    // Run command
    bot.command('run', (ctx) async {
      await ProtectedCommands.run(ctx);
    });
  }

  /// Register global message handler
  static void _registerGlobalHandler(Bot bot) {
    bot.onMessage((ctx) async {
      String? command = ctx.message?.text;
      if (command != null &&
          command.startsWith('/') &&
          !AuthService.isAuthorizedUser(ctx)) {
        AuthService.logUnauthorizedAccess(ctx, command);
      }
    });
  }
}
