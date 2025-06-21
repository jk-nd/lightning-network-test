# Lightning Network Test Implementation

A comprehensive test environment for exploring and learning the Bitcoin Lightning Network using Docker containers.

## Overview

This project provides a complete setup for testing and experimenting with the Lightning Network, including:

- Bitcoin testnet node running in Docker
- Lightning Network Daemon (LND) running in Docker
- Web interface for interacting with Lightning Network
- Payment channel management
- Transaction testing tools

## Project Structure

```
lightning-network-test/
├── bitcoin-node/          # Bitcoin testnet configuration
├── lnd-config/           # LND configuration files
├── web-interface/        # Simple web UI to interact with LN
├── scripts/              # Setup and utility scripts
├── docs/                 # Documentation and learning resources
└── tests/                # Test scenarios and examples
```

## Prerequisites

- macOS (tested on macOS 24.5.0)
- Git
- Docker Desktop (required for Bitcoin and LND containers)
- Node.js (for web interface)
- Python 3.8+ (for additional tools)

## Quick Start

1. **Clone the repository**
   ```bash
   git clone <your-github-repo-url>
   cd lightning-network-test
   ```

2. **Run setup script**
   ```bash
   ./scripts/setup.sh
   ```

3. **Start the Bitcoin testnet node (Docker)**
   ```bash
   ./scripts/start-bitcoin.sh
   ```

4. **Start the Lightning Network Daemon (Docker)**
   ```bash
   ./scripts/start-lnd.sh
   ```

5. **Create a wallet (if needed)**
   ```bash
   ./scripts/create-wallet.sh
   ```

6. **Access the web interface**
   ```bash
   ./scripts/start-web.sh
   ```

## Docker Containers

This project uses Docker containers for reliable, cross-platform operation:

- **Bitcoin testnet**: `kylemanna/bitcoind:latest`
- **LND**: `lightninglabs/lnd:v0.17.5-beta`

### Container Management

- **View running containers**: `docker ps`
- **View Bitcoin logs**: `docker logs -f bitcoin-testnet`
- **View LND logs**: `docker logs -f lnd-testnet`
- **Stop Bitcoin**: `docker stop bitcoin-testnet`
- **Stop LND**: `docker stop lnd-testnet`

## Features

- [x] Bitcoin testnet node setup (Docker)
- [x] LND installation and configuration (Docker)
- [ ] Payment channel creation and management
- [ ] Lightning invoice generation
- [ ] Payment routing and testing
- [ ] Web-based wallet interface
- [ ] Transaction monitoring
- [ ] Network topology visualization

## Learning Resources

- [Lightning Network Specification (BOLTs)](https://github.com/lightningnetwork/lightning-rfc)
- [LND Documentation](https://docs.lightning.engineering/)
- [Lightning Network Developer Guide](https://lightning.network/lightning-network-summary/)

## Contributing

This is a learning project. Feel free to experiment and contribute improvements!

## License

MIT License - see LICENSE file for details.

## Disclaimer

This is for educational purposes only. Do not use with real Bitcoin on mainnet without proper understanding and security measures.
