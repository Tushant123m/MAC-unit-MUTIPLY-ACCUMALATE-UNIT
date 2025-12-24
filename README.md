# FPGA-Based MAC Unit with Synchronous RAM for Matrix Multiplication

This repository contains the design and verification of a **pipelined Multiply–Accumulate (MAC) unit** integrated with a **synchronous dual-port RAM**, implemented in **Verilog HDL**.  
Together, these blocks form the core compute and storage infrastructure for a hardware matrix multiplication accelerator.

The project focuses on **correct RTL behavior, pipeline control, timing awareness, and memory interfacing**, rather than only functional correctness.

---

## 🔧 Design Overview

### MAC Unit
- Performs: result = result + (a × b)
- Uses valid-driven accumulation
- Internal registered accumulator
- Explicit reset and pipeline staging
- Designed for reuse across multiple computations

### RAM
- Synchronous dual-port RAM
- Independent read/write ports
- Single-clock operation
- Used for operand storage and result write-back

---

## 🐞 Bugs Identified and Fixed

### 🔹 MAC Unit Bugs

#### 1️⃣ Accumulator Using Stale Product Value
**Bug:**  
The accumulator was updated in the same cycle as multiplication, causing it to use the **previous cycle’s product**.

**Fix:**  
Separated multiply and accumulate stages using registered intermediate values and valid propagation.

---

#### 2️⃣ Missing Pipeline Control Between Multiply and Accumulate
**Bug:**  
The design assumed multiplication and accumulation completed in one cycle, ignoring multiplier latency.

**Fix:**  
Introduced explicit pipeline staging and delayed accumulation until the product was guaranteed to be valid.

---

#### 3️⃣ Incorrect `if–else` Control Logic
**Bug:**  
An `if (valid_in) else if (valid_stage)` structure prevented accumulation from executing in the intended cycle.

**Fix:**  
Redesigned control flow so accumulation depends only on **registered valid signals**, not same-cycle conditions.

---

#### 4️⃣ Improper Assumption of Simultaneous Readiness
**Bug:**  
The MAC assumed operands, product, and accumulator were all valid in the same cycle.

**Fix:**  
Added explicit valid signaling to correctly model real hardware timing behavior.

---

#### 5️⃣ Accumulator Not Cleared Between Independent Operations
**Bug:**  
Accumulator retained previous results when starting a new computation.

**Fix:**  
Ensured reset/clear explicitly initializes the accumulator before each new operation.

---

#### 6️⃣ Misunderstanding of Non-Blocking Assignment Semantics
**Bug:**  
The design relied on updated register values within the same clock cycle.

**Fix:**  
Reworked logic assuming all RHS evaluations use **previous-cycle values**, matching real hardware behavior.

---

### 🔹 RAM Bugs

#### 7️⃣ Incorrect Assumption of Combinational Read
**Bug:**  
The testbench assumed RAM read data was available in the same cycle as the address change.

**Fix:**  
Corrected control logic to account for **synchronous read latency**, adding explicit clock-cycle waits.

---

#### 8️⃣ Read and Write Timing Collision
**Bug:**  
Read and write operations were assumed to occur independently without considering clock-edge ordering.

**Fix:**  
Aligned all RAM accesses to clock edges and ensured writes occur only on `posedge clk`.

---

#### 9️⃣ Address Change Without Clock Synchronization
**Bug:**  
Addresses were changed without guaranteeing a clock edge before sampling output data.

**Fix:**  
Introduced clock-aligned address updates and enforced a full-cycle delay before data usage.

---

## 🧪 Verification

A cycle-accurate Verilog testbench verifies:
- MAC accumulation correctness across multiple cycles
- Proper reset and reuse of the MAC
- Correct RAM read/write behavior
- Correct interaction between MAC and RAM timing

All fixes were validated through simulation and static timing analysis (STA).

---

## 📈 Why This Project Matters

This project demonstrates:
- Deep understanding of RTL timing semantics
- Correct use of synchronous memory
- Real-world hardware debugging skills
- Awareness of STA and pipeline correctness
- Ability to build reusable compute blocks

---

## 👤 Author

**Tushant Mishra**  
B.Tech ECE | FPGA & Digital Design
