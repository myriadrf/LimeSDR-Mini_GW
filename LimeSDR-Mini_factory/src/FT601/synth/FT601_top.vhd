-- ----------------------------------------------------------------------------	
-- FILE: 	FT601_top.vhd
-- DESCRIPTION:	top module for FT601
-- DATE:	May 13, 2016
-- AUTHOR(s):	Lime Microsystems
-- REVISIONS:
-- ----------------------------------------------------------------------------	
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ----------------------------------------------------------------------------
-- Entity declaration
-- ----------------------------------------------------------------------------
entity FT601_top is
	generic(
			EP02_rdusedw_width	: integer := 11; 
			EP02_rwidth				: integer := 8;
			EP82_wrusedw_width	: integer := 11;
			EP82_wwidth				: integer := 8;
			EP82_wsize  			: integer := 64;  --packet size in bytes, has to be multiple of 4 bytes				
			EP03_rwidth				: integer := 32;
			EP83_wwidth				: integer := 64;
			EP83_wsize  			: integer := 2048 --packet size in bytes, has to be multiple of 4 bytes	
	);
	port (
			--input ports 
			clk         	: in std_logic;			--FTDI CLK
			reset_n   		: in std_logic;
			--FTDI external ports
			FT_wr_n			: out std_logic;
			FT_rxf_n			: in std_logic;
			FT_data			: inout std_logic_vector(31 downto 0);
			FT_be				: inout std_logic_vector(3 downto 0);
			FT_txe_n			: in std_logic;
		   --controll endpoint fifo PC->FPGA 
			EP02_rdclk		: in std_logic;
			EP02_rd			: in std_logic;
			EP02_rdata		: out std_logic_vector(EP02_rwidth-1 downto 0);
			EP02_rempty		: out std_logic;
			--controll endpoint fifo FPGA->PC
			EP82_wclk		: in std_logic;
			EP82_aclrn		: in std_logic;
			EP82_wr			: in std_logic;
			EP82_wdata		: in std_logic_vector(EP82_wwidth-1 downto 0);
			EP82_wfull		: out std_logic;
			--stream endpoint fifo PC->FPGA
--			EP03_rdclk		: in std_logic;
--			EP03_rd			: in std_logic;
--			EP03_rdata		: out std_logic_vector(EP03_rwidth-1 downto 0);
--			EP03_rempty		: out std_logic;
			ext_buff_rdy	: in std_logic;
			ext_buff_data	: out std_logic_vector(31 downto 0);
			ext_buff_wr		: out std_logic;
			--stream endpoint fifo FPGA->PC
			EP83_wclk		: in std_logic;
			EP83_aclrn		: in std_logic;
			EP83_wr			: in std_logic;
			EP83_wdata		: in std_logic_vector(EP83_wwidth-1 downto 0);
			EP83_wfull		: out std_logic;
			EP83_wrusedw	: out std_logic_vector(11 downto 0)
        
        );
end FT601_top;

-- ----------------------------------------------------------------------------
-- Architecture
-- ----------------------------------------------------------------------------
architecture arch of FT601_top is
--declare signals,  components here

--EP02 fifo signals 
signal EP02_wrempty			: std_logic;
signal EP02_wr					: std_logic; 
signal EP02_wdata				: std_logic_vector(31 downto 0);
--EP82 fifo signals
signal EP82_fifo_rdusedw	: std_logic_vector(EP82_wrusedw_width-1 downto 0);
signal EP82_fifo_q			: std_logic_vector(31 downto 0);
signal EP82_fifo_rdreq		: std_logic;

--EP03 fifo signals 
signal EP03_wrempty			: std_logic; 
signal EP03_wr					: std_logic;
signal EP03_wdata				: std_logic_vector(31 downto 0);

--EP83 fifo signals
signal EP83_fifo_rdusedw	: std_logic_vector(12 downto 0);
signal EP83_fifo_q			: std_logic_vector(31 downto 0);
signal EP83_fifo_rdreq		: std_logic;

