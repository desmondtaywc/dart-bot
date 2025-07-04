import 'package:dart_bot/auth.service.dart';
import 'package:dart_bot/terminal.dart';
import 'package:televerse/televerse.dart';

class ProtectedCommands {
  // Public methods that return protected versions
  static Future<void> Function(Context) get ping =>
      AuthService.protectedWrapper(_pingHandler);
  static Future<void> Function(Context) get uptime =>
      AuthService.protectedWrapper(_uptimeHandler);
  static Future<void> Function(Context) get run =>
      AuthService.protectedWrapper(_runHandler);

  // Clean command handlers without authorization wrapper
  static Future<void> _pingHandler(Context ctx) async {
    await ctx.reply('🏓 Pinging Google...');
    try {
      String pingResult = await Terminal.pingGoogle();
      await ctx.reply('```\n$pingResult\n```', parseMode: ParseMode.markdown);
      await ctx.reply('Pinging Completed.');
    } catch (e) {
      await ctx.reply('❌ Error: $e');
    }
  }

  /// Uptime command handler
  static Future<void> _uptimeHandler(Context ctx) async {
    try {
      final uptime = await Terminal.uptime();
      await ctx.reply(
        '⏱️ **System Uptime:**\n```\n$uptime\n```',
        parseMode: ParseMode.markdown,
      );
    } catch (e) {
      await ctx.reply('❌ Error: $e');
    }
  }

  /// Run command handler
  static Future<void> _runHandler(Context ctx) async {
    try {
      String? messageText = ctx.message?.text;
      if (messageText == null || messageText.trim() == '/run') {
        await ctx.reply('Usage: /run <command> [args]\nExample: /run ls -la');
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
  }
}
