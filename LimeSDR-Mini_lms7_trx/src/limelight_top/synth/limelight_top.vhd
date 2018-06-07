-- ----------------------------------------------------------------------------	
-- FILE: limelight_top.vhd
-- DESCRIPTION: top wrapper file for LMS7002 Limeligth RX and TX interface
-- DATE: May 11, 2017
-- AUTHOR(s): Lime Microsystems
-- REVISIONS:
-- ----------------------------------------------------------------------------	
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ----------------------------------------------------------------------------
-- Entity declaration
-- ----------------------------------------------------------------------------
entity limelight_top is
   generic(
      dev_family              : string := "Cyclone V";
      rx_ddio_clkinv          : string := "ON";            
      rx_diq_width            : integer := 12; -- Physical RX IO interface width
      rx_smpl_buff_rdusedw_w  : integer := 11; -- RX buffer size for samples before packets 
      rx_pct_fifo_wrusedw_w   : integer := 12; -- RX packet FIFO buffer wrusedw size
      
      tx_diq_width            : integer := 12; -- Physical TX IO interface width
      tx_pct_size_w           : integer := 16;
      tx_n_buff               : integer := 4; -- 2,4 valid values
      tx_in_pct_data_w        : integer := 32;
      tx_out_pct_data_w       : integer := 64;
      tx_decomp_fifo_size     : integer := 9 -- 256 words
      
      
   );
   port (      
      --LimeLight interface settings
      lml_smpl_width          : in std_logic_vector(1 downto 0); --"10"-12bit, "01"-14bit, "00"-16bit;
      lml_mode                : in std_logic; -- JESD207: 1; TRXIQ: 0
      lml_trxiqpulse          : in std_logic; -- trxiqpulse on: 1; trxiqpulse off: 0
      lml_ddr_en              : in std_logic; -- DDR: 1; SDR: 0
      lml_mimo_en             : in std_logic; -- SISO: 0; MIMO: 1
      lml_ch_en               : in std_logic_vector(1 downto 0); --"11" - Ch. A, "10" - Ch. B, "11" - Ch. A and Ch. B.
      lml_fidm                : in std_logic; -- 0 - Frame start at fsync = 0. 1- Frame start at fsync = 1.
      
      --RX interface (RF2BB, -> FPGA receive)
      rx_clk                  : in std_logic;
      rx_io_reset_n           : in std_logic;   
      rx_logic_reset_n        : in std_logic;
      rx_tst_ptrn_en          : in std_logic;
      rx_smpl_src_sel         : in std_logic;
      
      rx_smpl_fifo_wrreq      : in std_logic;
      rx_smpl_fifo_data       : in std_logic_vector(rx_diq_width*4-1 downto 0);
      rx_smpl_fifo_wfull      : out std_logic;
      rx_smpl_fifo_wrreq_out  : out std_logic;
      
      rx_diq                  : in std_logic_vector(rx_diq_width-1 downto 0);
      rx_diq_fsync            : in std_logic;
      rx_diq_h                : out std_logic_vector(rx_diq_width downto 0);
      rx_diq_l                : out std_logic_vector(rx_diq_width downto 0);
      rx_smpl_nr_clr          : in std_logic;
      rx_smpl_nr_ld           : in std_logic;
      rx_smpl_nr_in           : in std_logic_vector(63 downto 0);
      rx_smpl_nr_out          : out std_logic_vector(63 downto 0);
      rx_pct_loss_flg_clr     : in std_logic;
      rx_pct_fifo_wrusedw     : in std_logic_vector(rx_pct_fifo_wrusedw_w-1 downto 0);
      rx_pct_fifo_wrreq       : out std_logic;
      rx_pct_fifo_wdata       : out std_logic_vector(63 downto 0);
      
      
      --TX interface (BB2RF, FPGA transmit)      
      tx_clk                  : in std_logic;
      tx_pct_wclk             : in std_logic;
      tx_io_reset_n           : in std_logic;
      tx_logic_reset_n        : in std_logic;
      tx_sync_dis             : in std_logic;
      tx_pct_wrreq            : in std_logic;
      tx_pct_full             : out std_logic;
      tx_pct_data             : in std_logic_vector(31 downto 0);
      tx_diq                  : out std_logic_vector(tx_diq_width-1 downto 0);
      tx_diq_fsync            : out std_logic;     
      tx_diq_h                : out std_logic_vector(tx_diq_width downto 0);
      tx_diq_l                : out std_logic_vector(tx_diq_width downto 0);

      --sample compare
      smpl_cmp_start       : in std_logic;
      smpl_cmp_length      : in std_logic_vector(15 downto 0);
      smpl_cmp_done        : out std_logic;
      smpl_cmp_err         : out std_logic      
      
      


        );
end limelight_top;

-- ----------------------------------------------------------------------------
-- Architecture
-- ----------------------------------------------------------------------------
architecture arch of limelight_top is
--declare signals,  components here
--inst0
signal inst0_DIQ_h         : std_logic_vector (rx_diq_width downto 0); 
signal inst0_DIQ_l         : std_logic_vector (rx_diq_width downto 0);
signal inst0_smpl_nr_cnt   : std_logic_vector(63 downto 0);
signal inst0_pct_fifo_wrreq: std_logic;
signal inst0_pct_fifo_wdata: std_logic_vector(63 downto 0);
signal inst0_pct_hdr_cap   : std_logic;


