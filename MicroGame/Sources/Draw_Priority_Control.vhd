
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Draw_Priority_Control is
port(backData, fishData, linkData, herbData, boltData, lineData: in std_logic_vector(11 downto 0); 
enBackGround, enFish, enLink, enHerb, enBolt, enLine,clk : in std_logic; 
Red, Green, Blue: out std_logic_vector(3 downto 0));
end Draw_Priority_Control;

architecture Behavioral of Draw_Priority_Control is

begin

process(clk,enFish,enLink,enBolt,enHerb,enLine,enBackGround, fishData, linkData, boltData, herbData, lineData, backData)
begin
    if(enFish = '1') then
        Red <= fishData(11 downto 8);
        Green <= fishData(7 downto 4);
        Blue <= fishData(3 downto 0);
    elsif(enLink = '1') then
        Red <= linkData(11 downto 8);
        Green <= linkData(7 downto 4);
        Blue <= linkData(3 downto 0);
    elsif(enBolt = '1') then
        Red <= boltData(11 downto 8);
        Green <= boltData(7 downto 4);
        Blue <= boltData(3 downto 0);
    elsif(enHerb = '1') then
       Red <= herbData(11 downto 8);
       Green <= herbData (7 downto 4);
       Blue <= linkData(3 downto 0); 
    elsif(enLine = '1') then
        Red <= lineData(11 downto 8);
        Green <= lineData(7 downto 4);
        Blue <= lineData(3 downto 0); 
    --add new sprites here and change order to change priority. 
    elsif(enBackGround = '1') then
        Red <= backData(11 downto 8);
        Green <= backData(7 downto 4);
        Blue <= backData(3 downto 0);
    else
        Red <=  "0000";
        Green <= "0000";
        Blue <= "0000";
    end if;
end process;

end Behavioral;
