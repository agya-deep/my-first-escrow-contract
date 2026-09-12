# Basic Escrow Smart Contract

A basic Ethereum escrow smart contract written in Solidity and tested using Foundry.

The contract allows a buyer to deposit ETH into escrow, release the funds to the seller before the deadline, or request a refund after the deadline.

## Features

- Buyer can deposit ETH into the escrow.
- Only the buyer can release funds to the seller.
- Buyer or seller can trigger a refund after the deadline.
- Prevents multiple deposits.
- Prevents releasing or refunding the same escrow more than once.
- Includes deadline-based escrow logic.
- Includes Foundry tests covering successful and failure cases.

## Contract Flow


                Buyer
                  |
                  | deposit ETH
                  v
            +-------------+
            |   Escrow    |
            +-------------+
             /           \
            /             \
     release()          refund()
          |                 |
          v                 v
       Seller             Buyer
## Deposit 
The buyer deposits ETH into the escrow contract.
Buyer → Escrow
## Release
Before the deadline, the buyer can release the escrowed ETH to the seller.
Escrow → Seller
## Refund
After the deadline, either the buyer or seller can trigger a refund.
Escrow → Buyer
## Contract State
The contract keeps track of:
- seller — address receiving released funds
- buyer — address allowed to deposit and release funds
- amount — amount of ETH currently held by the escrow
- deposited — whether a deposit has been made
- released — whether funds have been released
- refunded — whether funds have been refunded
- deadline — timestamp after which a refund can be requested
## Tests
The project includes tests for:
- Successful deposits
- Unauthorized deposits
- Duplicate deposits
- Successful fund release
- Unauthorized fund release
- Release without a deposit
- Refund before the deadline
- Buyer refund after the deadline
- Seller refund after the deadline
- Release after the deadline
- Refund after release
- Multiple release attempts
- Multiple refund attempts
- Release after refund
### Run the test suite with:
forge test
## Project Structure
.
├── src/
│   └── escrow.sol
├── test/
│   └── escrow.t.sol
├── script/
│   └── DeployEscrow.s.sol
├── lib/
│   └── forge-std/
├── foundry.toml
├── foundry.lock
└── README.md
## Tech Stack
- Solidity
- Foundry
- Forge
- Ethereum / EVM
## Running Locally
### Clone the repository:
git clone <repository-url>
cd my-first-escrow-contract
### Install dependencies:
forge install
### Build the project:
forge build
### Run tests:
forge test
## Disclaimer
This is a basic educational project created to learn Solidity, Ethereum smart contract development, and Foundry testing.
It has not been audited and should not be used to hold real funds in production.