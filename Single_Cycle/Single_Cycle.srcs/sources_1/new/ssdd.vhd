library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SSDDs is
Port ( digits : in STD_LOGIC_VECTOR (15 downto 0);
       clk : in STD_LOGIC;
       an :out std_logic_vector(3 downto 0);
       cat : out STD_LOGIC_VECTOR (6 downto 0));
end SSDDs;

architecture Behavioral of SSDDs is
signal cnt:std_logic_vector(15 downto 0);
signal c1: std_logic_vector(3 downto 0);
signal c2: std_logic_vector(3 downto 0);
signal c3: std_logic_vector(3 downto 0);
signal c4: std_logic_vector(3 downto 0);
signal out1:std_logic_vector (3 downto 0);

begin
c1<=digits(15 downto 12);
c2<=digits(11 downto 8);
c3<=digits(7 downto 4);
c4<=digits(3 downto 0);
process(clk)
    begin
        if rising_edge(clk) then
            cnt<=cnt+1;
        end if;    
    end process;
    
process(cnt,digits)
begin
case cnt(15 downto 14) is
    when "00" => an <="0111";
    when "01" => an <="1011";
    when "10" => an <="1101";
    when "11" => an <="1110";
    end case;
end process;

process(cnt,digits,c1,c2,c3,c4)
begin
case cnt(15 downto 14) is
    when "00" => out1 <=c1;
    when "01" => out1 <=c2;
    when "10" => out1 <=c3;
    when "11" => out1 <=c4;
    end case;
end process;

process(out1)
begin
    case out1 is
    when "0000" => cat <= "1000000"; -- "0"     
    when "0001" => cat <= "1111001"; -- "1" 
    when "0010" => cat <= "0100100"; -- "2" 
    when "0011" => cat <= "0110000"; -- "3" 
    when "0100" => cat <= "0011001"; -- "4" 
    when "0101" => cat <= "0010010"; -- "5" 
    when "0110" => cat <= "0000010"; -- "6" 
    when "0111" => cat <= "1111000"; -- "7" 
    when "1000" => cat <= "0000000"; -- "8"     
    when "1001" => cat <= "0010000"; -- "9" 
    when "1010" => cat <= "0001000"; -- a
    when "1011" => cat <= "0000011"; -- b
    when "1100" => cat <= "1000110"; -- C
    when "1101" => cat <= "0100001"; -- d
    when "1110" => cat <= "0000110"; -- E
    when "1111" => cat <= "0001110"; -- F
    end case;
end process;

end Behavioral;
