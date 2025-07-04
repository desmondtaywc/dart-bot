# 🤖 Dart Telegram Bot

Telegram bot built with Dart that can execute terminal commands remotely with user authorization and Docker support.

### Telegram Public Commands
- `/myid` - Get your Telegram user ID for authorization

### Telegram Protected Commands (Authorization Required)
- `/ping` - Ping Google to test connectivity
- `/uptime` - Show system uptime
- `/run <command>` - Execute terminal commands

## 🚀 Quick Start

### Prerequisites

- [Dart SDK](https://dart.dev/get-dart) 3.7.2 or higher
- [Docker](https://www.docker.com/) (optional, for containerization)
- Telegram Bot Token from [@BotFather](https://t.me/BotFather)

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/dart-bot.git
cd dart-bot
```

### 2. Install Dependencies

```bash
dart pub get
```

### 3. Configure Environment

Create a `.env` file in the project root:

```bash
# Telegram Bot Configuration
BOT_TOKEN=your_bot_token_here
AUTHORIZED_USERS=123456789,987654321

```

### 4. Run the Bot

```bash
# Development
dart run
```