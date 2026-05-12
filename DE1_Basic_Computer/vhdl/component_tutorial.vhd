LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY component_tutorial IS
PORT (
    CLOCK_50 : IN STD_LOGIC;
    KEY      : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    HEX0     : OUT STD_LOGIC_VECTOR(0 TO 6);
    HEX1     : OUT STD_LOGIC_VECTOR(0 TO 6);
    HEX2     : OUT STD_LOGIC_VECTOR(0 TO 6);
    HEX3     : OUT STD_LOGIC_VECTOR(0 TO 6)
);
END component_tutorial;

ARCHITECTURE Structure OF component_tutorial IS

SIGNAL to_HEX : STD_LOGIC_VECTOR(15 DOWNTO 0);

COMPONENT nios_system IS
PORT (
		reset_n                     : in    std_logic                     := '0';             -- clk_clk_in_reset.reset_n
		zs_addr_from_the_sdram      : out   std_logic_vector(11 downto 0);                    --       sdram_wire.addr
		zs_ba_from_the_sdram        : out   std_logic_vector(1 downto 0);                     --                 .ba
		zs_cas_n_from_the_sdram     : out   std_logic;                                        --                 .cas_n
		zs_cke_from_the_sdram       : out   std_logic;                                        --                 .cke
		zs_cs_n_from_the_sdram      : out   std_logic;                                        --                 .cs_n
		zs_dq_to_and_from_the_sdram : inout std_logic_vector(15 downto 0) := (others => '0'); --                 .dq
		zs_dqm_from_the_sdram       : out   std_logic_vector(1 downto 0);                     --                 .dqm
		zs_ras_n_from_the_sdram     : out   std_logic;                                        --                 .ras_n
		zs_we_n_from_the_sdram      : out   std_logic;                                        --                 .we_n
		clk                         : in    std_logic                     := '0';             --       clk_clk_in.clk
		to_hex_export               : out   std_logic_vector(15 downto 0)                     --           to_hex.export
);
END COMPONENT nios_system;

COMPONENT hex7seg IS
PORT (
    hex     : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    display : OUT STD_LOGIC_VECTOR(0 TO 6)
);
END COMPONENT hex7seg;

BEGIN

    U0 : nios_system
    PORT MAP (
        clk        		=> CLOCK_50,
        reset_n 			=> KEY(0),
        to_hex_export  	=> to_HEX
    );

    h0 : hex7seg PORT MAP (to_HEX(3 DOWNTO 0),   HEX0);
    h1 : hex7seg PORT MAP (to_HEX(7 DOWNTO 4),   HEX1);
    h2 : hex7seg PORT MAP (to_HEX(11 DOWNTO 8),  HEX2);
    h3 : hex7seg PORT MAP (to_HEX(15 DOWNTO 12), HEX3);

END Structure;