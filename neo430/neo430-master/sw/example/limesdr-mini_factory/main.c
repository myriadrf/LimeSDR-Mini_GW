/**
 * @file main.c
 *
 * @brief NEO430 firmware for LimeSDR-Mini factory image. 
 *
 * Copyright (C) 2018 Lime Microsystems
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


// Includes
#include <stdint.h>
#include <string.h>
#include "../../lib/neo430/neo430.h"
#include "limesdr-mini_brd_1v1.h"
#include "i2c_opencores.h"

#define SWAP_UINT32(x) (((x) >> 24) | (((x) & 0x00FF0000) >> 8) | (((x) & 0x0000FF00) << 8) | ((x) << 24))


// Get Info related
//#define FW_VER				1 //Initial version
#define FW_VER				2 //Configuration possibility from image 0 added

// Check Intel System Designer for addresses
#define AV_FIFO_INT_0_BASE (0x0400)
#define ONCHIP_FLASH_0_CSR_BASE (0x0040)
#define ONCHIP_FLASH_0_DATA_BASE (0x100000)
#define I2C_OPENCORES_0_BASE (0x0060)
#define DUAL_BOOT_0_BASE (0x0020)


uint8_t test, block, cmd_errors, glEp0Buffer_Rx[64], glEp0Buffer_Tx[64];
tLMS_Ctrl_Packet *LMS_Ctrl_Packet_Tx = (tLMS_Ctrl_Packet*)glEp0Buffer_Tx;
tLMS_Ctrl_Packet *LMS_Ctrl_Packet_Rx = (tLMS_Ctrl_Packet*)glEp0Buffer_Rx;


// UART Configuration
#define BAUD_RATE 19200

// Macros
#define xstr(a) str(a)
#define str(a) #a


 /**
 * Triggers another configuration 
 */
void boot_from_flash(void)
{
	//set CONFIG_SEL overwrite to 1 and CONFIG_SEL to Image 0
	wishbone_write32(DUAL_BOOT_0_BASE+(1<<2), 0x00000001);

	//set CONFIG_SEL overwrite to 1 and CONFIG_SEL to Image 1
	//IOWR(DUAL_BOOT_0_BASE, 1, 0x00000003);

	/*wait while core is busy*/
	while(wishbone_read32(DUAL_BOOT_0_BASE+(3<<2)) == 1) {}

	//Trigger reconfiguration to selected Image
	wishbone_write32(DUAL_BOOT_0_BASE+(0<<2), 0x00000001);
}


 /**
 * Delay routine. 
 * PARAM t delay
 */
void delay(uint16_t t)
{
  uint16_t i = 0;

  while (t--)
	{
    for (i=0; i<0xFFFF; i++)
      asm volatile ("nop");
  }
}

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
	uint32_t u32_rd;
	uint32_t* dest = (uint32_t*)buf;
	
	//uart_br_print("\nPacket: ");
	
	for(cnt=0; cnt<k/sizeof(uint32_t); cnt++)
	{
		// Check if FIFO not empty
		do
			u32_rd = wishbone_read32(AV_FIFO_INT_0_BASE + (2<<2));	// Read FIFO Status
		while(u32_rd & 0x01);

		dest[cnt] = wishbone_read32(AV_FIFO_INT_0_BASE + (1<<2));	// Read Data from FIFO
		//uart_print_hex_dword(dest[cnt]);
	};
}

/**
 * Bit swap in byte
 */
uint8_t reverse(uint8_t b)
{
   b = (b & 0xF0) >> 4 | (b & 0x0F) << 4;
   b = (b & 0xCC) >> 2 | (b & 0x33) << 2;
   b = (b & 0xAA) >> 1 | (b & 0x55) << 1;
   return b;
}

/**
 * EEPROM test routine
 */
