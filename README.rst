SCAbox IPs
***************************************************************

.. image:: https://img.shields.io/github/license/samiBendou/sca-ip
    :target: https://choosealicense.com/licenses/mit/
    :alt: license

.. image:: https://img.shields.io/github/deployments/samiBendou/sca-ip/github-pages
    :target: https://emse-sas.github.io/sca-ip/
    :alt: pages

`Website <https://emse-sas-lab.github.io/SCAbox/>`_

Overview
===============================================================

This repository contains FPGA IP cores built for the
`SCAbox <https://emse-sas-lab.github.io/SCAbox/>`_ project

- Targets : cryptographic accelerators
- Sensors : voltage sensors
- Storage : synchronous sensor data storage

Each IP in this repository is provided with all the interface needed to be reusable in any
Vivado block design 

- RTL designs
- AXI4-Lite interfaces
- IP customization GUI
- Embedded drivers

Features
===============================================================

Sensors
---------------------------------------------------------------

- Time-to-Digital Converter based sensor (TDC)
- Ring-Oscillator-based sensor (RO)

Targets
---------------------------------------------------------------

- Advanced Encryption Standard Block Cipher (AES) 
- Present Block Cipher (PRESENT)
- Klein Block Cipher (KLEIN)
- Crypton Block Cipher (CRYPTON)

Storage
---------------------------------------------------------------

- FIFO hybrid acquisition controller (to be interfaced with a FIFO)
- FIFO hybrid acquisition controller + embedded FIFO 

Install
===============================================================

To install the repository you must first clone the sources from GitHub

.. code-block:: shell

    $ git clone  https://github.com/emse-sas-lab/SCAbox-ip
    
Then, launch Vivado and add each IP you need into your IP repositories.


Compatibility
---------------------------------------------------------------

The IPs have been tested on the Zybo-Z7010 board but are meant to work on any Zynq Xilinx board. 

Usage
===============================================================

Our IPs can be integrated to any Vivado block design as you can do with already existing IP blocks.
To integrate an IP just add the directory containing the IP to your IP repositories.
Use the customization GUI to change the parameters of each IP.

Documentation
===============================================================

The complete documentation of the IP repo is available `here < https://github.com/emse-sas-lab/SCAbox-ip>`_.
The project contains both hardware and software parts, 
therefore this documentation is split into two different websites.

Drivers
---------------------------------------------------------------

The documentation for the C drivers of the IPs can be found `here <c/index.html>`_

Hardware
---------------------------------------------------------------

The documentation of the IPs RTL can be found `here <hdl/index.html>`_

Build
---------------------------------------------------------------

You can generate the documentation of this repository from the sources using Doxygen and sphinx.
To do so, input the following commands from the root of the project :

.. code-block:: shell

    $ cd docs
    $ doxygen Doxyfile_c
    $ doxygen Doxyfile_vhd
    $ make html

More
===============================================================

SCABox is a project on the topic of side-channel analysis.
The goal of SCAbox is to provide an efficient test-bench for FPGA-based side-channel analysis.

To know more about SCABox please visit our `website <https://emse-sas-lab.github.io/SCAbox/>`_.
It provides a tutorials and a wiki about side-channel analysis.

SCABox is an open-source project, all the sources are hosted on GitHub

- `IP repository <https://github.com/emse-sas-lab/SCAbox-ip/>`_
- `Acquisition demo <https://github.com/emse-sas-lab/SCAbox-demo/>`_
- `Attack demo <https://github.com/emse-sas-lab/SCAbox-automation/>`_
- `SCAbox website  <https://github.com/emse-sas-lab/SCAbox/>`_

Contributing
---------------------------------------------------------------

Please feel free to take part into SCABox project, all kind of contributions are welcomed.

The project aims at gathering a significant number of IP cores, crypto-algorithms and attack models 
in order to provide an exhaustive view of today's remote SCA threat.

Software and embedded improvements are also greatly welcomed. Since the project is quite vast and invovles
a very heterogeneous technical stack, it is difficult to maintain the quality with a reduced size team.  

License
---------------------------------------------------------------

All the contents of the SCABox project are licensed under the `MIT license <https://choosealicense.com/licenses/mit/>`_ provided in each GitHub repository.

Copyright (c) 2020 Anonymous
