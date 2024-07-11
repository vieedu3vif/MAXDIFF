LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY CONTROLLER IS
 GENERIC ( DATA_WIDTH : INTEGER :=8);

  PORT(
        RST, CLK: IN STD_LOGIC;
        rt_i, check_i, min_sl, max_sl : IN STD_LOGIC;
        En_max, En_min, En_cnt, En_dt,  max_sel, min_sel, En_o, LD_i : OUT STD_LOGIC;
        START_i : IN STD_LOGIC;
        RE, WE : OUT STD_LOGIC;
        Done   : OUT STD_LOGIC
      --  MaxDIFF : IN STD_LOGIC_VECTOR (DATA_WIDTH -1 downto 0);
      -- RESULT : OUT STD_LOGIC_VECTOR (DATA_WIDTH -1 downto 0)
  ); 

END CONTROLLER;

ARCHITECTURE RTL OF CONTROLLER IS
  Type STate_type IS( S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15, S16, S17, S18, S19, S20, S21);
Signal State : State_type;
BEGIN
PROCESS (RST, CLK)

BEGIN

	IF (RST='1') THEN
		State <= S0;
	ELSIF (CLK'EVENT and CLK = '1') THEN
	 CASE State IS
		WHEN S0 =>
			State <= S1;
		WHEN S1 =>
			IF(Start_i = '1') THEN
				State <= S2;
			ELSE 
				State <= S1;
			END IF;	
		WHEN S2 => 
			State <= S3;
                WHEN S3 =>
                        IF (rt_i='0') THEN 
                                STATE <= S4;
                        ELSE
                                STATE <= S17;
                        END IF;
                WHEN S4 =>
                         STATE <= S5;
                WHEN S5 =>
                        IF (check_i ='1') THEN
				STATE <= S6;
			ELSE
				STATE <= S9;
			END IF;
                WHEN S6 =>
                        STATE <= S7;
                WHEN S7 => 
 	  		STATE <= S8;
                WHEN S8 =>
			STATE <= S3;
               WHEN S9 => 
			STATE <= S10;
		WHEN S10 =>
                         IF(max_sl='1') THEN 	
				 STATE <= S12;		
			 ELSE 
				 STATE <= S11;
 			 END IF;
               WHEN S11 => 
			 IF (min_sl = '1') THEN 
				 STAtE <= S14;
			 ELSE 
				 STATE <= S16;
 			 END IF;
	       WHEN S12 => 
			STATE <= S13;
	       WHEN S13 => 
			STATE <= S16;
	       WHEN S14 =>
			STATE <= S15;
	       WHEN S15 => 
			STATE <= S16;
   	       WHEN S16 =>
			STATE <= S3; 

		WHEN S17 =>
			STATE <= S18;
		WHEN S18 =>
			STATE <= S19;
		WHEN S19 => 
			STATE <= S20;
		WHEN S20 => 
			IF( Start_i = '0') THEN 
				STATE <= S21;
			ELSE 
				STATE <= S20;
			END IF;
		WHEN S21 =>
				STATE <= S0;
                        
        END CASE;

	END IF;

END PROCESS;
 LD_i <='1' WHEN STATE = S2 ELSE '0';
 RE <='1' WHEN STATE = S4 ELSE '0';
 EN_dt <= '1' WHEN (STATE = S7 OR STATE = S9) ELSE '0';
 EN_min <= '1' WHEN (STATE = S7 OR STATE = S15) ELSE '0';
 EN_max <= '1' WHEN (STATE = S7 OR STATE = S13) ELSE '0';
 En_o <= '0' WHEN STATE = S2 ELSE '1';
 EN_cnt <= '1' WHEN (STATE = S8 OR STATE = S16) ELSE '0';
 Done <= '1' WHEN (StaTE = S21 OR STATE = S0) ELSE '0';
 max_sel <= '0' WHEN STATE = S6 ELSE
           '1' WHEN STATE = S12 ELSE
           '1'; 
 min_sel <= '0' WHEN STATE = S6 ELSE
           '1' WHEN STATE = S14 ELSE
           '1'; 
 WE <='1' WHEN STATE = S19 ELSE '0';
END RTL;