-- ----------------------------------------------------------------------------
-- FILE:          pll_top.vhd
-- DESCRIPTION:   Top wrapper file for PLLs
-- DATE:          10:50 AM Wednesday, May 9, 2018
-- AUTHOR(s):     Lime Microsystems
-- REVISIONS:
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
--NOTES:
-- ----------------------------------------------------------------------------
-- altera vhdl_input_version vhdl_2008
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

LIBRARY altera_mf;
USE altera_mf.all;
USE altera_mf.altera_mf_components.all;
use work.pllcfg_pkg.all;

----------------------------------------------------------------------------
-- Entity declaration
----------------------------------------------------------------------------
entity pll_top is
   generic(
      N_PLL                   : integer   := 1;
      -- PLL parameters
      BANDWIDTH_TYPE          : STRING    := "AUTO";
      CLK0_DIVIDE_BY          : NATURAL   := 1;
      CLK0_DUTY_CYCLE         : NATURAL   := 50;
      CLK0_MULTIPLY_BY        : NATURAL   := 1;
      CLK0_PHASE_SHIFT        : STRING    := "0";
      CLK1_DIVIDE_BY          : NATURAL   := 1;
      CLK1_DUTY_CYCLE         : NATURAL   := 50;
      CLK1_MULTIPLY_BY        : NATURAL   := 1;
      CLK1_PHASE_SHIFT        : STRING    := "0";
      CLK2_DIVIDE_BY          : NATURAL   := 1;
      CLK2_DUTY_CYCLE         : NATURAL   := 50;
      CLK2_MULTIPLY_BY        : NATURAL   := 1;
      CLK2_PHASE_SHIFT        : STRING    := "0";
      CLK3_DIVIDE_BY          : NATURAL   := 1;
      CLK3_DUTY_CYCLE         : NATURAL   := 50;
      CLK3_MULTIPLY_BY        : NATURAL   := 1;
      CLK3_PHASE_SHIFT        : STRING    := "0";
      COMPENSATE_CLOCK        : STRING    := "CLK3";
      INCLK0_INPUT_FREQUENCY  : NATURAL   := 6250;
      INTENDED_DEVICE_FAMILY  : STRING    := "MAX 10";
      OPERATION_MODE          : STRING    := "NORMAL";
      SCAN_CHAIN_MIF_FILE     : STRING    := "ip/pll/pll.mif";
      DRCT_C0_NDLY            : integer   := 1;
      DRCT_C1_NDLY            : integer   := 8;
      DRCT_C2_NDLY            : integer   := 1;
      DRCT_C3_NDLY            : integer   := 8
   );
   port (
      --PLL ports
      pll_inclk            : in  std_logic;
      pll_reconfig_clk     : in  std_logic;
      pll_logic_reset_n    : in  std_logic;
      pll_clk_ena          : in  std_logic_vector(3 downto 0);
      pll_drct_clk_en      : in  std_logic_vector(3 downto 0);
      pll_c0               : out std_logic;
      pll_c1               : out std_logic;
      pll_c2               : out std_logic;
      pll_c3               : out std_logic;
      pll_locked           : out std_logic;
      --
      pll_smpl_cmp_en      : out std_logic;
      pll_smpl_cmp_done    : in  std_logic;
      pll_smpl_cmp_error   : in  std_logic;
      pll_smpl_cmp_cnt     : out std_logic_vector(15 downto 0);
      -- pllcfg ports
      to_pllcfg            : out t_TO_PLLCFG;
      from_pllcfg          : in  t_FROM_PLLCFG
   
   );
end pll_top;

----------------------------------------------------------------------------
-- Architecture
----------------------------------------------------------------------------
architecture arch of pll_top is
--declare signals,  components here

--inst0
signal inst0_pll_locked    : std_logic;
signal inst0_smpl_cmp_en   : std_logic;
signal inst0_busy          : std_logic;
signal inst0_dynps_done    : std_logic;
signal inst0_dynps_status  : std_logic;
signal inst0_rcnfig_status : std_logic;

