import 'package:televerse/televerse.dart';
import 'config.dart';

class AuthService {
  /// Check if user is authorized
  static bool isAuthorizedUser(Context ctx) {
    int? userId = ctx.from?.id;

    if (userId == null || !Config.authorizedUsers.contains(userId)) {
      print('❌ Unauthorized access attempt from user: $userId');
      return false;
    }

    print('✅ Authorized user: $userId');
    return true;
  }

  /// Send unauthorized access message
  static Future<void> sendUnauthorizedMessage(Context ctx) async {
    await ctx.reply(
      '❌ **Access Denied**\n\n'
      'You are not authorized to use this bot.\n'
      'Contact the bot administrator if you need access.',
      parseMode: ParseMode.markdown,
    );
  }

  /// Wrapper for protected commands
  static Future<void> protectedCommand(
    Context ctx,
    Future<void> Function() handler,
  ) async {
    if (!isAuthorizedUser(ctx)) {
      await sendUnauthorizedMessage(ctx);
      return;
    }
    await handler();
  }

  /// Create a protected command wrapper
  static Future<void> Function(Context) protectedWrapper(
    Future<void> Function(Context) handler,
  ) {
    return (Context ctx) async {
      await protectedCommand(ctx, () async {
        await handler(ctx);
      });
    };
  }

  /// Log unauthorized access attempts
  static void logUnauthorizedAccess(Context ctx, String command) {
    print(
      '📝 Blocked command "$command" from unauthorized user: ${ctx.from?.id}',
    );
  }
}
