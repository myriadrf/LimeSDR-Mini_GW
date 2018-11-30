/*
 * main.c
 *
 *  Created on: Jan 22, 2016
 *      Author: zydrunas
 */


#include "io.h"
#include "system.h"
#include "unistd.h"
//#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <altera_avalon_spi.h>
#include "alt_types.h"

#include "LMS64C_protocol.h"
#include "sodera_pcie_brd_v1r0.h"
#include "spi_flash_lib.h"
#include "i2c_opencores.h"

#define sbi(p,n) ((p) |= (1UL << (n)))
#define cbi(p,n) ((p) &= ~(1 << (n)))

//get info
//#define FW_VER				1 //Initial version
//#define FW_VER				2 //FLASH programming added
//#define FW_VER				3 //Temperature and Si5351C control added
//#define FW_VER				4 //LM75 configured to control fan; I2C speed increased up to 400kHz; ADF/DAC control implementation.
//#define FW_VER				5 //EEPROM and FLASH R/W funtionality added
#define FW_VER				6 // DAC value read from EEPROM memory

#define SPI_NR_LMS7002M 0
#define SPI_NR_FPGA     1
#define SPI_NR_DAC      0
#define SPI_NR_FLASH    0

//CMD_PROG_MCU
#define PROG_EEPROM 1
#define PROG_SRAM	2
#define BOOT_MCU	3

///CMD_PROG_MCU
#define MCU_CONTROL_REG	0x02
#define MCU_STATUS_REG	0x03
#define MCU_FIFO_WR_REG	0x04

#define MAX_MCU_RETRIES	30

#define DAC_VAL_ADDR  	0x0010		// Address in EEPROM memory where TCXO DAC value is stored
#define DAC_DEFF_VAL	180			// Default TCXO DAC value loaded when EEPROM is empty

uint8_t MCU_retries;

uint8_t test, block, cmd_errors, glEp0Buffer_Rx[64], glEp0Buffer_Tx[64];
tLMS_Ctrl_Packet *LMS_Ctrl_Packet_Tx = (tLMS_Ctrl_Packet*)glEp0Buffer_Tx;
tLMS_Ctrl_Packet *LMS_Ctrl_Packet_Rx = (tLMS_Ctrl_Packet*)glEp0Buffer_Rx;

unsigned char dac_val = 180;
unsigned char dac_data[2];

signed short int converted_val = 300;

int flash_page = 0, flash_page_data_cnt = 0, flash_data_cnt_free = 0, flash_data_counter_to_copy = 0;
//FPGA conf
unsigned long int last_portion, current_portion, fpga_data;
unsigned char data_cnt;
unsigned char sc_brdg_data[4];
unsigned char flash_page_data[FLASH_PAGE_SIZE];
tBoard_Config_FPGA *Board_Config_FPGA = (tBoard_Config_FPGA*) flash_page_data;
unsigned long int fpga_byte;

// Used for MAX10 Flash programming
uint32_t CFM0StartAddress = 0x04A000;
uint32_t CFM0EndAddress   = 0x08BFFF;
uint32_t address = 0x0;
uint32_t byte = 0;
uint32_t byte1;
uint32_t word = 0x0;
uint8_t state, Flash = 0x0;

int boot_img_en = 0;



/**	This function checks if all blocks could fit in data field.
*	If blocks will not fit, function returns TRUE. */
unsigned char Check_many_blocks (unsigned char block_size)
{
	if (LMS_Ctrl_Packet_Rx->Header.Data_blocks > (sizeof(LMS_Ctrl_Packet_Tx->Data_field)/block_size))
	{
		LMS_Ctrl_Packet_Tx->Header.Status = STATUS_BLOCKS_ERROR_CMD;
		return 1;
	}
	else return 0;
	return 1;
}

/**
 * Gets 64 bytes packet from FIFO.
 */
void getFifoData(uint8_t *buf, uint8_t k)
{
	uint8_t cnt = 0;
	uint32_t* dest = (uint32_t*)buf;
	for(cnt=0; cnt<k/sizeof(uint32_t); ++cnt)
	{
		dest[cnt] = IORD(AV_FIFO_INT_0_BASE, 1);	// Read Data from FIFO
	};
}


/**
 * Gets led_pattern as parameter in order to write to the register.
 */
void set_led(unsigned char led_pattern)
{
    IOWR(LEDS_BASE, 0, led_pattern);               // writes register
}


/**
 * Configures LM75
 */
void Configure_LM75(void)
{
	int spirez;

	// OS polarity configuration
	spirez = I2C_start(I2C_OPENCORES_0_BASE, LM75_I2C_ADDR, 0);
	spirez = I2C_write(I2C_OPENCORES_0_BASE, 0x01, 0);				// Pointer = configuration register
	//spirez = I2C_start(I2C_OPENCORES_0_BASE, LM75_I2C_ADDR, 1);
	spirez = I2C_write(I2C_OPENCORES_0_BASE, 0x04, 1);				//Configuration value: OS polarity = 1, Comparator/int = 0, Shutdown = 0

	// THYST configuration
	spirez = I2C_start(I2C_OPENCORES_0_BASE, LM75_I2C_ADDR, 0);
	spirez = I2C_write(I2C_OPENCORES_0_BASE, 0x02, 0);				// Pointer = THYST register
	//spirez = I2C_start(I2C_OPENCORES_0_BASE, LM75_I2C_ADDR, 1);
	spirez = I2C_write(I2C_OPENCORES_0_BASE, 45, 0);				// Set THYST H
	spirez = I2C_write(I2C_OPENCORES_0_BASE,  0, 1);				// Set THYST L

	// TOS configuration
	spirez = I2C_start(I2C_OPENCORES_0_BASE, LM75_I2C_ADDR, 0);
	spirez = I2C_write(I2C_OPENCORES_0_BASE, 0x03, 0);				// Pointer = TOS register
	//spirez = I2C_start(I2C_OPENCORES_0_BASE, LM75_I2C_ADDR, 1);
	spirez = I2C_write(I2C_OPENCORES_0_BASE, 55, 0);				// Set TOS H
	spirez = I2C_write(I2C_OPENCORES_0_BASE,  0, 1);				// Set TOS L

}

//
void testEEPROM(void)
{
	int spirez;
	uint8_t converted_val;

	//EEPROM Test, RD from 0x0000
	spirez = I2C_start(I2C_OPENCORES_0_BASE, EEPROM_I2C_ADDR, 0);
	spirez = I2C_write(I2C_OPENCORES_0_BASE, 0x00, 0);
	spirez = I2C_write(I2C_OPENCORES_0_BASE, 0x00, 0);

	spirez = I2C_start(I2C_OPENCORES_0_BASE, EEPROM_I2C_ADDR, 1);
	converted_val = I2C_read(I2C_OPENCORES_0_BASE, 1);

	//WR
	spirez = I2C_start(I2C_OPENCORES_0_BASE, EEPROM_I2C_ADDR, 0);
	spirez = I2C_write(I2C_OPENCORES_0_BASE, 0x00, 0);
	spirez = I2C_write(I2C_OPENCORES_0_BASE, 0x01, 0);
	spirez = I2C_write(I2C_OPENCORES_0_BASE, 0x5A, 1);

	//EEPROM Test, RD from 0x0001
	spirez = I2C_start(I2C_OPENCORES_0_BASE, EEPROM_I2C_ADDR, 0);
	spirez = I2C_write(I2C_OPENCORES_0_BASE, 0x00, 0);
	spirez = I2C_write(I2C_OPENCORES_0_BASE, 0x01, 0);

	spirez = I2C_start(I2C_OPENCORES_0_BASE, EEPROM_I2C_ADDR, 1);
	converted_val = I2C_read(I2C_OPENCORES_0_BASE, 1);
}

