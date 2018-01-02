/**
-- ----------------------------------------------------------------------------	
-- FILE:	sodera_pcie_brd.h
-- DESCRIPTION:	Stream v2r2
-- DATE:	2015.06.29
-- AUTHOR(s):	Lime Microsystems
-- REVISION: v0r2
-- ----------------------------------------------------------------------------	

*/
#ifndef _SODERA_PCIE_BRD_V1R0_H_
#define _SODERA_PCIE_BRD_V1R0_H_

#include "LMS64C_protocol.h"

#pragma message ("**** sodera_pcie_brd_v1r0 ****")

//I2C devices
#define   LM75_I2C_ADDR		0x48 //0x90
#define EEPROM_I2C_ADDR		0x50 //0xA2

//get info
#define DEV_TYPE			LMS_DEV_ULIMESDR
#define HW_VER				0
#define EXP_BOARD			EXP_BOARD_UNSUPPORTED

//FPGA Cyclone IV GX (EP4GX30F23C7N) bitstream (RBF) size in bytes
#define FPGA_SIZE 			2751361 //1191788

//FLash memory (W25Q40EW , 4M-bit))
#define FLASH_PAGE_SIZE 	0x100 //256 bytes, SPI Page size to be used for transfers
#define FLASH_SECTOR_SIZE 	0x10000 //2048 pages * 256 page size = 524288 bytes
//#define FLASH_BLOCK_SIZE	(FLASH_SECTOR_SIZE/FLASH_PAGE_SIZE) //in pages

//FLASH memory layout
#define FLASH_LAYOUT_FPGA_METADATA	64//FPGA autoload metadata (start sector)
#define FLASH_LAYOUT_FPGA_BITSTREAM	0//FPGA bitstream (start sector) till end

#define FLASH_CMD_SECTOR_ERASE 0x20 //0x1B //Depends on flash, reversed: 0xD8 or 0x20
#define FLASH_CMD_PAGE_WRITE   0x02 //0x40 //Reversed 0x02
#define FLASH_CMD_PAGE_WRITEEN 0x06 //0x60 //Reversed 0x06
#define FLASH_CMD_PAGE_READ    0x03 //0xC0 //Reversed 0x03
#define FLASH_CMD_PAGE_READST  0x05 //0xA0 //Reversed 0x05
#define FLASH_CMD_READJEDECID  0x9F //0xF9 //Reversed 0x9F

typedef struct{
	uint32_t Bitream_size;
	uint8_t Autoload;
}tBoard_Config_FPGA; //tBoard_Config_FPGA or tBoard_cfg_FPGA

#endif
