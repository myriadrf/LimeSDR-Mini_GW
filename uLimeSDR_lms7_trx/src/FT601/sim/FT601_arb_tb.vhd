-- ----------------------------------------------------------------------------	
-- FILE: FT601_arb_tb.vhd
-- DESCRIPTION:   
-- DATE: Feb 13, 2014
-- AUTHOR(s):  Lime Microsystems
-- REVISIONS:
-- ----------------------------------------------------------------------------	
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ----------------------------------------------------------------------------
-- Entity declaration
-- ----------------------------------------------------------------------------
entity FT601_arb_tb is
end FT601_arb_tb;

-- ----------------------------------------------------------------------------
-- Architecture
-- ----------------------------------------------------------------------------

architecture tb_behave of FT601_arb_tb is
   constant clk0_period             : time := 10 ns;
   constant clk1_period             : time := 10 ns; 
   --signals
   signal clk0,clk1                 : std_logic;
   signal reset_n                   : std_logic; 
   
   --inst0
   signal inst0_EP02_fifo_wrempty   : std_logic;
   signal inst0_EP82_fifo_rdusedw   : std_logic_vector(9 downto 0);
   signal inst0_EP03_fifo_wrempty   : std_logic;
   signal inst0_EP83_fifo_rdusedw   : std_logic_vector(9 downto 0);
   signal inst0_fsm_rdy             : std_logic;
   signal inst0_ep_status           : std_logic_vector(7 downto 0);
   
   
begin 
  
      clock0: process is
   begin
      clk0 <= '0'; wait for clk0_period/2;
      clk0 <= '1'; wait for clk0_period/2;
   end process clock0;

      clock: process is
   begin
      clk1 <= '0'; wait for clk1_period/2;
      clk1 <= '1'; wait for clk1_period/2;
   end process clock;
   
      res: process is
   begin
      reset_n <= '0'; wait for 20 ns;
      reset_n <= '1'; wait;
   end process res;
   
   
FT601_arb_inst0 : entity work.FT601_arb
   generic map(
         EP82_fifo_rwidth  => 10,
         EP82_wsize        => 64,   --packet size in bytes, has to be multiple of 4 bytes
         EP83_fifo_rwidth  => 10,
         EP83_wsize        => 2048  --packet size in bytes, has to be multiple of 4 bytes
   )
  port map(
         --input ports 
         clk               => clk0,
         reset_n           => reset_n,
         enable            => '1',
         --control EP PC->FPGA
         EP02_fifo_data    => open,
         EP02_fifo_wr      => open,
         EP02_fifo_wrempty => inst0_EP02_fifo_wrempty,
         --control EP FPGA->PC
         EP82_fifo_data    => (others=> '0'),
         EP82_fifo_rd      => open,
         EP82_fifo_rdusedw => inst0_EP82_fifo_rdusedw,
         --stream EP PC->FPGA
         EP03_fifo_data    => open,
         EP03_fifo_wr      => open,
         EP03_fifo_wrempty => inst0_EP03_fifo_wrempty,
         --stream EP FPGA->PC
         EP83_fifo_data    => (others=> '0'),
         EP83_fifo_rd      => open,
         EP83_fifo_rdusedw => inst0_EP83_fifo_rdusedw,
         --fsm controll signals
         fsm_epgo          => open, 
         fsm_rdwr          => open,       -- 0- MASTER RD (PC->FPGA), 1-MASTER WR (FPGA->PC)
         fsm_ch            => open,
         fsm_rdy           => inst0_fsm_rdy,
         fsm_rddata_valid  => '1',
         fsm_rddata        => (others=>'0'),
         fsm_wrdata_req    => '0',
         fsm_wrdata        => open,
         ep_status         => inst0_ep_status
        
        );
        
        inst0_EP02_fifo_wrempty <= '1';
        inst0_EP82_fifo_rdusedw <= (others=>'1');
        inst0_EP03_fifo_wrempty <= '1';
        inst0_EP83_fifo_rdusedw <= (others=>'1');
        
        inst0_fsm_rdy <= '1';
        
        inst0_ep_status <="11111110";
      
      

      
  

   end tb_behave;
  
  


  
