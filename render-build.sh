#!/bin/bash

# Install dependencies for Swift and Node.js
echo "Installing dependencies..."

# Install Swift
apt-get update
apt-get install -y swift

# Install Node.js dependencies
npm install

echo "Dependencies installed successfully."

# Run the server
echo "Starting the server..."
npm start
