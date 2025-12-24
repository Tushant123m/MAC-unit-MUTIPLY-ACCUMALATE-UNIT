# MAC-unit-MUTIPLY-ACCUMALATE-UNIT
FPGA-based matrix multiplication accelerator implemented in Verilog HDL.  The design uses a pipelined MAC architecture with synchronous dual-port RAM,  explicit valid control, and cycle-accurate dataflow. Verified using a  self-checking testbench and designed to be timing-clean under STA.
# Pipelined MAC Unit for Matrix Multiplication Accelerator (FPGA)

This repository contains the design and verification of a **pipelined Multiply–Accumulate (MAC) unit** implemented in **Verilog HDL**, intended as the core compute block for a hardware matrix multiplication accelerator.

The MAC unit performs multiplication and accumulation across clock cycles using explicit valid control and synchronous reset. The design emphasizes **correct RTL behavior, timing safety, and robust handling of sequential data dependencies**, making it suitable for FPGA-based compute accelerators.

---

## 🔧 MAC Unit Overview

The MAC unit computes:

result = result + (a × b)

Key characteristics:
- Fully synchronous design
- Valid-driven accumulation
- Internal accumulator register
- Clean reset behavior
- Timing-safe pipeline structure

The unit is designed to be reusable and scalable as a building block for larger compute engines.

---

## 🐞 Bugs Identified and Fixed (MAC Unit Only)

During development and verification, multiple **critical RTL-level bugs** were identified and fixed in the MAC unit. These fixes were essential for correctness, timing safety, and reliable reuse.

### 1️⃣ Accumulator Using Stale Product Value
**Bug:**  
The accumulator was updated in the same clock cycle as the product computation, causing the accumulator to use the **previous cycle’s product** instead of the current one.

**Fix:**  
Separated the design into pipeline stages using an intermediate register (`product`) and a valid-stage signal, ensuring accumulation occurs **only after the correct product is registered**.

---

### 2️⃣ Missing Pipeline Control Between Multiply and Accumulate
**Bug:**  
Multiply and accumulate operations were implicitly assumed to complete in one cycle, leading to incorrect results when the multiplier latency exceeded one clock cycle.

**Fix:**  
Introduced explicit pipeline staging and valid propagation so that accumulation only occurs when the multiplication result is guaranteed to be ready.

---

### 3️⃣ Incorrect Use of `if-else` Causing Skipped Accumulation
**Bug:**  
An `if (valid_in) ... else if (valid_stage1)` structure prevented accumulation from executing in the intended cycle due to mutually exclusive conditions.

**Fix:**  
Restructured control logic so that accumulation depends on a **registered valid signal**, not on the same-cycle condition, preserving correct sequential behavior.

---

### 4️⃣ “Everyone Is Ready” Handshake Assumption
**Bug:**  
The MAC unit assumed operands, product, and accumulator were all valid simultaneously, ignoring real pipeline delays.

**Fix:**  
Implemented explicit valid signaling to model real hardware timing and prevent accidental accumulation of invalid data.

---

### 5️⃣ Accumulator Not Properly Cleared Between Operations
**Bug:**  
The accumulator retained values across independent computations, causing incorrect results when the MAC was reused.

**Fix:**  
Ensured reset (or clear) explicitly initializes the accumulator before each new computation sequence.

---

### 6️⃣ Misinterpretation of Non-Blocking Assignment Timing
**Bug:**  
The design relied on updated register values within the same clock cycle, violating RTL semantics and causing simulation–hardware mismatch.

**Fix:**  
Reworked logic assuming all RHS evaluations use **previous-cycle values**, aligning RTL behavior with actual hardware operation.

---

## 🧪 Verification

The MAC unit is verified using a cycle-accurate Verilog testbench that:
- Drives operands with valid control
- Exercises multi-cycle accumulation
- Resets and reuses the MAC
- Confirms correctness across multiple input sequences

All fixes were validated through simulation and static timing analysis (STA).

---

## 📈 Why This Matters

This MAC unit demonstrates:
- Strong understanding of RTL timing semantics
- Proper pipeline and valid-signal design
- Real-world debugging of hardware race conditions
- Readiness for integration into larger accelerators

---

## 👤 Author

**Tushant Mishra**  
B.Tech ECE | FPGA & Digital Design
