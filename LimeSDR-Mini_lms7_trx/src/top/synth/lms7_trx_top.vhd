-- ----------------------------------------------------------------------------
-- FILE:          lms7_trx_top.vhd
-- DESCRIPTION:   Top level file for LimeSDR-Mini board
-- DATE:          10:06 AM Friday, May 11, 2018
-- AUTHOR(s):     Lime Microsystems
-- REVISIONS:
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
--NOTES:
-- ----------------------------------------------------------------------------
-- altera vhdl_input_version vhdl_2008
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fpgacfg_pkg.all;
use work.pllcfg_pkg.all;
use work.tstcfg_pkg.all;
use work.periphcfg_pkg.all;
use work.FIFO_PACK.all;

-- ----------------------------------------------------------------------------
-- Entity declaration
-- ----------------------------------------------------------------------------
entity lms7_trx_top is
   generic(
      -- General parameters
      BOARD                   : string := "LimeSDR-Mini";
      DEV_FAMILY              : string := "MAX 10";
      -- LMS7002 related 
      LMS_DIQ_WIDTH           : integer := 12;
      -- FTDI (USB3) related
      FTDI_DQ_WIDTH           : integer := 32;     -- FTDI Data bus size      
      CTRL0_FPGA_RX_SIZE      : integer := 1024;   -- Control PC->FPGA, FIFO size in bytes.
      CTRL0_FPGA_RX_RWIDTH    : integer := 32;     -- Control PC->FPGA, FIFO rd width.
      CTRL0_FPGA_TX_SIZE      : integer := 1024;   -- Control FPGA->PC, FIFO size in bytes
      CTRL0_FPGA_TX_WWIDTH    : integer := 32;     -- Control FPGA->PC, FIFO wr width
      STRM0_FPGA_RX_SIZE      : integer := 4096;   -- Stream PC->FPGA, FIFO size in bytes
      STRM0_FPGA_RX_RWIDTH    : integer := 128;    -- Stream PC->FPGA, rd width
      STRM0_FPGA_TX_SIZE      : integer := 16384;  -- Stream FPGA->PC, FIFO size in bytes
      STRM0_FPGA_TX_WWIDTH    : integer := 64;     -- Stream FPGA->PC, wr width
      -- 
      TX_N_BUFF               : integer := 4;      -- N 4KB buffers in TX interface (2 OR 4)
      TX_PCT_SIZE             : integer := 4096;   -- TX packet size in bytes
      TX_IN_PCT_HDR_SIZE      : integer := 16;
      -- Internal configuration memory 
      FPGACFG_START_ADDR      : integer := 0;
      PLLCFG_START_ADDR       : integer := 32;
      TSTCFG_START_ADDR       : integer := 96;
      PERIPHCFG_START_ADDR    : integer := 192
   );
   port (
      -- ----------------------------------------------------------------------------
      -- External GND pin for reset
      --EXT_GND           : in     std_logic;
      -- ----------------------------------------------------------------------------
      -- Clock sources
         -- Reference clock, coming from LMK clock buffer.
      LMK_CLK           : in     std_logic;
      -- ----------------------------------------------------------------------------
      -- LMS7002 Digital
         -- PORT1
      LMS_MCLK1         : in     std_logic;
      LMS_FCLK1         : out    std_logic;
      LMS_TXNRX1        : out    std_logic;
      LMS_ENABLE_IQSEL1 : out    std_logic;
      LMS_DIQ1_D        : out    std_logic_vector(LMS_DIQ_WIDTH-1 downto 0);
         -- PORT2
      LMS_MCLK2         : in     std_logic;
      LMS_FCLK2         : out    std_logic;
      LMS_TXNRX2        : out    std_logic;
      LMS_ENABLE_IQSEL2 : in     std_logic;
      LMS_DIQ2_D        : in     std_logic_vector(LMS_DIQ_WIDTH-1 downto 0);
         --MISC
      LMS_RESET         : out    std_logic := '1';
      LMS_TXEN          : out    std_logic;
      LMS_RXEN          : out    std_logic;
      LMS_CORE_LDO_EN   : out    std_logic;
      -- ----------------------------------------------------------------------------
      -- FTDI (USB3)
         -- Clock source
      FT_CLK            : in     std_logic;
         -- DATA
      FT_BE             : inout  std_logic_vector(FTDI_DQ_WIDTH/8-1 downto 0);
      FT_D              : inout  std_logic_vector(FTDI_DQ_WIDTH-1 downto 0);
         -- Control, flags
      FT_RXFn           : in     std_logic;
      FT_TXEn           : in     std_logic;
      FT_WRn            : out    std_logic;  
      -- ----------------------------------------------------------------------------
      -- External communication interfaces
         -- FPGA_SPI
      FPGA_SPI_SCLK     : out    std_logic;
      FPGA_SPI_MOSI     : out    std_logic;
      FPGA_SPI_MISO     : in     std_logic;      
      FPGA_SPI_LMS_SS   : out    std_logic;
      FPGA_SPI_DAC_SS   : out    std_logic;
         -- FPGA_QSPI
      FPGA_QSPI_SCLK    : out    std_logic;
      FPGA_QSPI_IO0     : out    std_logic;
      FPGA_QSPI_IO1     : in     std_logic;
      FPGA_QSPI_IO2     : out    std_logic;
      FPGA_QSPI_IO3     : out    std_logic;
      FPGA_QSPI_FLASH_SS: out    std_logic;
         -- FPGA I2C
      FPGA_I2C_SCL      : inout  std_logic;
      FPGA_I2C_SDA      : inout  std_logic;
      -- ----------------------------------------------------------------------------
      -- General periphery
         -- LEDs          
      FPGA_LED_R        : out    std_logic;
      FPGA_LED_G        : out    std_logic;
         -- GPIO 
      FPGA_GPIO         : inout  std_logic_vector(7 downto 0);
      FPGA_EGPIO        : inout  std_logic_vector(1 downto 0);
         -- Temperature sensor
      LM75_OS           : in     std_logic;
         -- Fan control 
      FAN_CTRL          : out    std_logic;
         -- RF loop back control 
      RFSW_RX_V1        : out    std_logic;
      RFSW_RX_V2        : out    std_logic;
      RFSW_TX_V1        : out    std_logic;
      RFSW_TX_V2        : out    std_logic;
      TX_LB_AT          : out    std_logic;
      TX_LB_SH          : OUT    std_logic;
         -- Bill Of material and hardware version 
      BOM_VER           : in     std_logic_vector(2 downto 0);
      HW_VER            : in     std_logic_vector(3 downto 0)

   );
