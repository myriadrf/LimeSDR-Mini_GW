-- ----------------------------------------------------------------------------	
-- FILE: 	FT601.vhd
-- DESCRIPTION:	FT601 fsm module
-- DATE:	May 11, 2016
-- AUTHOR(s):	Lime Microsystems
-- REVISIONS:
-- ----------------------------------------------------------------------------	
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ----------------------------------------------------------------------------
-- Entity declaration
-- ----------------------------------------------------------------------------
entity FT601 is
  generic(
			EP82_wsize	: integer := 64;		--packet size in bytes, has to be multiple of 4 bytes
			EP83_wsize  : integer := 2048 	--packet size in bytes, has to be multiple of 4 bytes
			);
  port (
        --input ports 
			clk			: in std_logic;
			reset_n		: in std_logic;
			trnsf_en    : in std_logic;
			ready			: out std_logic;
			rd_wr    	: in std_logic;		-- 0- MASTER RD (PC->FPGA), 1-MASTER WR (FPGA->PC)
			ch_n     	: in std_logic_vector(3 downto 0);
			valid_data 	: out std_logic;		-- 1- data is valid when MSRD and has to be valid when MSWR, 
														-- 0 - no incoming data and no data is required. 
			RD_data   	: out std_logic_vector(31 downto 0);
			WR_data  	: in std_logic_vector(31 downto 0);  
			wr_n			: out std_logic;
			rxf_n			: in std_logic;
			data			: inout std_logic_vector(31 downto 0);
			be				: inout std_logic_vector(3 downto 0);
			txe_n			: in std_logic
        );
end FT601;

-- ----------------------------------------------------------------------------
-- Architecture
-- ----------------------------------------------------------------------------
architecture arch of FT601 is
--declare signals,  components here


signal wr_en_sig    	: std_logic;

type state_type is (idle, cmd, master_rd, master_wr, command, rd_ch1, rd_ch2, bus_turn0, bus_turn1, data_trnsf);

signal current_state, next_state : state_type;

signal term_cnt	  	: unsigned(15 downto 0);

signal grant_int    	: std_logic;
signal rd_wr_int	  	: std_logic;

signal rd_wr_reg		: std_logic;
signal ch_n_reg		: std_logic_vector(3 downto 0);
signal trnsf_en_reg	: std_logic;
signal wr_n_sig   	: std_logic;

  
begin
  
 valid_data<=  not wr_n_sig and  not rxf_n;
 RD_data<=data;
 
-- ----------------------------------------------------------------------------
-- counter to determine when to stop transfer
-- ----------------------------------------------------------------------------
 process (reset_n, clk)
  	begin 
		if reset_n='0' then
		  term_cnt<=(others=>'0');
		elsif (clk'event and clk='1') then
		  if current_state=data_trnsf then 
				term_cnt<=term_cnt+1;
		  else 
				term_cnt<=(others=>'0');
      end if;
	  end if;
  end process;
 
 
-- ----------------------------------------------------------------------------
-- to latch values on enable signal
-- ----------------------------------------------------------------------------
process(reset_n, clk)
	begin 
		if reset_n='0' then 
			rd_wr_reg<='0';
			ch_n_reg<=(others=>'0');
			trnsf_en_reg<='0';
		elsif (clk'event and clk='1') then
			trnsf_en_reg<=trnsf_en;	
			if trnsf_en='1' then 
				rd_wr_reg<=rd_wr;
				ch_n_reg<=ch_n;
			else 
				rd_wr_reg<=rd_wr_reg;
				ch_n_reg<=ch_n_reg;
			end if;
		end if;
end process;
			
-- ----------------------------------------------------------------------------
-- fsm ready indication
-- ----------------------------------------------------------------------------
process(current_state) 
  begin 
    if current_state=idle then 
      ready<='1';
    else 
      ready<='0';
    end if;
end process;


-- ----------------------------------------------------------------------------
-- data bus control
-- ----------------------------------------------------------------------------
process (current_state, rd_wr_reg, ch_n_reg, WR_data)
  begin 
    case current_state is 
      when idle=>   
			data(31 downto 16)<=(others=>'1');
			data(15 downto 8)<=(others=>'Z');
			data(7 downto 0)<=(others=>'1');
			wr_n_sig<='1';
			be<=(others=>'1');
      when cmd =>
			data(31 downto 16)<=(others=>'1');
		   data(15 downto 8)<=(others=>'Z');
			data(7 downto 0)<="0000" & ch_n_reg; 
			wr_n_sig<='0';
			be<="000" & rd_wr_reg;
		when bus_turn1 => 
			if rd_wr_reg='1' then 
				data(31 downto 16)<=(others=>'1');
				data(15 downto 8)<=(others=>'Z');
				data(7 downto 0)<="0000" & ch_n_reg; 
				wr_n_sig<='0';
				be<="000" & rd_wr_reg;
			else 
				data(31 downto 16)<=(others=>'Z');
				data(15 downto 8)<=(others=>'Z');			
				data(7 downto 0)<=(others=>'Z');
				wr_n_sig<='0';
				be<=(others=>'Z');
			end if;
		when data_trnsf => 
				if rd_wr_reg='1' then 
				data<=WR_data;
				wr_n_sig<='0';
				be<=(others=>'1');
			else 
				data(31 downto 16)<=(others=>'Z');
				data(15 downto 8)<=(others=>'Z');			
				data(7 downto 0)<=(others=>'Z');
				wr_n_sig<='0';
				be<=(others=>'Z');
			end if;		
      when others=> 
			data(31 downto 16)<=(others=>'Z');
			data(15 downto 8)<=(others=>'Z');			
			data(7 downto 0)<=(others=>'Z');
			wr_n_sig<='0';
			be<=(others=>'Z');
    end case;
end process;

wr_n<=wr_n_sig;

-- ----------------------------------------------------------------------------
--state machine
-- ----------------------------------------------------------------------------
fsm_f : process(clk, reset_n)begin
	if(reset_n = '0')then
		current_state <= idle;
	elsif(clk'event and clk = '1')then 
		current_state <= next_state;
	end if;	
end process;

-- ----------------------------------------------------------------------------
--state machine combo
-- ----------------------------------------------------------------------------
fsm : process(current_state, trnsf_en_reg, rd_wr_reg, rxf_n, term_cnt, ch_n_reg) begin
	next_state <= current_state;
	case current_state is
	  
		when idle =>							--idle state 
		  if trnsf_en_reg='1' then  		-- if acces is granted go to read or write command
		      next_state<=cmd;      
		  else 
		    next_state<=idle;
		  end if;		
		  
		when cmd =>								-- command state, determine bus turn around length
		  if rd_wr_reg='0' then 
		     next_state<=bus_turn0;
		  else 
		    	next_state<=bus_turn1;
		  end if;
		  
		when bus_turn0 =>						-- bus turn around state
		    next_state<=bus_turn1;
			 
		when bus_turn1 =>						-- bus turn around state 
		    next_state<=data_trnsf;
			 
		when data_trnsf =>					-- data transfer state 
		    if rxf_n='1' or (term_cnt=EP82_wsize/4-1 AND rd_wr_reg='1' AND ch_n_reg=x"1") then 
		       next_state<=idle;
		    else 
		       next_state<=data_trnsf;
		    end if;	
			 
		when others => 
			next_state<=idle;
	end case;
end process;



  
end arch;





