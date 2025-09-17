# ShadowSelf: ZK-Mirrored Identities for Parallel Lives

[![Starknet Hackathon](https://img.shields.io/badge/Hackathon-Re%7BSolve%7D%20Starknet-blueviolet)](https://resolve-starknet.devpost.com/) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview
ShadowSelf is a privacy-preserving identity protocol on Starknet, allowing users to create "shadow" identities as ZK-proven forks of their prime self. Inspired by git branching, shadows evolve independently for contexts like professional vs. anonymous activism, with ZK audits preventing drift. Built for the Privacy & Identity track, it leverages Starknet's STARK proofs for selective disclosure (e.g., prove "over 18" without revealing data).

Why it's insane & new: Dynamic, forkable identities solve real-world privacy issues in Web3, beyond static tools like zkTLS or Starknet ID. Impact: Enables traceless, evolvable personas for global scale.

## Features (MVP)
- Deploy a prime identity contract with committed attributes (e.g., age, skills).
- Fork shadows for specific contexts.
- Generate ZK proofs for selective verification.
- Planned: AI integration via Wootzapp for attribute inference.

## Tech Stack
- **Language**: Cairo (Starknet-native, ZK-friendly).
- **Tools**: Scarb (build/package), Starknet Foundry (test/deploy), OpenZeppelin (security).
- **ZK**: STARK proofs for audits and disclosures.
- **Deployment**: Starknet Sepolia testnet.

## Prerequisites
- Ubuntu/WSL with Rust, asdf, Scarb, and Starknet Foundry (see Installation below).
- Starknet wallet (e.g., Argent) for testing deployments.

## Installation
1. Clone the repo:
git clone https://github.com/U-GOD/Shadow-Self.git
cd Shadow-Self

2. Build contracts:
scarb build

## Usage
1. Test locally:
snforge test

2. Deploy to testnet (update `sncast.toml` with your account):
sncast deploy --class-hash <hash> --salt 0x123</hash>

3. Interact: Use Cairo CLI or a frontend (coming soon) to commit attributes and fork shadows.

## Development Roadmap
- Week 1: Prime contract & commitments.
- Week 2: Forking & basic ZK proofs.
- Week 3: UI, integrations, & demo polish.
- Post-Hack: Mainnet, AI enhancements, ecosystem partnerships.

## Hackathon Submission
- **Track**: Privacy & Identity (Fat Solutions, Starkware, Wootzapp).
- **Progress**: Built during hackathon (see Git commits).
- **Demo**: 3-min video (link coming Oct 15).
- **Pitch Deck**: Optional PDF in repo.

## Contributing
Fork and PR! Questions? Open an issue.

## License
MIT - See [LICENSE](LICENSE) for details.

## Acknowledgments
- Starknet Foundation for workshops.
- Inspired by git versioning & ZK frontiers.