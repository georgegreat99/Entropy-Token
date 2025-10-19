🌀 Entropy Token

Overview

Entropy Token (ENTROPY) is a dynamic experimental fungible token built on the Stacks blockchain that simulates thermodynamic entropy through random and unpredictable supply fluctuations.
Unlike traditional tokens with fixed or controlled supplies, Entropy Token automatically adjusts its total supply at random intervals, reflecting a state of continual change and uncertainty—just like physical entropy in nature.

🔬 Core Concept

Entropy Token introduces the idea of "supply entropy" to blockchain assets.
Every few blocks, the total supply may increase, decrease, or remain constant, based on random values derived from block data.

Entropy Increase (30%) → Supply decreases.

Entropy Decrease (30%) → Supply increases.

Equilibrium (40%) → Supply remains unchanged.

The direction (add/subtract) has an additional 50/50 probability, introducing double randomness.

This creates a live economic system that constantly evolves without external input.

⚙️ Technical Details
Data Variables
Variable	Type	Description
token-name	string	Token name ("Entropy Token")
token-symbol	string	Token symbol ("ENTROPY")
token-decimals	uint	Number of decimals (6)
total-supply	uint	Dynamic supply (starts at 1,000,000)
last-entropy-block	uint	Tracks last block when entropy was applied
Data Maps
Map	Key	Value	Description
token-balances	principal	uint	Tracks balances per address
allowed-transfers	{owner, spender}	uint	Placeholder for approvals (not yet active)

🔐 Core Functions

Private Functions

get-entropy-seed
Combines block-height and the previous block’s hash to produce a pseudo-random seed.

calculate-entropy-change(seed)
Determines how much the supply changes based on the seed’s randomness.

apply-entropy-change()
Applies entropy-driven supply changes every 10 blocks, either increasing or decreasing supply randomly.

Public Functions

Function	Description

get-name, get-symbol, get-decimals	Retrieve token metadata
get-total-supply	View current dynamic supply
get-balance(principal)	Get balance of any user
transfer(amount, from, to)	Transfer tokens; also triggers possible entropy change
mint(amount, to)	Owner-only minting; also triggers possible entropy change
get-entropy-level	Shows how far the supply has deviated from its initial state

🌍 Entropy Cycle

Entropy adjustments occur automatically every 10 blocks:

A pseudo-random seed is generated using on-chain block data.

Based on probability, the total supply either increases, decreases, or stays the same.

Supply fluctuations are recorded through get-total-supply and get-entropy-level.

🧠 Design Philosophy

Entropy Token isn’t just a token — it’s a conceptual experiment exploring:

Randomness as a fundamental property of blockchain systems.

Unpredictable scarcity and abundance.

Simulated physical principles (entropy) in digital economies.

This makes ENTROPY suitable for academic, experimental DeFi, or tokenomics research contexts.


🚀 Deployment Notes

Deployer automatically becomes the CONTRACT-OWNER and receives the initial 1,000,000 ENTROPY.

Entropy effects are autonomous, requiring no manual intervention.

Minting is restricted to the contract owner.

Designed for experimentation on Stacks testnet or local Simnet.

🧾 License
MIT License