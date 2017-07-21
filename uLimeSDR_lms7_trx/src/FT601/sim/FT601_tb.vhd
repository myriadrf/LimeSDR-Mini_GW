-- ----------------------------------------------------------------------------	
-- FILE: FT601_tb.vhd
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
entity FT601_tb is
end FT601_tb;

-- ----------------------------------------------------------------------------
-- Architecture
-- ----------------------------------------------------------------------------

architecture tb_behave of FT601_tb is
   constant control_endpoint_size     : integer := 64;
   constant stream_endpoint_size      : integer := 1024;
   
   
   constant clk0_period             : time := 10 ns;
   constant clk1_period             : time := 10 ns; 
   --signals
   signal clk0,clk1                 : std_logic;
   signal reset_n                   : std_logic;
   
   signal tb_master_rd_cmd          : std_logic;   
   type EP_type is (control_endpoint, stream_endpoint);
   signal selected_EP: EP_type;
   
   --inst0

signal inst0_trnsf_en      : std_logic;
signal inst0_ready         : std_logic;
signal inst0_rd_wr         : std_logic;
signal inst0_ch_n          : std_logic_vector(3 downto 0);
signal inst0_wr_n          : std_logic;
signal inst0_rxf_n         : std_logic;
signal inst0_data          : std_logic_vector(31 downto 0);
signal inst0_be            : std_logic_vector(3 downto 0);
signal inst0_txe_n         : std_logic;
signal WR_data             : std_logic_vector(31 downto 0);
signal inst0_WR_data_req   : std_logic;
   
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
   
   
FT601_inst0 : entity work.FT601
  generic map(
			EP82_wsize     => control_endpoint_size,      --packet size in bytes, has to be multiple of 4 bytes
			EP83_wsize     => stream_endpoint_size       --packet size in bytes, has to be multiple of 4 bytes
			)
  port map(
        --input ports 
			clk            => clk0,
			reset_n        => reset_n,
			trnsf_en       => inst0_trnsf_en,
			ready          => inst0_ready,
			rd_wr          => inst0_rd_wr,      -- 0- MASTER RD (PC->FPGA), 1-MASTER WR (FPGA->PC)
			ch_n           => inst0_ch_n,
         RD_data_valid  => open,
			RD_data        => open,
         WR_data_req    => inst0_WR_data_req,
			WR_data        => WR_data,  
			wr_n           => inst0_wr_n,
			rxf_n          => inst0_rxf_n,
			data           => open,
			be             => inst0_be,
			txe_n          => inst0_txe_n
        );
        
        
proc_name : process(clk0, reset_n)
begin
   if reset_n = '0' then 
      WR_data <= (others => '0');
   elsif (clk0'event AND clk0='1') then 
      if inst0_WR_data_req = '1' then 
         WR_data <= std_logic_vector(unsigned(WR_data)+1);
      else 
         WR_data <= WR_data;
      end if;
   end if;
end process;
        
        
        
        
        
-- ----------------------------------------------------------------------------
-- Begin transfer process
-- ----------------------------------------------------------------------------        
      process is
      begin
         --Master read, channel 1 
         selected_EP <= control_endpoint;         
            inst0_trnsf_en <= '0';
         wait until reset_n = '1'; 
         wait until rising_edge(clk0);
            inst0_rd_wr <= '0';
            inst0_ch_n  <= "0001";
         wait until rising_edge(clk0);
            inst0_trnsf_en <= '1';
         wait until inst0_ready = '0';
         wait until rising_edge(clk0);
            inst0_trnsf_en <= '0';
         wait until inst0_ready = '1';
         
         --Master read, channel 2
         selected_EP <= stream_endpoint; 
         wait until rising_edge(clk0);
            inst0_rd_wr <= '0';
            inst0_ch_n  <= "0010";
         wait until rising_edge(clk0);
            inst0_trnsf_en <= '1';
         wait until inst0_ready = '0';
         wait until rising_edge(clk0);
            inst0_trnsf_en <= '0';
         wait until inst0_ready = '1';
         
         --Master write, channel 1 
         wait until rising_edge(clk0);
            inst0_rd_wr <= '1';
            inst0_ch_n  <= "0001";
         wait until rising_edge(clk0);
            inst0_trnsf_en <= '1';
         wait until inst0_ready = '0';
         wait until rising_edge(clk0);
            inst0_trnsf_en <= '0';
         wait until inst0_ready = '1';
         
          --Master write, channel 2
         selected_EP <= stream_endpoint;         
         wait until rising_edge(clk0);
            inst0_rd_wr <= '1';
            inst0_ch_n  <= "0010";
         wait until rising_edge(clk0);
            inst0_trnsf_en <= '1';
         wait until inst0_ready = '0';
         wait until rising_edge(clk0);
            inst0_trnsf_en <= '0';
         wait until inst0_ready = '1';
         
         
         wait;
      end process;
      
      
-- ----------------------------------------------------------------------------
-- FT601 slave rxf_n receive acknowledge signal model process
-- ----------------------------------------------------------------------------
      process is
      begin
         inst0_rxf_n <= '1';
         wait until falling_edge(inst0_wr_n); --wait command phase
            if inst0_be = "0000" then 
               --master read bus turn around
               tb_master_rd_cmd <= '1';
               wait until rising_edge(clk0);
               wait until rising_edge(clk0);
               wait until rising_edge(clk0);
            else 
               --master write bus turn around
               tb_master_rd_cmd <= '0';
               wait until rising_edge(clk0);
               wait until rising_edge(clk0);
            end if;
         inst0_rxf_n <= '0';
         
         if tb_master_rd_cmd = '1' then
            if selected_EP = control_endpoint then 
               --slave asserts rxf_n = '1' when read data is exhausted in control endpoint
               for i in 0 to control_endpoint_size-1 loop
                  wait until rising_edge(clk0);
               end loop;
            else
               --slave asserts rxf_n = '1' when read data is exhausted in stream endpoint
               for i in 0 to stream_endpoint_size-1 loop
                  wait until rising_edge(clk0);
               end loop;
            end if;
         else 
            --in this case master write full sized packets and terminates write command
            wait until rising_edge(inst0_wr_n);
            wait until rising_edge(clk0);
         end if;
      end process;
      
      
      
     
   end tb_behave;
  
  


  
