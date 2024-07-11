LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY Counter IS
    GENERIC (
        DATA_WIDTH : INTEGER := 8 
    );
    PORT (
        CLK       : IN  STD_LOGIC;
        Reset     : IN  STD_LOGIC;
        LD_i      : IN  STD_LOGIC;  
        En_cnt    : IN  STD_LOGIC;  
        Count_out : OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0)
    );
END Counter;

ARCHITECTURE Behavioral OF Counter IS
    SIGNAL pre_count: std_logic_vector(DATA_WIDTH-1 downto 0);  
    SIGNAL counter_reg : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0) := (others => '0');
BEGIN
    counter_reg(0) <= '0';
    PROCESS(CLK, En_cnt, Reset)
    BEGIN
        IF Reset = '1' THEN
            pre_count <= (OTHERS => '0');
        ELSIF (CLK'EVENT AND CLK = '1') THEN
            IF LD_i = '1' THEN
                pre_count <= counter_reg;
            ELSIF En_cnt = '1' THEN
                pre_count <= pre_count + "1"; 
            END IF;
        END IF;
    END PROCESS;

    Count_out <= pre_count;
END Behavioral;
