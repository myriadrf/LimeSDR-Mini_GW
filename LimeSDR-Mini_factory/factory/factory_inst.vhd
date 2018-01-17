	component factory is
		port (
			bridge_0_address     : in    std_logic_vector(20 downto 0) := (others => 'X'); -- address
			bridge_0_byte_enable : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- byte_enable
			bridge_0_read        : in    std_logic                     := 'X';             -- read
			bridge_0_write       : in    std_logic                     := 'X';             -- write
			bridge_0_write_data  : in    std_logic_vector(31 downto 0) := (others => 'X'); -- write_data
			bridge_0_acknowledge : out   std_logic;                                        -- acknowledge
			bridge_0_read_data   : out   std_logic_vector(31 downto 0);                    -- read_data
			clk_clk              : in    std_logic                     := 'X';             -- clk
			extfifo_of_d         : out   std_logic_vector(31 downto 0);                    -- of_d
			extfifo_of_wr        : out   std_logic;                                        -- of_wr
			extfifo_of_wrfull    : in    std_logic                     := 'X';             -- of_wrfull
			extfifo_if_d         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- if_d
			extfifo_if_rd        : out   std_logic;                                        -- if_rd
			extfifo_if_rdempty   : in    std_logic                     := 'X';             -- if_rdempty
			extfifo_fifo_rst     : out   std_logic;                                        -- fifo_rst
			pio_0_export         : out   std_logic_vector(7 downto 0);                     -- export
			reset_reset_n        : in    std_logic                     := 'X';             -- reset_n
			scl_export           : inout std_logic                     := 'X';             -- export
			sda_export           : inout std_logic                     := 'X'              -- export
		);
	end component factory;

	u0 : component factory
		port map (
			bridge_0_address     => CONNECTED_TO_bridge_0_address,     -- bridge_0.address
			bridge_0_byte_enable => CONNECTED_TO_bridge_0_byte_enable, --         .byte_enable
			bridge_0_read        => CONNECTED_TO_bridge_0_read,        --         .read
			bridge_0_write       => CONNECTED_TO_bridge_0_write,       --         .write
			bridge_0_write_data  => CONNECTED_TO_bridge_0_write_data,  --         .write_data
			bridge_0_acknowledge => CONNECTED_TO_bridge_0_acknowledge, --         .acknowledge
			bridge_0_read_data   => CONNECTED_TO_bridge_0_read_data,   --         .read_data
			clk_clk              => CONNECTED_TO_clk_clk,              --      clk.clk
			extfifo_of_d         => CONNECTED_TO_extfifo_of_d,         --  extfifo.of_d
			extfifo_of_wr        => CONNECTED_TO_extfifo_of_wr,        --         .of_wr
			extfifo_of_wrfull    => CONNECTED_TO_extfifo_of_wrfull,    --         .of_wrfull
			extfifo_if_d         => CONNECTED_TO_extfifo_if_d,         --         .if_d
			extfifo_if_rd        => CONNECTED_TO_extfifo_if_rd,        --         .if_rd
			extfifo_if_rdempty   => CONNECTED_TO_extfifo_if_rdempty,   --         .if_rdempty
			extfifo_fifo_rst     => CONNECTED_TO_extfifo_fifo_rst,     --         .fifo_rst
			pio_0_export         => CONNECTED_TO_pio_0_export,         --    pio_0.export
			reset_reset_n        => CONNECTED_TO_reset_reset_n,        --    reset.reset_n
			scl_export           => CONNECTED_TO_scl_export,           --      scl.export
			sda_export           => CONNECTED_TO_sda_export            --      sda.export
		);