/*
void testFlash(void)
{
	uint16_t cnt = 0, page = 0;
	uint8_t spirez;


	spirez = FlashSpiEraseSector(SPI_FPGA_AS_BASE, SPI_NR_FLASH, CyTrue, 0);

	for(page = 0; page < 10; page++)
	{
		for(cnt = 0; cnt < 256; cnt++)
		{
			flash_page_data[cnt] = cnt+page;
		}
		spirez = FlashSpiTransfer(SPI_FPGA_AS_BASE, SPI_NR_FLASH, page, FLASH_PAGE_SIZE, flash_page_data, 0);
	}

	for(page = 0; page < 10; page++)
	{
		spirez = FlashSpiTransfer(SPI_FPGA_AS_BASE, SPI_NR_FLASH, page, FLASH_PAGE_SIZE, flash_page_data, 1);
	}

}
*/


void boot_from_flash(void)
{
	//set CONFIG_SEL overwrite to 1 and CONFIG_SEL to Image 0
	//IOWR(DUAL_BOOT_0_BASE, 1, 0x00000001);

	//set CONFIG_SEL overwrite to 1 and CONFIG_SEL to Image 1
	IOWR(DUAL_BOOT_0_BASE, 1, 0x00000003);

	/*wait while core is busy*/
	while(IORD(DUAL_BOOT_0_BASE, 3) == 1) {}

	//Trigger reconfiguration to selected Image
	IOWR(DUAL_BOOT_0_BASE, 0, 0x00000001);
}

uint16_t rd_dac_val(uint16_t addr)
{
	uint8_t i2c_error;
	uint8_t addr_lsb = (uint8_t) addr & 0x00FF;
	uint8_t addr_msb = (uint8_t) (addr & 0xFF00) >> 8;
	uint8_t eeprom_rd_val_0;
	uint8_t eeprom_rd_val_1;
	uint16_t rez;

	i2c_error = I2C_start(I2C_OPENCORES_0_BASE, EEPROM_I2C_ADDR, 0);
	i2c_error = I2C_write(I2C_OPENCORES_0_BASE, addr_msb, 0);
	i2c_error = I2C_write(I2C_OPENCORES_0_BASE, addr_lsb, 0);
	i2c_error = I2C_start(I2C_OPENCORES_0_BASE, EEPROM_I2C_ADDR, 1);
	eeprom_rd_val_0 = I2C_read(I2C_OPENCORES_0_BASE, 0);
	eeprom_rd_val_1 = I2C_read(I2C_OPENCORES_0_BASE, 1);

	rez = ((uint16_t)eeprom_rd_val_1 << 8) | eeprom_rd_val_0;
	return rez;
}

/**
 * Main, what else? :)
 **/
