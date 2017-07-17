-- ----------------------------------------------------------------------------	
-- FILE: 	FT601_top_tb.vhd
-- DESCRIPTION:	
-- DATE:	Feb 13, 2014
-- AUTHOR(s):	Lime Microsystems
-- REVISIONS:
-- ----------------------------------------------------------------------------	
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ----------------------------------------------------------------------------
-- Entity declaration
-- ----------------------------------------------------------------------------
entity FT601_top_tb is
end FT601_top_tb;

-- ----------------------------------------------------------------------------
-- Architecture
-- ----------------------------------------------------------------------------

architecture tb_behave of FT601_top_tb is
   constant clk0_period       : time := 10 ns;
   constant clk1_period       : time := 10 ns; 
   --signals
   signal clk0,clk1		      : std_logic;
   signal reset_n             : std_logic; 
   
   --inst0
   signal inst0_FT_wr_n       : std_logic;
   signal inst0_FT_rxf_n      : std_logic; 
   signal inst0_FT_data       : std_logic_vector(31 downto 0);
   signal inst0_FT_be         : std_logic_vector(3 downto 0);
   signal inst0_FT_txe_n      : std_logic; 
   
   
   signal inst0_EP02_rd       : std_logic; 
signal inst0_EP02_rdata       : std_logic_vector(31 downto 0);
   signal inst0_EP02_rempty   : std_logic; 
   
   
   signal inst0_EP82_wr       : std_logic; 
   signal inst0_EP82_wdata    : std_logic_vector(31 downto 0);
   signal inst0_EP82_wfull    : std_logic; 
   
   -- signal inst0_EP03_rd       : std_logic; 
   -- signal inst0_EP03_rdata    : std_logic_vector(31 downto 0);
   -- signal inst0_EP03_rempty   : std_logic; 
   signal inst0_ext_buff_rdy  : std_logic; 
   signal inst0_ext_buff_data : std_logic_vector(31 downto 0);
   signal inst0_ext_buff_wr   : std_logic; 
   signal inst0_EP83_wr       : std_logic; 
   signal inst0_EP83_wdata    : std_logic_vector(63 downto 0); 
   signal inst0_EP83_wfull    : std_logic; 
   signal inst0_EP83_wrusedw  : std_logic_vector(11 downto 0);     
   
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
   
   
FT601_top_inst0 :   entity work.FT601_top
   generic map(
         EP02_rdusedw_width	=> 9,
         EP02_rwidth				=> 32,
         EP82_wrusedw_width	=> 9,
         EP82_wwidth				=> 32,
         EP82_wsize  			=> 64, --packet size in bytes, has to be multiple of 4 bytes				
         EP03_rwidth				=> 32,
         EP83_wwidth				=> 64,
         EP83_wsize  			=> 2048 --packet size in bytes, has to be multiple of 4 bytes	
   )
   port map(
         --input ports 
         clk         	=> clk0,			--FTDI CLK
         reset_n   		=> reset_n,
         --FTDI external ports
         FT_wr_n			=> inst0_FT_wr_n,
         FT_rxf_n			=> inst0_FT_rxf_n,
         FT_data			=> inst0_FT_data, 
         FT_be				=> inst0_FT_be,
         FT_txe_n			=> inst0_FT_txe_n,
         --controll endpoint fifo PC->FPGA 
         EP02_rdclk		=> clk1,
         EP02_rd			=> inst0_EP02_rd,
         EP02_rdata		=> inst0_EP02_rdata ,
         EP02_rempty		=> inst0_EP02_rempty,
         --controll endpoint fifo FPGA->PC
         EP82_wclk		=> clk1,
         EP82_aclrn		=> reset_n,
         EP82_wr			=> inst0_EP82_wr ,
         EP82_wdata		=> inst0_EP82_wdata ,
         EP82_wfull		=> inst0_EP82_wfull ,
         --stream endpoint fifo PC->FPGA
         -- EP03_rdclk		=> clk1,
         -- EP03_rd			=> inst0_EP03_rd ,
         -- EP03_rdata		=> inst0_EP03_rdata ,
         -- EP03_rempty		=> inst0_EP03_rempty ,
         ext_buff_rdy	=> inst0_ext_buff_rdy ,
         ext_buff_data	=> inst0_ext_buff_data ,
         ext_buff_wr		=> inst0_ext_buff_wr ,
         --stream endpoint fifo FPGA->PC
         EP83_wclk		=> clk1,
         EP83_aclrn		=> reset_n,
         EP83_wr			=> inst0_EP83_wr ,
         EP83_wdata		=> inst0_EP83_wdata ,
         EP83_wfull		=> inst0_EP83_wfull ,
         EP83_wrusedw	=> inst0_EP83_wrusedw      
      );
      
-- ----------------------------------------------------------------------------
-- EP02
-- ----------------------------------------------------------------------------  
process(clk1, reset_n)
begin
   if reset_n = '0' then 
      inst0_EP02_rd <= '0';
   elsif (clk1'event AND clk1='1') then 
      inst0_EP02_rd <= not inst0_EP02_rempty;    
   end if;
end process; 


-- ----------------------------------------------------------------------------
-- EP03
-- ----------------------------------------------------------------------------  
inst0_ext_buff_rdy <= '1';

-- ----------------------------------------------------------------------------
-- EP82
-- ----------------------------------------------------------------------------  
process(clk1, reset_n)
begin
   if reset_n = '0' then 
      inst0_EP82_wr <= '0';
      inst0_EP82_wdata <= (others=> '0');
   elsif (clk1'event AND clk1='1') then 
      inst0_EP82_wr <= not inst0_EP82_wfull;
      if inst0_EP82_wr = '1' then 
         inst0_EP82_wdata <= std_logic_vector(unsigned(inst0_EP82_wdata)+1);
      else 
         inst0_EP82_wdata <= inst0_EP82_wdata;
      end if;
   end if;
end process;  


-- ----------------------------------------------------------------------------
-- EP83
-- ----------------------------------------------------------------------------  
process(clk1, reset_n)
begin
   if reset_n = '0' then 
      inst0_EP83_wr <= '0';
      inst0_EP83_wdata <= (others=> '0');
   elsif (clk1'event AND clk1='1') then 
      inst0_EP83_wr <= not inst0_EP83_wfull;
      if inst0_EP83_wr = '1' then 
         inst0_EP83_wdata <= std_logic_vector(unsigned(inst0_EP83_wdata)+1);
      else 
         inst0_EP83_wdata <= inst0_EP83_wdata;
      end if;
   end if;
end process;
      
      
      
      inst0_FT_data(15 downto 8) <= "11101111";
      
      
  process is
	begin
		inst0_FT_rxf_n <= '1';
      wait until falling_edge(inst0_FT_wr_n); --wait for FT "Command phase"
         if inst0_FT_be = "0000" then
            wait until rising_edge(clk0);
            wait until rising_edge(clk0);
         else
            wait until rising_edge(clk0);
         end if;
      inst0_FT_rxf_n <= '0'; wait for 640 ns;     
      wait until rising_edge(clk0);
      inst0_FT_rxf_n <= '1';
	end process;
      
  
	
	end tb_behave;
  
  


  
