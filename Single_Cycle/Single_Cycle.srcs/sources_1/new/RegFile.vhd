library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

        entity RegFile is
              port ( 
                    clk    : in std_logic;
                    RegWrite :in std_logic;
                    
                    RA_1 : in std_logic_vector(2 downto 0);
                    RA_2 : in std_logic_vector(2 downto 0);
                    
                    WAdr   : in std_logic_vector(2 downto 0);
                    Wdata  : in std_logic_vector(15 downto 0);
                    
                    RData_1 : out std_logic_vector(15 downto 0);
                    RData_2 : out std_logic_vector(15 downto 0)
               );
        end RegFile;
    
    
             --//////////////////////////////////////////////////////
architecture Behavioral of RegFile is

     type RegFile is array(0 to 7) of std_logic_vector(15 downto 0);
     signal R : RegFile := ("0000000000000000",
                            "0000000000000001",
                            "0000000000000010",
                            "0000000000000011",
                            "0000000000000100",
                            "0000000000000101",
                            "0000000000000110",
                            "0000000000000111");
 --....................................................................
begin

                
    RData_1 <= R(conv_integer(RA_1));
    RData_2 <= R(conv_integer(RA_2));
    
    process(clk,RegWrite)
    begin
        if rising_edge(clk) and RegWrite = '1' then
            R(conv_integer(WAdr)) <= Wdata;
        end if ;
    end process;
    
    

end Behavioral;