end lms7_trx_top;

-- ----------------------------------------------------------------------------
-- Architecture
-- ----------------------------------------------------------------------------
architecture arch of lms7_trx_top is
--declare signals,  components here
signal reset_n                   : std_logic; 
signal reset_n_ft_clk            : std_logic;
signal reset_n_lmk_clk           : std_logic;

--inst0 (NIOS CPU instance)
signal inst0_exfifo_if_rd        : std_logic;
signal inst0_exfifo_of_d         : std_logic_vector(FTDI_DQ_WIDTH-1 downto 0);
signal inst0_exfifo_of_wr        : std_logic;
signal inst0_exfifo_of_rst       : std_logic;
signal inst0_gpo                 : std_logic_vector(7 downto 0);
signal inst0_lms_ctr_gpio        : std_logic_vector(3 downto 0);
signal inst0_spi_0_MISO          : std_logic;
signal inst0_spi_0_MOSI          : std_logic;
signal inst0_spi_0_SCLK          : std_logic;
signal inst0_spi_0_SS_n          : std_logic_vector(4 downto 0);
signal inst0_spi_1_MISO          : std_logic;
signal inst0_spi_1_MOSI          : std_logic;
signal inst0_spi_1_SCLK          : std_logic;
signal inst0_spi_1_SS_n          : std_logic_vector(1 downto 0);
signal inst0_from_fpgacfg        : t_FROM_FPGACFG;
signal inst0_to_fpgacfg          : t_TO_FPGACFG;
signal inst0_from_pllcfg         : t_FROM_PLLCFG;
signal inst0_to_pllcfg           : t_TO_PLLCFG;
signal inst0_from_tstcfg         : t_FROM_TSTCFG;
signal inst0_to_tstcfg           : t_TO_TSTCFG;
signal inst0_from_periphcfg      : t_FROM_PERIPHCFG;
signal inst0_to_periphcfg        : t_TO_PERIPHCFG;

