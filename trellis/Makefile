# Makefile for trellis tools + yosys + nextpnr
# 02-13-20 E. Brombaugh

# src directory
VPATH = .:../src/:../verilog-6502/

SRC =	ulx3s_6502_top.v ../src/tst_6502.v \
		../verilog-6502/cpu.v ../verilog-6502/ALU.v \
		../src/acia.v ../src/acia_tx.v ../src/acia_rx.v \

# preparing the machine code
FAKE_HEX =	rom.hex
REAL_HEX =  code.hex

# project stuff
PROJ = ulx3s_6502_top
LPF = ulx3s_v20.lpf
DEVICE = 85k

YOSYS = /usr/local/bin/yosys
NEXTPNR = nextpnr-ecp5
NEXTPNR_ARGS = 
ECPPACK = ecppack
ECPBRAM = ecpbram
UJPROG = ujprog
VERILATOR = verilator
#TECH_LIB = /usr/local/share/yosys/ecp5/cells_sim.v
TECH_LIB = 
HEXDUMP = hexdump
HEXDUMP_ARGS = -v -e '1/1 "%02x " "\n"'

all: $(PROJ).bit
		
$(FAKE_HEX):
	$(ECPBRAM) -w 8 -d 4096 -g $(FAKE_HEX)

%.json: $(SRC) $(FAKE_HEX)
	$(YOSYS) -p 'synth_ecp5 -nomux -nodram -top $(PROJ) -json $@' $(SRC)

%.config: %.json $(LPF) 
	$(NEXTPNR) $(NEXTPNR_ARGS) --$(DEVICE) --json $< --lpf $(LPF) --textcfg $@

$(REAL_HEX):
	$(MAKE) -C ../cc65/
	cp ../cc65/$(FAKE_HEX) ./$(REAL_HEX)
	
%.bit: %.config $(REAL_HEX)
	$(ECPBRAM) -f $(FAKE_HEX) -t $(REAL_HEX) -i $< -o temp.config
	$(ECPPACK) temp.config $@ --compress

prog: $(PROJ).bit
	$(UJPROG) $<
	
prog_term: $(PROJ).bit
	$(UJPROG) -t -b 9600 $<
	
recode:
	rm -f $(REAL_HEX) $(PROJ).bit
	$(MAKE) prog
    
lint: $(SRC)
	$(VERILATOR) --lint-only -Wall --top-module $(PROJ) $(TECH_LIB) $(SRC)

clean:
	rm -f $(PROJ).json $(PROJ).config temp.config $(PROJ).bit *.hex

.SECONDARY:
.PHONY: all prog clean
