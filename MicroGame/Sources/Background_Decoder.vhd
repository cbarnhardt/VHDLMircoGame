library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity backGroundDecoder is
Port(dataIn: in std_logic_vector(1 downto 0); backGroundOut: out std_logic_vector(11 downto 0));
end backGroundDecoder;

architecture Behavioral of backGroundDecoder is

begin
backGroundOut <= "111111111111" when (dataIn = "11") else
                 "011110101010" when (dataIn = "10") else
                 "000000001010" when (dataIn = "01") else
                 "000000000000" when (dataIn = "00") else
                 "000000000000";     
end Behavioral;
