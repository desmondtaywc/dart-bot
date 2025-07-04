# Use the official Dart image as the base image
FROM dart:stable AS build

# Set the working directory
WORKDIR /app

# Copy pubspec files
COPY pubspec.yaml pubspec.lock ./

# Get dependencies
RUN dart pub get

# Copy the source code
COPY . .

# Compile the application
RUN dart compile exe bin/dart_bot.dart -o dart_bot

# Use a minimal image for the final stage
FROM debian:bullseye-slim

# Install necessary tools (ping, uptime, etc.)
RUN apt-get update && apt-get install -y \
    iputils-ping \
    procps \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN useradd -m -s /bin/bash dartbot

# Set working directory
WORKDIR /app

# Copy the compiled binary from the build stage
COPY --from=build /app/dart_bot .

# Change ownership to the non-root user
RUN chown -R dartbot:dartbot /app

# Switch to the non-root user
USER dartbot

# Expose port (if needed for webhooks)
EXPOSE 8080

# Run the bot
CMD ["./dart_bot"] 