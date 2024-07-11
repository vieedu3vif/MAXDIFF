LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;
USE work.LIBRA.all;


ENTITY DATAPATH IS
  GENERIC(
        DATA_WIDTH : INTEGER := 8
);
  PORT(
        RST, CLK, RE, WE, START_i, LD_i : IN STD_LOGIC;
	En_max, En_min, En_dt, En_o,En_cnt: IN STD_LOGIC;
        result, data_in : IN STD_LOGIC_VECTOR (DATA_WIDTH -1 downto 0);
	ADDR_in : IN STD_LOGIC_VECTOR(DATA_WIDTH -1 downto 0);
	L: IN STD_LOGIC_VECTOR(DATA_WIDTH -1 downto 0);
        max_sel, min_sel: IN STD_LOGIC;
	rt_i, check_i: OUT STD_LOGIC;
        maxDiff : OUT STD_LOGIC_VECTOR (DATA_WIDTH -1 downto 0);
	max_sl, min_sl: OUT STD_LOGIC
  ); 

END DATAPATH;

ARCHITECTURE RTL OF DATAPATH IS
 SIGNAL Max, Min, ADDR_i, i, data_reg,data_in_o: STD_LOGIC_VECTOR (DATA_WIDTH -1 downto 0);
 SIGNAL data_i, diff : STD_LOGIC_VECTOR (DATA_WIDTH -1 downto 0);
SIGNAL max_reg, min_reg: STD_LOGIC_VECTOR (DATA_WIDTH -1 downto 0);
 BEGIN
 -- CMP_check_i
	check_i <= '0' WHEN i > 0 ELSE '1';
 -- CMP_rt_i not equal;
	rt_i <= '0' WHEN i/=L ELSE '1';
 -- Mux_for_ADDR
	ADDR_i <= i WHEN START_i = '1' ELSE ADDR_in; 
 -- Mux_for_data_in
	data_i <= data_in WHEN Start_i = '0' ELSE result;
 -- Mux_for_MAX 
	Max <= data_reg WHEN max_sel = '1' ELSE data_in_o;
 -- Mux_for_MIN
   	Min <= data_reg WHEN min_sel = '1' ELSE data_in_o;
 -- CMP_>max
	max_sl <= '1' WHEN data_reg > max_reg ELSE '0';
 -- CMP_<min 
	min_sl <= '1' WHEN data_reg < min_reg ELSE '0';
-- SUB_data_diff
   	diff <= max_reg - min_reg;
-- 
--result <= MAXDIFF;
 -- REGISTER MAX;  
  Max_Regn: REGN
   GENERIC MAP(DATA_WIDTH => DATA_WIDTH)
   PORT MAP (
	RST => RST,
	CLK => CLK,
	D => Max,
	Q => max_reg,
	En => En_max
  );

 -- REGISTER MIN; 
  Min_Regn: REGN
   GENERIC MAP(DATA_WIDTH => DATA_WIDTH)
   PORT MAP (
	RST => RST,
	CLK => CLK,
	D => Min,
	Q => min_reg,
	En => En_min
  );

 -- REGISTER_DATA_IN;
  DataIn_Regn: REGN
 GENERIC MAP (DATA_WIDTH => DATA_WIDTH)
        PORT MAP (
            RST => RST,
            CLK => CLK,
            D => data_in_o,
            Q => data_reg,
            En => En_dt
  );

 -- REGISTER_MAXDIFF
  MaxDiff_Regn: REGN
 GENERIC MAP (DATA_WIDTH => DATA_WIDTH)
	PORT MAP (
            RST => RST,
            CLK => CLK,
            D => diff,
            Q => maxDiff,
            En => En_o
  );

 -- MEMORY_M
  Memory_Component: Memory
    GENERIC MAP (
        DATA_WIDTH => DATA_WIDTH,
        ADDR_WIDTH => DATA_WIDTH 
    )
    PORT MAP (
        CLK => CLK,
        RST => RST,
        WE => WE, 
	RE => RE,
        ADDR => ADDR_i,  
        data_in => data_i,  
        data_out => data_in_o
    );
 -- COUNTER_I
 Counter_i: Counter
    GENERIC MAP (
        DATA_WIDTH => DATA_WIDTH
    )
    PORT MAP (
    	CLK => CLK,
        Reset => RST,
        En_cnt => En_cnt,
        Count_out => i,
	LD_i=> LD_i
    );
 END RTL;

