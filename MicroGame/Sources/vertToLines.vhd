
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity vertToLines is
generic(row1: integer := 398; 
rowSpacing: integer := 44; 
col1 : integer := 429; 
colSpacing: integer := 42);

Port(clk, lineReady: in std_logic; x1,x2,x3,x4,x5,x6,x7,y1,y2,y3,y4,y5,y6,y7: in integer range 0 to 5;
hcount, vcount :in std_logic_vector(10 downto 0); en: out std_logic; color: out std_logic_vector(11 downto 0);
xc1, xc2, xc3, xc4, xc5, xc6, xc7, yc1, yc2, yc3, yc4, yc5, yc6, yc7 : out integer range 0 to 640);
end vertToLines;

architecture Behavioral of vertToLines is

signal xI1, xI2, xI3, xI4, xI5, xI6, xI7, yI1, yI2, yI3, yI4, yI5, yI6, yI7 : integer range 0 to 640; 
signal Ihcount, Ivcount : integer range 0 to 640;
begin

xI1 <= col1 - (x1*colSpacing); 
xI2 <= col1 - (x2*colSpacing);
xI3 <= col1 - (x3*colSpacing);
xI4 <= col1 - (x4*colSpacing);
xI5 <= col1 - (x5*colSpacing);
xI6 <= col1 - (x6*colSpacing);
xI7 <= col1 - (x7*colSpacing);
yI1 <= row1 - (y1*rowSpacing);
yI2 <= row1 - (y2*rowSpacing);
yI3 <= row1 - (y3*rowSpacing);
yI4 <= row1 - (y4*rowSpacing);
yI5 <= row1 - (y5*rowSpacing);
yI6 <= row1 - (y6*rowSpacing);
yI7 <= row1 - (y7*rowSpacing);

xc1 <= xI1;
xc2 <= xI2;
xc3 <= xI3; 
xc4 <= xI4; 
xc5 <= xI5;
xc6 <= xI6;
xc7 <= xI7;

yc1 <= yI1;
yc2 <= yI2;
yc3 <= yI3;
yc4 <= yI4;
yc5 <= yI5;
yc6 <= yI6;
yc7 <= yI7;


Ihcount <= to_integer(unsigned(hcount));
Ivcount <= to_integer(unsigned(vcount));

process(clk,lineReady,Ihcount, Ivcount, xI1, xI2, xI3, xI4, xI5, xI6, xI7, yI1, yI2, yI3, yI4, yI5, yI6, yI7)
begin

if(lineReady ='1') then
    if((Ivcount < (yI1 + 1)) and (Ivcount > yI1 - 1) and (Ihcount < row1 + 1) and (Ihcount > xI1 - 1)) then
    color <= "111111111111";  
    en <= '1'; 
    end if;
    
    if(Ihcount < (xI1 + 1) and Ihcount > (xI1 - 1) and Ivcount < yI1 and Ivcount > yI2) then
    color <= "111111111111";
    en <= '1';
    end if;
    
    if((Ivcount < (yI2 + 1)) and (Ivcount > (yI2 - 1)) and (Ihcount < xI3 + 1) and (Ihcount > xI2 - 1)) then
        color <= "111111111111";
        en <= '1';
    end if;
    
    if((Ivcount < (yI2 + 1)) and (Ivcount > (yI2 - 1)) and (Ihcount > xI3 - 1) and (Ihcount < xI2 + 1)) then
        color <= "111111111111";
        en <= '1';
    end if;
    
    if(Ihcount < (xI3 + 1) and Ihcount > (xI3 - 1) and Ivcount < yI3 and Ivcount > yI4) then
    color <= "111111111111";
    en <= '1';
    end if;
    
    if(Ihcount < (xI3 + 1) and Ihcount > (xI3 - 1) and Ivcount > yI3 and Ivcount < yI4) then
    color <= "111111111111";
    en <= '1';
    end if;
    
    
    if((Ivcount < (yI4 + 1)) and (Ivcount > (yI4-1)) and (Ihcount < xI5 + 1) and (Ihcount > xI4 - 1)) then
    color <= "111111111111";
    en <= '1';
    end if;
    
    if((Ivcount < (yI4 + 1)) and (Ivcount > (yI4-1)) and (Ihcount > xI5 - 1) and (Ihcount < xI4 + 1)) then
    color <= "111111111111";
    en <= '1';
    end if;
    
    if(Ihcount < (xI5 + 1) and Ihcount > (xI5 - 1) and Ivcount < yI5 and Ivcount > yI6) then
    color <= "111111111111";
    en <= '1';
    end if;
    
    if(Ihcount < (xI5 + 1) and Ihcount > (xI5 - 1) and Ivcount > yI5 and Ivcount < yI6) then
    color <= "111111111111";
    en <= '1';
    end if;
    
    if((Ivcount < (yI6 + 1)) and (Ivcount > (yI6-1)) and (Ihcount < xI6 + 1) and (Ihcount > xI7 - 1)) then
    color <= "111111111111";
    en <= '1';
    end if;
    
    if((Ivcount < (yI6 + 1)) and (Ivcount > (yI6-1)) and (Ihcount > xI6 - 1) and (Ihcount < xI7 + 1)) then
    color <= "111111111111";
    en <= '1';
    end if;
    
    if(Ihcount < (xI7 + 1) and Ihcount > (xI7 - 1) and Ivcount > 175 and Ivcount < yI7) then
    color <= "111111111111";
    en <= '1';
    end if;
else
en <= '0';
color <= "111100001111";
end if;

--if(vcount < (yI2 + 3) and vcount > yI2 and 
end process; 
end Behavioral;
