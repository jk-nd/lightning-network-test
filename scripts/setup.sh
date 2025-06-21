#!/bin/bash

# Lightning Network Test Environment Setup Script
# This script sets up the basic environment for testing Lightning Network

set -e  # Exit on any error

echo "🚀 Setting up Lightning Network Test Environment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
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

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "This script is designed for macOS. Please run on a macOS system."
    exit 1
fi

print_status "Checking prerequisites..."

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    print_warning "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    print_success "Homebrew is installed"
fi

# Check if Git is installed
if ! command -v git &> /dev/null; then
    print_error "Git is not installed. Please install Git first."
    exit 1
else
    print_success "Git is installed"
fi

# Check if Docker is installed (optional)
if command -v docker &> /dev/null; then
    print_success "Docker is installed"
else
    print_warning "Docker not found. It's optional but recommended for containerized setup."
fi

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    print_warning "Node.js not found. Installing Node.js..."
    brew install node
else
    print_success "Node.js is installed ($(node --version))"
fi

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    print_warning "Python 3 not found. Installing Python 3..."
    brew install python
else
    print_success "Python 3 is installed ($(python3 --version))"
fi

print_status "Creating configuration directories..."

# Create necessary directories
mkdir -p bitcoin-node/data
mkdir -p lnd-config/data
mkdir -p web-interface/src
mkdir -p docs/guides
mkdir -p tests/scenarios

print_status "Setting up Bitcoin testnet configuration..."

# Create Bitcoin testnet configuration
cat > bitcoin-node/bitcoin.conf << 'EOF'
# Bitcoin testnet configuration
testnet=1
server=1
rpcuser=lightning_test
rpcpassword=lightning_test_password
rpcallowip=127.0.0.1
rpcbind=127.0.0.1
rpcport=18332
txindex=1
index=1
EOF

print_status "Setting up LND configuration..."

# Create LND configuration
cat > lnd-config/lnd.conf << 'EOF'
# LND configuration for testnet
[Application Options]
debuglevel=info
maxpendingchannels=5
alias=LightningTestNode
color=#3399FF

[Bitcoin]
bitcoin.active=1
bitcoin.testnet=1
bitcoin.node=bitcoind

[Bitcoind]
bitcoind.rpcuser=lightning_test
bitcoind.rpcpass=lightning_test_password
bitcoind.rpchost=127.0.0.1
bitcoind.rpcport=18332
bitcoind.zmqpubrawblock=tcp://127.0.0.1:28332
bitcoind.zmqpubrawtx=tcp://127.0.0.1:28333

[Routerrpc]
routerrpc.minrtlntimeout=40

[Invoices]
invoices.holdinvoice=1
EOF

print_status "Creating web interface package.json..."

# Create package.json for web interface
cat > web-interface/package.json << 'EOF'
{
  "name": "lightning-network-web-interface",
  "version": "1.0.0",
  "description": "Web interface for Lightning Network testing",
  "main": "src/index.js",
  "scripts": {
    "start": "node src/index.js",
    "dev": "nodemon src/index.js",
    "test": "jest"
  },
  "dependencies": {
    "express": "^4.18.2",
    "socket.io": "^4.7.2",
    "axios": "^1.5.0",
    "dotenv": "^16.3.1"
  },
  "devDependencies": {
    "nodemon": "^3.0.1",
    "jest": "^29.7.0"
  },
  "keywords": ["lightning", "bitcoin", "testnet"],
  "author": "Your Name",
  "license": "MIT"
}
EOF

print_status "Creating basic documentation..."

# Create basic documentation
cat > docs/guides/getting-started.md << 'EOF'
# Getting Started with Lightning Network Testing

## Overview
This guide will help you set up and run your Lightning Network test environment.

## Prerequisites
- macOS (tested on macOS 24.5.0)
- Homebrew
- Git
- Node.js
- Python 3

## Quick Setup
1. Run the setup script: `./scripts/setup.sh`
2. Start Bitcoin testnet: `./scripts/start-bitcoin.sh`
3. Start LND: `./scripts/start-lnd.sh`
4. Access web interface: `./scripts/start-web.sh`

## Next Steps
- Create a wallet
- Open payment channels
- Generate invoices
- Make test payments

## Troubleshooting
See the troubleshooting guide for common issues and solutions.
EOF

print_status "Making scripts executable..."

# Make scripts executable
chmod +x scripts/*.sh

print_success "Setup complete! 🎉"
echo ""
print_status "Next steps:"
echo "  1. Run: ./scripts/start-bitcoin.sh"
echo "  2. Run: ./scripts/start-lnd.sh"
echo "  3. Run: ./scripts/start-web.sh"
echo ""
print_status "For more information, see docs/guides/getting-started.md" 