-- ----------------------------------------------------------------------------	
-- FILE: 	FPGA_LED_ctrl.vhd
-- DESCRIPTION:	FPGA_LED control module
-- DATE:	March 17, 2017
-- AUTHOR(s):	Lime Microsystems
-- REVISIONS:
-- ----------------------------------------------------------------------------	
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

LIBRARY altera; 
USE altera.altera_primitives_components.all;

-- ----------------------------------------------------------------------------
-- Entity declaration
-- ----------------------------------------------------------------------------
entity FPGA_LED_ctrl is
  port (
        --input ports
			led_r_in   		: in std_logic; 
			led_g_in   		: in std_logic;
			led_ctrl		 	: in std_logic_vector(2 downto 0);
        --output ports 
			led_r			 	: out std_logic;
			led_g			 	: out std_logic

        );
end FPGA_LED_ctrl;

-- ----------------------------------------------------------------------------
-- Architecture
-- ----------------------------------------------------------------------------
architecture arch of FPGA_LED_ctrl is

signal led_r_sig : std_logic;
signal led_g_sig : std_logic;
  
begin

-- ----------------------------------------------------------------------------
-- Signal MUX
-- ----------------------------------------------------------------------------

led_r_sig <= led_r_in when led_ctrl(0)='0' else not led_ctrl(1);
led_g_sig <= led_g_in when led_ctrl(0)='0' else not led_ctrl(2);


-- ----------------------------------------------------------------------------
-- Open drain output buffers
-- ----------------------------------------------------------------------------
led_r_opndrn_buff: opndrn PORT MAP ( 
	a_in 	=> led_r_sig, 
	a_out => led_r
);

led_g_opndrn_buff: opndrn PORT MAP ( 
	a_in 	=> led_g_sig, 
	a_out => led_g
);




  
end arch;