--inst1 (pll_top instance)
signal inst1_pll_c1              : std_logic;
signal inst1_pll_c3              : std_logic;
signal inst1_pll_locked          : std_logic;
signal inst1_pll_smpl_cmp_en     : std_logic;
signal inst1_pll_smpl_cmp_cnt    : std_logic_vector(15 downto 0);

--inst2
constant C_EP02_RDUSEDW_WIDTH    : integer := FIFO_WORDS_TO_Nbits(CTRL0_FPGA_RX_SIZE/(CTRL0_FPGA_RX_RWIDTH/8),true);
constant C_EP82_WRUSEDW_WIDTH    : integer := FIFO_WORDS_TO_Nbits(CTRL0_FPGA_TX_SIZE/(CTRL0_FPGA_TX_WWIDTH/8),true);
constant C_EP03_RDUSEDW_WIDTH    : integer := FIFO_WORDS_TO_Nbits(STRM0_FPGA_RX_SIZE/(STRM0_FPGA_RX_RWIDTH/8),true);
constant C_EP83_WRUSEDW_WIDTH    : integer := FIFO_WORDS_TO_Nbits(STRM0_FPGA_TX_SIZE/(STRM0_FPGA_TX_WWIDTH/8),true);
signal inst2_ext_buff_data       : std_logic_vector(FTDI_DQ_WIDTH-1 downto 0);
signal inst2_ext_buff_wr         : std_logic;
signal inst2_EP82_wfull          : std_logic;
signal inst2_EP82_wrusedw        : std_logic_vector(C_EP82_WRUSEDW_WIDTH-1 downto 0);
signal inst2_EP03_rdata          : std_logic_vector(STRM0_FPGA_RX_RWIDTH-1 downto 0);
signal inst2_EP03_rempty         : std_logic;
signal inst2_EP03_rdusedw        : std_logic_vector(C_EP03_RDUSEDW_WIDTH-1 downto 0);
signal inst2_EP83_wfull          : std_logic;
signal inst2_EP83_wrusedw        : std_logic_vector(C_EP83_WRUSEDW_WIDTH-1 downto 0);
signal inst2_GPIF_busy           : std_logic;
signal inst2_faddr               : std_logic_vector(4 downto 0);
signal inst2_EP02_rdata          : std_logic_vector(CTRL0_FPGA_RX_RWIDTH-1 downto 0);
signal inst2_EP02_rempty         : std_logic;
signal inst2_EP02_rdusedw        : std_logic_vector(C_EP02_RDUSEDW_WIDTH-1 downto 0);

--inst4
constant C_INST4_GPIO_N          : integer := FPGA_GPIO'length + FPGA_EGPIO'length;
signal inst4_gpio                : std_logic_vector(C_INST4_GPIO_N-1 downto 0);


--inst5
signal inst5_busy : std_logic;

--inst6
signal inst6_tx_pct_loss_flg        : std_logic;
signal inst6_tx_txant_en            : std_logic;
signal inst6_tx_in_pct_full         : std_logic;
signal inst6_rx_pct_fifo_wrreq      : std_logic;
signal inst6_rx_pct_fifo_wdata      : std_logic_vector(63 downto 0);
signal inst6_rx_smpl_cmp_done       : std_logic;
signal inst6_rx_smpl_cmp_err        : std_logic;
signal inst6_to_tstcfg_from_rxtx    : t_TO_TSTCFG_FROM_RXTX;
signal inst6_rx_pct_fifo_aclrn_req  : std_logic;
signal inst6_tx_in_pct_rdreq        : std_logic;
signal inst6_tx_in_pct_reset_n_req  : std_logic;
signal inst6_wfm_in_pct_reset_n_req : std_logic;
signal inst6_wfm_in_pct_rdreq       : std_logic;
signal inst6_wfm_phy_clk            : std_logic;




begin

-- ----------------------------------------------------------------------------
-- Reset logic
-- ----------------------------------------------------------------------------  
   -- Reset from FPGA pin. 
   reset_n <= not HW_VER(3);
   
   -- Reset signal with synchronous removal to FTDI_PCLK clock domain, 
   sync_reg0 : entity work.sync_reg 
   port map(FT_CLK, reset_n, '1', reset_n_ft_clk);
   
   sync_reg1 : entity work.sync_reg 
   port map(LMK_CLK, reset_n, '1', reset_n_lmk_clk);   

