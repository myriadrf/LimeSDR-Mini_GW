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
    uart_rxd_i : in  std_ulogic  -- UART receive data
		
  );
end neo430_test;

architecture neo430_test_rtl of neo430_test is

  -- Local signals
  --signal gpio_out : std_logic_vector(15 downto 0);
	signal gpio_out : std_logic_vector(7 downto 0);
  signal rst_int, rst_intp  : std_ulogic;
	
	-- Wishbone Interface Signals
  signal wb_adr_o   : std_ulogic_vector(31 downto 0); -- address
  signal wb_dat_i   : std_logic_vector(31 downto 0); -- read data
  signal wb_dat_o   : std_ulogic_vector(31 downto 0); -- write data
  signal wb_we_o    : std_ulogic; -- read/write
  signal wb_sel_o   : std_ulogic_vector(03 downto 0); -- byte enable
  signal wb_stb_o   : std_ulogic; -- strobe
  signal wb_cyc_o   : std_ulogic; -- valid cycle
  signal wb_ack_i   : std_ulogic; -- transfer acknowledge
	
	-- Avalon Interface Signals
  signal m_av_address_o			: std_logic_vector(31 downto 0);
  signal m_av_byteenable_o		: std_logic_vector(3 downto 0);
  signal m_av_read_o					: std_logic; 
  signal m_av_readdata_i			: std_logic_vector(31 downto 0);
  signal m_av_write_o				: std_logic; 
  signal m_av_writedata_o		: std_logic_vector(31 downto 0);
  signal m_av_waitrequest_i	: std_logic; 
  signal m_av_readdatavalid_i: std_logic;
		
	
	component factory is
		port (
			clk_clk                   : in  std_logic                     := 'X';             -- clk
			reset_reset_n             : in  std_logic                     := 'X';             -- reset_n
			pio_0_export              : out std_logic_vector(7 downto 0);                     -- export
			bridge_0_address          : in  std_logic_vector(14 downto 0) := (others => 'X'); -- address
			bridge_0_byte_enable      : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- byte_enable
			bridge_0_read             : in  std_logic                     := 'X';             -- read
			bridge_0_write            : in  std_logic                     := 'X';             -- write
			bridge_0_write_data       : in  std_logic_vector(31 downto 0) := (others => 'X'); -- write_data
			bridge_0_acknowledge      : out std_logic;                                        -- acknowledge
			bridge_0_read_data        : out std_logic_vector(31 downto 0);                    -- read_data
			av_fifo_if_d_export       : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			av_fifo_if_rd_export      : out std_logic;                                        -- export
			av_fifo_of_wrfull_export  : in  std_logic                     := 'X';             -- export
			av_fifo_of_wr_export      : out std_logic;                                        -- export
			av_fifo_of_d_export       : out std_logic_vector(31 downto 0);                    -- export
			av_fifo_if_rdempty_export : in  std_logic                     := 'X';             -- export
			av_fifo_fifo_rst_export   : out std_logic                                         -- export
		);
	end component factory;
	
	
	component wb_to_avalon_bridge is
	generic 
	(
		DW: integer := 32;		--parameter DW = 32,	-- Data width
		AW: integer := 32;		--parameter AW = 32,	-- Address width
		BURST_SUPPORT: integer := 0			--parameter BURST_SUPPORT = 0
	);
	port
	(
		wb_clk_i: in std_logic;
		wb_rst_i: in std_logic; 
		
		-- Wishbone Slave Input
		wb_adr_i: in std_logic_vector(AW-1 downto 0);
		wb_dat_i: in std_logic_vector(DW-1 downto 0);
		wb_sel_i: in std_logic_vector(DW/8-1 downto 0);
		wb_we_i: in std_logic; 
		wb_cyc_i: in std_logic; 
		wb_stb_i: in std_logic; 
		wb_cti_i: in std_logic_vector(2 downto 0);
		wb_bte_i: in std_logic_vector(2 downto 0);
		wb_dat_o: out std_logic_vector(DW-1 downto 0);
		wb_ack_o: out std_logic; 
		wb_err_o: out std_logic; 
		wb_rty_o: out std_logic;
		
		-- Avalon Master Output
		m_av_address_o			: out std_logic_vector(AW-1 downto 0);
		m_av_byteenable_o		: out std_logic_vector(DW/8-1 downto 0);
		m_av_read_o					: out std_logic; 
		m_av_readdata_i			: in std_logic_vector(DW-1 downto 0);
		m_av_burstcount_o		: out std_logic_vector(7 downto 0);
		m_av_write_o				: out std_logic; 
		m_av_writedata_o		: out std_logic_vector(DW-1 downto 0);
		m_av_waitrequest_i	: in std_logic; 
		m_av_readdatavalid_i: in std_logic
	);
	end component;

