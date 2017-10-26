-- ----------------------------------------------------------------------------	
-- FILE: 	FT601.vhd
-- DESCRIPTION:	FT601 fsm module
-- DATE:	May 11, 2016
-- AUTHOR(s):	Lime Microsystems
-- REVISIONS:
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- Notes: 
-- ----------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ----------------------------------------------------------------------------
-- Entity declaration
-- ----------------------------------------------------------------------------
entity FT601 is
  generic(
         FT_data_width  : integer := 32;     -- 32 and 16 valid option
         FT_be_width    : integer := 4;      -- 4 and 2 valid options
			EP82_wsize     : integer := 64;		-- packet size in bytes, has to be multiple of 4 bytes
			EP83_wsize     : integer := 2048 	-- packet size in bytes, has to be multiple of 4 bytes
			);
  port (
        --input ports 
			clk            : in std_logic;
			reset_n        : in std_logic;
			trnsf_en       : in std_logic;
			ready          : out std_logic;
			rd_wr          : in std_logic;		-- 0- MASTER RD (PC->FPGA), 1-MASTER WR (FPGA->PC)
			ch_n           : in std_logic_vector(3 downto 0);
         RD_data_valid  : out std_logic;
			RD_data        : out std_logic_vector(FT_data_width-1 downto 0);
         WR_data_req    : out std_logic;     
			WR_data        : in std_logic_vector(FT_data_width-1 downto 0); -- should be 2 cycle latency after WR_data_req 
			wr_n           : out std_logic;
			rxf_n          : in std_logic;
			data           : inout std_logic_vector(FT_data_width-1 downto 0);
			be             : inout std_logic_vector(FT_be_width-1 downto 0);
			txe_n          : in std_logic
        );
end FT601;

-- ----------------------------------------------------------------------------
-- Architecture
-- ----------------------------------------------------------------------------
architecture arch of FT601 is
--declare signals,  components here


signal wr_en_sig    	: std_logic;

type state_type is (idle, prep_cmd, cmd, master_rd, master_wr, command, rd_ch1, rd_ch2, bus_turn0, bus_turn1, bus_turn2,data_trnsf);

signal current_state, next_state : state_type;

signal term_cnt	  	      : unsigned(15 downto 0);
signal WR_data_req_cnt	  	: unsigned(15 downto 0);
signal WR_data_req_int     : std_logic;

signal grant_int    	      : std_logic;
signal rd_wr_int	  	      : std_logic;

signal rd_wr_reg		      : std_logic;
signal ch_n_reg		      : std_logic_vector(3 downto 0);
signal trnsf_en_reg	      : std_logic;
signal wr_n_sig   	      : std_logic;
signal RD_data_valid_int   : std_logic;
signal EP82_trnsf_end      : std_logic;
signal EP83_trnsf_end      : std_logic;

