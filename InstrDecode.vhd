----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/21/2022 07:05:43 PM
-- Design Name: 
-- Module Name: IntrDecode - Behavioral
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

entity InstrDecode is
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
end InstrDecode;

architecture Behavioral of InstrDecode is

--signal wa : std_logic_vector(2 downto 0);

type mem_reg is array(0 to 255) of std_logic_vector(15 downto 0);
signal ad_reg : mem_reg := (
    x"0000",
    others => x"0000");

begin

process(RegDst)
begin
    if (RegDst = '0') then
        final_wa <= instr(9 downto 7);
    else
        final_wa <= instr(6 downto 4);
    end if;
end process;

process(clk)
begin
    if falling_edge(clk) then
        if btn_en = '1' then
            if (RegWr = '1') then
                ad_reg(conv_integer(wa)) <= wd;
            end if; 
        end if;
    end if;
end process;

rd1 <= ad_reg(conv_integer(instr(12 downto 10))); 
rd2 <= ad_reg(conv_integer(instr(9 downto 7)));

func <= instr(2 downto 0);
sa <= instr(3);

process(ExtOp)
begin
    if (ExtOp = '0') then
        ext_imm <= "000000000" & instr(6 downto 0);
     else 
        if (instr(6) = '1') then
            ext_imm <= "111111111" & instr(6 downto 0);
        else
            ext_imm <= "000000000" & instr(6 downto 0);
        end if;
     end if;
end process;

end Behavioral;