begin

	-- -----------------------------------------------------------------------------
  -- QSys components
  -- -----------------------------------------------------------------------------
	u0 : factory
		port map (
			clk_clk       => clk_i, 
			reset_reset_n => rst_int,
			pio_0_export         => gpio_out, --: out std_logic_vector(7 downto 0);                     -- export
			bridge_0_address     => m_av_address_o(14 downto 0), --: in  std_logic_vector(14 downto 0) := (others => 'X'); -- address
			bridge_0_byte_enable => m_av_byteenable_o, --: in  std_logic_vector(3 downto 0)  := (others => 'X'); -- byte_enable
			bridge_0_read        => m_av_read_o, --: in  std_logic                     := 'X';             -- read
			bridge_0_write       => m_av_write_o, --: in  std_logic                     := 'X';             -- write
			bridge_0_write_data  => m_av_writedata_o, --: in  std_logic_vector(31 downto 0) := (others => 'X'); -- write_data
			bridge_0_acknowledge => open, -- ???: out std_logic;                                        -- acknowledge
			bridge_0_read_data   => m_av_readdata_i, --: out std_logic_vector(31 downto 0)                     -- read_data
			av_fifo_if_d_export		=> av_fifo_if_d, --       : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			av_fifo_if_rd_export	=> av_fifo_if_rd, --      : out std_logic;                                        -- export
			av_fifo_of_wrfull_export => av_fifo_of_wrfull, --  : in  std_logic                     := 'X';             -- export
			av_fifo_of_wr_export	=> av_fifo_of_wr, --      : out std_logic;                                        -- export
			av_fifo_of_d_export 	=> av_fifo_of_d, --      : out std_logic_vector(31 downto 0);                    -- export
			av_fifo_if_rdempty_export	=> av_fifo_if_rdempty, -- : in  std_logic                     := 'X';             -- export
			av_fifo_fifo_rst_export 	=> av_fifo_fifo_rst --  : out std_logic                                         -- export

		);


	-- -----------------------------------------------------------------------------
  -- Wishbone to Avalon Bridge 
  -- -----------------------------------------------------------------------------
	u1: wb_to_avalon_bridge
	generic map
	(
		DW => 32,		--parameter DW = 32,	-- Data width
		AW => 32,		--parameter AW = 32,	-- Address width
		BURST_SUPPORT => 0			--parameter BURST_SUPPORT = 0
	)
	port map
	(
		wb_clk_i => clk_i, --: in std_logic;
		wb_rst_i => rst_intp, --: in std_logic; 
		
		-- Wishbone Slave Input
		wb_adr_i => std_logic_vector(wb_adr_o), --: in std_logic_vector(AW-1 downto 0);
		wb_dat_i => std_logic_vector(wb_dat_o), --: in std_logic_vector(DW-1 downto 0);
		wb_sel_i => std_logic_vector(wb_sel_o), --: in std_logic_vector(DW/8-1 downto 0);
		wb_we_i => wb_we_o, --: in std_logic; 
		wb_cyc_i => wb_cyc_o, --: in std_logic; 
		wb_stb_i => wb_stb_o, --: in std_logic; 
		wb_cti_i => "000", --: in std_logic_vector(2 downto 0);
		wb_bte_i => "000", --: in std_logic_vector(2 downto 0);
		wb_dat_o => wb_dat_i, --: out std_logic_vector(DW-1 downto 0);
		wb_ack_o => wb_ack_i, --: out std_logic; 
		wb_err_o => open, --: out std_logic; 
		wb_rty_o => open, --: out std_logic;
		
		-- Avalon Master Output
		m_av_address_o => m_av_address_o, --: out std_logic_vector(AW-1 downto 0);
		m_av_byteenable_o => m_av_byteenable_o, --: out std_logic_vector(DW/8-1 downto 0);
		m_av_read_o => m_av_read_o, --: out std_logic; 
		m_av_readdata_i => m_av_readdata_i, --: in std_logic_vector(DW-1 downto 0);
		m_av_burstcount_o => open, --: out std_logic_vector(7 downto 0);
		m_av_write_o => m_av_write_o, --: out std_logic; 
		m_av_writedata_o => m_av_writedata_o, --: out std_logic_vector(DW-1 downto 0);
		m_av_waitrequest_i => '0', --: in std_logic; ???
		m_av_readdatavalid_i => '0' --: in std_logic ???
	);		
		
	-- -----------------------------------------------------------------------------
  -- The Core of the Problem 
  -- -----------------------------------------------------------------------------
  u2: neo430_top
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
    spi_sclk_o => open,               -- serial clock line
    spi_mosi_o => open,               -- serial data line out
    spi_miso_i => '0',                -- serial data line in
    spi_cs_o   => open,               -- SPI CS 0..5
    -- 32-bit wishbone interface --
    wb_adr_o   => wb_adr_o,               -- address
    wb_dat_i   => std_ulogic_vector(wb_dat_i),        -- read data
    wb_dat_o   => wb_dat_o,               -- write data
    wb_we_o    => wb_we_o,               -- read/write
    wb_sel_o   => wb_sel_o,               -- byte enable
    wb_stb_o   => wb_stb_o,               -- strobe
    wb_cyc_o   => wb_cyc_o,               -- valid cycle
    wb_ack_i   => wb_ack_i,                -- transfer acknowledge
		
		
    -- 32-bit wishbone interface --
--    wb_adr_o   => open,               -- address
--    wb_dat_i   => x"00000000",        -- read data
--    wb_dat_o   => open,               -- write data
--    wb_we_o    => open,               -- read/write
--    wb_sel_o   => open,               -- byte enable
--    wb_stb_o   => open,               -- strobe
--    wb_cyc_o   => open,               -- valid cycle
--    wb_ack_i   => '0',                -- transfer acknowledge
		
		
    -- external interrupt --
    irq_i      => '0',                -- external interrupt request line
    irq_ack_o  => open                -- external interrupt request acknowledge
  );

  -- constrain output signals --
  gpio_o <= gpio_out(7 downto 0);

  -- internal reset (must be low-active!) --
  rst_int <= rst_i; -- invert me?!
	rst_intp <= not rst_i;

end neo430_test_rtl;
