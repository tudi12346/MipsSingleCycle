library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mpgs is
    Port ( btnC : in STD_LOGIC;
           clk : in STD_LOGIC;
           enable : out STD_LOGIC);
           
end mpgs;

architecture Behavioral of mpgs is
signal Q1: std_logic;
signal Q2: std_logic;
signal Q3: std_logic;
signal cnt: std_logic_vector(15 downto 0);

begin
    process(clk)
    begin
        if rising_edge(clk) then
            cnt<=cnt+1;
        end if;    
    end process;
    
    process(clk)
    begin
        if rising_edge(clk) then
            if cnt=x"FFFF" then
                Q1<=btnC;
            end if;
        end if;
    end process;
    
    process(clk)
    begin        
        if rising_edge(clk) then
            Q3<=Q2;
            Q2<=Q1;
        end if;
    end process;  
    
    enable<=Q2 and (not Q3);     
end Behavioral;