-- ----------------------------------------------------------------------------	
-- FILE: 	p2d_wr_fsm_tb.vhd
-- DESCRIPTION:	
-- DATE:	March 31, 2017
-- AUTHOR(s):	Lime Microsystems
-- REVISIONS:
-- ----------------------------------------------------------------------------	
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ----------------------------------------------------------------------------
-- Entity declaration
-- ----------------------------------------------------------------------------
entity p2d_wr_fsm_tb is
end p2d_wr_fsm_tb;

-- ----------------------------------------------------------------------------
-- Architecture
-- ----------------------------------------------------------------------------

architecture tb_behave of p2d_wr_fsm_tb is
constant clk0_period   : time := 10 ns;
constant clk1_period   : time := 10 ns; 
   --signals
signal clk0,clk1		: std_logic;
signal reset_n       : std_logic; 
   
   --dut0 signals
signal dut0_pct_size          : std_logic_vector(15 downto 0):=x"0008";
signal dut0_pct_hdr_0         : std_logic_vector(63 downto 0);
signal dut0_pct_hdr_1         : std_logic_vector(63 downto 0);
signal dut0_pct_data          : std_logic_vector(31 downto 0);
signal dut0_in_pct_wrfull     : std_logic;
signal dut0_pct_data_wrreq_delay : std_logic;
signal dut0_pct_state         : std_logic_vector(1 downto 0);
signal pct_cnt                : unsigned(31 downto 0);
signal dut0_pct_data_wrreq       : std_logic_vector(3 downto 0);
signal dut0_pct_data_wrreq_reg   : std_logic_vector(3 downto 0);
signal dut0_pct_buff_rdy      : std_logic_vector(3 downto 0);
signal dut0_in_pct_wrreq      : std_logic;

signal shift_reg              : std_logic_vector(4 downto 0);
signal shift_en               : std_logic;
  

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
   
   
   process is
	begin
      dut0_in_pct_wrreq <= '0';
      wait until reset_n = '1';
      wait until rising_edge(clk0);
      
      --write one full packet
      dut0_in_pct_wrreq <= '1';
      for i in 0 to to_integer(unsigned(dut0_pct_size)-1) loop
         wait until rising_edge(clk0);
      end loop;
      dut0_in_pct_wrreq <= '0';
      wait until rising_edge(clk0) AND dut0_in_pct_wrfull = '0';
            
      --write one half of packet
      dut0_in_pct_wrreq <= '1';
      for i in 0 to to_integer(unsigned(dut0_pct_size)-1)/2 loop
         wait until rising_edge(clk0);
      end loop;
      dut0_in_pct_wrreq <= '0';
      wait until rising_edge(clk0) AND dut0_in_pct_wrfull = '0';
      
      --write one half of packet
      dut0_in_pct_wrreq <= '1';
      for i in 0 to to_integer(unsigned(dut0_pct_size)-1)/2 loop
         wait until rising_edge(clk0);
      end loop;
      dut0_in_pct_wrreq <= '0';
      wait until rising_edge(clk0) AND dut0_in_pct_wrfull = '0';
      
      --write one full packet
      dut0_in_pct_wrreq <= '1';
      for i in 0 to to_integer(unsigned(dut0_pct_size)-1) loop
         wait until rising_edge(clk0);
      end loop;
      dut0_in_pct_wrreq <= '0';
      wait until rising_edge(clk0) AND dut0_in_pct_wrfull = '0';
      
      --write one half of packet
      dut0_in_pct_wrreq <= '1';
      for i in 0 to to_integer(unsigned(dut0_pct_size)-1)/2 loop
         wait until rising_edge(clk0);
      end loop;
      dut0_in_pct_wrreq <= '0';
      wait until rising_edge(clk0) AND dut0_in_pct_wrfull = '0';
      
      --write one half of packet
      dut0_in_pct_wrreq <= '1';
      for i in 0 to to_integer(unsigned(dut0_pct_size)-1)/2 loop
         wait until rising_edge(clk0);
      end loop;
      dut0_in_pct_wrreq <= '0';
      wait until rising_edge(clk0) AND dut0_in_pct_wrfull = '0';
      
      --write one full packet
      dut0_in_pct_wrreq <= '1';
      for i in 0 to to_integer(unsigned(dut0_pct_size)-1) loop
         wait until rising_edge(clk0);
      end loop;
      dut0_in_pct_wrreq <= '0';
      wait until rising_edge(clk0) AND dut0_in_pct_wrfull = '0';
         
	end process;
   
     process(reset_n, clk0)
    begin
      if reset_n='0' then
         pct_cnt <= (others=>'0');       
      elsif (clk0'event and clk0 = '1') then
         if dut0_in_pct_wrreq = '1' then 
            pct_cnt <= pct_cnt + 1;
         else 
            pct_cnt <= pct_cnt;
         end if;
 	    end if;
    end process;
    
    dut0_pct_data  <= std_logic_vector(pct_cnt);
    
   process(clk0, reset_n)
   begin
      if reset_n = '0' then 
         shift_reg <="00001";
         dut0_pct_data_wrreq_reg <= (others=>'0');
      elsif (clk0'event AND clk0='1') then
         dut0_pct_data_wrreq_reg <= dut0_pct_data_wrreq;
      end if;
   end process;
   
   
   process is
	begin
		dut0_pct_buff_rdy <= (others=>'1');
      wait until unsigned(dut0_pct_data_wrreq) > 0 and unsigned(dut0_pct_data_wrreq_reg) = 0;
      wait until rising_edge(clk0);
		dut0_pct_buff_rdy <= "1110";
      wait until unsigned(dut0_pct_data_wrreq) > 0 and unsigned(dut0_pct_data_wrreq_reg) = 0;
      dut0_pct_buff_rdy <= "1100";
      wait until unsigned(dut0_pct_data_wrreq) > 0 and unsigned(dut0_pct_data_wrreq_reg) = 0;
      dut0_pct_buff_rdy <= "1000";
      wait until unsigned(dut0_pct_data_wrreq) > 0 and unsigned(dut0_pct_data_wrreq_reg) = 0;
      dut0_pct_buff_rdy <= "0000";
      wait for 80 ns;
      wait until rising_edge(clk0);
      dut0_pct_buff_rdy <= "0010";
      wait for 80 ns;
      wait until rising_edge(clk0);
      dut0_pct_buff_rdy <= "0000";
      wait for 80 ns;
      wait until rising_edge(clk0);
      dut0_pct_buff_rdy <= "0001";
      wait until unsigned(dut0_pct_data_wrreq) > 0 and unsigned(dut0_pct_data_wrreq_reg) = 0;
      dut0_pct_buff_rdy <= "0010";
      wait;
	end process ;
   

  
  p2d_wr_fsm_dut0 : entity work.p2d_wr_fsm
   generic map(
      pct_size_w        => 16,
      n_buff            => 4,
      in_pct_data_w     => 32
   )
   port map(
      clk               => clk0,
      reset_n           => reset_n,
      pct_size          => dut0_pct_size, 
      
      in_pct_wrreq      => dut0_in_pct_wrreq,
      in_pct_data       => dut0_pct_data,
      in_pct_wrfull     => dut0_in_pct_wrfull,

      pct_hdr_0         => open,
      pct_hdr_0_valid   => open,

      pct_hdr_1         => open,
      pct_hdr_1_valid   => open,
      
      pct_data          => open,
      pct_data_wrreq    => dut0_pct_data_wrreq,
      
      pct_buff_rdy      => dut0_pct_buff_rdy
      );
	
	end tb_behave;
  
  


  
