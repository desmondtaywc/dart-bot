# Docker Setup Guide for Dart Bot

This guide will help you containerize and run your Dart Telegram bot using Docker.

## Prerequisites

- Docker installed on your system
- Docker Compose installed
- Telegram Bot Token (get from [@BotFather](https://t.me/BotFather))

## Environment Variables

Create a `.env` file in the project root with the following content:

```bash
# Telegram Bot Token - Get this from @BotFather
BOT_TOKEN=your_bot_token_here

# Optional: If you want to use webhooks instead of polling
# WEBHOOK_URL=https://your-domain.com/webhook

# Optional: Port for webhook server
# PORT=8080
```

## Build and Run

### Option 1: Using Docker Compose (Recommended)

1. **Create the `.env` file** with your bot token:
   ```bash
   echo "BOT_TOKEN=your_actual_bot_token_here" > .env
   ```

2. **Build and run the container**:
   ```bash
   docker compose up --build
   ```

3. **Run in detached mode** (background):
   ```bash
   docker compose up -d --build
   ```

4. **Stop the bot**:
   ```bash
   docker compose down
   ```

### Option 2: Using Docker directly

1. **Build the image**:
   ```bash
   docker build -t dart-bot .
   ```

2. **Run the container**:
   ```bash
   docker run -e BOT_TOKEN=your_actual_bot_token_here --name dart-bot dart-bot
   ```

3. **Run in detached mode**:
   ```bash
   docker run -d -e BOT_TOKEN=your_actual_bot_token_here --name dart-bot dart-bot
   ```

## Available Commands

Once your bot is running, users can interact with it using:

- `/uptime` - Show system uptime
- `/ping` - Ping Google 3 times

## Logs

### Docker Compose
```bash
# View logs
docker compose logs

# Follow logs in real-time
docker compose logs -f

# View logs for specific service
docker compose logs dart-bot
```

### Docker
```bash
# View logs
docker logs dart-bot

# Follow logs in real-time
docker logs -f dart-bot
```

## Troubleshooting

### Common Issues

1. **Bot Token Error**: Make sure your `.env` file contains the correct bot token
2. **Permission Denied**: Make sure Docker has proper permissions
3. **Port Already in Use**: Change the port mapping in `docker compose.yml`

### Debug Mode

To run with debug information:

```bash
# Docker Compose
docker compose up --build

# Docker
docker run -e BOT_TOKEN=your_token_here dart-bot
```

## Stopping the Bot

### Docker Compose
```bash
docker compose down
```

### Docker
```bash
docker stop dart-bot
docker rm dart-bot
```

## Updating the Bot

1. **Pull latest changes**:
   ```bash
   git pull
   ```

2. **Rebuild and restart**:
   ```bash
   docker compose down
   docker compose up --build -d
   ```

## Production Deployment

For production deployment, consider:

1. **Using Docker Swarm or Kubernetes**
2. **Setting up proper logging**
3. **Implementing health checks**
4. **Using secrets management for the bot token**
5. **Setting up monitoring and alerting**

Example for Docker Swarm:
```bash
docker service create \
  --name dart-bot \
  --env BOT_TOKEN=your_token_here \
  --restart-condition on-failure \
  dart-bot
``` 