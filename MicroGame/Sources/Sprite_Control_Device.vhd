library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

--spriteOffSetX: integer := 335;
--spriteOffSetY: integer := 445;

entity Sprite_Control_Device is
generic(spriteWidth: integer := 100;
        spriteHeight: integer := 61;        
        keyColor: std_logic_vector(11 downto 0) := "111100001111");
         
port(hcount,vcount : in STD_LOGIC_VECTOR(10 downto 0);
     blank, pix_clk : in STD_LOGIC; 
     --spriteState: in std_logic_vector(3 downto 0);
     fromMem: in STD_LOGIC_VECTOR(11 downto 0);
     memAddr: out STD_LOGIC_VECTOR(18 downto 0); 
     imageDataOut: out std_logic_vector(11 downto 0); 
     spriteOffSetX, spriteOffSetY: in std_logic_vector(9 downto 0);
     en : out std_logic);
end Sprite_Control_Device;

architecture Behavioral of Sprite_Control_Device is
signal vcounter: integer range 0 to 480;
signal hcounter: integer range 0 to 640;
signal row, col: integer;
signal index: integer range 0 to 307200;
signal offSetX: integer;
signal offSetY: integer;

begin
vcounter <= to_integer(unsigned(vcount));
hcounter <= to_integer(unsigned(hcount));
offSetX  <= to_integer(unsigned(spriteOffSetX));
offSetY  <= to_integer(unsigned(spriteOffSetY));
index <= row + (col * spriteWidth);
row <= (hcounter - offSetX);
col <= (vcounter - offSetY);
memAddr <= std_logic_vector(to_signed(index, memAddr'length));
imageDataOut <= fromMem;
process(pix_clk,row,col,blank,fromMem)
begin
if(rising_edge(pix_clk)) then
if(row > 0 and row < spriteWidth and col > 0 and col < spriteHeight and blank = '0') then
    --imageDataOut <= fromMem;
    if(fromMem = keyColor) then 
        en <= '0';
    else 
        en <= '1';
    end if;
else
    en <= '0'; 
    
end if;
end if; 
end process;
end Behavioral;
