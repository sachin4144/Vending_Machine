# Vending_Machine

A Verilog-based implementation of a digital vending machine. This project models the behavior of a vending machine as a finite state machine (FSM), handling coin input, product selection, dispensing, and change return. It serves as an educational resource for understanding FSM design in digital logic and Verilog.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Features](#features)
- [System Architecture](#system-architecture)
- [Modules](#modules)
- [Usage](#usage)
- [Simulation & Testing](#simulation--testing)
- [File Structure](#file-structure)
- [Contributing](#contributing)
- [License](#license)
- [References](#references)

---

## Project Overview

This repository provides a Verilog implementation of a vending machine that accepts coins, allows users to select products, dispenses items, and provides change where applicable. It demonstrates the use of finite state machines for control logic and modular design principles in Verilog.

---

## Features

- **Coin Insertion:** Supports multiple denominations.
- **Product Selection:** Multiple products with configurable prices.
- **Dispense Logic:** Dispenses products when sufficient funds are inserted.
- **Change Return:** Returns change if excess money is inserted.
- **Reset Functionality:** System can be reset to initial state.
- **Error Handling:** Handles invalid selection and insufficient funds.

---

## System Architecture

The system is divided into the following main modules:

1. **Input Interface**
    - Accepts coins and product selections.
2. **FSM Controller**
    - Manages states: idle, selection, dispense, change, error.
3. **Output Interface**
    - Drives product dispense and change return signals.

### State Diagram

```
+-------+       coin inserted      +-----------+
| Idle  |------------------------>| Selection |
+-------+                         +-----------+
     ^                                   |
     |                                   v
     |                              +----------+
     |          insufficient funds  |  Error   |
     +<-----------------------------+----------+
     |
     | sufficient funds     dispense
     |-------------------->+-----------+
                           | Dispense  |
                           +-----------+
                                 |
                                 v
                           +-----------+
                           |  Change   |
                           +-----------+
                                 |
                                 v
                             (Idle)
```

---

## Modules

### 1. `vending_machine.v`
- Top-level module integrating all submodules.
- Instantiates FSM, input, and output logic.

### 2. `fsm_controller.v`
- Implements the finite state machine for system control.
- Handles transitions between states.

### 3. `coin_input.v`
- Debounces and processes coin insertion signals.

### 4. `product_select.v`
- Handles product selection logic and verifies input validity.

### 5. `dispense.v`
- Controls the dispense mechanism for products.

### 6. `change_return.v`
- Calculates and returns change to the user.

### 7. `tb_vending_machine.v`
- Testbench for simulation and verification.

---

## Usage

### Requirements

- Verilog simulator (e.g., ModelSim, Icarus Verilog, Vivado)
- Optional: FPGA development board for hardware implementation

### Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/sachin4144/Vending_Machine.git
   ```
2. **Navigate to the project directory:**
   ```bash
   cd Vending_Machine
   ```
3. **Run simulation (example with Icarus Verilog):**
   ```bash
   iverilog -o vending_machine_tb tb_vending_machine.v vending_machine.v
   vvp vending_machine_tb
   ```
4. **View waveform (optional):**
   ```bash
   gtkwave vending_machine_tb.vcd
   ```

### Customization

- Change product prices in `product_select.v`
- Add more products or coin denominations as needed

---

## Simulation & Testing

- The testbench `tb_vending_machine.v` provides scenarios for coin insertion, product selection, and reset functionality.
- Waveform files can be generated for debugging and verification.

---

## File Structure

```
Vending_Machine/
├── vending_machine.v         # Top-level module
├── fsm_controller.v         # FSM logic
├── coin_input.v             # Coin input processing
├── product_select.v         # Product selection logic
├── dispense.v               # Dispense control
├── change_return.v          # Change return logic
├── tb_vending_machine.v     # Testbench
└── README.md                # Documentation
```

---

## Contributing

Contributions are welcome! Please open issues or submit pull requests to improve features, fix bugs, or enhance documentation.

---

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

---

## References

- [Verilog HDL: A Guide to Digital Design and Synthesis](https://www.amazon.com/Verilog-HDL-Guide-Digital-Synthesis/dp/0136398877)
- [Finite State Machines in HDL](https://www.fpga4student.com/2017/08/verilog-code-for-finite-state-machine.html)
- [Icarus Verilog Documentation](http://iverilog.icarus.com/)
