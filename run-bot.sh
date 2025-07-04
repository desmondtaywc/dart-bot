#!/bin/bash

# Dart Bot Docker Runner Script
# This script helps you easily run your Dart Telegram bot using Docker

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if .env file exists
if [ ! -f ".env" ]; then
    print_error ".env file not found!"
    print_status "Creating .env file template..."
    cat > .env << EOF
# Telegram Bot Token - Get this from @BotFather
BOT_TOKEN=your_bot_token_here

# Authorized Users (comma-separated)
AUTHORIZED_USERS=telegram_user_id1

# Optional: If you want to use webhooks instead of polling
# WEBHOOK_URL=https://your-domain.com/webhook

# Optional: Port for webhook server
# PORT=8080
EOF
    print_warning "Please edit .env file and add your bot token"
    print_status "You can get a bot token from @BotFather on Telegram"
    exit 1
fi

# Check if BOT_TOKEN is set
source .env
if [ -z "$BOT_TOKEN" ] || [ "$BOT_TOKEN" = "your_bot_token_here" ]; then
    print_error "BOT_TOKEN is not set in .env file!"
    print_status "Please edit .env file and add your bot token"
    exit 1
fi

# Function to show help
show_help() {
    echo "Dart Bot Docker Runner"
    echo ""
    echo "Usage: $0 [OPTION]"
    echo ""
    echo "Options:"
    echo "  start     Start the bot (detached mode)"
    echo "  stop      Stop the bot"
    echo "  restart   Restart the bot"
    echo "  logs      Show bot logs"
    echo "  build     Build the Docker image"
    echo "  dev       Run in development mode (with logs)"
    echo "  clean     Remove all containers and images"
    echo "  help      Show this help message"
    echo ""
}

# Parse command line arguments
case "$1" in
    "start")
        print_status "Pulling latest changes..."
        git pull
        print_status "Pull completed!"
        print_status "Starting Dart Bot..."
        docker compose up -d --build
        print_status "Bot started successfully!"
        print_status "Use '$0 logs' to view logs"
        ;;
    "stop")
        print_status "Stopping Dart Bot..."
        docker compose down
        print_status "Bot stopped successfully!"
        ;;
    "restart")
        print_status "Restarting Dart Bot..."
        docker compose down
        docker compose up -d --build
        print_status "Bot restarted successfully!"
        ;;
    "logs")
        print_status "Showing bot logs (Press Ctrl+C to exit)..."
        docker compose logs -f
        ;;
    "build")
        print_status "Building Docker image..."
        docker compose build
        print_status "Build completed successfully!"
        ;;
    "dev")
        print_status "Running in development mode..."
        docker compose up --build
        ;;
    "clean")
        print_warning "This will remove all containers and images!"
        read -p "Are you sure? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_status "Cleaning up..."
            docker compose down
            docker system prune -f
            print_status "Cleanup completed!"
        else
            print_status "Cleanup cancelled."
        fi
        ;;
    "help"|"--help"|"-h")
        show_help
        ;;
    "")
        print_error "No option provided!"
        show_help
        exit 1
        ;;
    *)
        print_error "Unknown option: $1"
        show_help
        exit 1
        ;;
esac 