#!/bin/bash

# Web Interface Startup Script

set -e

echo "🌐 Starting Lightning Network Web Interface..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    print_error "Node.js is not installed. Please install Node.js first."
    exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    print_error "npm is not installed. Please install npm first."
    exit 1
fi

# Navigate to web interface directory
cd web-interface

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    print_status "Installing dependencies..."
    npm install
fi

# Check if LND is running
if ! pgrep -x "lnd" > /dev/null; then
    print_warning "LND is not running. Starting LND..."
    cd ..
    ./scripts/start-lnd.sh
    cd web-interface
fi

# Start the web interface
print_status "Starting web interface..."
npm start &

# Wait a moment for the server to start
sleep 3

# Check if the web interface started successfully
if curl -s http://localhost:3000 > /dev/null 2>&1; then
    print_success "Web interface started successfully!"
    print_status "Access the interface at: http://localhost:3000"
    print_status "API endpoint: http://localhost:3000/api"
else
    print_error "Failed to start web interface"
    exit 1
fi

print_status "To stop the web interface, press Ctrl+C"
print_status "To view logs, check the terminal output" 