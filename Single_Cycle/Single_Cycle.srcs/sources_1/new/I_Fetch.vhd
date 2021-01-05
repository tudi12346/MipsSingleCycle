library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity I_Fetch is
    port ( 
        clk : in std_logic;
        
        PCSrc : in std_logic;
        Jump : in std_logic;
        jmpAdr : in std_logic_vector(15 downto 0);
        brcAdr : in std_logic_vector(15 downto 0);
        --reset : in std_logic;
        Inst : out std_logic_vector(15 downto 0);
        cur_adr : out std_logic_vector(15 downto 0)
        );
end I_Fetch;

architecture Behavioral of I_Fetch is
type ROM_type is array (0 to 15) of std_logic_vector(15 downto 0);
signal ROM : ROm_type :=(B"011_001_001_0000000",
                         B"011_010_010_0000000",
                         B"011_011_011_0000001",
                         B"011_100_100_0000000",
                         B"001_010_010_0000100",
                         B"000_001_010_001_0_100",
                         B"000_010_011_010_0_001",
                         B"111_100_010_0000001",
                         B"010_000_0000000101",
                         B"0000000000001001",
                         B"0000000000001010",

                    others=>"0000000000000000");


    signal PC : std_logic_vector(15 downto 0)     := B"0000_0000_0000_0000";
    signal PC_nxt : std_logic_vector(15 downto 0) := B"0000_0000_0000_0000";
    signal data : std_logic_vector(15 downto 0)   := B"0000_0000_0000_0000";
    signal M1 : std_logic_vector(15 downto 0)  := B"0000_0000_0000_0000";
    signal M2 : std_logic_vector(15 downto 0)  := B"0000_0000_0000_0000";

begin

      data<=ROM(conv_integer(pc));
                          
      Inst <= data;
      cur_adr <= PC_nxt;
      PC_nxt <= PC + 1;
                          
      process(clk)
      begin 
            if rising_edge(clk) then
               PC <= M2;
            end if;
      end process;
      
    -- mux 1
      M1 <= PC_nxt when (PCSrc = '0') else brcAdr;
    --mux 2
      M2 <= M1 when (Jump = '0') else jmpAdr;
      
--      process(reset)
--      begin 
--        if reset ='1' then
--            M1 <= "0000000000000000";
--        end if;
--      end process;
    
    

end Behavioral;
