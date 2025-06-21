#!/bin/bash

# Lightning Network Daemon (LND) Startup Script (Docker Version)

set -e

echo "⚡ Starting Lightning Network Daemon (LND) using Docker..."

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

# Check if Bitcoin container is running
if ! docker ps --format "table {{.Names}}" | grep -q "bitcoin-testnet"; then
    print_error "Bitcoin testnet container is not running. Please start Bitcoin first:"
    print_status "Run: ./scripts/start-bitcoin.sh"
    exit 1
fi

# Create LND data directory if it doesn't exist
mkdir -p lnd-config/data

# Check if LND container is already running
if docker ps --format "table {{.Names}}" | grep -q "lnd-testnet"; then
    print_warning "LND testnet container is already running"
    print_status "LND is running on port 10009"
    exit 0
fi

# Start LND container
print_status "Starting LND container..."
docker run -d \
    --name lnd-testnet \
    --network ln-testnet \
    -v "$(pwd)/lnd-config/data:/root/.lnd" \
    -v "$(pwd)/lnd-config/lnd.conf:/root/.lnd/lnd.conf" \
    lightninglabs/lnd:v0.17.5-beta \
    lnd --configfile=/root/.lnd/lnd.conf

# Wait for LND to start
print_status "Waiting for LND to start..."
sleep 10

# Check if LND container started successfully
if docker ps --format "table {{.Names}}" | grep -q "lnd-testnet"; then
    print_success "LND started successfully!"
    print_status "LND is running on port 10009"
    print_status "REST API: https://127.0.0.1:8080"
    print_status "gRPC: 127.0.0.1:10009"
    print_status "Container name: lnd-testnet"
else
    print_error "Failed to start LND container"
    exit 1
fi

print_status "To stop LND, run: docker stop lnd-testnet"
print_status "To view logs, run: docker logs -f lnd-testnet"
print_status "To remove container, run: docker rm lnd-testnet"

# Check if wallet exists
if docker exec lnd-testnet ls /root/.lnd/data/chain/bitcoin/testnet/wallet.db &> /dev/null; then
    print_success "Wallet already exists"
else
    print_warning "No wallet found. You'll need to create one:"
    print_status "Run: ./scripts/create-wallet.sh"
fi 