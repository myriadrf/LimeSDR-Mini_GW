-- #################################################################################################
-- #  << NEO430 - Processor Test Implementation (neo430_test.vhd) >>                               #
-- # ********************************************************************************************* #
-- #  If you do not have an own design (yet), you can use this unit as top entity to play with     #
-- #  the NEO430 processor. Take a look at the project's documentary (chapter "Let's Get It        #
-- #  Started!") to get more information.                                                          #
-- # ********************************************************************************************* #
-- # This file is part of the NEO430 Processor project: https://github.com/stnolting/neo430        #
-- # Copyright by Stephan Nolting: stnolting@gmail.com                                             #
-- #                                                                                               #
-- # This source file may be used and distributed without restriction provided that this copyright #
-- # statement is not removed from the file and that any derivative work contains the original     #
-- # copyright notice and the associated disclaimer.                                               #
-- #                                                                                               #
-- # This source file is free software; you can redistribute it and/or modify it under the terms   #
-- # of the GNU Lesser General Public License as published by the Free Software Foundation,        #
-- # either version 3 of the License, or (at your option) any later version.                       #
-- #                                                                                               #
-- # This source is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;      #
-- # without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.     #
-- # See the GNU Lesser General Public License for more details.                                   #
-- #                                                                                               #
-- # You should have received a copy of the GNU Lesser General Public License along with this      #
-- # source; if not, download it from https://www.gnu.org/licenses/lgpl-3.0.en.html                #
-- # ********************************************************************************************* #
-- #  Stephan Nolting, Hannover, Germany                                               01.12.2017  #
-- #  Adopted by Zydrunas Tamosevicius                                                 10.01.2018  #
-- #################################################################################################

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library neo430;
use neo430.neo430_package.all;

entity neo430_test is
  port (
    -- global control --
    clk_i      : in  std_ulogic; -- global clock, rising edge
    rst_i      : in  std_ulogic; -- global reset, async, LOW-active

		-- Avalon External Fifo Interface
		av_fifo_if_d       : in  std_logic_vector(31 downto 0) := (others => 'X');
		av_fifo_if_rd      : out std_logic;
		av_fifo_of_wrfull  : in  std_logic;
		av_fifo_of_wr      : out std_logic;
		av_fifo_of_d       : out std_logic_vector(31 downto 0);
		av_fifo_if_rdempty : in  std_logic;
		av_fifo_fifo_rst   : out std_logic;

    -- parallel io --
    gpio_o     : out std_logic_vector(07 downto 0); -- parallel output

    -- serial com --
    uart_txd_o : out std_ulogic; -- UART send data
    uart_rxd_i : in  std_ulogic; -- UART receive data
		
		spi_sclk_o : out std_ulogic;               -- serial clock line
    spi_mosi_o : out std_ulogic;               -- serial data line out
    spi_miso_i : in  std_ulogic;                -- serial data line in
    spi_cs_o   : out std_ulogic_vector(5 downto 0);               -- SPI CS 0..5
		
		-- I2C
		sda           : inout std_logic;
		scl           : inout std_logic
	
  );
end neo430_test;

