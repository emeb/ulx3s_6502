/*
 * main.c - top level 6502 C code for icestick_6502
 * 03-04-19 E. Brombaugh
 * based on example code from https://cc65.github.io/doc/customizing.html
 */
 
#include <stdio.h>
#include <string.h>
#include "fpga.h"
#include "acia.h"

unsigned long cnt;
unsigned char x = 0;
char txt_buf[32];
unsigned long i;

int main()
{
	// delay a bit
	for(i=0;i<10000;i++)
		x = x + 1;
	
	x = 0;
	
	// Send startup message
	acia_tx_str("\n\n\r     ULX3S 6502 cc65 serial test\n\n\r");
	
	// test some C stuff
	for(i=0;i<26;i++)
		txt_buf[i] = 'A'+i;
	txt_buf[i] = 0;
	acia_tx_str(txt_buf);
	acia_tx_str("\n\r");
	
	// enable ACIA IRQ for serial echo in background
	ACIA_CTRL = 0x80;
	asm("CLI");
	
    // Run forever with GPIO blink
    while(1)
    {
		// delay
		cnt = 4096L;
		while(cnt--)
		{
		}
		
        // write counter msbyte to GPIO
        GPIO_DATA = x;
        x++;
    }

    //  We should never get here!
    return (0);
}