signal master_is_writting  : std_logic;


  
begin
   
 RD_data_valid_int   <= '1' when current_state = data_trnsf and rxf_n = '0' AND rd_wr_reg = '0' else '0';

 EP82_trnsf_end      <= '1' when (term_cnt=EP82_wsize/(FT_data_width/8)-2 AND rd_wr_reg='1' AND ch_n_reg=x"1") else '0';
 EP83_trnsf_end      <= '1' when (term_cnt=EP83_wsize/(FT_data_width/8)-2 AND rd_wr_reg='1' AND ch_n_reg=x"2") else '0'; 

 
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
  
  
  process (reset_n, clk)
  	begin 
		if reset_n='0' then
		  master_is_writting <= '0';
		elsif (clk'event and clk='1') then
         if current_state = prep_cmd AND rd_wr_reg = '1' then 
            master_is_writting <= '1';
         elsif current_state = idle then 
            master_is_writting <= '0';
         else 
				master_is_writting <= master_is_writting;
      end if;
	  end if;
  end process;
   
  
-- ----------------------------------------------------------------------------
-- counter to determine when to stop reading wr data buffer
-- ----------------------------------------------------------------------------
process (reset_n, clk)
  	begin 
		if reset_n='0' then
		  WR_data_req_cnt<=(others=>'0');
		elsif (clk'event and clk='1') then
		  if WR_data_req_int = '1' then 
				WR_data_req_cnt<=WR_data_req_cnt+1;
		  else 
				WR_data_req_cnt<=(others=>'0');
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
				rd_wr_reg   <= rd_wr;
				ch_n_reg    <= ch_n;
			else 
				rd_wr_reg   <= rd_wr_reg;
				ch_n_reg    <= ch_n_reg;
			end if;
		end if;
end process;
			
-- ----------------------------------------------------------------------------
-- fsm ready indication
-- ----------------------------------------------------------------------------
process(clk) 
	begin	
	if (clk'event AND clk = '1') then 
		if current_state=idle AND txe_n = '0' then 
			ready<='1';
		else 
			ready<='0';
		end if;
	end if;
end process;


-- ----------------------------------------------------------------------------
-- data bus control
-- ----------------------------------------------------------------------------
--generate FT bus controll signals when data bus is 32bit wide
gen_32_bus : if FT_data_width = 32 generate 
process (clk)
begin
   if (clk'event AND clk = '1') then 
      case current_state is 
         when idle=>   
            data(31 downto 16)<=(others=>'1');
            data(15 downto 8)<=(others=>'Z');
            data(7 downto 0)<=(others=>'1');
            wr_n_sig<='1';
            be<=(others=>'1');
            
         when prep_cmd =>
            data(31 downto 16)<=(others=>'1');
            data(15 downto 8)<=(others=>'Z');
            data(7 downto 0)<="0000" & ch_n_reg; 
            wr_n_sig<='0';
            be<="000" & rd_wr_reg;
            
         when cmd => 
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
            
         when bus_turn0 => 
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
            
         when bus_turn1 => 
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
            
         when data_trnsf => 
               if rd_wr_reg='1' then 
               data<=WR_data;
               if rxf_n = '0' then
                  wr_n_sig<='0';
               else 
                  wr_n_sig<='1';
               end if;
               be<=(others=>'1');
            else 
               data(31 downto 16)<=(others=>'Z');
               data(15 downto 8)<=(others=>'Z');			
               data(7 downto 0)<=(others=>'Z');
               if rxf_n = '0' then
                  wr_n_sig<='0';
               else 
                  wr_n_sig<='1';
               end if;
               be<=(others=>'Z');
            end if;	
            
         when others=> 
            data(31 downto 16)<=(others=>'Z');
            data(15 downto 8)<=(others=>'Z');			
            data(7 downto 0)<=(others=>'Z');
            wr_n_sig<='1';
            be<=(others=>'Z');
            
      end case;
    end if;
end process;
end generate;

--generate FT bus controll signals whe data bus is 16bit wide
gen_16_bus : if FT_data_width = 16 generate
  process (clk)
begin
   if (clk'event AND clk = '1') then 
      case current_state is 
         when idle=>   
            data(15 downto 8)<=(others=>'Z');
            data(7 downto 0)<=(others=>'1');
            wr_n_sig<='1';
            be<=(others=>'1');
            
         when prep_cmd =>
            data(15 downto 8)<=(others=>'Z');
            data(7 downto 0)<="0000" & ch_n_reg; 
            wr_n_sig<='0';
            be<='0' & rd_wr_reg;
            
         when cmd => 
            if rd_wr_reg='1' then 
               data(15 downto 8)<=(others=>'Z');
               data(7 downto 0)<="0000" & ch_n_reg; 
               wr_n_sig<='0';
               be<='0' & rd_wr_reg;
            else 
               data(15 downto 8)<=(others=>'Z');			
               data(7 downto 0)<=(others=>'Z');
               wr_n_sig<='0';
               be<=(others=>'Z');
            end if;
            
         when bus_turn0 => 
               if rd_wr_reg='1' then 
               data<=WR_data;
               wr_n_sig<='0';
               be<=(others=>'1');
            else 
               data(15 downto 8)<=(others=>'Z');			
               data(7 downto 0)<=(others=>'Z');
               wr_n_sig<='0';
               be<=(others=>'Z');
            end if;
            
         when bus_turn1 => 
               if rd_wr_reg='1' then 
               data<=WR_data;
               wr_n_sig<='0';
               be<=(others=>'1');
            else 
               data(15 downto 8)<=(others=>'Z');			
               data(7 downto 0)<=(others=>'Z');
               wr_n_sig<='0';
               be<=(others=>'Z');
            end if;
            
         when data_trnsf => 
               if rd_wr_reg='1' then 
               data<=WR_data;
               if rxf_n = '0' then
                  wr_n_sig<='0';
               else 
                  wr_n_sig<='1';
               end if;
               be<=(others=>'1');
            else 
               data(15 downto 8)<=(others=>'Z');			
               data(7 downto 0)<=(others=>'Z');
               if rxf_n = '0' then
                  wr_n_sig<='0';
               else 
                  wr_n_sig<='1';
               end if;
               be<=(others=>'Z');
            end if;	
            
         when others=> 
            data(15 downto 8)<=(others=>'Z');			
            data(7 downto 0)<=(others=>'Z');
            wr_n_sig<='1';
            be<=(others=>'Z');
            
      end case;
    end if;

end process;
end generate;

wr_n<=wr_n_sig;


-- ----------------------------------------------------------------------------
-- WR_data_req signal 
-- ----------------------------------------------------------------------------
process(clk, reset_n)
   begin
   if reset_n = '0' then 
      WR_data_req_int <= '0';
   elsif (clk'event AND clk = '1') then
      if master_is_writting = '1' AND current_state = cmd then 
         WR_data_req_int <= '1';
      elsif (EP82_trnsf_end = '1' OR EP83_trnsf_end = '1') OR (rxf_n = '1' AND current_state = data_trnsf) then 
         WR_data_req_int <= '0';        
      else
         WR_data_req_int <= WR_data_req_int;
      end if;
   end if;
end process;

WR_data_req <= WR_data_req_int;

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
fsm : process(current_state, trnsf_en_reg, rd_wr_reg, rxf_n, EP82_trnsf_end, EP83_trnsf_end) begin
   next_state <= current_state;
   case current_state is
   
      when idle =>							-- idle state 
         if trnsf_en_reg='1' then  		-- if access is granted go to read or write command
            next_state <= prep_cmd;      
         else 
            next_state <= idle;
         end if;
      when prep_cmd => 
         next_state <= cmd;
      
      when cmd =>								-- command state, determine bus turn around length
         if rd_wr_reg = '0' then 
            next_state <= bus_turn0;
         else 
            next_state <= bus_turn1;
         end if;
      
      when bus_turn0 =>						-- bus turn around state
         next_state <= bus_turn1;
         
      when bus_turn1 =>						-- bus turn around state 
         next_state <= data_trnsf;
         
      when data_trnsf =>					-- data transfer state 
         if rxf_n='1' or EP82_trnsf_end = '1' or EP83_trnsf_end = '1' then 
            next_state  <= idle;
         else 
            next_state  <= data_trnsf;
         end if;	
         
      when others => 
         next_state<=idle;
   end case;
end process;

-- ----------------------------------------------------------------------------
-- Output registers
-- ----------------------------------------------------------------------------
process(clk)
   begin 
      if (clk'event AND clk = '1') then 
         RD_data_valid  <= RD_data_valid_int;
         RD_data        <= data;
      end if;
end process;

  
end arch;





