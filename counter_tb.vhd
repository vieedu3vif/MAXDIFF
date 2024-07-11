LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Counter_tb IS
END Counter_tb;

ARCHITECTURE behavior OF Counter_tb IS
    COMPONENT Counter
    GENERIC (
        DATA_WIDTH : INTEGER := 8
    );
    PORT(
        CLK       : IN  STD_LOGIC;
        Reset     : IN  STD_LOGIC;
        LD_i      : IN  STD_LOGIC;
        En_cnt    : IN  STD_LOGIC;
        Count_out : OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0)
    );
    END COMPONENT;
   
   -- Inputs
   SIGNAL CLK       : STD_LOGIC := '0';
   SIGNAL Reset     : STD_LOGIC := '0';
   SIGNAL LD_i      : STD_LOGIC := '0';
   SIGNAL En_cnt    : STD_LOGIC := '0';

   -- Outputs
   SIGNAL Count_out : STD_LOGIC_VECTOR(7 DOWNTO 0);

   -- Clock period definitions
   CONSTANT CLK_period : time := 10 ns;
   
BEGIN

   uut: Counter
   GENERIC MAP (
        DATA_WIDTH => 8
    )
   PORT MAP (
        CLK       => CLK,
        Reset     => Reset,
        LD_i      => LD_i,
        En_cnt    => En_cnt,
        Count_out => Count_out
    );

   -- Clock process definitions
   CLK_process :process
   BEGIN
        CLK <= '0';
        WAIT for CLK_period/2;
        CLK <= '1';
        WAIT for CLK_period/2;
   END PROCESS;
   
   -- Stimulus process
   stim_proc: process
   begin
        -- hold reset state for 20 ns.
        Reset <= '1';
        WAIT for 20 ns;  
        Reset <= '0';
        WAIT for 20 ns;

        -- Enable counting
        En_cnt <= '1';
        WAIT for 100 ns;
        
        -- Disable counting
        En_cnt <= '0';
        WAIT for 50 ns;

        -- Enable counting again
        En_cnt <= '1';
        WAIT for 100 ns;
        
        -- Finish simulation
        WAIT;
   end process;

END;

