----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/04/2022 03:49:06 PM
-- Design Name: 
-- Module Name: MC - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MC is
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
end MC;

architecture Behavioral of MC is

begin

process(instr)
begin

RegDst <= '0';
ExtOp <= '0';
ALUSrc <= '0';
Branch <= '0';
Jump <= '0';
ALUOp <= "00";
MemWrite <= '0';
MemToReg <= '0';
RegWrite <= '0';

case instr is
    when "000" => RegDst <= '1';
                  RegWrite <= '1';
    when "001" => ExtOp <= '1';
                  ALUSrc <= '1';
                  ALUOp <= "01";
                  RegWrite <= '1';
    when "010" => ExtOp <= '1';
                  ALUSrc <= '1';
                  ALUOp <= "01";
                  MemToReg <= '1';
                  RegWrite <= '1';
    when "011" => ExtOp <= '1';
                  ALUSrc <= '1';
                  ALUOp <= "01";
                  MemWrite <= '1';
    when "100" => ExtOp <= '1';
                  ALUOp <= "10";
                  Branch <= '1';
    when "101" => ALUsrc <= '1';
                  ALUOp <= "11";
                  RegWrite <= '1';
    when "110" => ExtOp <= '1';
                  ALUsrc <= '1';
                  ALUOp <= "10";
                  RegWrite <= '1';
    when "111" => Jump <= '1';
end case;

end process;

end Behavioral;
