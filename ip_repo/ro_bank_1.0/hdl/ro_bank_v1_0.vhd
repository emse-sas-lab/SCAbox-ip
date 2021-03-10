library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library rtl;
use rtl.ro_pack.all;

entity ro_bank_v1_0 is
	generic (
		-- Users to add parameters here
		count_g : positive   := 16;
		depth_g : positive   := 8;
		width_g : positive   := 32;
		mode_g  : string := "step";

		-- User parameters ends
		-- Do not modify the parameters beyond this line
		-- Parameters of Axi Slave Bus Interface S_AXI
		C_S_AXI_DATA_WIDTH : integer := 32;
		C_S_AXI_ADDR_WIDTH : integer := 5
	);
	port (
		-- Users to add ports here
		clock_i : in std_logic;
		data_o  : out std_logic_vector(width_g - 1 downto 0);
		-- User ports ends
		-- Do not modify the ports beyond this line
		-- Ports of Axi Slave Bus Interface S_AXI
		s_axi_aclk    : in std_logic;
		s_axi_aresetn : in std_logic;
		s_axi_awaddr  : in std_logic_vector(C_S_AXI_ADDR_WIDTH - 1 downto 0);
		s_axi_awprot  : in std_logic_vector(2 downto 0);
		s_axi_awvalid : in std_logic;
		s_axi_awready : out std_logic;
		s_axi_wdata   : in std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);
		s_axi_wstrb   : in std_logic_vector((C_S_AXI_DATA_WIDTH/8) - 1 downto 0);
		s_axi_wvalid  : in std_logic;
		s_axi_wready  : out std_logic;
		s_axi_bresp   : out std_logic_vector(1 downto 0);
		s_axi_bvalid  : out std_logic;
		s_axi_bready  : in std_logic;
		s_axi_araddr  : in std_logic_vector(C_S_AXI_ADDR_WIDTH - 1 downto 0);
		s_axi_arprot  : in std_logic_vector(2 downto 0);
		s_axi_arvalid : in std_logic;
		s_axi_arready : out std_logic;
		s_axi_rdata   : out std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);
		s_axi_rresp   : out std_logic_vector(1 downto 0);
		s_axi_rvalid  : out std_logic;
		s_axi_rready  : in std_logic
	);
end ro_bank_v1_0;

architecture arch_imp of ro_bank_v1_0 is

	-- component declaration
	component ro_bank_v1_0_S_AXI is
		generic (
			count_g : positive   := 2;
			depth_g : positive   := 8;
			width_g : positive   := 32;
			mode_g  : string;

			C_S_AXI_DATA_WIDTH : integer := 32;
			C_S_AXI_ADDR_WIDTH : integer := 5
		);
		port (
			clock_i : in std_logic;
			data_o  : out std_logic_vector(width_g - 1 downto 0);

			S_AXI_ACLK    : in std_logic;
			S_AXI_ARESETN : in std_logic;
			S_AXI_AWADDR  : in std_logic_vector(C_S_AXI_ADDR_WIDTH - 1 downto 0);
			S_AXI_AWPROT  : in std_logic_vector(2 downto 0);
			S_AXI_AWVALID : in std_logic;
			S_AXI_AWREADY : out std_logic;
			S_AXI_WDATA   : in std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);
			S_AXI_WSTRB   : in std_logic_vector((C_S_AXI_DATA_WIDTH/8) - 1 downto 0);
			S_AXI_WVALID  : in std_logic;
			S_AXI_WREADY  : out std_logic;
			S_AXI_BRESP   : out std_logic_vector(1 downto 0);
			S_AXI_BVALID  : out std_logic;
			S_AXI_BREADY  : in std_logic;
			S_AXI_ARADDR  : in std_logic_vector(C_S_AXI_ADDR_WIDTH - 1 downto 0);
			S_AXI_ARPROT  : in std_logic_vector(2 downto 0);
			S_AXI_ARVALID : in std_logic;
			S_AXI_ARREADY : out std_logic;
			S_AXI_RDATA   : out std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);
			S_AXI_RRESP   : out std_logic_vector(1 downto 0);
			S_AXI_RVALID  : out std_logic;
			S_AXI_RREADY  : in std_logic
		);
	end component ro_bank_v1_0_S_AXI;

begin

	-- Instantiation of Axi Bus Interface S_AXI
	ro_bank_v1_0_S_AXI_inst : ro_bank_v1_0_S_AXI
	generic map(
		count_g => count_g,
		depth_g => depth_g,
		width_g => width_g,
		mode_g  => mode_g,

		C_S_AXI_DATA_WIDTH => C_S_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH => C_S_AXI_ADDR_WIDTH
	)
	port map(
		clock_i => clock_i,
		data_o  => data_o,

		S_AXI_ACLK    => s_axi_aclk,
		S_AXI_ARESETN => s_axi_aresetn,
		S_AXI_AWADDR  => s_axi_awaddr,
		S_AXI_AWPROT  => s_axi_awprot,
		S_AXI_AWVALID => s_axi_awvalid,
		S_AXI_AWREADY => s_axi_awready,
		S_AXI_WDATA   => s_axi_wdata,
		S_AXI_WSTRB   => s_axi_wstrb,
		S_AXI_WVALID  => s_axi_wvalid,
		S_AXI_WREADY  => s_axi_wready,
		S_AXI_BRESP   => s_axi_bresp,
		S_AXI_BVALID  => s_axi_bvalid,
		S_AXI_BREADY  => s_axi_bready,
		S_AXI_ARADDR  => s_axi_araddr,
		S_AXI_ARPROT  => s_axi_arprot,
		S_AXI_ARVALID => s_axi_arvalid,
		S_AXI_ARREADY => s_axi_arready,
		S_AXI_RDATA   => s_axi_rdata,
		S_AXI_RRESP   => s_axi_rresp,
		S_AXI_RVALID  => s_axi_rvalid,
		S_AXI_RREADY  => s_axi_rready
	);

	-- Add user logic here

	-- User logic ends

end arch_imp;