--arbiter signals
signal arb_en 					: std_logic; 
signal arb_rd_wr				: std_logic;
signal arb_nth_ch				: std_logic_vector(3 downto 0);

--fsm signals
signal fsm_rdy					: std_logic;
signal fsm_rd_data_valid   : std_logic;
signal fsm_rd_data			: std_logic_vector(31 downto 0);
signal fsm_wr_data_req     : std_logic;
signal fsm_wr_data  			: std_logic_vector(31 downto 0);

--fifo for endpoints component
component fifo_inst is
  generic(dev_family	     : string  := "MAX 10";
          wrwidth         : integer := 64;
          wrusedw_witdth  : integer := 9; --12=2048 words 
          rdwidth         : integer := 32;
          rdusedw_width   : integer := 10;
          show_ahead      : string  := "OFF"
  );  

  port (

      reset_n       : in std_logic;
      wrclk         : in std_logic;
      wrreq         : in std_logic;
      data          : in std_logic_vector(wrwidth-1 downto 0);
      wrfull        : out std_logic;
		wrempty		  : out std_logic;
      wrusedw       : out std_logic_vector(wrusedw_witdth-1 downto 0);
      rdclk 	     : in std_logic;
      rdreq         : in std_logic;
      q             : out std_logic_vector(rdwidth-1 downto 0);
      rdempty       : out std_logic;
      rdusedw       : out std_logic_vector(rdusedw_width-1 downto 0)     
        
        );
end component;

--FT6001 arbiter component
component FT601_arb is
	generic(	
			EP82_fifo_rwidth	: integer := 9;
			EP82_wsize       	: integer := 64;  --packet size in bytes, has to be multiple of 4 bytes
			EP83_fifo_rwidth	: integer := 11;
			EP83_wsize       	: integer := 2048 --packet size in bytes, has to be multiple of 4 bytes
	);
  port (
			--input ports 
			clk       			: in std_logic;
			reset_n   			: in std_logic;
			enable       		: in std_logic;
			--control EP PC->FPGA
			EP02_fifo_data		: out std_logic_vector(31 downto 0);
			EP02_fifo_wr		: out std_logic;
			EP02_fifo_wrempty	: in std_logic;
			--control EP FPGA->PC
			EP82_fifo_data		: in std_logic_vector(31 downto 0);
			EP82_fifo_rd 		: out std_logic;
			EP82_fifo_rdusedw	: in std_logic_vector(EP82_fifo_rwidth-1 downto 0);
			--stream EP PC->FPGA
			EP03_fifo_data		: out std_logic_vector(31 downto 0);
			EP03_fifo_wr		: out std_logic;
			EP03_fifo_wrempty	: in std_logic;		
			--stream EP FPGA->PC
			EP83_fifo_data		: in std_logic_vector(31 downto 0);
			EP83_fifo_rd 		: out std_logic;
			EP83_fifo_rdusedw	: in std_logic_vector(EP83_fifo_rwidth-1 downto 0);
			--fsm controll signals
			fsm_epgo				: out std_logic;
			fsm_rdwr				: out std_logic; -- 0- MASTER RD (PC->FPGA), 1-MASTER WR (FPGA->PC)
			fsm_ch				: out std_logic_vector(3 downto 0);
			fsm_rdy				: in std_logic;
         fsm_rddata_valid  : in std_logic;
         fsm_rddata        : in std_logic_vector(31 downto 0);
         fsm_wrdata_req    : in std_logic;
         fsm_wrdata        : out std_logic_vector(31 downto 0);
			
			ep_status			: in std_logic_vector(7 downto 0)
        
        );
end component;

