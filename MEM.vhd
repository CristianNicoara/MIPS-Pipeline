----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/04/2022 03:28:06 PM
-- Design Name: 
-- Module Name: MEM - Behavioral
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

entity MEM is
    Port ( MemWrite : in STD_LOGIC;
           btn_en : in std_logic;
           ALURes : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           MemData : out STD_LOGIC_VECTOR (15 downto 0);
           ALURes_out : out STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC);
end MEM;

architecture Behavioral of MEM is

type mem_ram is array(0 to 255) of std_logic_vector(15 downto 0);
signal ad_ram : mem_ram := (
    x"0000",
    others => x"0000");

begin

process(clk)
begin
    if rising_edge(clk) then
        if btn_en = '1' then
            if MemWrite = '1' then
                ad_ram(conv_integer(ALURes)) <= RD2;
            end if;
        end if;
    end if;
end process;

MemData <= ad_ram(conv_integer(ALURes));

ALURes_out <= ALURes; 

end Behavioral;
