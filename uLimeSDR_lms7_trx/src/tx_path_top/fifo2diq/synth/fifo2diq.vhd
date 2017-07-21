-- ----------------------------------------------------------------------------	
-- FILE: 	fifo2diq.vhd
-- DESCRIPTION:	Writes DIQ data to FIFO, FIFO word size = 4  DIQ samples 
-- DATE:	Jan 13, 2016
-- AUTHOR(s):	Lime Microsystems
-- REVISIONS:
-- ----------------------------------------------------------------------------	
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ----------------------------------------------------------------------------
-- Entity declaration
-- ----------------------------------------------------------------------------
entity fifo2diq is
   generic( 
      dev_family				: string := "Cyclone IV E";
      iq_width					: integer := 12
      );
   port (
      clk         : in std_logic;
      reset_n     : in std_logic;
      --Mode settings
      mode			: in std_logic; -- JESD207: 1; TRXIQ: 0
		trxiqpulse	: in std_logic; -- trxiqpulse on: 1; trxiqpulse off: 0
		ddr_en 		: in std_logic; -- DDR: 1; SDR: 0
		mimo_en		: in std_logic; -- SISO: 1; MIMO: 0
		ch_en			: in std_logic_vector(1 downto 0); --"11" - Ch. A, "10" - Ch. B, "11" - Ch. A and Ch. B. 
		fidm			: in std_logic; -- External Frame ID mode. Frame start at fsync = 0, when 0. Frame start at fsync = 1, when 1.
      --Tx interface data 
      DIQ		 	: out std_logic_vector(iq_width-1 downto 0);
		fsync	 	   : out std_logic;
      DIQ_h       : out std_logic_vector(iq_width downto 0);
      DIQ_l       : out std_logic_vector(iq_width downto 0);
      --fifo ports 
      fifo_rdempty: in std_logic;
      fifo_rdreq  : out std_logic;
      fifo_q      : in std_logic_vector(iq_width*4-1 downto 0) 

        );
end fifo2diq;

-- ----------------------------------------------------------------------------
-- Architecture
-- ----------------------------------------------------------------------------
architecture arch of fifo2diq is
--declare signals,  components here
signal inst0_DIQ_h : std_logic_vector (iq_width downto 0); 
signal inst0_DIQ_l : std_logic_vector (iq_width downto 0); 
  
begin


        
--inst0_lms7002_dout : entity work.lms7002_ddout
--   generic map( 
--      dev_family	=> dev_family,
--      iq_width		=> iq_width
--	)
--	port map(
--      clk       	=> clk,
--      reset_n   	=> reset_n,
--		data_in_h	=> inst0_DIQ_h,
--		data_in_l	=> inst0_DIQ_l,
--		txiq		 	=> DIQ,
--		txiqsel	 	=> fsync
--      );

DIQ <= (others=>'0');
fsync <= '0';
        
        
 inst1_txiq : entity work.txiq
	generic map( 
      dev_family	   => dev_family,
      iq_width			=> iq_width
	)
	port map (
      clk            => clk,
      reset_n        => reset_n,
      trxiqpulse     => trxiqpulse,
		ddr_en 		   => ddr_en,
		mimo_en		   => mimo_en,
		ch_en			   => ch_en, 
		fidm			   => fidm,
      DIQ_h		 	   => inst0_DIQ_h,
		DIQ_l          => inst0_DIQ_l,
      fifo_rdempty   => fifo_rdempty,
      fifo_rdreq     => fifo_rdreq,
      fifo_q         => fifo_q
        );
        
DIQ_h <= inst0_DIQ_h;
DIQ_l <= inst0_DIQ_l;

  
end arch;