--inst2
signal inst2_pllcfg_busy      : std_logic_vector(N_PLL-1 downto 0);
signal inst2_pllcfg_done      : std_logic_vector(N_PLL-1 downto 0);
signal inst2_pll_lock         : std_logic_vector(N_PLL-1 downto 0);
signal inst2_phcfg_start      : std_logic_vector(N_PLL-1 downto 0);
signal inst2_pllcfg_start     : std_logic_vector(N_PLL-1 downto 0);
signal inst2_pllrst_start     : std_logic_vector(N_PLL-1 downto 0);
signal inst2_auto_phcfg_done  : std_logic_vector(N_PLL-1 downto 0);
signal inst2_auto_phcfg_err   : std_logic_vector(N_PLL-1 downto 0);
signal inst2_phcfg_mode       : std_logic;
signal inst2_phcfg_tst        : std_logic;
signal inst2_phcfg_updn       : std_logic;
signal inst2_cnt_ind          : std_logic_vector(4 downto 0);
signal inst2_cnt_phase        : std_logic_vector(15 downto 0);
signal inst2_pllcfg_data      : std_logic_vector(143 downto 0);
signal inst2_auto_phcfg_smpls : std_logic_vector(15 downto 0);
signal inst2_auto_phcfg_step  : std_logic_vector(15 downto 0);

signal pllcfg_busy            : std_logic;
signal pllcfg_done            : std_logic;


begin
   
-- ----------------------------------------------------------------------------
-- PLL instance
-- ----------------------------------------------------------------------------
rxtx_pll_inst0 : entity work.rxtx_pll
   generic map(
      bandwidth_type          => BANDWIDTH_TYPE,         
      clk0_divide_by          => CLK0_DIVIDE_BY,         
      clk0_duty_cycle         => CLK0_DUTY_CYCLE,        
      clk0_multiply_by        => CLK0_MULTIPLY_BY,       
      clk0_phase_shift        => CLK0_PHASE_SHIFT,       
      clk1_divide_by          => CLK1_DIVIDE_BY,         
      clk1_duty_cycle         => CLK1_DUTY_CYCLE,        
      clk1_multiply_by        => CLK1_MULTIPLY_BY,       
      clk1_phase_shift        => CLK1_PHASE_SHIFT,       
      clk2_divide_by          => CLK2_DIVIDE_BY,         
      clk2_duty_cycle         => CLK2_DUTY_CYCLE,        
      clk2_multiply_by        => CLK2_MULTIPLY_BY,       
      clk2_phase_shift        => CLK2_PHASE_SHIFT,       
      clk3_divide_by          => CLK3_DIVIDE_BY,         
      clk3_duty_cycle         => CLK3_DUTY_CYCLE,        
      clk3_multiply_by        => CLK3_MULTIPLY_BY,       
      clk3_phase_shift        => CLK3_PHASE_SHIFT,       
      compensate_clock        => COMPENSATE_CLOCK,       
      inclk0_input_frequency  => INCLK0_INPUT_FREQUENCY, 
      intended_device_family  => INTENDED_DEVICE_FAMILY, 
      operation_mode          => OPERATION_MODE,         
      scan_chain_mif_file     => SCAN_CHAIN_MIF_FILE,    
      drct_c0_ndly            => DRCT_C0_NDLY,           
      drct_c1_ndly            => DRCT_C1_NDLY,           
      drct_c2_ndly            => DRCT_C2_NDLY,           
      drct_c3_ndly            => DRCT_C3_NDLY           
   )
   port map(
      --PLL input
      inclk1				=> '0',
      inclk2         	=> pll_inclk,
      pll_areset        => inst2_pllrst_start(0),
      pll_logic_reset_n => pll_logic_reset_n,
      inv_c0            => '0',
      inv_c2            => '0',
      c0                => pll_c0,
      c1                => pll_c1,
      c2                => pll_c2,
      c3                => pll_c3,
      pll_locked        => inst0_pll_locked,
      --Bypass control
      clk_ena           => pll_clk_ena, --clock output enable
      drct_clk_en       => pll_drct_clk_en, --1- Direct clk, 0 - PLL clocks 
      --Reconfiguration ports
      rcnfg_clk         => pll_reconfig_clk,
      rcnfig_areset     => inst2_pllrst_start(0),
      rcnfig_en         => inst2_pllcfg_start(0),
      rcnfig_data       => inst2_pllcfg_data,
      rcnfig_status     => inst0_rcnfig_status,
      --Dynamic phase shift ports
      dynps_areset_n    => not inst2_pllrst_start(0),
      dynps_mode        => inst2_phcfg_mode, -- 0 - manual, 1 - auto
      dynps_en          => inst2_phcfg_start(0),
      dynps_tst         => inst2_phcfg_tst,
      dynps_dir         => inst2_phcfg_updn,
      dynps_cnt_sel     => inst2_cnt_ind(2 downto 0),
      -- max phase steps in auto mode, phase steps to shift in manual mode 
      dynps_phase       => inst2_cnt_phase(9 downto 0),
      dynps_step_size   => inst2_auto_phcfg_step(9 downto 0),
      dynps_busy        => open,
      dynps_done        => inst0_dynps_done,
      dynps_status      => inst0_dynps_status,
      --signals from sample compare module (required for automatic phase searching)
      smpl_cmp_en       => inst0_smpl_cmp_en,
      smpl_cmp_done     => pll_smpl_cmp_done,
      smpl_cmp_error    => pll_smpl_cmp_error,
      --Overall configuration PLL status
      busy              => inst0_busy
   );
   
   pllcfg_busy <= inst0_busy;
   pllcfg_done <= not pllcfg_busy;
   
   -- ----------------------------------------------------------------------------
