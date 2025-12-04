# GamePass Smart Contracts

Smart contracts for GamePass play-to-earn platform. Deploy to Celo. Test locally. Verify on Blockscout.

## What These Contracts Do

GamePassToken: ERC20 token for payments and rewards. Players use PASS tokens to mint Gems. Top players earn PASS rewards.

GamePassSwap: Buy PASS tokens with CELO or cUSD. Exchange rates set by owner. Mints tokens directly to buyers.

GamePassGem: ERC721 NFT contract. Players mint Gems to unlock games. One Gem costs 34 PASS tokens.

GamePassRewards: Tracks scores. Distributes rewards. Leaderboard management. Prize pool distribution.

## Prerequisites

Install Foundry. Get CELO for gas fees. Have a wallet ready.

Foundry installation: https://book.getfoundry.sh/getting-started/installation

## Installation

Clone the repository. Navigate to contracts folder. Install dependencies.

```bash
git clone <repository-url>
cd GamePass/contracts
forge install
```

Build contracts:

```bash
forge build
```

Run tests:

```bash
forge test
```

All tests must pass before deployment.

## Configuration

Create a `.env` file in the contracts directory:

```
PRIVATE_KEY=0xyour_private_key_with_0x_prefix
TREASURY_ADDRESS=your_treasury_address
ETHERSCAN_API_KEY=your_etherscan_api_key
```

Important notes:
- Private key must include 0x prefix
- Treasury address receives initial 500M PASS tokens
- Etherscan API key works for Celo Mainnet and Celo Sepolia
