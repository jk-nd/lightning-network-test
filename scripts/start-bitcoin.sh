#!/bin/bash

# Bitcoin Testnet Node Startup Script (Docker Version)

set -e

echo "🪙 Starting Bitcoin testnet node using Docker..."

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

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker Desktop first."
    print_status "Download from: https://www.docker.com/products/docker-desktop/"
    exit 1
else
    print_success "Docker is installed"
fi

# Check if Docker is running
if ! docker info &> /dev/null; then
    print_error "Docker is not running. Please start Docker Desktop first."
    exit 1
else
    print_success "Docker is running"
fi

# Create data directory if it doesn't exist
mkdir -p bitcoin-node/data

# Check if Bitcoin container is already running
if docker ps --format "table {{.Names}}" | grep -q "bitcoin-testnet"; then
    print_warning "Bitcoin testnet container is already running"
    print_status "Bitcoin testnet node is running on port 18332"
    exit 0
fi

# Start Bitcoin testnet container
print_status "Starting Bitcoin testnet container..."
docker run -d \
    --name bitcoin-testnet \
    --network host \
    -v "$(pwd)/bitcoin-node/data:/home/bitcoin/.bitcoin" \
    -v "$(pwd)/bitcoin-node/bitcoin.conf:/home/bitcoin/.bitcoin/bitcoin.conf" \
    kylemanna/bitcoind:latest \
    bitcoind -testnet -printtoconsole

# Wait a moment for the container to start
sleep 5

# Check if Bitcoin container started successfully
if docker ps --format "table {{.Names}}" | grep -q "bitcoin-testnet"; then
    print_success "Bitcoin testnet node started successfully!"
    print_status "RPC endpoint: http://127.0.0.1:18332"
    print_status "Data directory: ./bitcoin-node/data"
    print_status "Container name: bitcoin-testnet"
else
    print_error "Failed to start Bitcoin testnet container"
    exit 1
fi

print_status "To stop Bitcoin, run: docker stop bitcoin-testnet"
print_status "To view logs, run: docker logs -f bitcoin-testnet"
print_status "To remove container, run: docker rm bitcoin-testnet" 