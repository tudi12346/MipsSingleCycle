library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity Mem is
    Port ( clk : in STD_LOGIC;
           Rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           MemWrite : in STD_LOGIC;
           
           AluRes : in STD_LOGIC_VECTOR (15 downto 0);
           
           AluResO : out STD_LOGIC_VECTOR (15 downto 0);           
           MemData : out STD_LOGIC_VECTOR (15 downto 0)
    );
end Mem;

architecture Behavioral of Mem is

type memory is array(0 to 15) of std_logic_vector(15 downto 0);
     signal ram : memory := ("0000000000000000",
                            others => "0000000000000000");
                            
                            
begin
process (clk,MemWrite)
begin
    if rising_edge(clk) then 
        if memWrite= '1' then
            ram(conv_integer(AluRes)) <= Rd2;
        end if;
    end if;
end process;
memData <= ram(conv_integer(aluRes));
AluResO<= AluRes;
end Behavioral;
