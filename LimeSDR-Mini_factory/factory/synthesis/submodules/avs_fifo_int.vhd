-- avs_fifo_int.vhd

-- This file was auto-generated as a prototype implementation of a module
-- created in component editor.  It ties off all outputs to ground and
-- ignores all inputs.  It needs to be edited to make it do something
-- useful.
-- 
-- This file will not be automatically regenerated.  You should check it in
-- to your version control system if you want to keep it.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity avs_fifo_int is
	port (
		avs_s0_address     : in  std_logic_vector(7 downto 0)  := (others => '0'); -- avs_s0.address
		avs_s0_read        : in  std_logic                     := '0';             --       .read
		avs_s0_readdata    : out std_logic_vector(31 downto 0);                    --       .readdata
		avs_s0_write       : in  std_logic                     := '0';             --       .write
		avs_s0_writedata   : in  std_logic_vector(31 downto 0) := (others => '0'); --       .writedata
		avs_s0_waitrequest : out std_logic;                                        --       .waitrequest
		clock_clk          : in  std_logic                     := '0';             --  clock.clk
		reset_reset        : in  std_logic                     := '0';             --  reset.reset
		of_d               : out std_logic_vector(31 downto 0);                    --    coe.of_d
		of_wr              : out std_logic;                                        --       .of_wr
		of_wrfull          : in  std_logic                     := '0';             --       .of_wrfull
		if_d               : in  std_logic_vector(31 downto 0) := (others => '0'); --       .if_d
		if_rd              : out std_logic;                                        --       .if_rd
		if_rdempty         : in  std_logic                     := '0';             --       .if_rdempty
		fifo_rst           : out std_logic                                         --       .fifo_rst
	);
end entity avs_fifo_int;

architecture rtl of avs_fifo_int is

	signal status_reg : std_logic_vector(31 downto 0);
	signal fiford, fiford_reg : std_logic;
	
begin

--	-- TODO: Auto-generated HDL template
--
--	avs_s0_readdata <= "00000000000000000000000000000000";
--
--	avs_s0_waitrequest <= '0';
--
--	if_rd <= '0';
--
--	fifo_rst <= '0';
--
--	of_d <= "00000000000000000000000000000000";
--
--	of_wr <= '0';
	
	
	
	
	
	avs_s0_waitrequest <= '0';
	
	
	
	-- Output FIFO
	of_d <= avs_s0_writedata;
	of_wr <= '1' when avs_s0_write = '1' and avs_s0_address = x"00" and of_wrfull = '0' else '0';
	
	-- Input FIFO
	fiford <= '1' when avs_s0_read = '1' and avs_s0_address = x"01" and if_rdempty = '0' else '0';

	-- Read detect register
	frd_proc: process(clock_clk, reset_reset)
	begin
		if reset_reset = '1' then
			fiford_reg <= '0';
		elsif rising_edge(clock_clk) then
			fiford_reg <= fiford;
		end if;
	end process frd_proc;
	if_rd <= '1' when fiford_reg = '0' and fiford = '1' else '0';
	
	-- Status register
	st_proc: process(clock_clk, reset_reset)
	begin
		if reset_reset = '1' then
			status_reg <= (others => '0');
		elsif rising_edge(clock_clk) then
			status_reg(1 downto 0) <= of_wrfull & if_rdempty;
		end if;
	end process st_proc;
	
	-- Control register
	ct_proc: process(clock_clk, reset_reset)
	begin
		if reset_reset = '1' then
			fifo_rst <= '0';
		elsif rising_edge(clock_clk) then
			if (avs_s0_write = '1') and (avs_s0_address = x"03") then
				fifo_rst <= avs_s0_writedata(0);
			end if;
		end if;
	end process ct_proc;	
	

	-- Avalon data output mux
	rd_proc: process(avs_s0_address, status_reg, if_d) 
	begin
		case avs_s0_address is
			when x"01" => avs_s0_readdata <= if_d;
			when x"02" => avs_s0_readdata <= status_reg;		-- Status register to the Avalon bus
			when x"05" => avs_s0_readdata <= x"000000A5";		-- Test register to the Avalon bus
			when others => avs_s0_readdata <= (others => '0');			
		end case;
	end process rd_proc;
	

end architecture rtl; -- of avs_fifo_int
