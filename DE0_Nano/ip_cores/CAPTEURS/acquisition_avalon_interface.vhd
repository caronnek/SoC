LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY acquisition_avalon_interface IS
PORT (
    clock       : IN STD_LOGIC;
    resetn      : IN STD_LOGIC;
    read        : IN STD_LOGIC;
    write       : IN STD_LOGIC;
    chipselect  : IN STD_LOGIC;

    writedata   : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    readdata    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    byteenable  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	 
	 -- 3 bits CONVST/SCK/SDI + 1 bit SDO + 8 bits export = 12 bits
	 Q_ADC_OUT  : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);  -- vers ADC
	 Q_ADC_IN   : IN  STD_LOGIC;                      -- depuis ADC
	 Q_export   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
);
END acquisition_avalon_interface;

ARCHITECTURE Structure OF acquisition_avalon_interface IS


SIGNAL to_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);


SIGNAL inter_clk_40 : STD_LOGIC;
SIGNAL inter_clk_2  : STD_LOGIC;


SIGNAL data_ready_s : STD_LOGIC;
SIGNAL vect_capt_s  : STD_LOGIC_VECTOR(6 DOWNTO 0);


SIGNAL adc_convst_s : STD_LOGIC;
SIGNAL adc_sck_s    : STD_LOGIC;
SIGNAL adc_sdi_s    : STD_LOGIC;
SIGNAL adc_sdo_s    : STD_LOGIC;


COMPONENT capteurs_sol_seuil
PORT (
    clk            : IN  STD_LOGIC;
    reset_n        : IN  STD_LOGIC;

    data_capture   : IN  STD_LOGIC;
    data_readyr    : OUT STD_LOGIC;
	 data0r	       : OUT std_logic_vector(7 downto 0);
	 data1r			 : OUT std_logic_vector(7 downto 0);
	 data2r	       : OUT std_logic_vector(7 downto 0);
	 data3r	       : OUT std_logic_vector(7 downto 0);
	 data4r	       : OUT std_logic_vector(7 downto 0);
	 data5r	       : OUT std_logic_vector(7 downto 0);
	 data6r	       : OUT std_logic_vector(7 downto 0);

    NIVEAU         : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);

    vect_capt      : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);

    ADC_CONVSTr    : OUT STD_LOGIC;
    ADC_SCK        : OUT STD_LOGIC;
    ADC_SDIr       : OUT STD_LOGIC;
    ADC_SDO        : IN  STD_LOGIC
);
END COMPONENT;

COMPONENT pll_2freqs
PORT (
    areset  : IN STD_LOGIC;
    inclk0  : IN STD_LOGIC;
    c0      : OUT STD_LOGIC;
    c1      : OUT STD_LOGIC
);
END COMPONENT;

BEGIN


pll_2freqs_instance : pll_2freqs
PORT MAP (
    areset => NOT resetn,
    inclk0 => clock,
    c0     => inter_clk_40,
    c1     => inter_clk_2
);



capteur_sol_seuil_instance : capteurs_sol_seuil
PORT MAP (
    clk          => inter_clk_40,
    reset_n      => resetn,

    data_capture => inter_clk_2,
    data_readyr  => data_ready_s,

    NIVEAU       => to_reg(7 DOWNTO 0),

    vect_capt    => vect_capt_s,

    ADC_CONVSTr  => adc_convst_s,
    ADC_SCK      => adc_sck_s,
    ADC_SDIr     => adc_sdi_s,
    ADC_SDO      => adc_sdo_s
);


process(clock, resetn)
begin
    if resetn = '0' then
        to_reg <= (others => '0');

    elsif rising_edge(clock) then
        if chipselect = '1' and write = '1' then
            to_reg <= writedata;
        end if;
    end if;
end process;

--------------------------------------------------------------------
-- READ REGISTER (FPGA → CPU)
--------------------------------------------------------------------
process(clock, resetn)
begin
    if resetn = '0' then
        readdata <= (others => '0');
    elsif rising_edge(clock) then
        if chipselect = '1' and read = '1' then
            -- Bit 0    : data_ready
            -- Bits 7:1 : vect_capt (7 capteurs)
            -- Bits 15:8 : libre pour extensions futures
            -- Bits 31:16 : libre
            readdata(0)           <= data_ready_s;
            readdata(7 downto 1)  <= vect_capt_s;
            readdata(31 downto 8) <= (others => '0');
        end if;
    end if;
end process;

--------------------------------------------------------------------
-- Q_export mapping (TOP LEVEL PIN ASSIGNMENT)
--------------------------------------------------------------------

Q_ADC_OUT(0) <= adc_convst_s;
Q_ADC_OUT(1) <= adc_sck_s;
Q_ADC_OUT(2) <= adc_sdi_s;
adc_sdo_s    <= Q_ADC_IN;        

Q_export(0)          <= data_ready_s;
Q_export(7 downto 1) <= vect_capt_s;


END Structure;