--FT601 fsm component 
component FT601 is
    generic(
			EP82_wsize       : integer := 64;  	--packet size in bytes, has to be multiple of 4 bytes
			EP83_wsize       : integer := 2048 	--packet size in bytes, has to be multiple of 4 bytes
			);
  port (
			clk			   : in std_logic;
			reset_n		   : in std_logic;
			trnsf_en       : in std_logic;
			ready			   : out std_logic;
			rd_wr    	   : in std_logic;     		-- 0- rd, 1-wr
			ch_n     	   : in std_logic_vector(3 downto 0);
         RD_data_valid  : out std_logic;
			RD_data        : out std_logic_vector(31 downto 0);
         WR_data_req    : out std_logic;     
			WR_data        : in std_logic_vector(31 downto 0); -- should be 2 cycle latency after WR_data_req   
			wr_n			   : out std_logic;
			rxf_n			   : in std_logic;
			data			   : inout std_logic_vector(31 downto 0);
			be				   : inout std_logic_vector(3 downto 0);
			txe_n			   : in std_logic
        );
end component;
  
begin


-- ----------------------------------------------------------------------------
-- FTDI endpoint fifos
-- ----------------------------------------------------------------------------
-- controll PC->FPGA 
EP02_fifo : fifo_inst		
generic map(
		dev_family		=> "MAX 10",
		wrwidth			=> 32,								--32 bits ftdi side, 
		wrusedw_witdth	=> EP02_rdusedw_width, 		--10=512 words (2048kB)
		rdwidth			=> EP02_rwidth,
		rdusedw_width	=> EP02_rdusedw_width,				
		show_ahead     => "ON"
)
port map(
      reset_n       	=> reset_n, 
      wrclk         	=> clk,
      wrreq         	=> EP02_wr,
      data          	=> EP02_wdata,
      wrfull        	=> open,
		wrempty		  	=> EP02_wrempty,
      wrusedw       	=> open,
      rdclk 	     	=> EP02_rdclk,
      rdreq         	=> EP02_rd,
      q             	=> EP02_rdata,
      rdempty       	=> EP02_rempty,
      rdusedw       	=> open             
        );

-- controll FPGA->PC
EP82_fifo : fifo_inst		
generic map(
		dev_family		=> "MAX 10",
		wrwidth			=> EP82_wwidth,
		wrusedw_witdth	=> EP82_wrusedw_width, 						--12=2048 words (2048kB)
		rdwidth			=> 32,						--32 bits ftdi side, 
		rdusedw_width	=> EP82_wrusedw_width,				
		show_ahead		=> "ON"
)
port map(
      reset_n       	=> EP82_aclrn, 
      wrclk				=> EP82_wclk,
      wrreq				=> EP82_wr,
      data          	=> EP82_wdata,
      wrfull        	=> EP82_wfull,
		wrempty		  	=> open,
      wrusedw       	=> open,
      rdclk 	     	=> clk,
      rdreq         	=> EP82_fifo_rdreq,
      q             	=> EP82_fifo_q,
      rdempty       	=> open,
      rdusedw       	=> EP82_fifo_rdusedw           
        );

--stream PC->FPGA		  
--EP03_fifo : fifo_inst		
--generic map(
--		dev_family		=> "Cyclone IV",
--		wrwidth			=> 32,						--32 bits ftdi side, 
--		wrusedw_witdth	=> 10, 						--10=512 words (2048kB)
--		rdwidth			=> EP03_rwidth,
--		rdusedw_width	=> 10,				
--		show_ahead     => "OFF"
--)
--port map(
--      reset_n       	=> reset_n, 
--      wrclk         	=> clk,
--      wrreq         	=> EP03_wr,
--      data          	=> EP03_wdata,
--      wrfull        	=> open,
--		wrempty		  	=> EP03_wrempty,
--      wrusedw       	=> open,
--      rdclk 	     	=> EP03_rdclk,
--      rdreq         	=> EP03_rd,
--      q             	=> EP03_rdata,
--      rdempty       	=> EP03_rempty,
--      rdusedw       	=> open             
--        );	
	
