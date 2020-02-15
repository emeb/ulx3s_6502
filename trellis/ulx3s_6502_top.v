// ulx3s_6502_top.v - top level for tst_6502 on an ULX3S
// 02-13-20 E. Brombaugh

`default_nettype none

module ulx3s_6502_top(
	input  ftdi_txd,
	output ftdi_rxd,
	input  clk_25mhz,
	input [6:0] btn,
	output [7:0] led
);
	// reset generator waits > 10us
	reg [7:0] reset_cnt;
	reg reset;
	initial
        reset_cnt <= 6'h00;
    
	always @(posedge clk_25mhz)
	begin
		if(reset_cnt != 6'hff)
        begin
            reset_cnt <= reset_cnt + 6'h01;
            reset <= 1'b1;
        end
        else
            reset <= 1'b0;
	end
    
	// test unit
	wire [7:0] gpio_o, gpio_i;
	assign gpio_i = {1'b0,btn};
	tst_6502 uut(
		.clk(clk_25mhz),
		.reset(reset),
		
		.gpio_o(gpio_o),
		.gpio_i(gpio_i),
		
		.RX(ftdi_txd),
		.TX(ftdi_rxd)
	);
    
	// drive LEDs from GPIO
	assign led = gpio_o[7:3];
endmodule
