----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/28/2022 06:41:04 PM
-- Design Name: 
-- Module Name: ALU_MIPS - Behavioral
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

entity ALU_MIPS is
    Port ( rd1 : in STD_LOGIC_VECTOR (15 downto 0);
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           ext_imm : in STD_LOGIC_VECTOR (15 downto 0);
           sa : in STD_LOGIC;
           func : in STD_LOGIC_VECTOR (2 downto 0);
           ALUSrc : in STD_LOGIC;
           ALUOp : in STD_LOGIC_VECTOR (1 downto 0);
           zero : out STD_LOGIC;
           ALURes : out STD_LOGIC_VECTOR (15 downto 0));
end ALU_MIPS;

architecture Behavioral of ALU_MIPS is

signal ALUCtrl : std_logic_vector(2 downto 0);
signal alu_out : std_logic_vector(31 downto 0);
signal mux_out : std_logic_vector(15 downto 0);

begin

process(ALUSrc)
begin
    if (ALUSrc = '0') then
        mux_out <= rd2;
    else
        mux_out <= ext_imm;
    end if;
end process;

process(ALUOp)
begin
    case ALUOp is
        when "00" => ALUCtrl <= func;
        when "01" => ALUCtrl <= "000";
        when "10" => ALUCtrl <= "001";
        when "11" => ALUCtrl <= "110";
    end case;
end process;

process(ALUCtrl)
begin
    case ALUCtrl is
        when "000" => alu_out(15 downto 0) <= rd1 + mux_out;
        when "001" => alu_out(15 downto 0) <= rd1 - mux_out;
                      if (rd1 = mux_out) then
                            zero <= '1';
                      else
                            zero <= '0';
                      end if;
        when "010" => if (sa = '1') then 
                            alu_out(15 downto 0) <= rd1(14 downto 0) & '0';
                       else
                            alu_out(15 downto 0) <= rd1;
                       end if;
        when "011" => if (sa = '1') then 
                            alu_out(15 downto 0) <= '0' & rd1(15 downto 1);
                       else
                            alu_out(15 downto 0) <= rd1;
                       end if;
        when "100" => alu_out(15 downto 0) <= rd1 and mux_out;
        when "101" => alu_out(15 downto 0) <= rd1 or mux_out;
        when "110" => alu_out(15 downto 0) <= rd1 xor mux_out;
        when "111" => alu_out <= rd1 * mux_out;
    end case;
    ALURes <= alu_out(15 downto 0);
end process;

end Behavioral;
