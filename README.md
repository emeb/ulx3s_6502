# ulx3s_6502
Simple 6502 system on a ULX3S FPGA board

## prerequisites
To build this you will need the following FPGA tools

* Trellis - Lattice ECP5 FPGA project https://github.com/SymbiFlow/prjtrellis
* Yosys - Synthesis https://github.com/YosysHQ/yosys
* Nextpnr - Place and Route https://github.com/YosysHQ/nextpnr

Additionally, you'll need the ujprog JTAG programming tool for the ULX3S board.
Note that getting this tool running properly can be tricky - I had to build it
from source, making changes to the Makefile and the source code in order for it
to build, run and recognize my ULX3S board.

You will also need the following 6502 tools:

* cc65 6502 C compiler (for default option) https://github.com/cc65/cc65

## Building

	git clone https://github.com/emeb/ulx3s_6502
	cd ulx3s_6502
	git submodule update --init
	cd trellis
	make

## Running

Make sure you've properly set up udev rules for the ULX3S, then plug it in.
Then load the previously built bitstream.

	make prog

The 8 ULX3S LEDs should begin flashing a binary sequence. If you'd like to try
the serial port then that can be done with the command

	ujprog -t -b 9600 ulx3s_6502_top.bit
	
This will load the bitstream and immediately start a 9600 bps terminal session
where you can type and see characters echoed by the 6502. To exit the terminal
session just type "<enter>~."

## CPU coding

By default the build system fills the ROM with code based on the C and assembly
source in the cc65 directory. Optionally you can use pure assembly to create
the ROM with the following commands

	make assembly
	make

within the icestorm directory. 

## Simulating

## Thanks

Thanks to the developers of all the tools used for this, as well as the authors
of the IP cores I snagged for the 6502 and UART. I've added those as submodules
so you'll know where to get them and who to give credit to.