--isnt1
signal inst1_pct_loss_flg  : std_logic;
signal inst1_DIQ           : std_logic_vector(tx_diq_width-1 downto 0);
signal inst1_fsync         : std_logic;
signal inst1_DIQ_h         : std_logic_vector(tx_diq_width downto 0);
signal inst1_DIQ_l         : std_logic_vector(tx_diq_width downto 0);
signal inst1_in_pct_full   : std_logic;


  
begin
   
-- ----------------------------------------------------------------------------
-- RX instance
-- ----------------------------------------------------------------------------   
   rx_path_top_inst0 : entity work.rx_path_top
   generic map( 
      dev_family           => dev_family,
      iq_width             => rx_diq_width,
      invert_input_clocks  => rx_ddio_clkinv,
      smpl_buff_rdusedw_w  => rx_smpl_buff_rdusedw_w,
      pct_buff_wrusedw_w   => rx_pct_fifo_wrusedw_w
      )
   port map(
      clk                  => rx_clk,
      reset_n              => rx_logic_reset_n,
      io_reset_n           => rx_io_reset_n,
      test_ptrn_en         => rx_tst_ptrn_en,
      smpl_src_sel         => rx_smpl_src_sel,
      --Mode settings (lml_ signals are synced to rx_clk inside this module)     
      sample_width         => lml_smpl_width,
      mode                 => lml_mode,
      trxiqpulse           => lml_trxiqpulse,
      ddr_en               => lml_ddr_en,
      mimo_en              => lml_mimo_en,
      ch_en                => lml_ch_en,
      fidm                 => lml_fidm,
      
      smpl_fifo_wrreq      => rx_smpl_fifo_wrreq,
      smpl_fifo_data       => rx_smpl_fifo_data,
      smpl_fifo_wfull      => rx_smpl_fifo_wfull,
      smpl_fifo_wrreq_out  => rx_smpl_fifo_wrreq_out,
      
      --Rx interface data 
      DIQ                  => rx_diq,
      fsync                => rx_diq_fsync,
      DIQ_h                => inst0_DIQ_h,
      DIQ_l                => inst0_DIQ_l,
      --samples            
      smpl_fifo_wrreq_out  => open,
      --Packet fifo ports  
      pct_fifo_wusedw      => rx_pct_fifo_wrusedw,
      pct_fifo_wrreq       => inst0_pct_fifo_wrreq,
      pct_fifo_wdata       => inst0_pct_fifo_wdata,
      pct_hdr_cap          => inst0_pct_hdr_cap,
      --sample nr          
      clr_smpl_nr          => rx_smpl_nr_clr,
      ld_smpl_nr           => rx_smpl_nr_ld,
      smpl_nr_in           => rx_smpl_nr_in,
      smpl_nr_cnt          => inst0_smpl_nr_cnt,
      --flag control       
      tx_pct_loss          => inst1_pct_loss_flg,
      tx_pct_loss_clr      => rx_pct_loss_flg_clr,
      --sample compare
      smpl_cmp_start       => smpl_cmp_start,
      smpl_cmp_length      => smpl_cmp_length,
      smpl_cmp_done        => smpl_cmp_done,
      smpl_cmp_err         => smpl_cmp_err
     
        );
        
        
        
tx_path_top_inst1 : entity work.tx_path_top
   generic map( 
      dev_family        => dev_family,
      iq_width          => tx_diq_width,
      pct_size_w        => tx_pct_size_w,
      n_buff            => tx_n_buff,
      in_pct_data_w     => tx_in_pct_data_w,
      out_pct_data_w    => tx_out_pct_data_w,
      decomp_fifo_size  => tx_decomp_fifo_size
      )
   port map(
      pct_wrclk         => tx_pct_wclk,
      iq_rdclk          => tx_clk,
      reset_n           => tx_logic_reset_n,
      en                => tx_logic_reset_n,
      
      rx_sample_clk     => rx_clk,
      rx_sample_nr      => inst0_smpl_nr_cnt,
      
      pct_sync_dis      => tx_sync_dis,
      pct_loss_flg      => inst1_pct_loss_flg,
      pct_loss_flg_clr  => inst0_pct_hdr_cap,
      
      --Mode settings
      mode              => lml_mode,
      trxiqpulse        => lml_trxiqpulse,
      ddr_en            => lml_ddr_en,
      mimo_en           => lml_mimo_en,
      ch_en             => lml_ch_en,
      fidm              => lml_fidm,
      sample_width      => lml_smpl_width,
      --Tx interface data 
      DIQ               => inst1_DIQ,
      fsync             => inst1_fsync,
      DIQ_h             => inst1_DIQ_h,
      DIQ_l             => inst1_DIQ_l,
      --fifo ports 
      in_pct_wrreq      => tx_pct_wrreq,
      in_pct_data       => tx_pct_data,
      in_pct_full       => inst1_in_pct_full
        );

-- ----------------------------------------------------------------------------
-- Output ports
-- ----------------------------------------------------------------------------
rx_diq_h          <= inst0_DIQ_h;
rx_diq_l          <= inst0_DIQ_l;
rx_pct_fifo_wrreq <= inst0_pct_fifo_wrreq;
rx_pct_fifo_wdata <= inst0_pct_fifo_wdata;
rx_smpl_nr_out    <= inst0_smpl_nr_cnt;

tx_diq            <= inst1_DIQ;      
tx_diq_fsync      <= inst1_fsync;
tx_diq_h          <= inst1_DIQ_h;
tx_diq_l          <= inst1_DIQ_l;
tx_pct_full       <= inst1_in_pct_full;

  
end arch;   


