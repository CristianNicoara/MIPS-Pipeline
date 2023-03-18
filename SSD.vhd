----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/21/2022 06:29:24 PM
-- Design Name: 
-- Module Name: Afisare_7SD - Behavioral
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

entity SSD is
    Port ( cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           digit0 : in STD_LOGIC_VECTOR (3 downto 0);
           digit1 : in STD_LOGIC_VECTOR (3 downto 0);
           digit2 : in STD_LOGIC_VECTOR (3 downto 0);
           digit3 : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in std_logic);
end SSD;

architecture Behavioral of SSD is

component Counter is
    Port ( clk : in STD_LOGIC;
           up : in std_logic;
           led : out STD_LOGIC_VECTOR (15 downto 0));
end component;

signal cnt_signal : std_logic_vector(15 downto 0) := x"0000";
signal mux_out : std_logic_vector(3 downto 0);
begin
C1: Counter port map (clk,'0',cnt_signal);

process(cnt_signal(15 downto 14))
begin
    case cnt_signal(15 downto 14) is
        when "00" => mux_out <= digit0;
        when "01" => mux_out <= digit1;
        when "10" => mux_out <= digit2;
        when "11" => mux_out <= digit3;
    end case;
end process;

with mux_out select
   cat<= "1111001" when "0001",   --1
         "0100100" when "0010",   --2
         "0110000" when "0011",   --3
         "0011001" when "0100",   --4
         "0010010" when "0101",   --5
         "0000010" when "0110",   --6
         "1111000" when "0111",   --7
         "0000000" when "1000",   --8
         "0010000" when "1001",   --9
         "0001000" when "1010",   --A
         "0000011" when "1011",   --b
         "1000110" when "1100",   --C
         "0100001" when "1101",   --d
         "0000110" when "1110",   --E
         "0001110" when "1111",   --F
         "1000000" when others;   --0
    

process(cnt_signal(15 downto 14))
begin
    case cnt_signal(15 downto 14) is
        when "00" => an <= "1110";
        when "01" => an <= "1101";
        when "10" => an <= "1011";
        when "11" => an <= "0111";
    end case;
end process;

end Behavioral;
