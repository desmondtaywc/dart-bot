import 'package:dart_bot/auth.service.dart';
import 'package:dart_bot/terminal.dart';
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
      int? userId = ctx.from?.id;
      String? username = ctx.from?.username;
      String? firstName = ctx.from?.firstName;
      String? lastName = ctx.from?.lastName;

      await ctx.reply(
        '**Your Telegram Details:**\n\n'
        '👤 **User ID:** `$userId`\n'
        '🏷️ **Username:** ${username != null ? '@$username' : 'N/A'}\n'
        '📝 **First Name:** ${firstName ?? 'N/A'}\n'
        '📝 **Last Name:** ${lastName ?? 'N/A'}\n\n'
        '💡 **Note:** Copy your User ID to authorize yourself in the bot configuration.',
        parseMode: ParseMode.markdown,
      );

      print('User ID request from: $userId (@${username ?? 'unknown'})');
    });
  }

  /// Register protected commands (authorization required)
  static void _registerProtectedCommands(Bot bot) {
    // Ping command
    bot.command('ping', (ctx) async {
      await AuthService.protectedCommand(ctx, () async {
        await ctx.reply('🏓 Pinging Google...');
        try {
          String pingResult = await Terminal.pingGoogle();
          await ctx.reply(
            '```\n$pingResult\n```',
            parseMode: ParseMode.markdown,
          );
          await ctx.reply('Pinging Completed.');
        } catch (e) {
          await ctx.reply('❌ Error: $e');
        }
      });
    });

    // Uptime command
    bot.command('uptime', (ctx) async {
      await AuthService.protectedCommand(ctx, () async {
        try {
          final uptime = await Terminal.uptime();
          await ctx.reply(
            '⏱️ **System Uptime:**\n```\n$uptime\n```',
            parseMode: ParseMode.markdown,
          );
        } catch (e) {
          await ctx.reply('❌ Error: $e');
        }
      });
    });

    // Run command
    bot.command('run', (ctx) async {
      await AuthService.protectedCommand(ctx, () async {
        try {
          String? messageText = ctx.message?.text;
          if (messageText == null || messageText.trim() == '/run') {
            await ctx.reply(
              'Usage: /run <command> [args]\nExample: /run ls -la',
            );
            return;
          }

          List<String> parts = messageText.substring(4).trim().split(' ');
          String command = parts[0];
          List<String> args = parts.length > 1 ? parts.sublist(1) : [];

          await ctx.reply(
            '🔄 **Running:** `$command ${args.join(' ')}`...',
            parseMode: ParseMode.markdown,
          );

          String result = await Terminal.runCommand(command, args);

          if (result.length > 4000) {
            result = '${result.substring(0, 4000)}\n... (output truncated)';
          }

          await ctx.reply('```\n$result\n```', parseMode: ParseMode.markdown);
        } catch (e) {
          await ctx.reply('❌ Error: $e');
        }
      });
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
