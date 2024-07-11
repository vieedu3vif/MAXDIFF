entity top_tb is
end entity;
 
architecture top_tb_arch of top_tb is
   component top 
     port (A : in bit;
            F: out bit);
   end component;
   signal A_TB, F_TB: bit;
   
   begin 
   DUT1: top port map (A_TB, F_TB);

   process
      begin 
         A_TB <= '0'; wait for 10 ns;
         A_TB <= '1'; wait for 10 ns;
      end process;
end architecture;