-- ----------------------------------------------------------------------------
-- NIOS CPU instance.
-- CPU is responsible for communication interfaces and control logic
-- ----------------------------------------------------------------------------   
   inst0_nios_cpu : entity work.nios_cpu
   generic map (
      FPGACFG_START_ADDR   => FPGACFG_START_ADDR,
      PLLCFG_START_ADDR    => PLLCFG_START_ADDR,
      TSTCFG_START_ADDR    => TSTCFG_START_ADDR,
      PERIPHCFG_START_ADDR => PERIPHCFG_START_ADDR
   )
   port map(
      clk                        => LMK_CLK,
      reset_n                    => reset_n_lmk_clk,
      -- Control data FIFO
      exfifo_if_d                => inst2_EP02_rdata,
      exfifo_if_rd               => inst0_exfifo_if_rd, 
      exfifo_if_rdempty          => inst2_EP02_rempty,
      exfifo_of_d                => inst0_exfifo_of_d, 
      exfifo_of_wr               => inst0_exfifo_of_wr, 
      exfifo_of_wrfull           => inst2_EP82_wfull,
      exfifo_of_rst              => inst0_exfifo_of_rst, 
      -- SPI 0 
      spi_0_MISO                 => FPGA_SPI_MISO,
      spi_0_MOSI                 => inst0_spi_0_MOSI,
      spi_0_SCLK                 => inst0_spi_0_SCLK,
      spi_0_SS_n                 => inst0_spi_0_SS_n,
      -- SPI 1
      spi_1_MISO                 => FPGA_QSPI_IO1,
      spi_1_MOSI                 => inst0_spi_1_MOSI,
      spi_1_SCLK                 => inst0_spi_1_SCLK,
      spi_1_SS_n                 => inst0_spi_1_SS_n,
      -- I2C
      i2c_scl                    => FPGA_I2C_SCL,
      i2c_sda                    => FPGA_I2C_SDA,
      -- Genral purpose I/O
      gpi                        => (others=>'0'),
      gpo                        => inst0_gpo, 
      -- LMS7002 control 
      lms_ctr_gpio               => inst0_lms_ctr_gpio,
      -- Configuration registers
      from_fpgacfg               => inst0_from_fpgacfg,
      to_fpgacfg                 => inst0_to_fpgacfg,
      from_pllcfg                => inst0_from_pllcfg,
      to_pllcfg                  => inst0_to_pllcfg,
      from_tstcfg                => inst0_from_tstcfg,
      to_tstcfg                  => inst0_to_tstcfg,
      to_tstcfg_from_rxtx        => inst6_to_tstcfg_from_rxtx,
      from_periphcfg             => inst0_from_periphcfg,
      to_periphcfg               => inst0_to_periphcfg
   );
   
   inst0_to_fpgacfg.HW_VER    <= HW_VER;
   inst0_to_fpgacfg.BOM_VER   <= '0' & BOM_VER; 
   inst0_to_fpgacfg.PWR_SRC   <= '0';
   
