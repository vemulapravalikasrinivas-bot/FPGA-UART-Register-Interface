# FPGA UART Register Interface

A UART-based communication system written in Verilog/SystemVerilog.

The design receives commands through UART, stores data into an internal register file, and returns register contents through UART read operations.

---

## Features

- UART Receiver
- UART Transmitter
- Baud Rate Generator
- Byte Buffer
- Command Parser
- Register File
- Read/Write Operations
- Hex-to-ASCII Conversion
- Read Data Transmission Controller

---

## Command Format

### Write

W 08 01

Meaning:

Write 0x01 into register address 0x08

### Read

R 08 00

Meaning:

Read register address 0x08

Returned UART Data:

01

---

## Design Flow
<img width="1536" height="1024" alt="ChatGPT Image May 27, 2026, 01_49_04 PM" src="https://github.com/user-attachments/assets/8813daa3-1bb3-46ba-9ca7-b72b1bae3a82" />
UART RX
↓
Byte Buffer
↓
Command Parser
↓
Register File
↓
TX Controller
↓
UART TX

---

## Simulation

Simulation performed using:

- EDA Playground
- Icarus Verilog
- Vivado 2024.1

### Example

Write Command:

W 08 01

Read Command:

R 08 00

Output:

01

---

## Synthesis

Successfully synthesized using:

- Vivado 2024.1

---

## Future Work

- FPGA implementation on Vivado
- BRAM-based register file
- Command checksum support
- SPI/UART bridge
- APB interface
- AXI-Lite interface

---

## Author

Pravalika Vemula
B.Tech ECE
RGUKT Basar
