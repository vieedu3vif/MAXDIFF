LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Memory_tb IS
END Memory_tb;

ARCHITECTURE behavior OF Memory_tb IS
    -- Component Declaration for the UUT
    COMPONENT Memory
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
    END COMPONENT;

    -- Testbench Signals
    SIGNAL clk, rst, we, re, start_i : STD_LOGIC;
    SIGNAL addr : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL data_in, data_out : STD_LOGIC_VECTOR(7 DOWNTO 0);

    -- Clock generation
    CONSTANT clk_period : TIME := 10 ns;

    -- Define an array of test data
    TYPE data_array_type IS ARRAY (0 TO 9) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    CONSTANT test_data : data_array_type := (
        "00000001", "00000100", "00000101", "00001010",
        "00010000", "00100000", "00110000", "01000000",
        "01010000", "01100000"
    );

BEGIN
    -- Instantiate the UUT
    uut: Memory
        GENERIC MAP (
            DATA_WIDTH => 8,
            ADDR_WIDTH => 8
        )
        PORT MAP (
            CLK     => clk,
            RST     => rst,
            WE      => we,
            RE      => re,
            ADDR    => addr,
            data_in => data_in,
            data_out => data_out
        );

    -- Clock process
    clk_process: PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period/2;
        clk <= '1';
        WAIT FOR clk_period/2;
    END PROCESS;

    -- Stimulus process
    stim_proc: PROCESS
        VARIABLE idx : INTEGER;
    BEGIN
        -- Reset
        rst <= '1';
        we <= '0';
        re <= '0';
	start_i <= '0';
        addr <= (others => '0');
        data_in <= (others => '0');
        WAIT FOR 20 ns;
        rst <= '0';

        -- Write data to memory
        FOR idx IN test_data'RANGE LOOP
            data_in <= test_data(idx);
            addr <= STD_LOGIC_VECTOR(to_unsigned(idx, 8));
            we <= '1'; -- Enable write operation
            WAIT FOR clk_period; -- Wait for one clock cycle
            we <= '0'; -- Disable write
            WAIT FOR clk_period;
        END LOOP;

        -- Read data from memory
        FOR idx IN test_data'RANGE LOOP
            addr <= STD_LOGIC_VECTOR(to_unsigned(idx, 8));
            re <= '1'; -- Enable read operation
            WAIT FOR clk_period; -- Wait for one clock cycle to read data
            re <= '0'; -- Disable read
            ASSERT data_out = test_data(idx) REPORT "Mismatch at address " & INTEGER'image(idx) SEVERITY ERROR;
            WAIT FOR clk_period;
        END LOOP;

        -- Finish simulation
        WAIT;
    END PROCESS;
END behavior;

