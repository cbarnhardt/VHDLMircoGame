

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity staticsController is
port(clk: in std_logic; hcount, vcount : in std_logic_vector(10 downto 0); enBack, enFish, enHerb, enBolt: out std_logic ;state: in std_logic_vector(3 downto 0));
end staticsController;

architecture Behavioral of staticsController is

component blk_mem_gen_0
port(clka : IN STD_LOGIC; addra : IN STD_LOGIC_VECTOR(18 DOWNTO 0); douta : OUT STD_LOGIC_VECTOR(1 DOWNTO 0));
end component; 

component blk_mem_gen_1 
port(clka : in std_logic; addra : in std_logic_vector(12 downto 0); douta: out std_logic_vector(11 downto 0));
end component; 

component blk_mem_gen_2 
port(clka : in std_logic; addra: in std_logic_vector(12 downto 0); douta: out std_logic_vector(11 downto 0));
end component;

component blk_mem_gen_3
port(clka: in std_logic; addra: in std_logic_vector(11 downto 0); douta: out std_logic_vector(11 downto 0));
end component;

component backGroundDecoder
port(dataIn: in std_logic_vector(1 downto 0); backGroundOut: out std_logic_vector(11 downto 0));
end component;

component Sprite_Control_Device is
generic(spriteWidth: integer;
        spriteHeight: integer;
        keyColor: std_logic_vector(11 downto 0));
Port(hcount,vcount : in STD_LOGIC_VECTOR(10 downto 0); blank, pix_clk : in STD_LOGIC;
     spriteOffSetX, spriteOffSetY: in std_logic_vector(9 downto 0);
     fromMem: in STD_LOGIC_VECTOR(11 downto 0); 
     memAddr: out STD_LOGIC_VECTOR(18 downto 0);
     imageDataOut: out std_logic_vector(11 downto 0);
     en: out std_logic);
end component;

signal 

begin


end Behavioral;
