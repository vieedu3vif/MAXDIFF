LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY REGN IS
  GENERIC(
        DATA_WIDTH : INTEGER := 8);
  PORT(
        RST, CLK: IN STD_LOGIC;
        D : IN STD_LOGIC_VECTOR (DATA_WIDTH -1 downto 0);
        Q : OUT STD_LOGIC_VECTOR (DATA_WIDTH -1 downto 0);
        En: IN STD_LOGIC
  ); 

END REGN;

ARCHITECTURE RTL OF REGN IS
 BEGIN
 PROCESS (RST, CLK)
 BEGIN
 IF (RST = '1') THEN
 Q <= (OTHERS => '0');
 ELSIF (CLK'EVENT AND CLK = '1') THEN
   IF(En = '1') THEN 
     Q <= D;
   END IF;
 END IF;

 END PROCESS;
 END RTL;

