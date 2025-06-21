#!/bin/bash

# Lightning Network Daemon (LND) Startup Script

set -e

echo "⚡ Starting Lightning Network Daemon (LND)..."

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

# Check if LND is installed
if ! command -v lnd &> /dev/null; then
    print_warning "LND not found. Installing via Homebrew..."
    brew install lnd
else
    print_success "LND is installed"
fi

# Check if Bitcoin container is running
if ! docker ps --format "table {{.Names}}" | grep -q "bitcoin-testnet"; then
    print_error "Bitcoin testnet container is not running. Please start Bitcoin first:"
    print_status "Run: ./scripts/start-bitcoin.sh"
    exit 1
fi

# Create LND data directory if it doesn't exist
mkdir -p lnd-config/data

# Check if LND is already running
if pgrep -x "lnd" > /dev/null; then
    print_warning "LND is already running"
    print_status "LND is running on port 10009"
    exit 0
fi

# Start LND
print_status "Starting LND..."
lnd --configfile=./lnd-config/lnd.conf --datadir=./lnd-config/data &

# Wait for LND to start
print_status "Waiting for LND to start..."
sleep 5

# Check if LND started successfully
if pgrep -x "lnd" > /dev/null; then
    print_success "LND started successfully!"
    print_status "LND is running on port 10009"
    print_status "REST API: https://127.0.0.1:8080"
    print_status "gRPC: 127.0.0.1:10009"
else
    print_error "Failed to start LND"
    exit 1
fi

print_status "To stop LND, run: ./scripts/stop-lnd.sh"
print_status "To view logs, run: tail -f ./lnd-config/data/logs/bitcoin/testnet/lnd.log"

# Check if wallet exists
if [ -f "./lnd-config/data/data/chain/bitcoin/testnet/wallet.db" ]; then
    print_success "Wallet already exists"
else
    print_warning "No wallet found. You'll need to create one:"
    print_status "Run: ./scripts/create-wallet.sh"
fi 