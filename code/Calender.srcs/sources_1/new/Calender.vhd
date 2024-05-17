----------------------------------------------------------------------------------
-- Company: University Of Regina
-- Engineer in Training: Amandip Padda
-- 
-- Create Date: 11/29/2022 05:24:54 PM
-- Design Name: Calender Implementation
-- Module Name: Calender - Behavioral
-- Project Name: Calender Implementation
-- Target Devices: FPGA
-- Tool Versions: N/A
-- Description: Calender to display the amount of days in each month
-- 
-- Dependencies: N/A
-- 
-- Revision: None
-- Revision 0.01 - File Created
-- Additional Comments: N/A
-- 
----------------------------------------------------------------------------------

-- libraries used
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Ports
entity Calender is
    Port (clk  : in std_logic ; -- clk port 
         power : in std_logic; -- power switch 1
         leap  : in std_logic; -- leap switch 
       special : in std_logic; -- special switch 3
        oneled : out std_logic ; -- 31 day
       zeroled : out std_logic; -- 30 day
       nineled : out std_logic; -- 29 day
      eightled : out std_logic; -- 28 day
           led : out  std_logic_vector (11 downto 0)); -- all other 12 leds
end Calender;

architecture Behavioral of Calender is
    signal clock_divider :std_logic_vector (26 downto 0) := "000000000000000000000000000"; -- clocking speed
    signal month_register : std_logic_vector (11 downto 0) := "000000000001"; -- month register shifting
begin

    process (clk) -- process to slow the clock down
    begin
        if (clk'event and clk = '1') then
            clock_divider <= clock_divider + '1';
        end if;
    end process;
    
    process (clock_divider(26)) -- process to shift months with slowed clock passed down
    begin
    if(power = '1') then
        if (clock_divider(26)'event and clock_divider(26) = '1') then -- shifting through months
            month_register(1) <= month_register(0);
            month_register(2) <= month_register(1);
            month_register(3) <= month_register(2);
            month_register(4) <= month_register(3);
            month_register(5) <= month_register(4);
            month_register(6) <= month_register(5);
            month_register(7) <= month_register(6);
            month_register(8) <= month_register(7);
            month_register(9) <= month_register(8);
            month_register(10) <= month_register(9);
            month_register(11) <= month_register(10);
            month_register(0) <= month_register(11);
        end if;
    end if;
    
            -- condition statement for 31 day months
            if(month_register(0) = '1' or month_register(2) = '1' or month_register(4) = '1' or month_register(6) = '1' or month_register(7) = '1' or month_register(9) = '1' or month_register(11) = '1') then
            zeroled <= '0';
            nineled <= '0';
            eightled <= '0';
            oneled <= '1';
            end if;
            
            -- condition statement for 30 day months
            if(month_register(3) = '1' or month_register(5) = '1' or month_register(8) = '1' or month_register(10) = '1') then
            nineled <= '0';
            eightled <= '0';
            oneled <= '0';
            zeroled <= '1';
            end if;
            
            -- condition for 29 day month
            if(month_register(1) = '1' and leap = '1') then
            eightled <= '0';
            zeroled <= '0';
            oneled <= '0';
            nineled <= '1';
            
            -- condition for 29 day month
            else if(month_register(1) = '1') then
            zeroled <= '0';
            oneled <= '0';
            nineled <= '0';
            eightled <= '1';
            end if;  
            end if;
            
            -- birthday condition for all leds
            if(month_register(5) = '1' and special = '1') then
            oneled <= '1';
            zeroled <= '1';
            nineled <= '1';
            eightled <= '1';
            end if;

end process;
            led <= month_register;

end Behavioral;
