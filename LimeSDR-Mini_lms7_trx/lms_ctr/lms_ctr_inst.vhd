	component lms_ctr is
		port (
			clk_clk                                 : in    std_logic                     := 'X';             -- clk
			dac_spi_ext_MISO                        : in    std_logic                     := 'X';             -- MISO
			dac_spi_ext_MOSI                        : out   std_logic;                                        -- MOSI
			dac_spi_ext_SCLK                        : out   std_logic;                                        -- SCLK
			dac_spi_ext_SS_n                        : out   std_logic;                                        -- SS_n
			exfifo_if_d_export                      : in    std_logic_vector(31 downto 0) := (others => 'X'); -- export
			exfifo_if_rd_export                     : out   std_logic;                                        -- export
			exfifo_if_rdempty_export                : in    std_logic                     := 'X';             -- export
			exfifo_of_d_export                      : out   std_logic_vector(31 downto 0);                    -- export
			exfifo_of_wr_export                     : out   std_logic;                                        -- export
			exfifo_of_wrfull_export                 : in    std_logic                     := 'X';             -- export
			exfifo_rst_export                       : out   std_logic;                                        -- export
			flash_spi_MISO                          : in    std_logic                     := 'X';             -- MISO
			flash_spi_MOSI                          : out   std_logic;                                        -- MOSI
			flash_spi_SCLK                          : out   std_logic;                                        -- SCLK
			flash_spi_SS_n                          : out   std_logic;                                        -- SS_n
			fpga_spi_ext_MISO                       : in    std_logic                     := 'X';             -- MISO
			fpga_spi_ext_MOSI                       : out   std_logic;                                        -- MOSI
			fpga_spi_ext_SCLK                       : out   std_logic;                                        -- SCLK
			fpga_spi_ext_SS_n                       : out   std_logic_vector(1 downto 0);                     -- SS_n
			i2c_scl_export                          : inout std_logic                     := 'X';             -- export
			i2c_sda_export                          : inout std_logic                     := 'X';             -- export
			leds_external_connection_export         : out   std_logic_vector(7 downto 0);                     -- export
			lms_ctr_gpio_external_connection_export : out   std_logic_vector(3 downto 0);                     -- export
			switch_external_connection_export       : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- export
			uart_external_connection_rxd            : in    std_logic                     := 'X';             -- rxd
			uart_external_connection_txd            : out   std_logic                                         -- txd
		);
	end component lms_ctr;

	u0 : component lms_ctr
		port map (
			clk_clk                                 => CONNECTED_TO_clk_clk,                                 --                              clk.clk
			dac_spi_ext_MISO                        => CONNECTED_TO_dac_spi_ext_MISO,                        --                      dac_spi_ext.MISO
			dac_spi_ext_MOSI                        => CONNECTED_TO_dac_spi_ext_MOSI,                        --                                 .MOSI
			dac_spi_ext_SCLK                        => CONNECTED_TO_dac_spi_ext_SCLK,                        --                                 .SCLK
			dac_spi_ext_SS_n                        => CONNECTED_TO_dac_spi_ext_SS_n,                        --                                 .SS_n
			exfifo_if_d_export                      => CONNECTED_TO_exfifo_if_d_export,                      --                      exfifo_if_d.export
			exfifo_if_rd_export                     => CONNECTED_TO_exfifo_if_rd_export,                     --                     exfifo_if_rd.export
			exfifo_if_rdempty_export                => CONNECTED_TO_exfifo_if_rdempty_export,                --                exfifo_if_rdempty.export
			exfifo_of_d_export                      => CONNECTED_TO_exfifo_of_d_export,                      --                      exfifo_of_d.export
			exfifo_of_wr_export                     => CONNECTED_TO_exfifo_of_wr_export,                     --                     exfifo_of_wr.export
			exfifo_of_wrfull_export                 => CONNECTED_TO_exfifo_of_wrfull_export,                 --                 exfifo_of_wrfull.export
			exfifo_rst_export                       => CONNECTED_TO_exfifo_rst_export,                       --                       exfifo_rst.export
			flash_spi_MISO                          => CONNECTED_TO_flash_spi_MISO,                          --                        flash_spi.MISO
			flash_spi_MOSI                          => CONNECTED_TO_flash_spi_MOSI,                          --                                 .MOSI
			flash_spi_SCLK                          => CONNECTED_TO_flash_spi_SCLK,                          --                                 .SCLK
			flash_spi_SS_n                          => CONNECTED_TO_flash_spi_SS_n,                          --                                 .SS_n
			fpga_spi_ext_MISO                       => CONNECTED_TO_fpga_spi_ext_MISO,                       --                     fpga_spi_ext.MISO
			fpga_spi_ext_MOSI                       => CONNECTED_TO_fpga_spi_ext_MOSI,                       --                                 .MOSI
			fpga_spi_ext_SCLK                       => CONNECTED_TO_fpga_spi_ext_SCLK,                       --                                 .SCLK
			fpga_spi_ext_SS_n                       => CONNECTED_TO_fpga_spi_ext_SS_n,                       --                                 .SS_n
			i2c_scl_export                          => CONNECTED_TO_i2c_scl_export,                          --                          i2c_scl.export
			i2c_sda_export                          => CONNECTED_TO_i2c_sda_export,                          --                          i2c_sda.export
			leds_external_connection_export         => CONNECTED_TO_leds_external_connection_export,         --         leds_external_connection.export
			lms_ctr_gpio_external_connection_export => CONNECTED_TO_lms_ctr_gpio_external_connection_export, -- lms_ctr_gpio_external_connection.export
			switch_external_connection_export       => CONNECTED_TO_switch_external_connection_export,       --       switch_external_connection.export
			uart_external_connection_rxd            => CONNECTED_TO_uart_external_connection_rxd,            --         uart_external_connection.rxd
			uart_external_connection_txd            => CONNECTED_TO_uart_external_connection_txd             --                                 .txd
		);

