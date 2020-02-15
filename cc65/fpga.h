/*
 * fpga.h - handy info about the FPGA
 * 03-04-19 E. Brombaugh
 */

#ifndef __FPGA__
#define __FPGA__

#define GPIO_DATA (*(unsigned char *) 0x1000)
#define ACIA_CTRL (*(unsigned char *) 0x2000)
#define ACIA_DATA (*(unsigned char *) 0x2000)

#endif