void testEEPROM(void)
{
	int spirez;
	uint8_t rd_val;
	uint16_t addr = 0x0400;
	uint16_t size = 0;
	
	uart_br_print("\nEEPROM dump, staring at 0x400: ");
	
	for (addr=0x0400; addr<0x0406; addr++)
	{
		//EEPROM Test, RD from 0x0404
		spirez = I2C_start(I2C_OPENCORES_0_BASE, EEPROM_I2C_ADDR, 0);
		spirez = I2C_write(I2C_OPENCORES_0_BASE, (uint8_t)(addr>>8), 0);
		spirez = I2C_write(I2C_OPENCORES_0_BASE, (uint8_t)addr, 0);

		spirez = I2C_start(I2C_OPENCORES_0_BASE, EEPROM_I2C_ADDR, 1);
		rd_val = I2C_read(I2C_OPENCORES_0_BASE, 1);
		uart_print_hex_byte(rd_val);
	};
	
	// Size MSB
	spirez = I2C_start(I2C_OPENCORES_0_BASE, EEPROM_I2C_ADDR, 0);
	spirez = I2C_write(I2C_OPENCORES_0_BASE, (uint8_t)(addr>>8), 0);
	spirez = I2C_write(I2C_OPENCORES_0_BASE, (uint8_t)addr, 0);
	addr++;

	spirez = I2C_start(I2C_OPENCORES_0_BASE, EEPROM_I2C_ADDR, 1);
	rd_val = I2C_read(I2C_OPENCORES_0_BASE, 1);
	uart_print_hex_byte(rd_val);
	size = (uint16_t)rd_val;
	size = (size << 8) & 0xFF00;
		
	//Size LSB	
	spirez = I2C_start(I2C_OPENCORES_0_BASE, EEPROM_I2C_ADDR, 0);
	spirez = I2C_write(I2C_OPENCORES_0_BASE, (uint8_t)(addr>>8), 0);
	spirez = I2C_write(I2C_OPENCORES_0_BASE, (uint8_t)addr, 0);
	addr++;

	spirez = I2C_start(I2C_OPENCORES_0_BASE, EEPROM_I2C_ADDR, 1);
	rd_val = I2C_read(I2C_OPENCORES_0_BASE, 1);
	uart_print_hex_byte(rd_val);
	size = size | (uint16_t)rd_val;
	
	
	uart_br_print("\n\nSize = ");
	uart_print_hex_word(size);
	uart_br_print("\n\n");
	
	for (addr=addr; addr<0x0400+size; addr++)
	{
		//EEPROM Test, RD from 0x0404
		spirez = I2C_start(I2C_OPENCORES_0_BASE, EEPROM_I2C_ADDR, 0);
		spirez = I2C_write(I2C_OPENCORES_0_BASE, (uint8_t)(addr>>8), 0);
		spirez = I2C_write(I2C_OPENCORES_0_BASE, (uint8_t)addr, 0);

		spirez = I2C_start(I2C_OPENCORES_0_BASE, EEPROM_I2C_ADDR, 1);
		rd_val = I2C_read(I2C_OPENCORES_0_BASE, 1);
		uart_print_hex_byte(rd_val);
	};

	//WR
	/*
	spirez = I2C_start(I2C_OPENCORES_0_BASE, EEPROM_I2C_ADDR, 0);
	spirez = I2C_write(I2C_OPENCORES_0_BASE, 0x00, 0);
	spirez = I2C_write(I2C_OPENCORES_0_BASE, 0x01, 0);
	spirez = I2C_write(I2C_OPENCORES_0_BASE, 0x5A, 1);
*/
}

/**
 * Main, what else? :)
 **/