-- ----------------------------------------------------------------------------
-- pll_top instance.
-- Clock source for LMS7002 RX and TX logic
-- ----------------------------------------------------------------------------   
   inst1_pll_top : entity work.pll_top
   generic map(
      N_PLL                   => 1,
      -- PLL parameters       
      BANDWIDTH_TYPE          => "AUTO",
      CLK0_DIVIDE_BY          => 1,
      CLK0_DUTY_CYCLE         => 50,
      CLK0_MULTIPLY_BY        => 1,
      CLK0_PHASE_SHIFT        => "0",
      CLK1_DIVIDE_BY          => 1,
      CLK1_DUTY_CYCLE         => 50,
      CLK1_MULTIPLY_BY        => 1,
      CLK1_PHASE_SHIFT        => "0",
      CLK2_DIVIDE_BY          => 1,
      CLK2_DUTY_CYCLE         => 50,
      CLK2_MULTIPLY_BY        => 1,
      CLK2_PHASE_SHIFT        => "0",
      CLK3_DIVIDE_BY          => 1,
      CLK3_DUTY_CYCLE         => 50,
      CLK3_MULTIPLY_BY        => 1,
      CLK3_PHASE_SHIFT        => "0",
      COMPENSATE_CLOCK        => "CLK3",
      INCLK0_INPUT_FREQUENCY  => 6250,
      INTENDED_DEVICE_FAMILY  => "MAX 10",
      OPERATION_MODE          => "NORMAL",
      SCAN_CHAIN_MIF_FILE     => "ip/pll/pll.mif",
      DRCT_C0_NDLY            => 1,
      DRCT_C1_NDLY            => 8,
      DRCT_C2_NDLY            => 1,
      DRCT_C3_NDLY            => 8
   )
   port map(
      -- PLL ports
      pll_inclk            => LMS_MCLK2,
      pll_reconfig_clk     => LMK_CLK,
      pll_logic_reset_n    => reset_n,
      pll_clk_ena          => inst0_from_fpgacfg.CLK_ENA(3 downto 0),
      pll_drct_clk_en      => inst0_from_fpgacfg.drct_clk_en(0) & inst0_from_fpgacfg.drct_clk_en(0) & inst0_from_fpgacfg.drct_clk_en(0) & inst0_from_fpgacfg.drct_clk_en(0),
      pll_c0               => LMS_FCLK1,
      pll_c1               => inst1_pll_c1,
      pll_c2               => LMS_FCLK2,
      pll_c3               => inst1_pll_c3,
      pll_locked           => inst1_pll_locked,
      pll_smpl_cmp_en      => inst1_pll_smpl_cmp_en,      
      pll_smpl_cmp_done    => inst6_rx_smpl_cmp_done,
      pll_smpl_cmp_error   => inst6_rx_smpl_cmp_err,
      pll_smpl_cmp_cnt     => inst1_pll_smpl_cmp_cnt,       
      -- pllcfg ports
      from_pllcfg          => inst0_from_pllcfg,
      to_pllcfg            => inst0_to_pllcfg
   );
   
-- ----------------------------------------------------------------------------
-- FT601_top instance.
-- USB3 interface 
-- ----------------------------------------------------------------------------
   inst2_FT601_top : entity work.FT601_top
   generic map(
      FT_data_width        => FTDI_DQ_WIDTH,
      FT_be_width          => FTDI_DQ_WIDTH/8,
      EP02_rdusedw_width   => C_EP02_RDUSEDW_WIDTH, 
      EP02_rwidth          => CTRL0_FPGA_RX_RWIDTH,
      EP82_wrusedw_width   => C_EP82_WRUSEDW_WIDTH,
      EP82_wwidth          => CTRL0_FPGA_TX_WWIDTH,
      EP82_wsize           => 64,  --packet size in bytes, has to be multiple of 4 bytes
      EP03_rdusedw_width   => C_EP03_RDUSEDW_WIDTH,    
      EP03_rwidth          => STRM0_FPGA_RX_RWIDTH,
      EP83_wrusedw_width   => C_EP83_WRUSEDW_WIDTH,
      EP83_wwidth          => STRM0_FPGA_TX_WWIDTH,
      EP83_wsize           => 2048 --packet size in bytes, has to be multiple of 4 bytes	
   )
   port map(
      --input ports 
      clk            => FT_CLK,   --FTDI CLK
      reset_n        => reset_n,
      --FTDI external ports
      FT_wr_n        => FT_WRn,
      FT_rxf_n       => FT_RXFn,
      FT_data        => FT_D,
      FT_be          => FT_BE,
      FT_txe_n       => FT_TXEn,
      --controll endpoint fifo PC->FPGA 
      EP02_rdclk     => LMK_CLK, 
      EP02_rd        => inst0_exfifo_if_rd,
      EP02_rdata     => inst2_EP02_rdata,
      EP02_rempty    => inst2_EP02_rempty,
      --controll endpoint fifo FPGA->PC
      EP82_wclk      => LMK_CLK,
      EP82_aclrn     => not inst0_exfifo_of_rst,
      EP82_wr        => inst0_exfifo_of_wr,
      EP82_wdata     => inst0_exfifo_of_d,
      EP82_wfull     => inst2_EP82_wfull,
      --stream endpoint fifo PC->FPGA
      EP03_aclrn     => inst0_from_fpgacfg.rx_en,
      EP03_rdclk     => inst1_pll_c1,
      EP03_rd        => inst6_tx_in_pct_rdreq,
      EP03_rdata     => inst2_EP03_rdata,
      EP03_rempty    => inst2_EP03_rempty,
      EP03_rusedw    => inst2_EP03_rdusedw,
      --stream endpoint fifo FPGA->PC
      EP83_wclk      => inst1_pll_c3, 
      EP83_aclrn     => inst6_rx_pct_fifo_aclrn_req,
      EP83_wr        => inst6_rx_pct_fifo_wrreq,
      EP83_wdata     => inst6_rx_pct_fifo_wdata,
      EP83_wfull     => inst2_EP83_wfull,
      EP83_wrusedw   => inst2_EP83_wrusedw
   );

