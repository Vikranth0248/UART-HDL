# UART-verilog
In the process of learning HDL for RTL design, came across some widely used pheripheral protocols like UART, SPI, I2C. So to get a deeper knowledge about the working procedure of communication procotols and to get hands on project experiance in RTL design, I started designing an UART module using Verilog. This repository helped me dive deep into the world of embedded systems, flow of data between modules inside IC, and the working principle of UART.

## UART Data Packet Format

> | Field      | Bit count | Description |
> |------------|-----------|-------------|
> | Start bit  | 1         | Always one sync bit (logic 0) |
> | Data bits  | 5–9       | LSB-first payload bits |
> | Parity bit | 0–1       | Optional even/odd parity |
> | Stop bits  | 1–2       | Line idle high ending frame |

**Example Frame:** 1 Start + 8 Data + 1 Parity + 1 Stop = 11 total bits 

