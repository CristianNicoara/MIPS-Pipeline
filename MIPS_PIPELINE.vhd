----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/04/2022 06:48:27 PM
-- Design Name: 
-- Module Name: MIPS_1 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MIPS_PIPELINE is
    Port ( clk : in STD_LOGIC;
           btn_reset : in std_logic;
           btn_en : in std_logic;
           sw : in std_logic_vector(2 downto 0);
           led : out std_logic_vector(15 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end MIPS_PIPELINE;

architecture Behavioral of MIPS_PIPELINE is

component MC is
    Port ( instr : in STD_LOGIC_VECTOR (2 downto 0);
           RegDst : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           Branch : out STD_LOGIC;
           Jump : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR (1 downto 0);
           MemWrite : out STD_LOGIC;
           MemToReg : out STD_LOGIC;
           RegWrite : out STD_LOGIC);
end component;

component InstrFetch is
    Port ( --pc_in : in STD_LOGIC_VECTOR(15 downto 0);
           btn_reset : in std_logic;
           btn_en : in std_logic;
           clk : in STD_LOGIC;
           jump : in STD_LOGIC;
           PCsrc : in STD_LOGIC;
           jump_addr : in STD_LOGIC_VECTOR (15 downto 0);
           branch_addr : in STD_LOGIC_VECTOR (15 downto 0);
           instr : out STD_LOGIC_VECTOR (15 downto 0);
           --cat : out STD_LOGIC_VECTOR (6 downto 0);
           --an : out STD_LOGIC_VECTOR (3 downto 0);
           pc_next : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component InstrDecode is
    Port ( clk : in STD_LOGIC;
           btn_en : in std_logic;
           RegWr : in STD_LOGIC;
           instr : in STD_LOGIC_VECTOR (15 downto 0);
           RegDst : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0);
           ext_imm : out STD_LOGIC_VECTOR (15 downto 0);
           func : out STD_LOGIC_VECTOR (2 downto 0);
           sa : out STD_LOGIC;
           wa : in STD_LOGIC_VECTOR(2 downto 0);
           final_wa : out STD_LOGIC_VECTOR(2 downto 0));
end component;

component ALU_MIPS is
    Port ( rd1 : in STD_LOGIC_VECTOR (15 downto 0);
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           ext_imm : in STD_LOGIC_VECTOR (15 downto 0);
           sa : in STD_LOGIC;
           func : in STD_LOGIC_VECTOR (2 downto 0);
           ALUSrc : in STD_LOGIC;
           ALUOp : in STD_LOGIC_VECTOR (1 downto 0);
           zero : out STD_LOGIC;
           ALURes : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component MEM is
    Port ( MemWrite : in STD_LOGIC;
           btn_en : in std_logic;
           ALURes : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           MemData : out STD_LOGIC_VECTOR (15 downto 0);
           ALURes_out : out STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC);
end component;

component SSD is
    Port ( cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           digit0 : in STD_LOGIC_VECTOR (3 downto 0);
           digit1 : in STD_LOGIC_VECTOR (3 downto 0);
           digit2 : in STD_LOGIC_VECTOR (3 downto 0);
           digit3 : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in std_logic);
end component;

component MPG is
    Port ( input : in STD_LOGIC;
           clk : in STD_LOGIC;
           enable : out STD_LOGIC);
end component;

signal pc : std_logic_vector(15 downto 0) := x"0000";
signal instr : std_logic_vector(15 downto 0);
signal RegDst : STD_LOGIC;
signal ExtOp : STD_LOGIC;
signal ALUSrc : STD_LOGIC;
signal Branch : STD_LOGIC;
signal Jump : STD_LOGIC;
signal ALUOp : STD_LOGIC_VECTOR (1 downto 0);
signal MemWrite : STD_LOGIC;
signal MemToReg : STD_LOGIC;
signal RegWrite : STD_LOGIC;
signal jumpAdress: std_logic_vector(15 downto 0);
signal branchAdress: std_logic_vector(15 downto 0);
signal ext_imm : std_logic_vector(15 downto 0);
signal PCSrc : std_logic;
signal zero: std_logic;
signal wd : STD_LOGIC_VECTOR (15 downto 0);
signal rd1 : STD_LOGIC_VECTOR (15 downto 0);
signal rd2 : STD_LOGIC_VECTOR (15 downto 0);
signal func : STD_LOGIC_VECTOR (2 downto 0);
signal sa : STD_LOGIC;
signal ALURes : std_logic_vector(15 downto 0);
signal MemData : std_logic_vector(15 downto 0);
signal ALURes_out : std_logic_vector(15 downto 0);
signal afisare : std_logic_vector(15 downto 0);
signal btn_reset_mpg : std_logic;
signal btn_en_mpg : std_logic;

-----Pipeline-----
signal instr_if_id : std_logic_vector(15 downto 0);
signal pc_next_if_id : std_logic_vector(15 downto 0);
signal final_wa_if_id : std_logic_vector(2 downto 0);

signal pc_next_id_ex : std_logic_vector(15 downto 0);
signal rd1_id_ex : std_logic_vector(15 downto 0);
signal rd2_id_ex : std_logic_vector(15 downto 0);
signal ext_imm_id_ex : std_logic_vector(15 downto 0);
signal func_id_ex : std_logic_vector(2 downto 0);
signal sa_id_ex : std_logic;
signal ALUSrc_id_ex : std_logic;
signal Branch_id_ex : std_logic;
signal MemWrite_id_ex : std_logic;
signal MemToReg_id_ex : std_logic;
signal zero_id_ex : std_logic;
signal RegWrite_id_ex : std_logic;
signal ALUOp_id_ex : std_logic_vector(1 downto 0);
signal final_wa_id_ex : std_logic_vector(2 downto 0);
signal AluRes_id_ex : std_logic_vector(15 downto 0);
signal branchAdress_id_ex : std_logic_vector(15 downto 0);

signal MemToReg_ex_mem : std_logic;
signal RegWrite_ex_mem : std_logic;
signal MemWrite_ex_mem : std_logic;
signal Branch_ex_mem : std_logic;
signal zero_ex_mem : std_logic;
signal final_wa_ex_mem : std_logic_vector(2 downto 0);
signal branchAdress_ex_mem : std_logic_vector(15 downto 0);
signal AluRes_ex_mem : std_logic_vector(15 downto 0);
signal AluRes_out_ex_mem : std_logic_vector(15 downto 0);
signal MemData_ex_mem : std_logic_vector(15 downto 0);

signal RegWrite_mem_wb : std_logic;
signal MemToReg_mem_wb : std_logic;
signal MemData_mem_wb : std_logic_vector(15 downto 0);
signal ALURes_out_mem_wb : std_logic_vector(15 downto 0);
signal final_wa_mem_wb : std_logic_vector(2 downto 0);
-----Pipeline-----

begin

MPG1: MPG port map(btn_reset, clk, btn_reset_mpg);
MPG2: MPG port map(btn_en, clk, btn_en_mpg);

jumpAdress <= "000" & instr_if_id(12 downto 0);
branchAdress_id_ex <= pc_next_id_ex + ext_imm_id_ex;
PCSrc <= Branch_ex_mem and zero_ex_mem;

IntrF: InstrFetch port map(btn_reset_mpg, btn_en_mpg, clk, Jump, PCSrc,jumpAdress,branchAdress_ex_mem,instr,pc);


-----1-----
process(clk)
begin
    if rising_edge(clk) then
        if btn_en_mpg = '1' then
            instr_if_id <= instr;
            pc_next_if_id <= pc;
        end if;
    end if;
end process;
-----------

ID: InstrDecode port map(clk, btn_en_mpg, RegWrite_mem_wb, instr_if_id, RegDst, ExtOp, wd, rd1, rd2, ext_imm, func, sa,final_wa_mem_wb,final_wa_if_id);

MainCtrl: MC port map(instr_if_id(15 downto 13), RegDst, ExtOp, ALUSrc, Branch, Jump, ALUOp, MemWrite, MemToReg, RegWrite);

-----2-----
process(clk)
begin
    if rising_edge(clk) then
        if btn_en_mpg = '1' then
            MemToReg_id_ex <= MemToReg;
            RegWrite_id_ex <= RegWrite;
            MemWrite_id_ex <= MemWrite;
            Branch_id_ex <= Branch;
            ALUOp_id_ex <= ALUOp;
            ALUSrc_id_ex <= ALUSrc;
            pc_next_id_ex <= pc_next_if_id;
            rd1_id_ex <= rd1;
            rd2_id_ex <= rd2;
            ext_imm_id_ex <= ext_imm;
            func_id_ex <= instr_if_id(2 downto 0);
            sa_id_ex <= sa;
            final_wa_id_ex <= final_wa_if_id;
        end if;
    end if;
end process;
-----------

ALU: ALU_MIPS port map(rd1_id_ex, rd2_id_ex, ext_imm_id_ex, sa_id_ex, func_id_ex, ALUSrc_id_ex, ALUOp_id_ex, zero_id_ex, ALURes_id_ex);

-----3-----
process(clk)
begin
    if rising_edge(clk) then
        if btn_en_mpg = '1' then
            MemToReg_ex_mem <= MemToReg_id_ex;
            RegWrite_ex_mem <= RegWrite_id_ex;
            MemWrite_ex_mem <= MemWrite_id_ex;
            Branch_ex_mem <= Branch_id_ex;
            branchAdress_ex_mem <= branchAdress_id_ex;
            zero_ex_mem <= zero_id_ex;
            ALURes_ex_mem <= ALURes_id_ex;
            MemData_ex_mem <= rd2_id_ex;
            final_wa_ex_mem <= final_wa_id_ex;
        end if;
    end if;
end process;
-----------

Memory: MEM port map(MemWrite_ex_mem, btn_en_mpg, ALURes_ex_mem, rd2, MemData_ex_mem, ALURes_out_ex_mem, clk);

-----4-----
process(clk)
begin
    if rising_edge(clk) then
        if btn_en_mpg = '1' then
            MemToReg_mem_wb <= MemToReg_ex_mem;
            RegWrite_mem_wb <= RegWrite_ex_mem;
            MemData_mem_wb <= MemData;
            ALURes_out_mem_wb <= ALURes_out_ex_mem;
            final_wa_mem_wb <= final_wa_ex_mem;
        end if;
    end if;
end process;
-----------

process(MemToReg)
begin
    if (MemToReg = '1') then
        wd <= MemData_mem_wb;
    else
        wd <= ALURes_out_mem_wb;
    end if;
end process;

process(sw)
begin
    case sw is
        when "000" => afisare <= instr;
        when "001" => afisare <= pc;
        when "010" => afisare <= rd1;
        when "011" => afisare <= rd2;
        when "100" => afisare <= ext_imm;
        when "101" => afisare <= ALURes_id_ex;
        when "110" => afisare <= MemData;
        when "111" => afisare <= wd;
    end case; 
end process;

led(0) <= RegDst;
led(1) <= ExtOp;
led(2) <= ALUSrc;
led(3) <= Branch;
led(4) <= Jump;
led(6 downto 5) <= ALUOp;
led(7) <= MemWrite;
led(8) <= MemToReg;
led(9) <= RegWrite;
led(15 downto 10) <= "000000";

SSD1: SSD port map (cat, an, afisare(3 downto 0), afisare(7 downto 4), afisare(11 downto 8), afisare(15 downto 12), clk); 

end Behavioral;
