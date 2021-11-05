
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;


entity boltControl is
generic(rateDefault: integer := 1000000;
rowSpacing: integer := 44; 
col1 : integer := 429; 
colSpacing: integer := 42);
Port(up, down, left, right, clkIn, reset: in std_logic; 
x1, x2, x3, x4, x5, x6, x7, y1, y2, y3, y4, y5, y6, y7: in integer range 0 to 640; 
xLocation, yLocation: out std_logic_vector(9 downto 0); linked: out std_logic);
end boltControl;

architecture Behavioral of boltControl is

type state_type is (resetState, firstSeg, secondSeg, thirdSeg, fourthSeg, fifthSeg, sixthSeg, seventhSeg, eigthSeg, endLine);

signal upReg, downReg, leftReg, rightReg: std_logic;
signal tempY: integer range 0 to 480;
signal tempX: integer range 0 to 640;
signal currentState, nextState: state_type; 

begin
xLocation <= std_logic_vector(to_unsigned(tempX, xLocation'length));
yLocation <= std_logic_vector(to_unsigned(tempY, yLocation'length));

sreg: process(clkIn) 
begin 
if(reset = '1') then
currentState <= resetState;
elsif(rising_edge(clkIn)) then
currentState <= nextState; 
end if;
end process;

M1: process(clkIn, tempY, tempX, x1, x2, x3, x4, x5, x6, x7, y1, y2, y3, y4, y5, y6, y7) 
begin
case currentState is

when resetState =>

if(leftReg = '1') then
    nextState <= firstSeg;
else
    nextState <= resetState;

end if;

when firstSeg  => 
    if((tempX + 10)<= x1) then 
    nextState <= secondSeg;
    else
    nextState <= firstSeg;
    end if;
when secondSeg =>  
    if(tempY + 15 <= y2) then
    nextState <= thirdSeg;
    else 
    nextState <= secondSeg;
    end if;
when thirdSeg =>
    if(x2 > x3) then
    if(tempX + 10 <= x3) then
    nextState <= fourthSeg;
    else
    nextState <= thirdSeg;
    end if;
    else
    if(tempX + 10 >= x3) then
    nextState <= fourthSeg;
    else
    nextState <= thirdSeg;
    end if;
    end if;
when fourthSeg => 
    if(y3 > y4) then
    if(tempY + 15 <= y4) then
    nextState <= fifthSeg; 
    else
    nextState <= fourthSeg;
    end if;
    else
     if(tempY + 15 >= y4) then
    nextState <= fifthSeg; 
    else
    nextState <= fourthSeg;
    end if;
    end if;
when fifthSeg => 
    if(x4 > x5) then
    if(tempX + 10 <= x5) then
    nextState <= sixthSeg;
    else
    nextState <= fifthSeg;
    end if;
    else
    if(tempX + 10 >= x5) then
    nextState <= sixthSeg;
    else
    nextState <= fifthSeg;
    end if;
    end if;
when sixthSeg =>
    if(y5 > y6) then
    if(tempY + 15 <= y6) then
    nextState <= seventhSeg; 
    else
    nextState <= sixthSeg;
    end if;
    else
     if(tempY + 15>= y6) then
    nextState <= seventhSeg; 
    else
    nextState <= sixthSeg;
    end if;
    end if;
    
when seventhSeg => 
    if(x6 > x7) then
        if(tempX + 10 <= x7) then
        nextState <= eigthSeg;
        else
        nextState <= seventhSeg;
        end if;
    else
        if(tempX +10 >= x7) then
        nextState <= eigthSeg;
        else
        nextState <= seventhSeg;
        end if;
    end if;
when eigthSeg => 
    if(tempY + 15 <= 175) then
    nextState <= endLine;
    else
    nextState <= eigthSeg;
    end if;
when endLine =>
nextState <= endLine; 
when others => 
    nextState <= resetState;
end case;
end process;


--(resetState, firstSeg, secondSeg, thirdSeg, 
--fourthSeg, fifthSeg, sixthSeg, seventhSeg, eigthSeg, endLine);


btnHandler: process(clkIn, up, down, left, right, tempX, tempY)
begin 
if(rising_edge(clkIn)) then
if(currentState = resetState) then
    if(left = '1') then
        leftReg <= '1'; 
    else 
        leftReg <= '0';
        upReg <= '0';
        downReg <= '0';
        rightReg <= '0';
    end if; 
elsif(currentState = firstSeg) then
    if(left = '1' and (tempX + 10) >= x1) then 
        leftReg <= '1';
         upReg <= '0';
        downReg <= '0';
        rightReg <= '0';   
    else 
        leftReg <= '0';
         upReg <= '0';
        downReg <= '0';
        rightReg <= '0';
    end if;  
elsif(currentState = secondSeg) then
    if(up ='1' and tempY + 15 >= y2) then
        upReg <= '1';
        downReg <= '0';
        rightReg <= '0';
        leftReg <= '0';
    else
        upReg <= '0';
        downReg <= '0';
        rightReg <= '0';
        leftReg <= '0';
    end if;
elsif(currentState = thirdSeg) then
    if(x2 > x3) then 
    if(left = '1' and (tempX + 10) >= x3) then 
        leftReg <= '1';
         upReg <= '0';
        downReg <= '0';
        rightReg <= '0';
    else 
        leftReg <= '0';
         upReg <= '0';
        downReg <= '0';
        rightReg <= '0';
    end if;
    else
    if(right = '1' and (tempX + 10) <= x3) then 
        leftReg <= '0';
         upReg <= '0';
        downReg <= '0';
        rightReg <= '1';
    else 
        leftReg <= '0';
         upReg <= '0';
        downReg <= '0';
        rightReg <= '0';
    end if;
    end if; 
elsif(currentState = fourthSeg) then
    if(y3 > y4) then
    if(up = '1' and tempY + 15 >= y4) then
        upReg <= '1';
        leftReg <= '0';
        downReg <= '0';
        rightReg <= '0';
    else
      leftReg <= '0';
         upReg <= '0';
        downReg <= '0';
        rightReg <= '0';
    end if;
    else
    if(down = '1' and tempY + 15 <= y4) then
    downReg <= '1';
     leftReg <= '0';
        upReg <= '0';
        rightReg <= '0';
    else 
        leftReg <= '0';
        upReg <= '0';
        downReg <= '0';
        rightReg <= '0';
    end if;
    end if;
elsif(currentState = fifthSeg) then
    if(x4 > x5) then 
    if(left = '1' and (tempX + 10) >= x5) then 
        leftReg <= '1';
         upReg <= '0';
        downReg <= '0';
        rightReg <= '0';
    else 
        leftReg <= '0';
         upReg <= '0';
        downReg <= '0';
        rightReg <= '0';
    end if;
    else
    if(right = '1' and (tempX + 10) <= x5) then 
        leftReg <= '0';
         upReg <= '0';
        downReg <= '0';
        rightReg <= '1';
    else 
        leftReg <= '0';
         upReg <= '0';
        downReg <= '0';
        rightReg <= '0';
    end if;
    end if; 
elsif(currentState = sixthSeg) then
    if(y5 > y6) then
    if(up = '1' and tempY + 15 >= y6) then
        upReg <= '1';
        leftReg <= '0';
        downReg <= '0';
        rightReg <= '0';
    else
      leftReg <= '0';
         upReg <= '0';
        downReg <= '0';
        rightReg <= '0';
    end if;
    else
    if(down = '1' and tempY + 15 <= y6) then
    downReg <= '1';
     leftReg <= '0';
        upReg <= '0';
        rightReg <= '0';
    else 
        leftReg <= '0';
        upReg <= '0';
        downReg <= '0';
        rightReg <= '0';
    end if;
    end if;
elsif(currentState = seventhSeg) then
       if(x6 > x7) then 
    if(left = '1' and (tempX+10) >= x7) then 
        leftReg <= '1';
         upReg <= '0';
        downReg <= '0';
        rightReg <= '0';
    else 
        leftReg <= '0';
         upReg <= '0';
        downReg <= '0';
        rightReg <= '0';
    end if;
    else
    if(right = '1' and (tempX+10) <= x7) then 
        leftReg <= '0';
         upReg <= '0';
        downReg <= '0';
        rightReg <= '1';
    else 
        leftReg <= '0';
         upReg <= '0';
        downReg <= '0';
        rightReg <= '0';
    end if;
    end if; 
elsif(currentState = eigthSeg) then 
 if(up ='1' and tempY + 15 >= 175) then
        upReg <= '1';
        downReg <= '0';
        rightReg <= '0';
        leftReg <= '0';
    else
        upReg <= '0';
        downReg <= '0';
        rightReg <= '0';
        leftReg <= '0';
    end if;
else
    upReg <= '0';
    downReg <= '0';
    leftReg <= '0';
    rightReg <= '0';
end if;

--    if(up = '1') then
--        upReg <= '1'; 
--    elsif(down = '1') then
--        downReg <= '1';
--    elsif(left = '1') then
--        leftReg <= '1';
--    elsif(right = '1') then
--        rightReg <= '1';
----    else
----    upReg <= '0';
----    rightReg <= '0';
----    leftReg <= '0';
----    downReg <= '0';
--    end if; 
    
--    if(up = '0') then
--        upReg <= '0'; 
--    end if;
--    if(down = '0') then
--        downReg <= '0';
--    end if;
--    if(left = '0') then
--        leftReg <= '0';
--    end if;
--    if(right = '0') then
--        rightReg <= '0';
--    end if; 
end if;
end process; 

logic: process(clkIn, rightReg, leftReg, downReg, upReg) 
variable counter: integer range 0 to 100000000;
begin 
if(rising_edge(clkIn)) then
counter := counter + 1;
    if(counter = rateDefault) then
    counter := 0;
      if(not(currentState = resetState or currentState = endLine)) then
        if(upReg = '1') then 
            tempY <= tempY - 1;
        elsif(rightReg = '1') then
            tempX <= tempX + 1;
        elsif(leftReg = '1') then
            tempX <= tempX - 1;
        elsif(downReg = '1') then
            tempY <= tempY + 1;
        else
            tempY <= tempY;
            tempX <= tempX; 
        end if;      
      elsif(currentState = endLine) then
             tempY <= tempY;
             tempX <= tempX;
             linked <= '1';
      else
          tempX <= 425;
          tempY <= 377;
          linked <= '0';
      end if;
    else
    tempY <= tempY;
    tempX <= tempX; 
    linked <= '0';
    end if;
end if;
end process;
end Behavioral;
