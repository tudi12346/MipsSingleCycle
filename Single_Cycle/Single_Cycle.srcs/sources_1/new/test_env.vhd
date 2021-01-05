library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;


entity test_env is
  Port (clk :in std_logic;
        btnC: in std_logic;
        sw: in std_logic_vector(2 downto 0); 
        an :out std_logic_vector(3 downto 0);
        cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is

signal enable : std_logic;
signal digits : std_logic_vector(15 downto 0);
--semnalele de control
signal RegDst: std_logic;
signal RegWrite: std_logic;
signal ExtOp: std_logic;
signal AluSrc: std_logic;
signal AluOp: std_logic_vector(2 downto 0);
signal Branch: std_logic;
signal Jump: std_logic;
signal MemWrite: std_logic;
signal MemToReg: std_logic;

--semnale intermediare
signal opcode : std_logic_vector(2 downto 0);
signal PcSrc : std_logic;
signal zeroFlag : std_logic;
signal funct : std_logic_vector(2 downto 0);
signal shiftAmount : std_logic;

signal jumpadress : std_logic_vector(15 downto 0);
signal branchadress : std_logic_vector(15 downto 0);
signal currentadress : std_logic_vector(15 downto 0);

signal instruction : std_logic_vector(15 downto 0);
signal writeData : std_logic_vector(15 downto 0);
signal readData1 : std_logic_vector(15 downto 0);
signal readData2 : std_logic_vector(15 downto 0);
signal extImm : std_logic_vector(15 downto 0);
signal aluResult : std_logic_vector(15 downto 0);
signal aluResultOut : std_logic_vector(15 downto 0);
signal memData : std_logic_vector(15 downto 0);


--componente
component I_Decode is
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
end component;
component I_Fetch is
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
end component;
component Mem is
    Port ( clk : in STD_LOGIC;
           Rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           MemWrite : in STD_LOGIC;
           
           AluRes : in STD_LOGIC_VECTOR (15 downto 0);
           
           AluResO : out STD_LOGIC_VECTOR (15 downto 0);           
           MemData : out STD_LOGIC_VECTOR (15 downto 0)
    );
end component;
component ALUs is
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
end component;
component SSDDs is
Port ( digits : in STD_LOGIC_VECTOR (15 downto 0);
       clk : in STD_LOGIC;
       an :out std_logic_vector(3 downto 0);
       cat : out STD_LOGIC_VECTOR (6 downto 0));
end component;
component mpgs is
    Port ( btnC : in STD_LOGIC;
           clk : in STD_LOGIC;
           enable : out STD_LOGIC);
           
end component;
begin
process(currentAdress,extImm,instruction)
begin
    jumpAdress <= (currentAdress and x"e000")or extImm;
    branchAdress <= currentAdress + extImm;
end process;

opcode <= instruction(15 downto 13);

process(opcode)
begin
    case opcode is
        --operatie de tip R
        when "000"=> RegDst<='1';
                     RegWrite<='1';
                     ExtOp<='0';
                     AluSrc<='0';
                     AluOp<="000";
                     Branch<='0';
                     Jump<='0';
                     MemWrite<='0';
                     MemToReg<='0';
        -- addi             
        when "001"=> RegDst<='0';
                     RegWrite<='1';
                     ExtOp<='1';
                     AluSrc<='1';
                     AluOp<="001";
                     Branch<='0';
                     Jump<='0';
                     MemWrite<='0';
                     MemToReg<='0';
        -- lw
        when "100"=> RegDst<='0';
                     RegWrite<='1';
                     ExtOp<='1';
                     AluSrc<='1';
                     AluOp<="100";
                     Branch<='0';
                     Jump<='0';
                     MemWrite<='0';
                     MemToReg<='1';
        --sw
        when "101"=> RegDst<='0';
                     RegWrite<='1';
                     ExtOp<='1';
                     AluSrc<='1';
                     AluOp<="101";
                     Branch<='0';
                     Jump<='0';
                     MemWrite<='1';
                     MemToReg<='0';
        -- beq
        when "111"=> RegDst<='0';
                     RegWrite<='0';
                     ExtOp<='1';
                     AluSrc<='0';
                     AluOp<="111";
                     Branch<='1';
                     Jump<='0';
                     MemWrite<='0';
                     MemToReg<='0';
        -- subi
        when "110"=> RegDst<='0';
                     RegWrite<='1';
                     ExtOp<='1';
                     AluSrc<='1';
                     AluOp<="110";
                     Branch<='0';
                     Jump<='0';
                     MemWrite<='0';
                     MemToReg<='0';
        -- andi
        when "011"=> RegDst<='0';
                     RegWrite<='1';
                     ExtOp<='0';
                     AluSrc<='1';
                     AluOp<="011";
                     Branch<='0';
                     Jump<='0';
                     MemWrite<='0';
                     MemToReg<='0';
        -- jump
        when "010"=> RegDst<='0';
                     RegWrite<='0';
                     ExtOp<='0';
                     AluSrc<='0';
                     AluOp<="010";
                     Branch<='0';
                     Jump<='1';
                     MemWrite<='0';
                     MemToReg<='0';
    end case;
end process;

--poarta si
PcSrc<= Branch and zeroFlag;

IFetch: I_Fetch port map ( 
        clk =>enable,
        
        PCSrc =>PcSrc,
        Jump =>jump,
        jmpAdr =>jumpAdress,
        brcAdr =>branchAdress,
        --reset : in std_logic;
        
        Inst =>instruction,--out
        cur_adr =>currentAdress--out
        );
IDec: I_Decode  port map (
        clk=>enable ,
         
        RegWrite=> RegWrite ,
        RegDst =>RegDst,
        ExtOp =>ExtOp,
        
        WD =>writeData,
        instr=>instruction(12 downto 0),

        
        RD1 =>readData1, --out
        RD2 =>readData2, --out
        
        Ext_Imm=> extImm ,--out
        func=> funct ,--out
        sa=> shiftAmount--out
        );
-- mux ul din dreapta de tot
writeData <= aluResultOut when MemToReg ='0' else memData;
Memory: Mem  port map ( 
           clk =>enable,
           Rd2 =>readData2,
           MemWrite =>MemWrite,
           
           AluRes =>aluResult,
           
           AluResO =>aluResultOut, --out        
           MemData =>memData--out
    );
Unit_EX: ALUs port map ( 
         rd1=>readData1,
         
         AluSrc=>AluSrc,
         
         rd2=>readData2,
         Ext_imm =>extImm,
         
         sa =>shiftAmount,
         
         funct =>funct,
         aluOp=>AluOp,
         
         zero =>zeroflag,
         aluRes=>aluResult
  );

mpg: mpgs port map( 
           btnC =>btnC,
           clk =>clk,
           enable =>enable);
ssd: SSDDs port map( 
       digits =>digits,
       clk =>clk,
       an =>an,
       cat =>cat);

process(clk,sw,readData1,readData2,instruction,currentAdress,extImm,MemData,WriteData,aluResult)
begin
    case sw is
        when "000"=> digits <= instruction;
        when "001"=> digits <= currentAdress;
        when "010"=> digits <= readData1;
        when "011"=> digits <= readData2;
        when "100"=> digits <= extImm;
        when "101"=> digits <= aluresult;
        when "110"=> digits <= MemData;
        when "111"=> digits <= WriteData;
        end case;
end process;
end Behavioral;