-- pllcfg_top instance
-- ----------------------------------------------------------------------------
   process(pllcfg_busy) 
      begin 
         inst2_pllcfg_busy <= (others=>'0');
         inst2_pllcfg_busy(0) <= pllcfg_busy;
   end process;
   
   process(pllcfg_done) 
      begin 
         inst2_pllcfg_done <= (others=>'1');
         inst2_pllcfg_done(0) <= pllcfg_done;
   end process;
   
   inst2_pll_lock(0)       <= inst0_pll_locked;   
   inst2_auto_phcfg_done(0)<= inst0_dynps_done; 
   inst2_auto_phcfg_err(0) <= inst0_dynps_status;

   pll_ctrl_inst2 : entity work.pll_ctrl 
   generic map(
      n_pll	=> N_PLL
   )
   port map(
      to_pllcfg         => to_pllcfg,
      from_pllcfg       => from_pllcfg,
         -- Status Inputs
      pllcfg_busy       => inst2_pllcfg_busy,
      pllcfg_done       => inst2_pllcfg_done,
         -- PLL Lock flags
      pll_lock          => inst2_pll_lock,
         -- PLL Configuration Related
      phcfg_mode        => inst2_phcfg_mode,
      phcfg_tst         => inst2_phcfg_tst,
      phcfg_start       => inst2_phcfg_start,   --
      pllcfg_start      => inst2_pllcfg_start,  --
      pllrst_start      => inst2_pllrst_start,  --
      phcfg_updn        => inst2_phcfg_updn,
      cnt_ind           => inst2_cnt_ind,       --
      cnt_phase         => inst2_cnt_phase,     --
      pllcfg_data       => inst2_pllcfg_data,
      auto_phcfg_done   => inst2_auto_phcfg_done,
      auto_phcfg_err    => inst2_auto_phcfg_err,
      auto_phcfg_smpls  => inst2_auto_phcfg_smpls,
      auto_phcfg_step   => inst2_auto_phcfg_step
        
      );
-- ----------------------------------------------------------------------------
-- Output ports
-- ----------------------------------------------------------------------------
pll_locked         <= inst0_pll_locked;
pll_smpl_cmp_en    <= inst0_smpl_cmp_en;
pll_smpl_cmp_cnt   <= inst2_auto_phcfg_smpls;

end arch;   