int main(void)
{
	uint32_t* dest = (uint32_t*)glEp0Buffer_Tx;
	unsigned int spirez;
	uint32_t u32_rd;
	short cnt = 0;
	uint8_t boot_img_en = 0;
	
	// FPGA Flash programming related
	uint32_t current_portion;
	uint8_t data_cnt;
	uint8_t state = 0, Flash = 0x0;
	uint32_t CFM0StartAddress = 0x012800;
	uint32_t CFM0EndAddress   = 0x022FFF;
	uint32_t UFMStartAddress = 0x0;
	uint32_t UFMEndAddress   = 0x01FFF;
	uint32_t address = 0x0;
	uint32_t byte = 0;
	uint32_t word = 0x0;

  // Setup UART
  uart_set_baud(BAUD_RATE);
  USI_CT = (1<<USI_CT_EN);
	
	// FIFO reset
	wishbone_write32(AV_FIFO_INT_0_BASE + (3<<2), 1);		// Toggle FIFO reset
	wishbone_write32(AV_FIFO_INT_0_BASE + (3<<2), 0);		// Toggle FIFO reset

/*	
	while(1)
	{
		u32_rd = wishbone_read32(0x40 + (1<<2));	// 
		uart_print_hex_dword(u32_rd);
		delay(10);
	}
*/	
	
/*		
	while(1)
	{
		u32_rd = wishbone_read32(AV_FIFO_INT_0_BASE + (5<<2));	// Read Test Register, should be 0x41
		uart_print_hex_dword(u32_rd);
	}
*/	
  // setup UART
  uart_set_baud(BAUD_RATE);
  USI_CT = (1<<USI_CT_EN);

  // intro text
  uart_br_print("\nLimeSDR-Mini Factory Firmware Version: "xstr(FW_VER)"\n");
	
	
	// I2C initialiazation
	I2C_init(I2C_OPENCORES_0_BASE, 40000000, 100000);
	//uart_br_print("\nI2C Initialized.\n");
	
	
	//testEEPROM();

  // check if GPIO unit was synthesized, exit if no GPIO is available
  if (!(SYS_FEATURES & (1<<SYS_GPIO_EN))) {
    uart_br_print("Error! No GPIO unit synthesized!");
    return 1;
  }

  // Configure Avalon GPIO IP
  //wishbone_write32(0x01, 0x00FF);	// Set as outputs
  
  
  //gpio_port_set(0); // deactivate all LEDs
  //wishbone_write32(0x00, 0);	// deactivate all LEDs



  //uint16_t i = 0; // init counter
  while (1)
  {
		//gpio_port_set(0x00FF & i++); // set output port and increment counter
		//wishbone_write32(0x00, 0x00FF & i++);	// set output port and increment counter
		//delay(10); // wait some time
		
		spirez = wishbone_read32(AV_FIFO_INT_0_BASE + (2<<2));	// Read FIFO Status
		//uart_br_print(".");
		if(!(spirez & 0x01))
		{
			
			//uart_br_print("\nGot a Packet\n");
			//uart_print_hex_byte((uint8_t)spirez);
			
			//Read packet from the FIFO
			getFifoData(glEp0Buffer_Rx, 64);

			memset (glEp0Buffer_Tx, 0, sizeof(glEp0Buffer_Tx)); //fill whole tx buffer with zeros
			cmd_errors = 0;

			LMS_Ctrl_Packet_Tx->Header.Command = LMS_Ctrl_Packet_Rx->Header.Command;
			LMS_Ctrl_Packet_Tx->Header.Data_blocks = LMS_Ctrl_Packet_Rx->Header.Data_blocks;
			LMS_Ctrl_Packet_Tx->Header.Periph_ID = LMS_Ctrl_Packet_Rx->Header.Periph_ID;
			LMS_Ctrl_Packet_Tx->Header.Status = STATUS_BUSY_CMD;		
/*
			uart_br_print("\nCommand code: ");
			uart_print_hex_byte((uint8_t)LMS_Ctrl_Packet_Rx->Header.Command);
			uart_br_print("\n");
*/			
     	switch(LMS_Ctrl_Packet_Rx->Header.Command)
     	{

 				case CMD_GET_INFO:
					//uart_br_print("Command: CMD_GET_INFO\n");
 					LMS_Ctrl_Packet_Tx->Data_field[0] = FW_VER;
 					LMS_Ctrl_Packet_Tx->Data_field[1] = DEV_TYPE;
 					LMS_Ctrl_Packet_Tx->Data_field[2] = LMS_PROTOCOL_VER;
 					LMS_Ctrl_Packet_Tx->Data_field[3] = HW_VER;
 					LMS_Ctrl_Packet_Tx->Data_field[4] = EXP_BOARD;

 					LMS_Ctrl_Packet_Tx->Header.Status = STATUS_COMPLETED_CMD;
 				break;
				

				case CMD_ALTERA_FPGA_GW_WR: //FPGA passive serial

					current_portion = ((uint32_t)LMS_Ctrl_Packet_Rx->Data_field[1] << 24)	| ((uint32_t)LMS_Ctrl_Packet_Rx->Data_field[2] << 16) | ((uint32_t)LMS_Ctrl_Packet_Rx->Data_field[3] << 8) | ((uint32_t)LMS_Ctrl_Packet_Rx->Data_field[4]);
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
							LMS_Ctrl_Packet_Tx->Header.Status = STATUS_ERROR_CMD;
						break;

						case 1: //write data to Flash from PC

							current_portion = ((uint32_t)LMS_Ctrl_Packet_Rx->Data_field[1] << 24) | ((uint32_t)LMS_Ctrl_Packet_Rx->Data_field[2] << 16) | ((uint32_t)LMS_Ctrl_Packet_Rx->Data_field[3] << 8) | ((uint32_t)LMS_Ctrl_Packet_Rx->Data_field[4]);
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
									//Initiate CFM0 (ID5) Erase Operation
									case 10:
										//Set Flash memory addresses
										address = UFMStartAddress;

										//Write Control Register of On-Chip Flash IP to un-protect and erase operation
										wishbone_write32(ONCHIP_FLASH_0_CSR_BASE + (1<<2), 0xf67fffff);
										wishbone_write32(ONCHIP_FLASH_0_CSR_BASE + (1<<2), 0xf65fffff);

										state = 11;
										Flash = 1;
									break;

									case 11:
										//Start erase CFM0
										if((wishbone_read32(ONCHIP_FLASH_0_CSR_BASE + (0<<2)) & 0x13) == 0x10)
										{
											wishbone_write32(ONCHIP_FLASH_0_CSR_BASE + (1<<2), 0xf67fffff);
											uart_br_print("CFM0 Erased\n");
											state = 13;
											Flash = 1;
										}
										if((wishbone_read32(ONCHIP_FLASH_0_CSR_BASE + (0<<2)) & 0x13) == 0x01)
										{
											uart_br_print("Erasing CFM0\n");
											state = 11;
											Flash = 1;
										}
										if((wishbone_read32(ONCHIP_FLASH_0_CSR_BASE + (0<<2)) & 0x13) == 0x00)
										{
											uart_br_print("Erase CFM0 Failed\n");
											state = 0;
										}
									break;
									
									//Initiate UFM (ID1) Erase Operation
									case 13:
										//Write Control Register of On-Chip Flash IP to un-protect and erase operation
										wishbone_write32(ONCHIP_FLASH_0_CSR_BASE + (1<<2), 0xf67fffff);
										wishbone_write32(ONCHIP_FLASH_0_CSR_BASE + (1<<2), 0xf61fffff);

										state = 14;
										Flash = 1;
									break;

									case 14:
										//Start erase UFM ID1
										if((wishbone_read32(ONCHIP_FLASH_0_CSR_BASE + (0<<2)) & 0x13) == 0x10)
										{
											wishbone_write32(ONCHIP_FLASH_0_CSR_BASE + (1<<2), 0xf67fffff);
											uart_br_print("UFM ID1 Erased\n");
											state = 16;
											Flash = 1;
										}
										if((wishbone_read32(ONCHIP_FLASH_0_CSR_BASE + (0<<2)) & 0x13) == 0x01)
										{
											uart_br_print("Erasing UFM ID1\n");
											state = 14;
											Flash = 1;
										}
										if((wishbone_read32(ONCHIP_FLASH_0_CSR_BASE + (0<<2)) & 0x13) == 0x00)
										{
											uart_br_print("Erase UFM ID1 Failed\n");
											state = 0;
										}
									break;

									//Initiate UFM (ID2) Erase Operation
									case 16:

										//Write Control Register of On-Chip Flash IP to un-protect and erase operation
										wishbone_write32(ONCHIP_FLASH_0_CSR_BASE + (1<<2), 0xf67fffff);
										wishbone_write32(ONCHIP_FLASH_0_CSR_BASE + (1<<2), 0xf62fffff);

										state = 17;
										Flash = 1;
									break;

									case 17:
										//Start erase UFM ID2
										if((wishbone_read32(ONCHIP_FLASH_0_CSR_BASE + (0<<2)) & 0x13) == 0x10)
										{
											wishbone_write32(ONCHIP_FLASH_0_CSR_BASE + (1<<2), 0xf67fffff);
											uart_br_print("UFM ID2 Erased\n");
											state = 20;
											Flash = 1;
										}
										if((wishbone_read32(ONCHIP_FLASH_0_CSR_BASE + (0<<2)) & 0x13) == 0x01)
										{
											uart_br_print("Erasing UFM ID2\n");
											state = 17;
											Flash = 1;
										}
										if((wishbone_read32(ONCHIP_FLASH_0_CSR_BASE + (0<<2)) & 0x13) == 0x00)
										{
											uart_br_print("Erase UFM ID2 Failed\n");
											state = 0;
										}
									break;

									//Program
									case 20:
										for(byte = 24; byte <= 52; byte += 4)
										{
											//Take word and swap bits
											word  = ((uint32_t)reverse(LMS_Ctrl_Packet_Rx->Data_field[byte+0]) << 24) & 0xFF000000;
											word |= ((uint32_t)reverse(LMS_Ctrl_Packet_Rx->Data_field[byte+1]) << 16) & 0x00FF0000;
											word |= ((uint32_t)reverse(LMS_Ctrl_Packet_Rx->Data_field[byte+2]) <<  8) & 0x0000FF00;
											word |= ((uint32_t)reverse(LMS_Ctrl_Packet_Rx->Data_field[byte+3]) <<  0) & 0x000000FF;

											//Command to write into On-Chip Flash IP
											if(address <= CFM0EndAddress)
											{
												wishbone_write32(ONCHIP_FLASH_0_DATA_BASE + (address<<2), word);

												while((wishbone_read32(ONCHIP_FLASH_0_CSR_BASE + (0<<2)) & 0x0b) == 0x02)
												{
													//printf("Writing CFM0(%d)\n", address);
												}

												if((wishbone_read32(ONCHIP_FLASH_0_CSR_BASE + (0<<2)) & 0x0b) == 0x00)
												{
													uart_br_print("Write to addr failed\n");
													state = 0;
													address = 700000;
												}

												if((wishbone_read32(ONCHIP_FLASH_0_CSR_BASE + (0<<2)) & 0x0b) == 0x08)
												{
												};

												// Increment address or move to CFM0 sector
												if (address == UFMEndAddress) address = CFM0StartAddress;
												else address += 1;

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
										wishbone_write32(ONCHIP_FLASH_0_CSR_BASE + (1<<2), 0xffffffff);

										state = 0;
										Flash = 0;

										LMS_Ctrl_Packet_Tx->Header.Status = STATUS_COMPLETED_CMD;
										uart_br_print("Programing CFM0 Finished\n");
									break;

									default:
										LMS_Ctrl_Packet_Tx->Header.Status = STATUS_ERROR_CMD;
										state = 0;
										Flash = 0;
								};
							};
						break;

						case 2: //configure FPGA from flash
/*
							//set CONFIG_SEL overwrite to 1 and CONFIG_SEL to Image 1
							//IOWR(DUAL_BOOT_0_BASE, 1, 0x00000003);

							//set CONFIG_SEL overwrite to 1 and CONFIG_SEL to Image 0
							IOWR(DUAL_BOOT_0_BASE, 1, 0x00000001);


							//wait while core is busy
							while(IORD(DUAL_BOOT_0_BASE, 3) == 1) {}

							//Trigger reconfiguration to Image 1
							//IOWR(DUAL_BOOT_0_BASE, 0, 0x00000001);

							//Trigger reconfiguration to Image 0
							IOWR(DUAL_BOOT_0_BASE, 0, 0x00000001);

							LMS_Ctrl_Packet_Tx->Header.Status = STATUS_COMPLETED_CMD;
*/
							//enable boot to factory image, booting is executed after response to command is sent
							boot_img_en = 1;
							LMS_Ctrl_Packet_Tx->Header.Status = STATUS_COMPLETED_CMD;
						break;

						default:
							LMS_Ctrl_Packet_Tx->Header.Status = STATUS_COMPLETED_CMD;
						break;

					}

				break;

				
				default:
 					// This is unknown request
					uart_br_print("Command: UNKNOWN\n");
					LMS_Ctrl_Packet_Tx->Header.Status = STATUS_UNKNOWN_CMD;
			};
		
			//Send response to the command
			for(cnt=0; cnt<64/sizeof(uint32_t); cnt++)
			{
				wishbone_write32(AV_FIFO_INT_0_BASE + (0<<2), dest[cnt]);
			};
			//uart_br_print("Response Sent\n");
			
			// If boot from flash CMD is executed FPGA GW is loaded from internal FLASH (image 1)
			if(boot_img_en==1)
			{
				boot_from_flash();
			};
		};
  }

  return 0;
}
