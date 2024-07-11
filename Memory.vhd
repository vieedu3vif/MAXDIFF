LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Memory IS
    GENERIC (
        DATA_WIDTH : INTEGER := 8;
        ADDR_WIDTH : INTEGER := 8
    );
    PORT (
        CLK : IN STD_LOGIC;
        RST : IN STD_LOGIC;
        WE, RE : IN STD_LOGIC;                
        ADDR : IN STD_LOGIC_VECTOR(ADDR_WIDTH-1 DOWNTO 0);
        data_in : IN STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
        data_out : OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0)
    );
END Memory;

ARCHITECTURE Behavioral OF Memory IS
    TYPE ram_type IS ARRAY (2**ADDR_WIDTH-1 DOWNTO 0) OF STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
    SIGNAL ram : ram_type;
    SIGNAL output_reg : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0) := (others => '0');  
BEGIN
    PROCESS(CLK)
    BEGIN
        IF rising_edge(CLK) THEN
            IF RST = '1' THEN
                output_reg <= (others => '0');
            ELSIF WE = '1' THEN
                ram(to_integer(unsigned(ADDR))) <= data_in;
	    END IF;  
            IF RE = '1' THEN
                output_reg <= ram(to_integer(unsigned(ADDR)));
            END IF;
        END IF;
    END PROCESS;
    data_out <= output_reg;
END Behavioral;
