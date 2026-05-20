LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;


ENTITY sysRobot IS
PORT (
	SW : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	KEY : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
	CLOCK_50 : IN STD_LOGIC;
	LED : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	DRAM_CLK, DRAM_CKE : OUT STD_LOGIC;
	DRAM_ADDR : OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
	DRAM_BA : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
	DRAM_CS_N, DRAM_CAS_N, DRAM_RAS_N, DRAM_WE_N : OUT STD_LOGIC;
	DRAM_DQ : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	DRAM_DQM : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); 
	MTRR_P, MTRR_N, MTRL_P, MTRL_N : OUT STD_LOGIC;
	LTC_ADC_CONVST, LTC_ADC_SCK,LTC_ADC_SDI : OUT STD_LOGIC;
	LTC_ADC_SDO : IN STD_LOGIC;
	VCC3P3_PWRON_n : OUT STD_LOGIC
	
);
END sysRobot;

ARCHITECTURE Structure OF sysRobot IS
COMPONENT nios_system
PORT (
	clk_clk : IN STD_LOGIC;
	reset_reset_n : IN STD_LOGIC;
	leds_export : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	switches_export : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	sdram_wire_addr : OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
	sdram_wire_ba : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
	sdram_wire_cas_n : OUT STD_LOGIC;
	sdram_wire_cke : OUT STD_LOGIC;
	sdram_wire_cs_n : OUT STD_LOGIC;
	sdram_wire_dq : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	sdram_wire_dqm : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
	sdram_wire_ras_n : OUT STD_LOGIC;
	sdram_wire_we_n : OUT STD_LOGIC;
	pwm_avalon_interface_export         : out   std_logic_vector(3 downto 0);
	acquisition_avalon_interfac_conduit_2_export  : in    std_logic;             --  acquisition_avalon_interfac_conduit_2.export
	acquisition_avalon_interface_conduit_0_export : out   std_logic_vector(7 downto 0);                     -- acquisition_avalon_interface_conduit_0.export
	acquisition_avalon_interface_conduit_1_export : out   std_logic_vector(2 downto 0)                     -- acquisition_avalon_interface_conduit_1.export
);
END COMPONENT;


BEGIN

VCC3P3_PWRON_n <= '0';

NiosII: nios_system
PORT MAP (
	clk_clk => CLOCK_50,
	reset_reset_n => KEY(0),
	leds_export => OPEN,
	switches_export => SW,
	sdram_wire_addr => DRAM_ADDR,
	sdram_wire_ba => DRAM_BA,
	sdram_wire_cas_n => DRAM_CAS_N,
	sdram_wire_cke => DRAM_CKE,
	sdram_wire_cs_n => DRAM_CS_N,
	sdram_wire_dq => DRAM_DQ,
	sdram_wire_dqm => DRAM_DQM,
	sdram_wire_ras_n => DRAM_RAS_N,
	sdram_wire_we_n => DRAM_WE_N,
	
	pwm_avalon_interface_export(0) => MTRR_P,
	pwm_avalon_interface_export(1) => MTRR_N, 
	pwm_avalon_interface_export(2) => MTRL_P,
	pwm_avalon_interface_export(3) => MTRL_N,
	
	
	

	acquisition_avalon_interface_conduit_0_export => LED,
	acquisition_avalon_interface_conduit_1_export(0) =>LTC_ADC_CONVST,
	acquisition_avalon_interface_conduit_1_export(1) =>LTC_ADC_SCK,
	acquisition_avalon_interface_conduit_1_export(2) =>LTC_ADC_SDI,
	acquisition_avalon_interfac_conduit_2_export => LTC_ADC_SDO
	);
	DRAM_CLK <= CLOCK_50;
END Structure;
