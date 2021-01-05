library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;


entity I_Decode is
  port (
        clk : in std_logic;
         
        RegWrite : in std_logic;
        RegDst : in std_logic;
        ExtOp : in std_logic;
        
        WD : in std_logic_vector(15 downto 0);
        instr : in std_logic_vector(12 downto 0);

        
        RD1 : out std_logic_vector(15 downto 0);
        RD2 : out std_logic_vector(15 downto 0);
        
        Ext_Imm : out std_logic_vector(15 downto 0);
        func : out std_logic_vector(2 downto 0);
        sa : out std_logic 
        );
end I_Decode;

architecture Behavioral of I_Decode is

 component RegFile is
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
end component;

signal WRAdr : std_logic_vector(2 downto 0);
 
begin

 WRAdr <= instr(9 downto 7) when (RegDst ='0') else instr(6 downto 4); 
 --Ext_Imm <= B"0000_0000_0" & instr(6 downto 0) when (ExtOp = '0') else B"1111_1111_1" & instr(6 downto 0);
 process(extop,instr)
 begin
     if ExtOp='0' then
        Ext_Imm<="000000000"&Instr(6 downto 0);
     elsif Instr(6)='0' then
        Ext_Imm<="000000000"&Instr(6 downto 0);
       else 
      Ext_Imm<="111111111"&Instr(6 downto 0);
    end if;
end process;
 func <= instr(2 downto 0);
 sa <= instr(3);

 RF : RegFile port map(
    clk => clk,
    RegWrite => RegWrite, 
    
    RA_1 => instr(12 downto 10),
    RA_2 => instr(9 downto 7),
            
    WAdr => WRAdr,
    Wdata => WD,
            
    RData_1 => RD1,
    RData_2 => RD2
    );
 

end Behavioral;
