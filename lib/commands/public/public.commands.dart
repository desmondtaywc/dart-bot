import 'package:televerse/televerse.dart';

class PublicCommands {
  static Future<void> getId(Context ctx) async {
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
  }
}
