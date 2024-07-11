LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.LIBRA.all;

ENTITY MAXDIFF_tb IS
END MAXDIFF_tb;

ARCHITECTURE behavior OF MAXDIFF_tb IS
    
    COMPONENT MAXDIFF
        GENERIC (DATA_WIDTH : INTEGER := 8);
        PORT (
            RST     : IN STD_LOGIC;
            CLK     : IN STD_LOGIC;
            Start_i : IN STD_LOGIC;
            data_in : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            ADDR_in,L : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            maxDiff  : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
            Done    : OUT STD_LOGIC;
	WE: IN STD_LOGIC
        );
    END COMPONENT;


    SIGNAL rst, clk, start_i, done,we : STD_LOGIC := '0';
    SIGNAL data_in, addr_in,data_o, L:STD_LOGIC_VECTOR(7 DOWNTO 0);
    --SIGNAL rt_i, check_i, min_sl, max_sl ,  En_max, En_min, En_cnt, En_dt,  max_sel, min_sel, En_o, LD_i, RE, WE: STD_LOGIC;
    -- SIGNAL RESULT:  STD_LOGIC_VECTOR (8-1 downto 0);

    TYPE data_array_type IS ARRAY (0 TO 9) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    CONSTANT test_data : data_array_type := (
        "00000010", "00000001", "00000011", "00000100",
        "00000101", "00000110", "00000111", "00001100",
        "00001001", "00001101"
    );

BEGIN
    uut: MAXDIFF
        PORT MAP (
            RST     => rst,
            CLK     => clk,
	    WE => we,
            Start_i => start_i,
            data_in => data_in,
            ADDR_in => addr_in,
            maxDiff  =>data_o,
            Done    => done,
	    L => L
        );

    
    clk_process:	PROCESS
    BEGIN
	
        WAIT FOR 10 ns;
        clk <= '0';
        WAIT FOR 10 ns;
	clk <= '1';
    END PROCESS;

    PROCESS
    BEGIN
	rst <='0';
	start_i <= '0';
	we <= '0';
	ADDR_in <= "00000000";
	L <= "00001010";

        RST <= '1'; 
	WAIT FOR 40 ns;
        start_i <= '0';
        WAIT FOR 40 ns;  
        rst <= '0'; 

        FOR j IN 0 TO 9 LOOP  
            data_in <= test_data(j); 
	    we <= '1';
            WAIT FOR 10 ns; 
        END LOOP;

	we <='0';
	start_i <= '1';
	WAIT FOR 1200 ns;
 
        Start_i <= '0';
        WAIT;  
    END PROCESS;
END behavior;

