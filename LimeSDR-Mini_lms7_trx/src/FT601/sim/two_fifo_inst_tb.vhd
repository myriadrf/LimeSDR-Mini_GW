-- ----------------------------------------------------------------------------
-- FILE:          two_fifo_inst_tb.vhd
-- DESCRIPTION:   
-- DATE:          Feb 13, 2014
-- AUTHOR(s):     Lime Microsystems
-- REVISIONS:
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- NOTES:
-- ----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ----------------------------------------------------------------------------
-- Entity declaration
-- ----------------------------------------------------------------------------
entity two_fifo_inst_tb is
end two_fifo_inst_tb;

-- ----------------------------------------------------------------------------
-- Architecture
-- ----------------------------------------------------------------------------

architecture tb_behave of two_fifo_inst_tb is
   constant clk0_period    : time := 10 ns;
   constant clk1_period    : time := 2.1 ns; 
   --signals
   signal clk0,clk1        : std_logic;
   signal reset_n          : std_logic;
   
   constant C_PKT_SIZE     : integer := 32;      -- Packet size in bytes
   
   constant C_DUT0_DEV_FAMILY       : string := "MAX 10";
   constant C_DUT0_WRWIDTH          : integer := 32;
   constant C_DUT0_WRUSEDW_WITDTH   : integer := 10;  
   constant C_DUT0_RDWIDTH          : integer := 128;
   constant C_DUT0_RDUSEDW_WIDTH    : integer := 9;    
   constant C_DUT0_SHOW_AHEAD       : string := "OFF";
   constant C_DUT0_TRNSF_N          : integer := 4;
   constant C_DUT0_TRNSF_SIZE       : integer := C_PKT_SIZE/C_DUT0_TRNSF_N;

   
   signal dut0_reset_0_n            : std_logic;
   signal dut0_reset_1_n            : std_logic;
   signal dut0_wrreq                : std_logic;
   signal dut0_data                 : std_logic_vector(C_DUT0_WRWIDTH-1 downto 0);
   signal dut0_wrfull               : std_logic;
   signal dut0_wrempty              : std_logic;
   signal dut0_wrusedw              : std_logic_vector(C_DUT0_WRUSEDW_WITDTH-1 downto 0);
   signal dut0_rdreq                : std_logic;
   signal dut0_q                    : std_logic_vector(C_DUT0_RDWIDTH-1 downto 0);
   signal dut0_rdempty              : std_logic;
   signal dut0_rdusedw              : std_logic_vector(C_DUT0_RDUSEDW_WIDTH-1 downto 0);
   
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
   
   
   dut0_reset_0_n <= reset_n;
   
   -- FIFO write process
   process is
   begin
      dut0_wrreq <= '0'; wait until rising_edge(clk0) AND dut0_reset_0_n = '1' AND dut0_wrempty = '1';
      for i in 0 to C_PKT_SIZE*8/C_DUT0_WRWIDTH/2 - 1 loop 
         dut0_wrreq <= '1'; wait until rising_edge(clk0);
      end loop;
      
      dut0_wrreq <= '0'; wait until rising_edge(clk0) AND dut0_wrempty = '1';
      
      for i in 0 to C_PKT_SIZE*8/C_DUT0_WRWIDTH/4 - 1 loop 
         dut0_wrreq <= '1'; wait until rising_edge(clk0);
      end loop;
      
   end process;
   
   process(clk0, dut0_reset_0_n)
   begin
      if dut0_reset_0_n = '0' then 
         dut0_data <= (others=>'0');
      elsif (clk0'event AND clk0='1') then 
         if dut0_wrreq = '1' then
            if unsigned(dut0_data) < C_PKT_SIZE*8/C_DUT0_WRWIDTH -1 then 
               dut0_data <= std_logic_vector(unsigned(dut0_data) + 1);
            else 
               dut0_data <= (others=>'0');
            end if;
         else 
            dut0_data <= dut0_data;
         end if;
      end if;
   end process;
   
   process is
   begin
      dut0_reset_1_n <= '1';
      dut0_rdreq <= '0'; wait until rising_edge(clk1) AND unsigned(dut0_rdusedw) >=C_PKT_SIZE*8/C_DUT0_RDWIDTH;
      for i in 0 to C_PKT_SIZE*8/C_DUT0_RDWIDTH - 1 loop 
         dut0_rdreq <= '1'; wait until rising_edge(clk1);
      end loop;  
      
      dut0_rdreq <= '0'; wait until rising_edge(clk1) AND unsigned(dut0_rdusedw) >=C_PKT_SIZE*8/C_DUT0_RDWIDTH;
      for i in 0 to C_PKT_SIZE*8/C_DUT0_RDWIDTH - 1 loop 
         dut0_rdreq <= '1'; wait until rising_edge(clk1);
      end loop;
      
      dut0_rdreq <= '0'; wait until rising_edge(clk1) AND unsigned(dut0_rdusedw) >=C_PKT_SIZE*8/C_DUT0_RDWIDTH;
      dut0_reset_1_n <= '0';wait until rising_edge(clk1);
      
   end process;
   

      -- design under test   
   two_fifo_inst_dut0 : entity work.two_fifo_inst
   generic map(
      DEV_FAMILY     => C_DUT0_DEV_FAMILY,
      WRWIDTH        => C_DUT0_WRWIDTH,
      WRUSEDW_WITDTH => C_DUT0_WRUSEDW_WITDTH,  -- wrwords = 2^(WRUSEDW_WITDTH-1)
      RDWIDTH        => C_DUT0_RDWIDTH,
      RDUSEDW_WIDTH  => C_DUT0_RDUSEDW_WIDTH,   -- rdwords = 2^(RDUSEDW_WIDTH-1)
      SHOW_AHEAD     => C_DUT0_SHOW_AHEAD,
      TRNSF_SIZE     => C_DUT0_TRNSF_SIZE,      -- First to second FIFO transfer size in bytes
      TRNSF_N        => C_DUT0_TRNSF_N          -- N transfer cycles    
   )
   port map(
      reset_0_n     => dut0_reset_0_n,
      reset_1_n     => dut0_reset_1_n,
      wrclk         => clk0,
      wrreq         => dut0_wrreq,
      data          => dut0_data,
      wrfull        => dut0_wrfull,
      wrempty		  => dut0_wrempty,
      wrusedw       => dut0_wrusedw,
      rdclk 	     => clk1,
      rdreq         => dut0_rdreq,
      q             => dut0_q,
      rdempty       => dut0_rdempty,
      rdusedw       => dut0_rdusedw 
   );

end tb_behave;

