----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/16/2022 08:27:23 PM
-- Design Name: 
-- Module Name: Counter - Behavioral
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

entity Counter is
    Port ( clk : in STD_LOGIC;
           up : in std_logic;
           led : out STD_LOGIC_VECTOR (15 downto 0));
end Counter;

architecture Behavioral of Counter is
    signal cnt : std_logic_vector(15 downto 0) := x"0000";
    begin
    process(clk)
    begin
        if rising_edge(clk) then
            if up = '0' then
                cnt <= cnt + 1;
            else 
                cnt <= cnt - 1;
            end if;
        end if;
    end process;
    led <= cnt;
end Behavioral;