-- ----------------------------------------------------------------------------
-- tst_top instance.
-- Clock test logic
-- ----------------------------------------------------------------------------
   inst3_tst_top : entity work.tst_top
   port map(
      --input ports 
      FX3_clk           => FT_CLK,
      reset_n           => reset_n_ft_clk,    
      Si5351C_clk_0     => '0',
      Si5351C_clk_1     => '0',
      Si5351C_clk_2     => '0',
      Si5351C_clk_3     => '0',
      Si5351C_clk_5     => '0',
      Si5351C_clk_6     => '0',
      Si5351C_clk_7     => '0',
      LMK_CLK           => LMK_CLK,
      ADF_MUXOUT        => '0',    
   
      -- To configuration memory
      to_tstcfg         => inst0_to_tstcfg,
      from_tstcfg       => inst0_from_tstcfg
   );
   
-- ----------------------------------------------------------------------------
-- general_periph_top instance.
-- Control module for external periphery
-- ----------------------------------------------------------------------------
   inst4_general_periph_top : entity work.general_periph_top
   generic map(
      DEV_FAMILY  => DEV_FAMILY,
      N_GPIO      => C_INST4_GPIO_N
   )
   port map(
      -- General ports
      clk                  => FT_CLK,
      reset_n              => reset_n_ft_clk,
      -- configuration memory
      to_periphcfg         => inst0_to_periphcfg,
      from_periphcfg       => inst0_from_periphcfg,     
      -- Dual colour LEDs
      -- LED1 (Clock and PLL lock status)
      led1_pll1_locked     => inst1_pll_locked,
      led1_pll2_locked     => inst1_pll_locked,
      led1_ctrl            => inst0_from_fpgacfg.FPGA_LED1_CTRL,
      led1_g               => FPGA_LED_G,
      led1_r               => FPGA_LED_R,      
      --LED2 (TCXO control status)
      led2_clk             => '0',
      led2_adf_muxout      => '0',
      led2_dac_ss          => '0',
      led2_adf_ss          => '0',
      led2_ctrl            => inst0_from_fpgacfg.FPGA_LED2_CTRL,
      led2_g               => open,
      led2_r               => open,     
      --LED3 (FX3 and NIOS CPU busy)
      led3_g_in            => '0',
      led3_r_in            => '0',
      led3_ctrl            => inst0_from_fpgacfg.FX3_LED_CTRL,
      led3_hw_ver          => HW_VER,
      led3_g               => open,
      led3_r               => open,     
      --GPIO
      gpio_dir             => (others=>'1'),
      gpio_out_val         => "000000000" & inst1_pll_locked,
      gpio_rd_val          => open,
      gpio(7 downto 0)     => FPGA_GPIO,
      gpio(9 downto 8)     => FPGA_EGPIO,
      --Fan control
      fan_sens_in          => LM75_OS,
      fan_ctrl_out         => FAN_CTRL
   );
   
   -- ----------------------------------------------------------------------------
