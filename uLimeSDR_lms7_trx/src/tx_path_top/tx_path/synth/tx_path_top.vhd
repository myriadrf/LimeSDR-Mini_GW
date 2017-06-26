-- ----------------------------------------------------------------------------	
-- FILE: 	tx_path_top.vhd
-- DESCRIPTION:	describe file
-- DATE:	March 27, 2017
-- AUTHOR(s):	Lime Microsystems
-- REVISIONS:
-- ----------------------------------------------------------------------------	
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ----------------------------------------------------------------------------
-- Entity declaration
-- ----------------------------------------------------------------------------
entity tx_path_top is
   generic( 
      dev_family		   : string := "Cyclone IV E";
      iq_width				: integer := 12;
      pct_size_w        : integer := 16;
      n_buff            : integer := 4; -- 2,4 valid values
      in_pct_data_w     : integer := 32;
      out_pct_data_w    : integer := 64;
      decomp_fifo_size  : integer := 9 -- 256 words
      );
   port (
      pct_wrclk         : in std_logic;
      iq_rdclk          : in std_logic;
      reset_n           : in std_logic;
      en                : in std_logic;
      
      rx_sample_clk     : in std_logic;
      rx_sample_nr      : in std_logic_vector(63 downto 0);
      
      pct_sync_dis      : in std_logic;
      pct_loss_flg      : out std_logic;
      pct_loss_flg_clr  : in std_logic;
      
      --Mode settings
      mode			      : in std_logic; -- JESD207: 1; TRXIQ: 0
		trxiqpulse	      : in std_logic; -- trxiqpulse on: 1; trxiqpulse off: 0
		ddr_en 		      : in std_logic; -- DDR: 1; SDR: 0
		mimo_en		      : in std_logic; -- SISO: 1; MIMO: 0
		ch_en			      : in std_logic_vector(1 downto 0); --"11" - Ch. A, "10" - Ch. B, "11" - Ch. A and Ch. B. 
		fidm			      : in std_logic; -- External Frame ID mode. Frame start at fsync = 0, when 0. Frame start at fsync = 1, when 1.
      sample_width      : in std_logic_vector(1 downto 0); --"10"-12bit, "01"-14bit, "00"-16bit;
      --Tx interface data 
      DIQ		 	      : out std_logic_vector(iq_width-1 downto 0);
		fsync	 	         : out std_logic;
      DIQ_h             : out std_logic_vector(iq_width downto 0);
      DIQ_l             : out std_logic_vector(iq_width downto 0);
      --fifo ports 
      in_pct_wrreq      : in std_logic;
      in_pct_data       : in std_logic_vector(in_pct_data_w-1 downto 0);
      in_pct_full       : out std_logic
        );
end tx_path_top;

-- ----------------------------------------------------------------------------
-- Architecture
-- ----------------------------------------------------------------------------
architecture arch of tx_path_top is
--declare signals,  components here

signal rx_sample_nr_iq_rdclk        : std_logic_vector(63 downto 0);
signal en_sync_rx_sample_clk        : std_logic;
signal en_sync_iq_rdclk             : std_logic;
signal pct_loss_flg_clr_sync_iq_rdclk : std_logic;

signal mode_sync_iq_rdclk           : std_logic;
signal trxiqpulse_sync_iq_rdclk     : std_logic; 
signal ddr_en_sync_iq_rdclk         : std_logic;
signal mimo_en_sync_iq_rdclk        : std_logic;
signal fidm_sync_iq_rdclk           : std_logic;
signal ch_en_sync_iq_rdclk          : std_logic_vector(1 downto 0);
signal sample_width_sync_iq_rdclk   : std_logic_vector(1 downto 0);

--inst0
signal inst0_smpl_buff_rdempty      : std_logic;
signal inst0_smpl_buff_q            : std_logic_vector(out_pct_data_w-1 downto 0);
signal inst0_pct_size               : std_logic_vector(pct_size_w-1 downto 0);
signal inst0_in_pct_clr_flag        : std_logic;

--inst1
signal inst1_fifo_rdreq             : std_logic;
signal inst1_fifo_q                 : std_logic_vector(iq_width*4-1 downto 0);

signal pct_loss_flg_int             : std_logic;






begin

--Synchronization registers for asynchronous input ports
sync_reg0 : entity work.sync_reg 
port map(rx_sample_clk, '1', en, en_sync_rx_sample_clk);

sync_reg1 : entity work.sync_reg 
port map(iq_rdclk, '1', en, en_sync_iq_rdclk);

sync_reg2 : entity work.sync_reg 
 port map(iq_rdclk, '1', mode, mode_sync_iq_rdclk);

sync_reg3 : entity work.sync_reg 
 port map(iq_rdclk, '1', trxiqpulse, trxiqpulse_sync_iq_rdclk);
 
sync_reg4 : entity work.sync_reg 
 port map(iq_rdclk, '1', ddr_en, ddr_en_sync_iq_rdclk);
 
sync_reg5 : entity work.sync_reg 
 port map(iq_rdclk, '1', mimo_en, mimo_en_sync_iq_rdclk);
 
sync_reg6 : entity work.sync_reg 
 port map(iq_rdclk, '1', fidm, fidm_sync_iq_rdclk);

