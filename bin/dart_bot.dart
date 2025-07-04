import 'dart:io';
import 'package:dart_bot/terminal.dart';
import 'package:televerse/televerse.dart';

void main(List<String> arguments) async {
  // Get bot token from environment variable
  String? botToken = Platform.environment['BOT_TOKEN'];

  if (botToken == null) {
    print('Error: BOT_TOKEN environment variable is not set');
    print('Please set BOT_TOKEN environment variable with your bot token');
    exit(1);
  }

  final bot = Bot(botToken);

  // Register handler for the /start commmand
  bot.command('uptime', (ctx) async {
    // Reply with the menu
    final uptime = await Terminal.uptime();
    await ctx.reply(uptime);
  });

  bot.command('ping', (ctx) async {
    await ctx.reply('🏓 Pinging Google...');
    // Reply with the menu
    try {
      String pingResult = await Terminal.pingGoogle();
      await ctx.reply('```\n$pingResult\n```', parseMode: ParseMode.markdown);
      await ctx.reply('Pinging Completed.');
    } catch (e) {
      await ctx.reply('❌ Error: $e');
    }
  });

  bot.command('run', (ctx) async {
    try {
      // Get the message text and remove the /run command
      String? messageText = ctx.message?.text;
      if (messageText == null || messageText.trim() == '/run') {
        await ctx.reply('Usage: /run <command> [args]\nExample: /run ls -la');
        return;
      }

      // Parse command and arguments
      List<String> parts = messageText.substring(4).trim().split(' ');
      String command = parts[0];
      List<String> args = parts.length > 1 ? parts.sublist(1) : [];

      await ctx.reply('🔄 Running: $command ${args.join(' ')}...');

      String result = await Terminal.runCommand(command, args);

      // Split long results
      if (result.length > 4000) {
        result = '${result.substring(0, 4000)}\n... (output truncated)';
      }

      await ctx.reply('```\n$result\n```', parseMode: ParseMode.markdown);
    } catch (e) {
      await ctx.reply('❌ Error: $e');
    }
  });

  // Start the bot and listen for updates
  await bot.start();
  print('Bot is running...');
}