-- rxtx_top instance.
-- Receive and transmit interface for LMS7002
-- ----------------------------------------------------------------------------
   inst6_rxtx_top : entity work.rxtx_top
   generic map(
      DEV_FAMILY              => DEV_FAMILY,
      -- TX parameters
      TX_IQ_WIDTH             => LMS_DIQ_WIDTH,
      TX_N_BUFF               => TX_N_BUFF,              -- 2,4 valid values
      TX_IN_PCT_SIZE          => TX_PCT_SIZE,
      TX_IN_PCT_HDR_SIZE      => TX_IN_PCT_HDR_SIZE,
      TX_IN_PCT_DATA_W        => STRM0_FPGA_RX_RWIDTH,      -- 
      TX_IN_PCT_RDUSEDW_W     => C_EP03_RDUSEDW_WIDTH,
      
      -- RX parameters
      RX_IQ_WIDTH             => LMS_DIQ_WIDTH,
      RX_INVERT_INPUT_CLOCKS  => "ON",
      RX_PCT_BUFF_WRUSEDW_W   => C_EP83_WRUSEDW_WIDTH --bus width in bits 
      
   )
   port map(                                             
      from_fpgacfg            => inst0_from_fpgacfg,
      to_tstcfg_from_rxtx     => inst6_to_tstcfg_from_rxtx,
      from_tstcfg             => inst0_from_tstcfg,
      
      -- TX module signals
      tx_clk                  => inst1_pll_c1,
      tx_clk_reset_n          => inst1_pll_locked,     
      tx_pct_loss_flg         => inst6_tx_pct_loss_flg,
      tx_txant_en             => inst6_tx_txant_en,  
      --Tx interface data 
      tx_DIQ                  => LMS_DIQ1_D,
      tx_fsync                => LMS_ENABLE_IQSEL1,
      --fifo ports
      tx_in_pct_rdreq         => inst6_tx_in_pct_rdreq,
      tx_in_pct_data          => inst2_EP03_rdata,
      tx_in_pct_rdempty       => inst2_EP03_rempty,
      tx_in_pct_rdusedw       => inst2_EP03_rdusedw,
      
      -- RX path
      rx_clk                  => inst1_pll_c3,
      rx_clk_reset_n          => inst1_pll_locked,
      --Rx interface data 
      rx_DIQ                  => LMS_DIQ2_D,
      rx_fsync                => LMS_ENABLE_IQSEL2,
      --Packet fifo ports
      rx_pct_fifo_aclrn_req   => inst6_rx_pct_fifo_aclrn_req,
      rx_pct_fifo_wusedw      => inst2_EP83_wrusedw,
      rx_pct_fifo_wrreq       => inst6_rx_pct_fifo_wrreq,
      rx_pct_fifo_wdata       => inst6_rx_pct_fifo_wdata,
      --sample compare
      rx_smpl_cmp_start       => inst1_pll_smpl_cmp_en,
      rx_smpl_cmp_length      => inst1_pll_smpl_cmp_cnt,
      rx_smpl_cmp_done        => inst6_rx_smpl_cmp_done,
      rx_smpl_cmp_err         => inst6_rx_smpl_cmp_err     
   );
   
-- ----------------------------------------------------------------------------
-- Output ports
-- ----------------------------------------------------------------------------

   FPGA_SPI_MOSI     <= inst0_spi_0_MOSI;
   FPGA_SPI_SCLK     <= inst0_spi_0_SCLK;
   FPGA_SPI_LMS_SS   <= inst0_spi_0_SS_n(0);
   FPGA_SPI_DAC_SS   <= inst0_spi_0_SS_n(2);
   
   FPGA_QSPI_SCLK    <= inst0_spi_1_SCLK;
   FPGA_QSPI_IO0     <= inst0_spi_1_MOSI;
   FPGA_QSPI_IO2     <= '1';
   FPGA_QSPI_IO3     <= '1';
   FPGA_QSPI_FLASH_SS<= inst0_spi_1_SS_n(0);
   
   LMS_RESET         <= inst0_from_fpgacfg.LMS1_RESET AND inst0_lms_ctr_gpio(0);
   LMS_TXEN          <= inst0_from_fpgacfg.LMS1_TXEN;
   LMS_RXEN          <= inst0_from_fpgacfg.LMS1_RXEN;
   LMS_CORE_LDO_EN   <= inst0_from_fpgacfg.LMS1_CORE_LDO_EN;
   LMS_TXNRX1        <= inst0_from_fpgacfg.LMS1_TXNRX1;
   LMS_TXNRX2        <= inst0_from_fpgacfg.LMS1_TXNRX2;
   
--   FPGA_GPIO         <= inst4_gpio(7 downto 0);
--   FPGA_EGPIO        <= inst4_gpio(9 downto 8);
   
   
   
   
   RFSW_RX_V1        <= inst0_from_fpgacfg.GPIO(8);
   RFSW_RX_V2        <= inst0_from_fpgacfg.GPIO(9);
   RFSW_TX_V1        <= inst0_from_fpgacfg.GPIO(12);
   RFSW_TX_V2        <= inst0_from_fpgacfg.GPIO(13);
   TX_LB_AT          <= inst0_from_fpgacfg.GPIO(1);
   TX_LB_SH          <= inst0_from_fpgacfg.GPIO(2);
   


end arch;   