-- stream FPGA->PC
EP83_fifo : fifo_inst		
generic map(
		dev_family		=> "MAX 10",
		wrwidth			=> EP83_wwidth,
		wrusedw_witdth	=> 12, 			--11=1024 words x EP83_wwidth (8192KB)
		rdwidth			=> 32,			--32 bits ftdi side, 
		rdusedw_width	=> 13,				
		show_ahead		=> "ON"
)
port map(
      reset_n       	=> EP83_aclrn, 
      wrclk				=> EP83_wclk,
      wrreq				=> EP83_wr,
      data          	=> EP83_wdata,
      wrfull        	=> EP83_wfull,
		wrempty		  	=> open,
      wrusedw       	=> EP83_wrusedw,
      rdclk 	     	=> clk,
      rdreq         	=> EP83_fifo_rdreq,
      q             	=> EP83_fifo_q,
      rdempty       	=> open,
      rdusedw       	=> EP83_fifo_rdusedw           
		);
		 
-- ----------------------------------------------------------------------------
-- FTDI arbiter
-- ----------------------------------------------------------------------------		
	ftdi_arbiter : FT601_arb
	generic map(	
			EP82_fifo_rwidth	=> EP82_wrusedw_width,
			EP82_wsize       	=> EP82_wsize,
			EP83_fifo_rwidth	=> 13,
			EP83_wsize       	=> EP83_wsize
	)
  port map(
			clk       			=> clk, 
			reset_n   			=> reset_n,
			enable       		=> '1',
			EP02_fifo_data		=> EP02_wdata, 
			EP02_fifo_wr		=> EP02_wr, 
			EP02_fifo_wrempty	=> EP02_wrempty,
			EP82_fifo_data		=> EP82_fifo_q,
			EP82_fifo_rd 		=> EP82_fifo_rdreq,
			EP82_fifo_rdusedw	=> EP82_fifo_rdusedw,
			EP03_fifo_data		=> EP03_wdata,
			EP03_fifo_wr		=> EP03_wr,
			EP03_fifo_wrempty	=> ext_buff_rdy, --EP03_wrempty, fifo is not used
			EP83_fifo_data		=> EP83_fifo_q,
			EP83_fifo_rd 		=> EP83_fifo_rdreq,	
			EP83_fifo_rdusedw	=> EP83_fifo_rdusedw,

			fsm_epgo				=> arb_en, 
			fsm_rdwr				=> arb_rd_wr,
			fsm_ch				=> arb_nth_ch, 		 
			fsm_rdy				=> fsm_rdy, 
			fsm_rddata_valid	=> fsm_rd_data_valid,
			fsm_rddata			=> fsm_rd_data,
         fsm_wrdata_req    => fsm_wr_data_req,
			fsm_wrdata			=> fsm_wr_data,
			ep_status			=> FT_data(15 downto 8)       
			);
			
ext_buff_data	<=EP03_wdata;	
ext_buff_wr		<=EP03_wr; 		
		  
-- ----------------------------------------------------------------------------
-- FTDI fsm 
-- ----------------------------------------------------------------------------		  
ft_fsm : FT601
generic map(
			EP82_wsize	=> EP82_wsize,
			EP83_wsize	=> EP83_wsize 
			)
  port map (
			clk			   => clk,
			reset_n		   => reset_n,
			trnsf_en       => arb_en,
			ready			   => fsm_rdy,
			rd_wr    	   => arb_rd_wr,
			ch_n     	   => arb_nth_ch,
			RD_data_valid	=> fsm_rd_data_valid, 
			RD_data   	   => fsm_rd_data,
         WR_data_req    => fsm_wr_data_req,
			WR_data  	   => fsm_wr_data,  
			wr_n			   => FT_wr_n,
			rxf_n			   => FT_rxf_n,
			data			   => FT_data,
			be				   => FT_be,
			txe_n			   => FT_txe_n
			);
		  
  
end arch;





