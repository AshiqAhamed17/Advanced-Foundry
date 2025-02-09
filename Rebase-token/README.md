# Cross-Chain Rebase Token

1. A protocol that allows users to deposit into a vault in return, receiver rebase tokens that represents the underlying balance

2. Rebase-token -> balanceOf function is dynamic to show the changing balance with time.
    - Balance increase linearly with time.
    - Mint token to the users every time they perform an action (minting, burning, transferring, or ... bridging).

3. Interest Rate
    - Individually set an interest rate or each user based on some global interest rate of the protocol at the time at user deposits into vault.
    - This global interest rate can only decrease to incetivise/rewards early adopters.
    - Increase Token Adoption!

---


## 🔹 How It Works

### 1️⃣ Vault-Based Deposits
- Users deposit assets like **ETH or USDC** into the vault.
- They receive **rebase tokens** (e.g., `rETH`).
- Over time, their **rETH balance increases automatically**.

🛠 **Example:**
- Alice deposits **10 ETH** → Receives **10 rETH**.
- After **1 month** (with 5% APY) → Balance becomes **10.41 rETH**.

---

### 2️⃣ Dynamic `balanceOf()`
Unlike standard ERC20 tokens, **rebase tokens do not store balances**. Instead, the **balance is calculated dynamically**.

- Balance **updates automatically** using a time-weighted formula.
- Whenever users **mint, burn, transfer, or bridge**, the balance adjusts.

🛠 **Example:**
- Alice has **10 rETH**.
- After **30 days**, `balanceOf(Alice)` shows **10.41 rETH**.

---

### 3️⃣ Interest Rate Model
- A **global interest rate** is set when users deposit.
- This **rate decreases over time** to **reward early adopters**.
- The **longer you hold**, the **more rewards you get**.

🛠 **Example:**
- Alice deposits first → **5% APY**.
- Bob deposits later → **3% APY** (since more users joined).
- Alice earns **more over time**.

---

### 4️⃣ Cross-Chain Bridging
Rebase tokens **maintain their rebasing effect across chains**.

- **Burn & Mint Model**: Tokens are **burned on Chain A** and **minted on Chain B**.
- **Liquidity Pool Model**: Uses **cross-chain liquidity pools** instead of burning.

🛠 **Example:**
- Alice has **10 rETH on Ethereum**.
- She bridges to **Arbitrum**.
- Her balance continues **growing at the same rate**.

---
