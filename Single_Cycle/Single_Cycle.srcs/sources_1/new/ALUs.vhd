library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;



entity ALUs is
  Port ( rd1 : in std_logic_vector (15 downto 0);
         
         AluSrc: in std_logic;
         
         rd2: in std_logic_vector (15 downto 0);
         Ext_imm :in std_logic_vector(15 downto 0);
         
         sa : in std_logic;
         
         funct :in std_logic_vector(2 downto 0);
         aluOp: in std_logic_vector(2 downto 0);
         
         zero : out std_logic;
         aluRes: out std_logic_vector(15 downto 0)
  );
end ALUs;

architecture Behavioral of ALUs is
signal selectedInp : std_logic_vector (15 downto 0);
signal aluCtrl : std_logic_vector (2 downto 0);
signal rez : std_logic_vector (15 downto 0);
begin

selectedinp <= rd2 when (alusrc = '0') else ext_imm;

process(funct,aluop)
begin
    case aluop is 
            when "000" => case funct is
                            when "100"=> aluCtrl <= "000";--adunare
                            when "001"=> aluCtrl <= "001";--scadere
                            when "010"=> aluCtrl <= "010";--shift left
                            when "000"=> aluCtrl <= "011";--shift right
                            when "011"=> aluCtrl <= "100";--and
                            when "111"=> aluCtrl <= "101";--or
                            when "101"=> aluCtrl <= "110";--xor
                            when "110"=> aluCtrl <= "111";
                            
                            end case;
            
            when "001" =>  aluctrl <= "000"; --  addi alu executa +
            when "100" =>  aluctrl <= "000"; --  lw alu executa +
            when "101" =>  aluctrl <= "000"; --  sw alu executa +
            when "111" =>  aluctrl <= "001"; --  beq alu executa -
            when "110" =>  aluctrl <= "001"; --  subi alu executa -
            when "011" =>  aluctrl <= "100"; --  andi alu executa and(si logic)
            when "010" =>  aluctrl <= "111"; --  jump alu nu conteaza
           
         end case;
end process;


 process(rd1,selectedinp,aluctrl,sa)
    begin
        case aluCtrl is 
            when "000" => rez <= rd1 + selectedinp; --  +
            when "001" => rez <= rd1 - selectedinp; --  -
            when "010" => if sa='1' then
                            rez<= rd1(13 downto 0)&"00";
                          else
                            rez<= rd1(14 Downto 0)&'0';
                            end if; --  sll cu sa+1
            when "011" => if sa='1' then
                            rez<= "00" & rd1(13 downto 0);
                          else
                            rez<= '0' & rd1(14 Downto 0);
                            end if; --  srl cu sa+1
            when "100" => rez <= rd1 and selectedinp; --  and
            when "101" => rez <= rd1 or selectedinp; --  or
            when "110" => rez <= rd1 xor selectedinp; -- xor
            when "111" => if rd1 < selectedinp then
                            rez<= "0000000000000001";
                          else
                            rez<= "0000000000000000";
                            end if; --  slt 
            
           
         end case;
end process;
process(rez)
begin
        if (rez = B"0000_0000_0000_0000") then 
            zero <= '1';
        else 
            zero <= '0';
        end if;
    end process;
alures<= rez;
end Behavioral;
