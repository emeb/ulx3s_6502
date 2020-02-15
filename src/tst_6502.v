// tst_6502.v - test 6502 core
// 02-11-19 E. Brombaugh

`default_nettype none

module tst_6502(
    input clk,              // 4..0MHz CPU clock
    input reset,            // Low-true reset
    
	output reg [7:0] gpio_o,
	input [7:0] gpio_i,
	
	input RX,				// serial RX
	output TX				// serial TX
);
    // The 6502
    wire [15:0] CPU_AB;
    reg [7:0] CPU_DI;
    wire [7:0] CPU_DO;
    wire CPU_WE, CPU_IRQ;
    cpu ucpu(
        .clk(clk),
        .reset(reset),
        .AB(CPU_AB),
        .DI(CPU_DI),
        .DO(CPU_DO),
        .WE(CPU_WE),
        .IRQ(CPU_IRQ),
        .NMI(1'b0),
        .RDY(1'b1)
    );
    
	// address decode - not fully decoded for 512-byte memories
	wire p0 = (CPU_AB[15:12] == 4'h0) ? 1 : 0;
	wire p1 = (CPU_AB[15:12] == 4'h1) ? 1 : 0;
	wire p2 = (CPU_AB[15:12] == 4'h2) ? 1 : 0;
	wire pf = (CPU_AB[15:12] == 4'hf) ? 1 : 0;
	
	// RAM @ pages 00-0f
	reg [7:0] ram_mem[4095:0];
	reg [7:0] ram_do;
	always @(posedge clk)
		if((CPU_WE == 1'b1) && (p0 == 1'b1))
			ram_mem[CPU_AB[11:0]] <= CPU_DO;
	always @(posedge clk)
		ram_do <= ram_mem[CPU_AB[11:0]];
	
	// GPIO @ page 10-1f
	reg [7:0] gpio_do;
	always @(posedge clk)
		if((CPU_WE == 1'b1) && (p1 == 1'b1))
			gpio_o <= CPU_DO;
	always @(posedge clk)
		gpio_do <= gpio_i;
	
	// ACIA at page 20-2f
	wire [7:0] acia_do;
	acia uacia(
		.clk(clk),				// system clock
		.rst(reset),			// system reset
		.cs(p2),				// chip select
		.we(CPU_WE),			// write enable
		.rs(CPU_AB[0]),			// register select
		.rx(RX),				// serial receive
		.din(CPU_DO),			// data bus input
		.dout(acia_do),			// data bus output
		.tx(TX),				// serial transmit
		.irq(CPU_IRQ)			// interrupt request
	);
	
	// ROM @ pages f0,f1...
    reg [7:0] rom_mem[4095:0];
	reg [7:0] rom_do;
	initial
        $readmemh("rom.hex",rom_mem);
	always @(posedge clk)
		rom_do <= rom_mem[CPU_AB[11:0]];

	// data mux
	reg [3:0] mux_sel;
	always @(posedge clk)
		mux_sel <= CPU_AB[15:12];
	always @(*)
		casez(mux_sel)
			4'h0: CPU_DI = ram_do;
			4'h1: CPU_DI = gpio_do;
			4'h2: CPU_DI = acia_do;
			4'hf: CPU_DI = rom_do;
			default: CPU_DI = rom_do;
		endcase
endmodule
