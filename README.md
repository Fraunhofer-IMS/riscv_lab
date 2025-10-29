# Fraunhofer IMS RISC-V Lab

[![Fraunhofer_IMS](https://img.shields.io/badge/Fraunhofer-IMS-179c7d.svg?longCache=true&style=flat&logo=fraunhofergesellschaft&logoColor=179c7d)](https://ims.fraunhofer.de/en.html)
[![license](https://img.shields.io/github/license/Fraunhofer-IMS/riscv_lab?longCache=true&style=flat&logo=bsd)](https://github.com/Fraunhofer-IMS/riscv_lab/blob/main/LICENSE)

This repository hosts the _RISC-V Lab_, a collaborative educational project by
[Fraunhofer IMS](https://ims.fraunhofer.de/en.html) in cooperation with the
[University of Duisburg-Essen](https://uni-due.de/en).

The goal of this lab is to give students hands-on experience with [RISC-V](https://riscv.org),
an open and free instruction set architecture that is shaping the future of computing. Within
this lab, students will explore a RISC-V-based platform implemented on the
[Digilent Nexy A7](https://digilent.com/reference/programmable-logic/nexys-a7/start) FPGA
development board using a fully open-source and royalty-free soft-core processor.

Initially, the setup is used much like a simple microcontroller platform - ideal for getting started
with embedded programming and digital design. Later exercises may extend into system-level topics
such as custom accelerators and interfaces, hardware/software co-design, and verification.

[![riscv_logo](docs/img/riscv_logo_small.png)](https://riscv.org)

We welcome contributions! If you encounter issues or have suggestions, please use GitHub
[Issues](https://github.com/Fraunhofer-IMS/riscv_lab/issues) or the
[Discussions](https://github.com/Fraunhofer-IMS/riscv_lab/discussions) board for feedback.
Pull requests are highly appreciated! For academic or organizational inquiries,
please contact the lab staff:

* **T.B.A.**


## Getting Started

Clone this repository using `git`. Note that this repository uses submodules. Hence, you need to clone
_recursively_ to include all submodules.

```bash
git clone --recurse-submodules https://github.com/Fraunhofer-IMS/riscv_lab.git
```

> [!WARNING]
> If you just use the _Download_ button the **submodules will not be included** and have to be downloaded manually.

The [`vivado`](vivado) folder contains the actual hardware design of the RISC-V SoC implemented
on the FPGA. Here you will also find documentation on the integrated peripherals connected to the
SoC. Tutorials also show you how to set up the Vivado project yourself.

The [`eclipse`](eclipse) folder provides a preconfigured example project and instructions on how
to set up and configure Eclipse to start coding.


## Legal

This project is released under the permissive BSD-3-clause license.
See [`LICENSE`](LICENSE) for more information.

Copyright (c) 2025 by Fraunhofer Institute for Microelectronic Circuits and Systems (_Fraunhofer IMS_).\
Finkenstrasse 61, 47057 Duisburg, Germany.\
https://ims.fraunhofer.de/en.html


### Proprietary Notice

* "Nexys" is a trademark of Digilent Inc.
* "Vivado" and "Artix" are trademarks of AMD Inc.
* "AXI", "AXI4", "AXI4-Lite" and "AXI4-Stream" are trademarks of Arm Holdings plc.
* "Windows" is a trademark of Microsoft Corporation.
* "ESP" is a trademark of Espressif Systems (Shanghai) Co., Ltd.
* "Eclipse" is trademark of the Eclipse Foundation.
* "PuTTY" copyright by Simon Tatham.
* "Tera Term" copyright by T. Teranishi.
* "Zadig" copyright by Pete Batard.

All further/unreferenced projects/products/brands belong to their according copyright holders.
No copyright infringement intended.

### Limitation of Liability for External Links

This document contains links to the websites of third parties ("external links"). As the content of these websites
is not under our control, we cannot assume any liability for such external content. In all cases, the provider of
information of the linked websites is liable for the content and accuracy of the information provided. At the
point in time when the links were placed, no infringements of the law were recognizable to us. As soon as an
infringement of the law becomes known to us, we will immediately remove the link in question.