int main()
{
    uint32_t* dest = (uint32_t*)glEp0Buffer_Tx;
    unsigned char led_pattern = 0x00;
    //volatile uint32_t *uart = (volatile uint32_t*) UART_BASE;
    //char *str = "Hello from NIOS II\r\n";

    volatile int spirez;
    char cnt = 0;
    int k;
    uint16_t eeprom_dac_val;

    uint8_t status = 0;

    //Reset LMS7
    IOWR(LMS_CTR_GPIO_BASE, 0, 0x06);
    IOWR(LMS_CTR_GPIO_BASE, 0, 0x07);

    //
    uint8_t spi_wrbuf1[2] = {0x00, 0x20};
    uint8_t spi_wrbuf2[6] = {0x80, 0x20, 0xFF, 0xFD, 0x00, 0x20};
    //uint8_t spi_rdbuf[2] = {0x01, 0x00};

    // I2C initialiazation
    I2C_init(I2C_OPENCORES_0_BASE, ALT_CPU_FREQ, 100000);

	// Read TCXO DAC value from EEPROM memory
	eeprom_dac_val = rd_dac_val(DAC_VAL_ADDR);
	if (eeprom_dac_val == 0xFFFF){
		dac_val = DAC_DEFF_VAL; //default DAC value
	}
	else {
		dac_val = (unsigned char) eeprom_dac_val;
	}


    // Write initial data to the DAC
	dac_data[0] = (dac_val) >>2; //POWER-DOWN MODE = NORMAL OPERATION (MSB bits =00) + MSB data
	dac_data[1] = (dac_val) <<6; //LSB data
	spirez = alt_avalon_spi_command(DAC_SPI_BASE, SPI_NR_DAC, 2, dac_data, 0, NULL, 0);

    //FLASH MEMORY
    //spi_wrbuf1[0] = FLASH_CMD_READJEDECID;	//
    //spirez = alt_avalon_spi_command(SPI_FPGA_AS_BASE, SPI_NR_FLASH, 1, spi_wrbuf1, 3, spi_wrbuf2, 0);

	//flash_page_data[FLASH_PAGE_SIZE];
    //testFlash();
    /*
	spirez = FlashSpiTransfer(SPI_FPGA_AS_BASE, SPI_NR_FLASH, 0x0000, FLASH_PAGE_SIZE, flash_page_data, 1);
	spirez = FlashSpiTransfer(SPI_FPGA_AS_BASE, SPI_NR_FLASH, 0x0001, FLASH_PAGE_SIZE, flash_page_data, 1);
	spirez = FlashSpiTransfer(SPI_FPGA_AS_BASE, SPI_NR_FLASH, 0x0002, FLASH_PAGE_SIZE, flash_page_data, 1);
	spirez = FlashSpiTransfer(SPI_FPGA_AS_BASE, SPI_NR_FLASH, 0x0003, FLASH_PAGE_SIZE, flash_page_data, 1);
	spirez = FlashSpiTransfer(SPI_FPGA_AS_BASE, SPI_NR_FLASH, 0x0004, FLASH_PAGE_SIZE, flash_page_data, 1);
	spirez = FlashSpiTransfer(SPI_FPGA_AS_BASE, SPI_NR_FLASH, 0x0005, FLASH_PAGE_SIZE, flash_page_data, 1);
	spirez = FlashSpiTransfer(SPI_FPGA_AS_BASE, SPI_NR_FLASH, 0x0006, FLASH_PAGE_SIZE, flash_page_data, 1);
	spirez = FlashSpiTransfer(SPI_FPGA_AS_BASE, SPI_NR_FLASH, 0x0007, FLASH_PAGE_SIZE, flash_page_data, 1);
	spirez = FlashSpiTransfer(SPI_FPGA_AS_BASE, SPI_NR_FLASH, 0x0008, FLASH_PAGE_SIZE, flash_page_data, 1);
	spirez = FlashSpiTransfer(SPI_FPGA_AS_BASE, SPI_NR_FLASH, 0x0009, FLASH_PAGE_SIZE, flash_page_data, 1);
	spirez = FlashSpiTransfer(SPI_FPGA_AS_BASE, SPI_NR_FLASH, 0x000A, FLASH_PAGE_SIZE, flash_page_data, 1);
	//spirez = FlashSpiTransfer(SPI_FPGA_AS_BASE, SPI_NR_FLASH, 0x0010, 10, flash_page_data, 1);
	*/



    // Configure LM75
    Configure_LM75();


 /*
    // LM75
	spirez = I2C_start(I2C_OPENCORES_0_BASE, LM75_I2C_ADDR, 0);
	spirez = I2C_write(I2C_OPENCORES_0_BASE, 0x00, 1);				// Pointer = temperature register
	spirez = I2C_start(I2C_OPENCORES_0_BASE, LM75_I2C_ADDR, 1);

	converted_val = (signed short int)I2C_read(I2C_OPENCORES_0_BASE, 0);
	//converted_val = 0xE7 << 8;	// Test -25 deg
	converted_val = 10 * (converted_val >> 8);
	spirez = I2C_read(I2C_OPENCORES_0_BASE, 1);

	if(spirez & 0x80) converted_val = converted_val + 5;
*/


/*
    while (1)	// infinite loop
    {
        led_pattern = IORD(SWITCH_BASE, 0);     // gets LEDs
        set_led(led_pattern<<3);                     // sets LEDs


        // SPI
        //spirez = alt_avalon_spi_command(SPI_LMS_BASE, 0, 2, spi_wrbuf1, 2, spi_rdbuf, 0);
        //spirez = alt_avalon_spi_command(SPI_LMS_BASE, 0, 6, spi_wrbuf2, 2, spi_rdbuf, 0);
        //spirez = alt_avalon_spi_command(SPI_LMS_BASE, 0, 2, spi_wrbuf1, 2, spi_rdbuf, 0);

        //FLASH MEMORY
        //spi_wrbuf1[0] = ReverseBitOrder(0x9F);	//
        //spirez = alt_avalon_spi_command(SPI_FPGA_AS_BASE, SPI_NR_FLASH, 1, spi_wrbuf1, 3, spi_wrbuf2, 0);
        //spi_wrbuf2[0] = ReverseBitOrder(spi_wrbuf2[0]);
        //spi_wrbuf2[1] = ReverseBitOrder(spi_wrbuf2[1]);
        //spi_wrbuf2[2] = ReverseBitOrder(spi_wrbuf2[2]);



		spirez = I2C_start(I2C_OPENCORES_0_BASE, LM75_I2C_ADDR, 0);
		spirez = I2C_write(I2C_OPENCORES_0_BASE, 0x00, 1);				// Pointer = temperature register
		spirez = I2C_start(I2C_OPENCORES_0_BASE, LM75_I2C_ADDR, 1);

		// Read temperature and recalculate
		converted_val = (signed short int)I2C_read(I2C_OPENCORES_0_BASE, 0);
		converted_val = converted_val << 8;
		converted_val = 10 * (converted_val >> 8);
		spirez = I2C_read(I2C_OPENCORES_0_BASE, 1);
		if(spirez & 0x80) converted_val = converted_val + 5;


		//Read from LMS7
		spi_wrbuf1[0] = 0x00;
		spi_wrbuf1[1] = 0x21;
		spirez = alt_avalon_spi_command(FPGA_SPI_BASE, SPI_NR_LMS7002M, 2, spi_wrbuf1, 2, spi_wrbuf2, 0);

		// Write to the DAC
		//dac_val = 10;
		//dac_data[0] = (dac_val) >>2; //POWER-DOWN MODE = NORMAL OPERATION (MSB bits =00) + MSB data
		//dac_data[1] = (dac_val) <<6; //LSB data
		//spirez = alt_avalon_spi_command(DAC_SPI_BASE, SPI_NR_DAC, 2, dac_data, 0, NULL, 0);

		//dac_val = 200;
		//dac_data[0] = (dac_val) >>2; //POWER-DOWN MODE = NORMAL OPERATION (MSB bits =00) + MSB data
		//dac_data[1] = (dac_val) <<6; //LSB data
		//spirez = alt_avalon_spi_command(DAC_SPI_BASE, SPI_NR_DAC, 2, dac_data, 0, NULL, 0);

		//EEPROM Test, RD from 0x0000
		testEEPROM();

    }
*/


    while (1)	// infinite loop
    {
        // FIFO
        //IOWR(AV_FIFO_INT_0_BASE, 0, cnt);		// Write Data to FIFO
        //cnt++;
        spirez = IORD(AV_FIFO_INT_0_BASE, 2);	// Read FIFO Status
        if(!(spirez & 0x01))
        {
        	//Read packet from the FIFO
        	getFifoData(glEp0Buffer_Rx, 64);

         	memset (glEp0Buffer_Tx, 0, sizeof(glEp0Buffer_Tx)); //fill whole tx buffer with zeros
         	cmd_errors = 0;

     		LMS_Ctrl_Packet_Tx->Header.Command = LMS_Ctrl_Packet_Rx->Header.Command;
     		LMS_Ctrl_Packet_Tx->Header.Data_blocks = LMS_Ctrl_Packet_Rx->Header.Data_blocks;
     		LMS_Ctrl_Packet_Tx->Header.Periph_ID = LMS_Ctrl_Packet_Rx->Header.Periph_ID;
     		LMS_Ctrl_Packet_Tx->Header.Status = STATUS_BUSY_CMD;

     		switch(LMS_Ctrl_Packet_Rx->Header.Command)
     		{

	 			case CMD_GPIO_DIR_WR:
	 				//if(Check_many_blocks (2)) break;

					//write reg addr
					sc_brdg_data[0] = 0x80;		// Write command & BOARD_GPIO_DIR register address MSB
					sc_brdg_data[1] = 0xC4;		// BOARD_GPIO_DIR register address LSB
					sc_brdg_data[2] = LMS_Ctrl_Packet_Rx->Data_field[1];	// Data fields swapped, while MSB in the data packet is in the
					sc_brdg_data[3] = LMS_Ctrl_Packet_Rx->Data_field[0];	// leftmost byte
					spirez = alt_avalon_spi_command(FPGA_SPI_BASE, SPI_NR_FPGA, 4, sc_brdg_data, 0, NULL, 0);

	 				LMS_Ctrl_Packet_Tx->Header.Status = STATUS_COMPLETED_CMD;
	 			break;


				case CMD_GPIO_DIR_RD:
					//if(Check_many_blocks (2)) break;

				//write reg addr
					sc_brdg_data[0] = 0x00;		// Read command & BOARD_GPIO_DIR register address MSB
					sc_brdg_data[1] = 0xC4;		// BOARD_GPIO_DIR register address LSB
				spirez = alt_avalon_spi_command(FPGA_SPI_BASE, SPI_NR_FPGA, 2, sc_brdg_data, 2, &sc_brdg_data[2], 0);

				LMS_Ctrl_Packet_Tx->Data_field[0] = sc_brdg_data[3];	// Data fields swapped, while MSB in the data packet is in the
				LMS_Ctrl_Packet_Tx->Data_field[1] = sc_brdg_data[2];	// leftmost byte

					LMS_Ctrl_Packet_Tx->Header.Status = STATUS_COMPLETED_CMD;
				break;



	 			case CMD_GPIO_WR:
	 				//if(Check_many_blocks (2)) break;

	 				//write reg addr
	 				sc_brdg_data[0] = 0x80;		// Write command & BOARD_GPIO_VAL register address MSB
	 				sc_brdg_data[1] = 0xC6;		// BOARD_GPIO_VAL register address LSB
	 				sc_brdg_data[2] = LMS_Ctrl_Packet_Rx->Data_field[1];	// Data fields swapped, while MSB in the data packet is in the
	 				sc_brdg_data[3] = LMS_Ctrl_Packet_Rx->Data_field[0];	// leftmost byte
	 				spirez = alt_avalon_spi_command(FPGA_SPI_BASE, SPI_NR_FPGA, 4, sc_brdg_data, 0, NULL, 0);

	 				LMS_Ctrl_Packet_Tx->Header.Status = STATUS_COMPLETED_CMD;
	 			break;

				case CMD_GPIO_RD:
					//if(Check_many_blocks (2)) break;

				//write reg addr
	 				sc_brdg_data[0] = 0x00;		// Read command & BOARD_GPIO_RD register address MSB
	 				sc_brdg_data[1] = 0xC2;		// BOARD_GPIO_RD register address LSB
					spirez = alt_avalon_spi_command(FPGA_SPI_BASE, SPI_NR_FPGA, 2, sc_brdg_data, 2, &sc_brdg_data[2], 0);

					LMS_Ctrl_Packet_Tx->Data_field[0] = sc_brdg_data[3];	// Data fields swapped, while MSB in the data packet is in the
					LMS_Ctrl_Packet_Tx->Data_field[1] = sc_brdg_data[2];	// leftmost byte

					LMS_Ctrl_Packet_Tx->Header.Status = STATUS_COMPLETED_CMD;
				break;



 				case CMD_GET_INFO:

 					LMS_Ctrl_Packet_Tx->Data_field[0] = FW_VER;
 					LMS_Ctrl_Packet_Tx->Data_field[1] = DEV_TYPE;
 					LMS_Ctrl_Packet_Tx->Data_field[2] = LMS_PROTOCOL_VER;
 					LMS_Ctrl_Packet_Tx->Data_field[3] = HW_VER;
 					LMS_Ctrl_Packet_Tx->Data_field[4] = EXP_BOARD;

 					LMS_Ctrl_Packet_Tx->Header.Status = STATUS_COMPLETED_CMD;
 				break;

 				case CMD_LMS_RST:

 					switch (LMS_Ctrl_Packet_Rx->Data_field[0])
 					{
 						case LMS_RST_DEACTIVATE:
 							IOWR(LMS_CTR_GPIO_BASE, 0, 0x07);
 						break;

 						case LMS_RST_ACTIVATE:
 							IOWR(LMS_CTR_GPIO_BASE, 0, 0x06);
 						break;

 						case LMS_RST_PULSE:
 							IOWR(LMS_CTR_GPIO_BASE, 0, 0x06);
 							asm("nop"); asm("nop"); asm("nop"); asm("nop"); asm("nop");
 							asm("nop"); asm("nop"); asm("nop"); asm("nop"); asm("nop");
 							IOWR(LMS_CTR_GPIO_BASE, 0, 0x07);
 						break;

 						default:
 							cmd_errors++;
 						break;
 					}

 					LMS_Ctrl_Packet_Tx->Header.Status = STATUS_COMPLETED_CMD;
 				break;


 	 			case CMD_LMS7002_WR:
 	 				if(Check_many_blocks (4)) break;

 	 				for(block = 0; block < LMS_Ctrl_Packet_Rx->Header.Data_blocks; block++)
 	 				{
 	 					//write reg addr
 	 					sbi(LMS_Ctrl_Packet_Rx->Data_field[0 + (block * 4)], 7); //set write bit
 	 					spirez = alt_avalon_spi_command(FPGA_SPI_BASE, SPI_NR_LMS7002M, 4, &LMS_Ctrl_Packet_Rx->Data_field[0 + (block * 4)], 0, NULL, 0);
 	 				}

 	 				LMS_Ctrl_Packet_Tx->Header.Status = STATUS_COMPLETED_CMD;
 	 			break;


 				case CMD_LMS7002_RD:
 					if(Check_many_blocks (4)) break;

 					for(block = 0; block < LMS_Ctrl_Packet_Rx->Header.Data_blocks; block++)
 					{

 						//write reg addr
 						cbi(LMS_Ctrl_Packet_Rx->Data_field[0 + (block * 2)], 7);  //clear write bit
 						spirez = alt_avalon_spi_command(FPGA_SPI_BASE, SPI_NR_LMS7002M, 2, &LMS_Ctrl_Packet_Rx->Data_field[0 + (block * 2)], 2, &LMS_Ctrl_Packet_Tx->Data_field[2 + (block * 4)], 0);
 					}

 					LMS_Ctrl_Packet_Tx->Header.Status = STATUS_COMPLETED_CMD;
 				break;


 	 			case CMD_BRDSPI16_WR:
 	 				if(Check_many_blocks (4)) break;

 	 				for(block = 0; block < LMS_Ctrl_Packet_Rx->Header.Data_blocks; block++)
 	 				{
 	 					//write reg addr
 	 					sbi(LMS_Ctrl_Packet_Rx->Data_field[0 + (block * 4)], 7); //set write bit
 	 					spirez = alt_avalon_spi_command(FPGA_SPI_BASE, SPI_NR_FPGA, 4, &LMS_Ctrl_Packet_Rx->Data_field[0 + (block * 4)], 0, NULL, 0);
 	 				}

 	 				LMS_Ctrl_Packet_Tx->Header.Status = STATUS_COMPLETED_CMD;
 	 			break;

 				case CMD_BRDSPI16_RD:
 					if(Check_many_blocks (4)) break;

 					for(block = 0; block < LMS_Ctrl_Packet_Rx->Header.Data_blocks; block++)
 					{
 						//write reg addr
 						cbi(LMS_Ctrl_Packet_Rx->Data_field[0 + (block * 2)], 7);  //clear write bit
 						spirez = alt_avalon_spi_command(FPGA_SPI_BASE, SPI_NR_FPGA, 2, &LMS_Ctrl_Packet_Rx->Data_field[0 + (block * 2)], 2, &LMS_Ctrl_Packet_Tx->Data_field[2 + (block * 4)], 0);
 					}

 					LMS_Ctrl_Packet_Tx->Header.Status = STATUS_COMPLETED_CMD;
 				break;


				case CMD_MEMORY_WR:
					current_portion = (LMS_Ctrl_Packet_Rx->Data_field[1] << 24) | (LMS_Ctrl_Packet_Rx->Data_field[2] << 16) | (LMS_Ctrl_Packet_Rx->Data_field[3] << 8) | (LMS_Ctrl_Packet_Rx->Data_field[4]);
					data_cnt = LMS_Ctrl_Packet_Rx->Data_field[5];

					if((LMS_Ctrl_Packet_Rx->Data_field[10] == 0) && (LMS_Ctrl_Packet_Rx->Data_field[11] == 3)) //TARGET = 3 (EEPROM)
					{
						if(LMS_Ctrl_Packet_Rx->Data_field[0] == 0) //write data to EEPROM #1
						{

							cmd_errors = I2C_start(I2C_OPENCORES_0_BASE, EEPROM_I2C_ADDR, 0);
							cmd_errors += I2C_write(I2C_OPENCORES_0_BASE, LMS_Ctrl_Packet_Rx->Data_field[8], 0);
							cmd_errors += I2C_write(I2C_OPENCORES_0_BASE, LMS_Ctrl_Packet_Rx->Data_field[9], 0);

							for(k=0; k<data_cnt-1; k++)
							{
								cmd_errors += I2C_write(I2C_OPENCORES_0_BASE, LMS_Ctrl_Packet_Rx->Data_field[24+k], 0);
								usleep(5000);
							}
							cmd_errors += I2C_write(I2C_OPENCORES_0_BASE, LMS_Ctrl_Packet_Rx->Data_field[24+k], 1);
							usleep(5000);

							if(cmd_errors) LMS_Ctrl_Packet_Tx->Header.Status = STATUS_ERROR_CMD;
							else LMS_Ctrl_Packet_Tx->Header.Status = STATUS_COMPLETED_CMD;
						}
						else
							LMS_Ctrl_Packet_Tx->Header.Status = STATUS_ERROR_CMD;
					}
					else

						if((LMS_Ctrl_Packet_Rx->Data_field[10] == 0) && (LMS_Ctrl_Packet_Rx->Data_field[11] == 1)) // TARGET = 1 (FX3)
						{
							switch (LMS_Ctrl_Packet_Rx->Data_field[0]) //PROG_MODE
							{

								case 2: //PROG_MODE = 2 (write FW to flash). Note please, that writes must be page after page.

									if(current_portion == 0)//beginning
									{
										flash_page = 0;
										flash_page_data_cnt = 0;
										flash_data_counter_to_copy = 0;
										fpga_byte = 0;
									}

									flash_data_cnt_free = FLASH_PAGE_SIZE - flash_page_data_cnt;

									if (flash_data_cnt_free > 0)
									{
										if (flash_data_cnt_free > data_cnt)
											flash_data_counter_to_copy = data_cnt; //copy all data if fits to free page space
										else
											flash_data_counter_to_copy = flash_data_cnt_free; //copy only amount of data that fits in to free page size

										memcpy(&flash_page_data[flash_page_data_cnt], &LMS_Ctrl_Packet_Rx->Data_field[24], flash_data_counter_to_copy);

										flash_page_data_cnt = flash_page_data_cnt + flash_data_counter_to_copy;
										flash_data_cnt_free = FLASH_PAGE_SIZE - flash_page_data_cnt;

										if (data_cnt == 0)//all bytes transmitted, end of programming
										{
											if (flash_page_data_cnt > 0)
												flash_page_data_cnt = FLASH_PAGE_SIZE; //finish page
										}

										flash_data_cnt_free = FLASH_PAGE_SIZE - flash_page_data_cnt;
									}

									if (flash_page_data_cnt >= FLASH_PAGE_SIZE) //write data to flash
									{
										if ((flash_page % (FLASH_SECTOR_SIZE/FLASH_PAGE_SIZE)) == 0) //need to erase sector? reached number of pages in block?
											if( FlashSpiEraseSector(FLASH_SPI_BASE, SPI_NR_FLASH, CyTrue, flash_page/(FLASH_SECTOR_SIZE/FLASH_PAGE_SIZE)) != CY_U3P_SUCCESS) cmd_errors++;

										if(!cmd_errors)
											if( FlashSpiTransfer(FLASH_SPI_BASE, SPI_NR_FLASH, flash_page, FLASH_PAGE_SIZE, flash_page_data, CyFalse) != CY_U3P_SUCCESS)  cmd_errors++;//write to flash

										flash_page++;
										flash_page_data_cnt = 0;
										flash_data_cnt_free = FLASH_PAGE_SIZE - flash_page_data_cnt;
									}

									//if not all bytes written to flash page
									if (data_cnt > flash_data_counter_to_copy)
									{
										flash_data_counter_to_copy = data_cnt - flash_data_counter_to_copy;

										memcpy(&flash_page_data[flash_page_data_cnt], &LMS_Ctrl_Packet_Rx->Data_field[24], data_cnt);

										flash_page_data_cnt = flash_page_data_cnt + flash_data_counter_to_copy;
										flash_data_cnt_free = FLASH_PAGE_SIZE - flash_page_data_cnt;
									}

									fpga_byte = fpga_byte + data_cnt;

									if (fpga_byte <= FLASH_PAGE_SIZE * FLASH_SECTOR_SIZE) //correct firmware size?
									{
										if (data_cnt == 0)//end of programming
										{
										}

										if(cmd_errors) LMS_Ctrl_Packet_Tx->Header.Status = STATUS_ERROR_CMD;
										else LMS_Ctrl_Packet_Tx->Header.Status = STATUS_COMPLETED_CMD;
									}
									else //not correct firmware size
										LMS_Ctrl_Packet_Tx->Header.Status = STATUS_ERROR_CMD;

									break;

								default:
									LMS_Ctrl_Packet_Tx->Header.Status = STATUS_ERROR_CMD;
									break;
							}
						}
						else LMS_Ctrl_Packet_Tx->Header.Status = STATUS_ERROR_CMD;

				break;


				case CMD_MEMORY_RD:
					current_portion = (LMS_Ctrl_Packet_Rx->Data_field[1] << 24) | (LMS_Ctrl_Packet_Rx->Data_field[2] << 16) | (LMS_Ctrl_Packet_Rx->Data_field[3] << 8) | (LMS_Ctrl_Packet_Rx->Data_field[4]);
					data_cnt = LMS_Ctrl_Packet_Rx->Data_field[5];

					if((LMS_Ctrl_Packet_Rx->Data_field[10] == 0) && (LMS_Ctrl_Packet_Rx->Data_field[11] == 3)) //TARGET = 3 (EEPROM)
					{
						if(LMS_Ctrl_Packet_Rx->Data_field[0] == 0) //read data from EEPROM #1
						{

							cmd_errors = I2C_start(I2C_OPENCORES_0_BASE, EEPROM_I2C_ADDR, 0);
							cmd_errors += I2C_write(I2C_OPENCORES_0_BASE, LMS_Ctrl_Packet_Rx->Data_field[8], 0);
							cmd_errors += I2C_write(I2C_OPENCORES_0_BASE, LMS_Ctrl_Packet_Rx->Data_field[9], 0);

							cmd_errors += I2C_start(I2C_OPENCORES_0_BASE, EEPROM_I2C_ADDR, 1);
							for(k=0; k<data_cnt-1; k++)
							{
								LMS_Ctrl_Packet_Tx->Data_field[24+k] = I2C_read(I2C_OPENCORES_0_BASE, 0);
							}
							LMS_Ctrl_Packet_Tx->Data_field[24+k] = I2C_read(I2C_OPENCORES_0_BASE, 1);

							if(cmd_errors) LMS_Ctrl_Packet_Tx->Header.Status = STATUS_ERROR_CMD;
							else LMS_Ctrl_Packet_Tx->Header.Status = STATUS_COMPLETED_CMD;
						}
						else
							LMS_Ctrl_Packet_Tx->Header.Status = STATUS_ERROR_CMD;
					}
					else
					{
						if((LMS_Ctrl_Packet_Rx->Data_field[10] == 0) && (LMS_Ctrl_Packet_Rx->Data_field[11] == 1)) // TARGET = 1 (FX3)
						{
							flash_page  = LMS_Ctrl_Packet_Rx->Data_field[6] << 24;
							flash_page |= LMS_Ctrl_Packet_Rx->Data_field[7] << 16;
							flash_page |= LMS_Ctrl_Packet_Rx->Data_field[8] << 8;
							flash_page |= LMS_Ctrl_Packet_Rx->Data_field[9];
							//flash_page = flash_page / FLASH_PAGE_SIZE;

							//if( FlashSpiTransfer(FLASH_SPI_BASE, SPI_NR_FLASH, flash_page, FLASH_PAGE_SIZE, flash_page_data, CyTrue) != CY_U3P_SUCCESS)  cmd_errors++;//write to flash
							if( FlashSpiRead(FLASH_SPI_BASE, SPI_NR_FLASH, flash_page, FLASH_PAGE_SIZE, flash_page_data) != CY_U3P_SUCCESS)  cmd_errors++;//write to flash

							for(k=0; k<data_cnt; k++)
							{
								LMS_Ctrl_Packet_Tx->Data_field[24+k] = flash_page_data[k];
							}

							if(cmd_errors) LMS_Ctrl_Packet_Tx->Header.Status = STATUS_ERROR_CMD;
							else LMS_Ctrl_Packet_Tx->Header.Status = STATUS_COMPLETED_CMD;
						}
						else
							LMS_Ctrl_Packet_Tx->Header.Status = STATUS_ERROR_CMD;
					}

				break;




				case CMD_ANALOG_VAL_RD:

					for(block = 0; block < LMS_Ctrl_Packet_Rx->Header.Data_blocks; block++)
					{

						//signed short int converted_val = 300;

						switch (LMS_Ctrl_Packet_Rx->Data_field[0 + (block)])//ch
						{
							case 0://dac val

								LMS_Ctrl_Packet_Tx->Data_field[0 + (block * 4)] = LMS_Ctrl_Packet_Rx->Data_field[block]; //ch
								LMS_Ctrl_Packet_Tx->Data_field[1 + (block * 4)] = 0x00; //RAW //unit, power

								LMS_Ctrl_Packet_Tx->Data_field[2 + (block * 4)] = 0; //signed val, MSB byte
								LMS_Ctrl_Packet_Tx->Data_field[3 + (block * 4)] = dac_val; //signed val, LSB byte
								break;

							case 1: //temperature

								spirez = I2C_start(I2C_OPENCORES_0_BASE, LM75_I2C_ADDR, 0);
								spirez = I2C_write(I2C_OPENCORES_0_BASE, 0x00, 1);				// Pointer = temperature register
								spirez = I2C_start(I2C_OPENCORES_0_BASE, LM75_I2C_ADDR, 1);

								// Read temperature and recalculate
								converted_val = (signed short int)I2C_read(I2C_OPENCORES_0_BASE, 0);
								converted_val = converted_val << 8;
								converted_val = 10 * (converted_val >> 8);
								spirez = I2C_read(I2C_OPENCORES_0_BASE, 1);
								if(spirez & 0x80) converted_val = converted_val + 5;


								LMS_Ctrl_Packet_Tx->Data_field[0 + (block * 4)] = LMS_Ctrl_Packet_Rx->Data_field[block]; //ch
								LMS_Ctrl_Packet_Tx->Data_field[1 + (block * 4)] = 0x50; //mC //unit, power

								LMS_Ctrl_Packet_Tx->Data_field[2 + (block * 4)] = (converted_val >> 8); //signed val, MSB byte
								LMS_Ctrl_Packet_Tx->Data_field[3 + (block * 4)] = converted_val; //signed val, LSB byte

							break;

							default:
								cmd_errors++;
							break;
						}
					}

					LMS_Ctrl_Packet_Tx->Header.Status = STATUS_COMPLETED_CMD;

				break;


				case CMD_ANALOG_VAL_WR:
					if(Check_many_blocks (4)) break;

					for(block = 0; block < LMS_Ctrl_Packet_Rx->Header.Data_blocks; block++)
					{
						switch (LMS_Ctrl_Packet_Rx->Data_field[0 + (block * 4)]) //do something according to channel
						{
							case 0:
								if (LMS_Ctrl_Packet_Rx->Data_field[1 + (block * 4)] == 0) //RAW units?
								{
									if(LMS_Ctrl_Packet_Rx->Data_field[2 + (block * 4)] == 0) //MSB byte empty?
									{
										dac_val = LMS_Ctrl_Packet_Rx->Data_field[3 + (block * 4)];

										dac_data[0] = (dac_val >> 2) & 0x3F; //POWER-DOWN MODE = NORMAL OPERATION (MSB bits =00) + MSB data
										dac_data[1] = (dac_val << 6) & 0xC0; //LSB data

										//if( CyU3PI2cTransmitBytes (&preamble, &sc_brdg_data[0], 2, 0) != CY_U3P_SUCCESS)  cmd_errors++;
										spirez = alt_avalon_spi_command(DAC_SPI_BASE, SPI_NR_DAC, 2, dac_data, 0, NULL, 0);
									}
									else cmd_errors++;
								}
								else cmd_errors++;

							break;

							default:
								cmd_errors++;
							break;
						}
					}


					if(cmd_errors) LMS_Ctrl_Packet_Tx->Header.Status = STATUS_ERROR_CMD;
					else LMS_Ctrl_Packet_Tx->Header.Status = STATUS_COMPLETED_CMD;

				break;







				case CMD_ALTERA_FPGA_GW_WR: //FPGA passive serial

					current_portion = (LMS_Ctrl_Packet_Rx->Data_field[1] << 24) | (LMS_Ctrl_Packet_Rx->Data_field[2] << 16) | (LMS_Ctrl_Packet_Rx->Data_field[3] << 8) | (LMS_Ctrl_Packet_Rx->Data_field[4]);
					data_cnt = LMS_Ctrl_Packet_Rx->Data_field[5];

					switch(LMS_Ctrl_Packet_Rx->Data_field[0])//prog_mode
					{
						/*
						Programming mode:

						0 - Bitstream to FPGA
						1 - Bitstream to Flash
						2 - Bitstream from Flash
						*/

						case 0://Bitstream to FPGA from PC
							/*
							if ( Configure_FPGA (&LMS_Ctrl_Packet_Rx->Data_field[24], current_portion, data_cnt) ) LMS_Ctrl_Packet_Tx->Header.Status = STATUS_COMPLETED_CMD;
							else LMS_Ctrl_Packet_Tx->Header.Status = STATUS_ERROR_CMD;
							*/
							LMS_Ctrl_Packet_Tx->Header.Status = STATUS_ERROR_CMD;

						break;

						case 1: //write data to Flash from PC

							current_portion = (LMS_Ctrl_Packet_Rx->Data_field[1] << 24) | (LMS_Ctrl_Packet_Rx->Data_field[2] << 16) | (LMS_Ctrl_Packet_Rx->Data_field[3] << 8) | (LMS_Ctrl_Packet_Rx->Data_field[4]);
							data_cnt = LMS_Ctrl_Packet_Rx->Data_field[5];

							if (current_portion == 0) state = 10;
							if (data_cnt        == 0)
							{
								state = 30;
							}
							Flash = 1;

							while(Flash)
							{
								switch (state)
								{
									//Init
									case 10:
										//Set Flash memory addresses
										CFM0StartAddress = 0x04A000;
										CFM0EndAddress   = 0x08BFFF;

										address = CFM0StartAddress;

										//Write Control Register of On-Chip Flash IP to un-protect and erase operation
										IOWR(ONCHIP_FLASH_0_CSR_BASE, 1, 0xf7ffffff);
										IOWR(ONCHIP_FLASH_0_CSR_BASE, 1, 0xf7dfffff);

										state = 11;
										Flash = 1;

									case 11:
										//Start erase CFM0
										if((IORD(ONCHIP_FLASH_0_CSR_BASE, 0) & 0x13) == 0x10)
										{
											IOWR(ONCHIP_FLASH_0_CSR_BASE, 1, 0xf7ffffff);
											//printf("CFM0 Erased\n");
											//printf("Enter Programming file.\n");
											state = 20;
											Flash = 1;
										}
										if((IORD(ONCHIP_FLASH_0_CSR_BASE, 0) & 0x13) == 0x01)
										{
											//printf("Erasing CFM0\n");
											state = 11;
											Flash = 1;
										}
										if((IORD(ONCHIP_FLASH_0_CSR_BASE, 0) & 0x13) == 0x00)
										{
											//printf("Erase CFM0 Failed\n");
											state = 0;
										}

									break;

									//Program
									case 20:
										for(byte = 24; byte <= 52; byte += 4)
										{
											//Take word
											//word = (LMS_Ctrl_Packet_Rx->Data_field[byte+0]<<24)|(LMS_Ctrl_Packet_Rx->Data_field[byte+1]<<16)|(LMS_Ctrl_Packet_Rx->Data_field[byte+2]<<8)|(LMS_Ctrl_Packet_Rx->Data_field[byte+3]);
											word  = (ALT_CI_NIOS_CUSTOM_INSTR_BITSWAP_0(LMS_Ctrl_Packet_Rx->Data_field[byte+0]) >>  0) & 0xFF000000;
											word |= (ALT_CI_NIOS_CUSTOM_INSTR_BITSWAP_0(LMS_Ctrl_Packet_Rx->Data_field[byte+1]) >>  8) & 0x00FF0000;
											word |= (ALT_CI_NIOS_CUSTOM_INSTR_BITSWAP_0(LMS_Ctrl_Packet_Rx->Data_field[byte+2]) >> 16) & 0x0000FF00;
											word |= (ALT_CI_NIOS_CUSTOM_INSTR_BITSWAP_0(LMS_Ctrl_Packet_Rx->Data_field[byte+3]) >> 24) & 0x000000FF;


								  		  	//for(byte1=byte; byte1<byte+4; byte1++)
								  		  	//{
								  		  	//	LMS_Ctrl_Packet_Rx->Data_field[byte1] = (((LMS_Ctrl_Packet_Rx->Data_field[byte1] & 0xaa)>>1)|((LMS_Ctrl_Packet_Rx->Data_field[byte1] & 0x55)<<1));		/*Swap LSB with MSB before write into CFM*/
								  		  	//	LMS_Ctrl_Packet_Rx->Data_field[byte1] = (((LMS_Ctrl_Packet_Rx->Data_field[byte1] & 0xcc)>>2)|((LMS_Ctrl_Packet_Rx->Data_field[byte1] & 0x33)<<2));
								  		  	// 	LMS_Ctrl_Packet_Rx->Data_field[byte1] = (((LMS_Ctrl_Packet_Rx->Data_field[byte1] & 0xf0)>>4)|((LMS_Ctrl_Packet_Rx->Data_field[byte1] & 0x0f)<<4));
								  		  	//}

											//Swap bits using hardware accelerator
											//word = ALT_CI_NIOS_CUSTOM_INSTR_BITSWAP_0(word);

											//Command to write into On-Chip Flash IP
											if(address <= CFM0EndAddress)
											{
												IOWR_32DIRECT(ONCHIP_FLASH_0_DATA_BASE, address, word);

												address += 4;


												while((IORD(ONCHIP_FLASH_0_CSR_BASE, 0) & 0x0b) == 0x02)
												{
													//printf("Writing CFM0(%d)\n", address);
												}
												if((IORD(ONCHIP_FLASH_0_CSR_BASE, 0) & 0x0b) == 0x00)
												{
													//printf("Write to %d failed\n", address);
													state = 0;
													address = 700000;
												}
												if((IORD(ONCHIP_FLASH_0_CSR_BASE, 0) & 0x0b) == 0x08)
												{
												};
											}
											else
											{
												LMS_Ctrl_Packet_Tx->Header.Status = STATUS_ERROR_CMD;
											};
										};

										state = 20;
										Flash = 0;
										LMS_Ctrl_Packet_Tx->Header.Status = STATUS_COMPLETED_CMD;

									break;

									//Finish
									case 30:
										//Re-protect the sector
										IOWR(ONCHIP_FLASH_0_CSR_BASE, 1, 0xffffffff);

										state = 0;
										Flash = 0;

										LMS_Ctrl_Packet_Tx->Header.Status = STATUS_COMPLETED_CMD;

									break;

									default:
										LMS_Ctrl_Packet_Tx->Header.Status = STATUS_ERROR_CMD;
										state = 0;
										Flash = 0;
								};
							};

						break;

						case 2: //configure FPGA from flash

							//enable boot to factory image, booting is executed after response to command is sent
							boot_img_en = 1;

							LMS_Ctrl_Packet_Tx->Header.Status = STATUS_COMPLETED_CMD;



						break;

						default:
							LMS_Ctrl_Packet_Tx->Header.Status = STATUS_COMPLETED_CMD;
						break;

					}

				break;

				case CMD_LMS_MCU_FW_WR:

					current_portion = LMS_Ctrl_Packet_Rx->Data_field[1];

					//check if portions are send in correct order
					if(current_portion != 0) //not first portion?
					{
						if(last_portion != (current_portion - 1)) //portion number increments?
						{
							LMS_Ctrl_Packet_Tx->Header.Status = STATUS_WRONG_ORDER_CMD;
							break;
						}
					}

					//**ZT Modify_BRDSPI16_Reg_bits (FPGA_SPI_REG_LMS1_LMS2_CTRL, LMS1_SS, LMS1_SS, 0); //Enable LMS's SPI

					if (current_portion == 0) //PORTION_NR = first fifo
					{
						//reset mcu
						//write reg addr - mSPI_REG2 (Controls MCU input pins)
						sc_brdg_data[0] = (0x80); //reg addr MSB with write bit
						sc_brdg_data[1] = (MCU_CONTROL_REG); //reg addr LSB

						sc_brdg_data[2] = (0x00); //reg data MSB
						sc_brdg_data[3] = (0x00); //reg data LSB //8

						//**ZT CyU3PSpiTransmitWords (&sc_brdg_data[0], 4);
						spirez = alt_avalon_spi_command(FPGA_SPI_BASE, SPI_NR_LMS7002M, 4, &sc_brdg_data[0], 0, NULL, 0);

						//set mode
						//write reg addr - mSPI_REG2 (Controls MCU input pins)
						sc_brdg_data[0] = (0x80); //reg addr MSB with write bit
						sc_brdg_data[1] = (MCU_CONTROL_REG); //reg addr LSB

						sc_brdg_data[2] = (0x00); //reg data MSB

						//reg data LSB
						switch (LMS_Ctrl_Packet_Rx->Data_field[0]) //PROG_MODE
						{
							case PROG_EEPROM:
								sc_brdg_data[3] = (0x01); //Programming both EEPROM and SRAM  //8
								//**ZT CyU3PSpiTransmitWords (&sc_brdg_data[0], 4);
								spirez = alt_avalon_spi_command(FPGA_SPI_BASE, SPI_NR_LMS7002M, 4, &sc_brdg_data[0], 0, NULL, 0);
								break;

							case PROG_SRAM:
								sc_brdg_data[3] =(0x02); //Programming only SRAM  //8
								//**ZT CyU3PSpiTransmitWords (&sc_brdg_data[0], 4);
								spirez = alt_avalon_spi_command(FPGA_SPI_BASE, SPI_NR_LMS7002M, 4, &sc_brdg_data[0], 0, NULL, 0);
								break;


							case BOOT_MCU:
								sc_brdg_data[3] = (0x03); //Programming both EEPROM and SRAM  //8
								//**ZT CyU3PSpiTransmitWords (&sc_brdg_data[0], 4);
								spirez = alt_avalon_spi_command(FPGA_SPI_BASE, SPI_NR_LMS7002M, 4, &sc_brdg_data[0], 0, NULL, 0);

								/*sbi (PORTB, SAEN); //Disable LMS's SPI
								cbi (PORTB, SAEN); //Enable LMS's SPI*/

								//spi read
								//write reg addr
								sc_brdg_data[0] = (0x00); //reg addr MSB
								sc_brdg_data[1] = (MCU_STATUS_REG); //reg addr LSB
								//**ZT CyU3PSpiTransmitWords (&sc_brdg_data[0], 2);
								//spirez = alt_avalon_spi_command(FPGA_SPI_BASE, SPI_NR_LMS7002M, 2, &sc_brdg_data[0], 0, NULL, 0);

								//read reg data
								//**ZT CyU3PSpiReceiveWords (&sc_brdg_data[0], 2); //reg data
								spirez = alt_avalon_spi_command(FPGA_SPI_BASE, SPI_NR_LMS7002M, 2, &sc_brdg_data[0], 2, &sc_brdg_data[0], 0);

								goto BOOTING;

								break;
						}
					}

					MCU_retries = 0;

					//wait till EMPTY_WRITE_BUFF = 1
					while (MCU_retries < MAX_MCU_RETRIES)
					{
						//read status reg

						//spi read
						//write reg addr
						sc_brdg_data[0] = (0x00); //reg addr MSB
						sc_brdg_data[1] = (MCU_STATUS_REG); //reg addr LSB
						//**ZT CyU3PSpiTransmitWords (&sc_brdg_data[0], 2);
						//spirez = alt_avalon_spi_command(FPGA_SPI_BASE, SPI_NR_LMS7002M, 2, &sc_brdg_data[0], 0, NULL, 0);

						//read reg data
						//**ZT CyU3PSpiReceiveWords (&sc_brdg_data[0], 2); //reg data
						spirez = alt_avalon_spi_command(FPGA_SPI_BASE, SPI_NR_LMS7002M, 2, &sc_brdg_data[0], 2, &sc_brdg_data[0], 0);

						if (sc_brdg_data[1] &0x01) break; //EMPTY_WRITE_BUFF = 1

						MCU_retries++;
						usleep (30);
					}

					//write 32 bytes to FIFO
					for(block = 0; block < 32; block++)
					{
						/*
						//wait till EMPTY_WRITE_BUFF = 1
						while (MCU_retries < MAX_MCU_RETRIES)
						{
							//read status reg

							//spi read
							//write reg addr
							SPI_SendByte(0x00); //reg addr MSB
							SPI_SendByte(MCU_STATUS_REG); //reg addr LSB

							//read reg data
							SPI_TransferByte(0x00); //reg data MSB
							temp_status = SPI_TransferByte(0x00); //reg data LSB

							if (temp_status &0x01) break;

							MCU_retries++;
							Delay_us (30);
						}*/

						//write reg addr - mSPI_REG4 (Writes one byte of data to MCU  )
						sc_brdg_data[0] = (0x80); //reg addr MSB with write bit
						sc_brdg_data[1] = (MCU_FIFO_WR_REG); //reg addr LSB

						sc_brdg_data[2] = (0x00); //reg data MSB
						sc_brdg_data[3] = (LMS_Ctrl_Packet_Rx->Data_field[2 + block]); //reg data LSB //8

						//**ZT CyU3PSpiTransmitWords (&sc_brdg_data[0], 4);
						spirez = alt_avalon_spi_command(FPGA_SPI_BASE, SPI_NR_LMS7002M, 4, &sc_brdg_data[0], 0, NULL, 0);

						MCU_retries = 0;
					}

					/*sbi (PORTB, SAEN); //Enable LMS's SPI
					cbi (PORTB, SAEN); //Enable LMS's SPI*/


					MCU_retries = 0;

					//wait till EMPTY_WRITE_BUFF = 1
					while (MCU_retries < 500)
					{
						//read status reg

						//spi read
						//write reg addr
						sc_brdg_data[0] = (0x00); //reg addr MSB
						sc_brdg_data[1] = (MCU_STATUS_REG); //reg addr LSB
						//**ZT CyU3PSpiTransmitWords (&sc_brdg_data[0], 2);
						//spirez = alt_avalon_spi_command(FPGA_SPI_BASE, SPI_NR_LMS7002M, 2, &sc_brdg_data[0], 0, NULL, 0);

						//read reg data
						//**ZT CyU3PSpiReceiveWords (&sc_brdg_data[0], 2); //reg data
						spirez = alt_avalon_spi_command(FPGA_SPI_BASE, SPI_NR_LMS7002M, 2, &sc_brdg_data[0], 2, &sc_brdg_data[0], 0);

						if (sc_brdg_data[1] &0x01) break; //EMPTY_WRITE_BUFF = 1

						MCU_retries++;
						usleep (30);
					}


					if (current_portion  == 255) //PORTION_NR = last fifo
					{
						//chek programmed bit

						MCU_retries = 0;

						//wait till PROGRAMMED = 1
						while (MCU_retries < MAX_MCU_RETRIES)
						{
							//read status reg

							//spi read
							//write reg addr
							sc_brdg_data[0] = (0x00); //reg addr MSB
							sc_brdg_data[1] = (MCU_STATUS_REG); //reg addr LSB
							//**ZT CyU3PSpiTransmitWords (&sc_brdg_data[0], 2);
							//spirez = alt_avalon_spi_command(FPGA_SPI_BASE, SPI_NR_LMS7002M, 2, &sc_brdg_data[0], 0, NULL, 0);

							//read reg data
							//**ZT CyU3PSpiReceiveWords (&sc_brdg_data[0], 2); //reg data
							spirez = alt_avalon_spi_command(FPGA_SPI_BASE, SPI_NR_LMS7002M, 2, &sc_brdg_data[0], 2, &sc_brdg_data[0], 0);

							if (sc_brdg_data[1] &0x40) break; //PROGRAMMED = 1

							MCU_retries++;
							usleep (30);
						}

						if (MCU_retries == MAX_MCU_RETRIES) cmd_errors++;
					}

					last_portion = current_portion; //save last portion number

					BOOTING:

					if(cmd_errors) LMS_Ctrl_Packet_Tx->Header.Status = STATUS_ERROR_CMD;
					else LMS_Ctrl_Packet_Tx->Header.Status = STATUS_COMPLETED_CMD;

					//**ZT Modify_BRDSPI16_Reg_bits (FPGA_SPI_REG_LMS1_LMS2_CTRL, LMS1_SS, LMS1_SS, 1); //Disable LMS's SPI

				break;

 				default:
 					/* This is unknown request. */
 					//isHandled = CyFalse;
					LMS_Ctrl_Packet_Tx->Header.Status = STATUS_UNKNOWN_CMD;
 				break;
     		}

     		///////////for testing
     		//LMS_Ctrl_Packet_Tx->Header.Status = STATUS_INVALID_PERIPH_ID_CMD;

     		//Send response to the command
        	for(cnt=0; cnt<64/sizeof(uint32_t); ++cnt)
        	{
        		IOWR(AV_FIFO_INT_0_BASE, 0, dest[cnt]);
        	};

        	// If boot from flash CMD is executed FPGA GW is loaded from internal FLASH (image 1)
        	if (boot_img_en==1) {

        		boot_from_flash();

        	};


        };

        //IOWR(AV_FIFO_INT_0_BASE, 0, cnt);		// Write Data to FIFO


        //IOWR(AV_FIFO_INT_0_BASE, 3, 1);		// Toggle FIFO reset
        //IOWR(AV_FIFO_INT_0_BASE, 3, 0);		// Toggle FIFO reset



/*
        // UART
        char *ptr = str;
        while (*ptr != '\0')
        {
           while ((uart[2] & (1<<6)) == 0);
           uart[1] = *ptr;
           ptr++;
        }
*/

    }

    return 0;	//Just make compiler happy!
}