sync_reg7 : entity work.sync_reg 
 port map(iq_rdclk, '1', pct_loss_flg_clr, pct_loss_flg_clr_sync_iq_rdclk); 
 
 
bus_sync_reg0 : entity work.bus_sync_reg
 generic map (2) 
 port map(iq_rdclk, '1', ch_en, ch_en_sync_iq_rdclk);

bus_sync_reg1 : entity work.bus_sync_reg
 generic map (2) 
 port map(iq_rdclk, '1', sample_width, sample_width_sync_iq_rdclk); 
 
 


 
-- bus_sync_reg0 : entity work.bus_sync_reg
-- generic map (2)
-- port map(clk, '1', sample_width, sample_width_sync);


process(sample_width)
begin
      if sample_width = "01" then 
         inst0_pct_size <= x"0100";
      else 
         inst0_pct_size <= x"0400";
      end if;
end process;


process(iq_rdclk, reset_n)
begin
	if reset_n = '0' then 
		pct_loss_flg_int <= '0';
	elsif (iq_rdclk'event AND iq_rdclk='1') then
		if inst0_in_pct_clr_flag = '1' then 
			pct_loss_flg_int <= '1';
		elsif pct_loss_flg_clr_sync_iq_rdclk = '1' then 
			pct_loss_flg_int <= '0';
		else 
			pct_loss_flg_int <= pct_loss_flg_int;
		end if;
	end if;
end process;

pct_loss_flg<= pct_loss_flg_int;

-- ----------------------------------------------------------------------------
-- To synchronize rx_sample_nr to iq_rdclk clock domain
-- ----------------------------------------------------------------------------
sync_fifo_rw_inst : entity work.sync_fifo_rw
  generic map( dev_family	=> dev_family,
			  data_w 		=> 64
  )
  port map(
        --input ports 
        wclk         => rx_sample_clk,      
        rclk         => iq_rdclk,
        reset_n      => reset_n,
        sync_en      => en_sync_rx_sample_clk,
        sync_data    => rx_sample_nr,
        sync_q       => rx_sample_nr_iq_rdclk
        );


-- ----------------------------------------------------------------------------
-- packets2data_top instance
-- ----------------------------------------------------------------------------
  packets2data_top_inst0 : entity work.packets2data_top
   generic map (
      dev_family        => dev_family,
      pct_size_w        => pct_size_w,
      n_buff            => n_buff, -- 2,4 valid values
      in_pct_data_w     => in_pct_data_w,
      out_pct_data_w    => out_pct_data_w
   )
   port map(

      wclk              => pct_wrclk,
      rclk              => iq_rdclk, 
      reset_n           => reset_n,
      
      mode              => mode_sync_iq_rdclk, 
      trxiqpulse        => trxiqpulse_sync_iq_rdclk,	
      ddr_en 		      => ddr_en_sync_iq_rdclk,
      mimo_en		      => mimo_en_sync_iq_rdclk,	
      ch_en			      => ch_en_sync_iq_rdclk,
      sample_width      => sample_width_sync_iq_rdclk,
      
      pct_size          => inst0_pct_size,
      
      pct_sync_dis      => pct_sync_dis,
      sample_nr         => rx_sample_nr_iq_rdclk,
      
      in_pct_wrreq      => in_pct_wrreq,
      in_pct_data       => in_pct_data,
      in_pct_last       => open,
      in_pct_full       => in_pct_full,
      in_pct_clr_flag   => inst0_in_pct_clr_flag,
      
      smpl_buff_rdempty => inst0_smpl_buff_rdempty,
      smpl_buff_q       => inst0_smpl_buff_q,    
      smpl_buff_rdreq   => inst1_fifo_rdreq
        );
        
               
-- ----------------------------------------------------------------------------
-- fifo2diq instance
-- ----------------------------------------------------------------------------       
inst1_fifo_q <=   inst0_smpl_buff_q(63 downto 64-iq_width) & 
                  inst0_smpl_buff_q(47 downto 48-iq_width) &
                  inst0_smpl_buff_q(31 downto 32-iq_width) & 
                  inst0_smpl_buff_q(15 downto 16-iq_width);

diq2fifo_inst1 : entity work.fifo2diq
	generic map( 
      dev_family     => dev_family,
      iq_width	      => iq_width
	)
	port map (
      clk            => iq_rdclk,
      reset_n        => en_sync_iq_rdclk,
      mode			   => mode_sync_iq_rdclk,
		trxiqpulse	   => trxiqpulse_sync_iq_rdclk,
		ddr_en 		   => ddr_en_sync_iq_rdclk,
		mimo_en		   => mimo_en_sync_iq_rdclk,
		ch_en			   => ch_en_sync_iq_rdclk,
		fidm			   => fidm_sync_iq_rdclk,
      DIQ		 	   => DIQ,
		fsync	 	      => fsync,
      DIQ_h          => DIQ_h,
      DIQ_l          => DIQ_l,
      fifo_rdempty   => inst0_smpl_buff_rdempty,
      fifo_rdreq     => inst1_fifo_rdreq,
      fifo_q         => inst1_fifo_q 
     
        );
end arch;   