architecture neo430_test_rtl of neo430_test is

  -- Local signals
  --signal gpio_out : std_logic_vector(15 downto 0);
	signal gpio_out : std_logic_vector(7 downto 0);
  signal rst_int, rst_intp  : std_ulogic;
	
  -- internal wishbone (unresolved) bus --
  type wb_bus_ul_t is record
    adr : std_ulogic_vector(31 downto 0); -- address
    di  : std_ulogic_vector(31 downto 0); -- slave input data
    do  : std_ulogic_vector(31 downto 0); -- slave output data
    we  : std_ulogic; -- write enable
    sel : std_ulogic_vector(03 downto 0); -- byte enable
    stb : std_ulogic; -- strobe
    cyc : std_ulogic; -- valid cycle
    ack : std_ulogic; -- transfer acknowledge
  end record;
  signal wb_core : wb_bus_ul_t;

  -- internal wishbone bus --
  type wb_bus_t is record
    adr : std_logic_vector(31 downto 0); -- address
    di  : std_logic_vector(31 downto 0); -- slave input data
    do  : std_logic_vector(31 downto 0); -- slave output data
    we  : std_logic; -- write enable
    sel : std_logic_vector(03 downto 0); -- byte enable
    stb : std_logic; -- strobe
    cyc : std_logic; -- valid cycle
    ack : std_logic; -- transfer acknowledge
  end record;
  signal wb_conv : wb_bus_t;
	
	-- Avalon slave interface --
	signal avm_chipselect  : std_logic;
	signal avm_address     : std_logic_vector(31 downto 0);
	signal avm_readdata    : std_logic_vector(31 downto 0);
	signal avm_writedata   : std_logic_vector(31 downto 0);
	signal avm_byteenable  : std_logic_vector(03 downto 0);
	signal avm_write       : std_logic;
	signal avm_read        : std_logic;
	signal avm_waitrequest : std_logic;
	signal avm_acknowledge : std_logic;
	
		
	  -- misc --
  signal trans_en: std_logic;
	
	component factory is
		port (
			bridge_0_address     : in  std_logic_vector(20 downto 0) := (others => 'X'); -- address
			bridge_0_byte_enable : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- byte_enable
			bridge_0_read        : in  std_logic                     := 'X';             -- read
			bridge_0_write       : in  std_logic                     := 'X';             -- write
			bridge_0_write_data  : in  std_logic_vector(31 downto 0) := (others => 'X'); -- write_data
			bridge_0_acknowledge : out std_logic;                                        -- acknowledge
			bridge_0_read_data   : out std_logic_vector(31 downto 0);                    -- read_data
			clk_clk              : in  std_logic                     := 'X';             -- clk
			pio_0_export         : out std_logic_vector(7 downto 0);                     -- export
			reset_reset_n        : in  std_logic                     := 'X';             -- reset_n
			extfifo_of_d         : out std_logic_vector(31 downto 0);                    -- of_d
			extfifo_of_wr        : out std_logic;                                        -- of_wr
			extfifo_of_wrfull    : in  std_logic                     := 'X';             -- of_wrfull
			extfifo_if_d         : in  std_logic_vector(31 downto 0) := (others => 'X'); -- if_d
			extfifo_if_rd        : out std_logic;                                        -- if_rd
			extfifo_if_rdempty   : in  std_logic                     := 'X';             -- if_rdempty
			extfifo_fifo_rst     : out std_logic;                                        -- fifo_rst
			sda_export           : inout std_logic                     := 'X';             -- export
			scl_export           : inout std_logic                     := 'X'              -- export
		);
	end component factory;


