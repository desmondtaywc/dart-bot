import 'package:dart_bot/bot.commands.dart';
import 'package:dart_bot/config.dart';
import 'package:televerse/televerse.dart';

void main(List<String> arguments) async {
  // Initialize configuration
  Config.init();

  // Create bot instance
  final bot = Bot(Config.botToken);

  // Register all commands
  BotCommands.registerCommands(bot);

  // Print startup information
  print('🚀 Bot is running with authorization system...');
  Config.printSummary();

  // Start the bot and listen for updates
  await bot.start();
}
