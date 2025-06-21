#!/bin/bash

# Bitcoin Testnet Node Startup Script

set -e

echo "🪙 Starting Bitcoin testnet node..."

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

# Check if Bitcoin Core is installed
if ! command -v bitcoind &> /dev/null; then
    print_warning "Bitcoin Core not found. Installing via Homebrew..."
    brew install bitcoin
else
    print_success "Bitcoin Core is installed"
fi

# Create data directory if it doesn't exist
mkdir -p bitcoin-node/data

# Check if Bitcoin is already running
if pgrep -x "bitcoind" > /dev/null; then
    print_warning "Bitcoin daemon is already running"
    print_status "Bitcoin testnet node is running on port 18332"
    exit 0
fi

# Start Bitcoin testnet daemon
print_status "Starting Bitcoin testnet daemon..."
bitcoind -testnet -datadir=./bitcoin-node/data -conf=./bitcoin-node/bitcoin.conf -daemon

# Wait a moment for the daemon to start
sleep 3

# Check if Bitcoin started successfully
if pgrep -x "bitcoind" > /dev/null; then
    print_success "Bitcoin testnet node started successfully!"
    print_status "RPC endpoint: http://127.0.0.1:18332"
    print_status "Data directory: ./bitcoin-node/data"
else
    print_error "Failed to start Bitcoin testnet node"
    exit 1
fi

print_status "To stop Bitcoin, run: ./scripts/stop-bitcoin.sh"
print_status "To view logs, run: tail -f ./bitcoin-node/data/testnet3/debug.log" 