begin

	-- -----------------------------------------------------------------------------
  -- QSys components
  -- -----------------------------------------------------------------------------
	u0 : factory
		port map (
			clk_clk       => clk_i, 
			reset_reset_n => rst_int,
			pio_0_export         => gpio_out, --: out std_logic_vector(7 downto 0);                     -- export
			
			bridge_0_address     => avm_address(20 downto 0), --: in  std_logic_vector(14 downto 0) := (others => 'X'); -- address
			bridge_0_byte_enable => avm_byteenable, --: in  std_logic_vector(3 downto 0)  := (others => 'X'); -- byte_enable
			bridge_0_read        => avm_read, --: in  std_logic                     := 'X';             -- read
			bridge_0_write       => avm_write, --: in  std_logic                     := 'X';             -- write
			bridge_0_write_data  => avm_writedata, --: in  std_logic_vector(31 downto 0) := (others => 'X'); -- write_data
			bridge_0_acknowledge => avm_acknowledge, -- ???: out std_logic;                                        -- acknowledge
			bridge_0_read_data   => avm_readdata, --: out std_logic_vector(31 downto 0)                     -- read_data
			
			extfifo_if_d		=> av_fifo_if_d, --       : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			extfifo_if_rd	=> av_fifo_if_rd, --      : out std_logic;                                        -- export
			extfifo_of_wrfull => av_fifo_of_wrfull, --  : in  std_logic                     := 'X';             -- export
			extfifo_of_wr	=> av_fifo_of_wr, --      : out std_logic;                                        -- export
			extfifo_of_d 	=> av_fifo_of_d, --      : out std_logic_vector(31 downto 0);                    -- export
			extfifo_if_rdempty	=> av_fifo_if_rdempty, -- : in  std_logic                     := 'X';             -- export
			extfifo_fifo_rst 	=> av_fifo_fifo_rst, --  : out std_logic                                         -- export
			
			sda_export => sda, 
			scl_export => scl

		);


		
		
	-- -----------------------------------------------------------------------------
  -- The Core of the Problem 
  -- -----------------------------------------------------------------------------
  u1: neo430_top
  generic map 
	(
    -- general configuration --
    CLOCK_SPEED => 40000000,         -- main clock in Hz
    IMEM_SIZE   => 4*1024,            -- internal IMEM size in bytes, max 32kB (default=4kB)
    DMEM_SIZE   => 2*1024,            -- internal DMEM size in bytes, max 28kB (default=2kB)
    -- additional configuration --
    USER_CODE   => x"CAFE",           -- custom user code
    -- module configuration --
    DADD_USE    => true,              -- implement DADD instruction? (default=true)
    MULDIV_USE  => true,              -- implement multiplier/divider unit? (default=true)
    WB32_USE    => true,              -- implement WB32 unit? (default=true)
    WDT_USE     => true,              -- implement WDT? (default=true)
    GPIO_USE    => true,              -- implement GPIO unit? (default=true)
    TIMER_USE   => true,              -- implement timer? (default=true)
    USART_USE   => true,              -- implement USART? (default=true)
		CRC_USE     => false,             -- implement CRC unit? (default=true)
    CFU_USE     => false,             -- implement custom functions unit? (default=false) 
    -- boot configuration --
    BOOTLD_USE  => true,              -- implement and use bootloader? (default=true)
    IMEM_AS_ROM => false              -- implement IMEM as read-only memory? (default=false)
  )
  port map 
	(
    -- global control --
    clk_i      => clk_i,              -- global clock, rising edge
    rst_i      => rst_int,            -- global reset, async, low-active
    -- gpio --
    gpio_o     => open, --gpio_out,           -- parallel output
    gpio_i     => x"0000",            -- parallel input
    -- serial com --
    uart_txd_o => uart_txd_o,         -- UART send data
    uart_rxd_i => uart_rxd_i,         -- UART receive data
    spi_sclk_o => spi_sclk_o,               -- serial clock line
    spi_mosi_o => spi_mosi_o,               -- serial data line out
    spi_miso_i => spi_miso_i,                -- serial data line in
    spi_cs_o   => spi_cs_o,               -- SPI CS 0..5
    -- 32-bit wishbone interface --
    wb_adr_o    => wb_core.adr,       -- address
    wb_dat_i    => wb_core.di,        -- read data
    wb_dat_o    => wb_core.do,        -- write data
    wb_we_o     => wb_core.we,        -- read/write
    wb_sel_o    => wb_core.sel,       -- byte enable
    wb_stb_o    => wb_core.stb,       -- strobe
    wb_cyc_o    => wb_core.cyc,       -- valid cycle
    wb_ack_i    => wb_core.ack,       -- transfer acknowledge
		
		
    -- external interrupt --
    irq_i      => '0',                -- external interrupt request line
    irq_ack_o  => open                -- external interrupt request acknowledge
  );

  -- constrain output signals --
  gpio_o <= gpio_out(7 downto 0);

  -- internal reset (must be low-active!) --
  rst_int <= rst_i; -- invert me?!
	rst_intp <= not rst_i;
	
	
	
  -- Wishbone-to-Avalon Bridge ------------------------------------------------
  -- -----------------------------------------------------------------------------
  -- Type Conversion --
  wb_conv.adr    <= std_logic_vector(wb_core.adr);
  wb_conv.do     <= std_logic_vector(wb_core.do);
  wb_conv.we     <= std_logic(wb_core.we);
  wb_conv.sel    <= std_logic_vector(wb_core.sel);
  wb_conv.stb    <= std_logic(wb_core.stb);
  wb_conv.cyc    <= std_logic(wb_core.cyc);
  
  wb_core.di     <= std_ulogic_vector(wb_conv.di);
  wb_core.ack    <= std_ulogic(wb_conv.ack);

	-- Wishbone -> Avalon
  active_transfer: process(clk_i)
  begin
    if rising_edge(clk_i) then
      trans_en <= wb_conv.cyc and (trans_en or wb_conv.stb); -- keep STB virtually alive
    end if;
  end process active_transfer;

  
  avm_address    <= wb_conv.adr;
  avm_writedata  <= wb_conv.do;
  avm_byteenable <= wb_conv.sel;
  avm_write      <= wb_conv.cyc and (wb_conv.stb or trans_en) and wb_conv.we;
  avm_read       <= wb_conv.cyc and (wb_conv.stb or trans_en) and (not wb_conv.we);
	avm_waitrequest <= '0';

  -- Avalon -> Wishbone
  wb_conv.di     <= avm_readdata;
  wb_conv.ack    <= avm_acknowledge; --wb_conv.cyc and (not avm_waitrequest);

end neo430_test_rtl;
