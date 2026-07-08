----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/29/2026 09:00:06 PM
-- Design Name: 
-- Module Name: LED_BRIGHTNESS - Behavioral
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
use IEEE.numeric_std.ALL;

entity LED_BRIGHTNESS is
    Generic (
        INPUT_CLK : integer := 100000000;
        NUM_LEDS  : integer := 4
    );
    Port (
        Led_Out    : out std_logic_vector(NUM_LEDS - 1 downto 0);
        Clk        : in std_logic;
        LED_Enable : in std_logic
    );
end entity LED_BRIGHTNESS;

architecture Behavioral of LED_BRIGHTNESS is

component PWM
    Generic (
        BIT_DEPTH : integer := 8;
        INPUT_CLK : integer := 50000000;
        FREQ      : integer := 50
    );
    Port (
        Pwm_Out    : out std_logic;
        Duty_Cycle : in std_logic_vector(BIT_DEPTH - 1 downto 0);
        Clk        : in std_logic;
        Enable     : in std_logic
    );
end component;

component COUNTER
    Generic (
        MAX_VAL     : integer := 2**30;
        SYNCH_Reset : boolean := true
    );
    Port (
        Max_Count : out std_logic;
        Clk       : in std_logic;
        Reset     : in std_logic
    ); 
end component;

constant LED_MAX_COUNT : integer := INPUT_CLK / 85;
constant SYN_RESET     : boolean := true;
constant MAX_LED_DUTY  : integer := 225;

signal led_max_cnt     : std_logic := '0';
signal led_pwm_reg     : std_logic := '0';
signal led_counter_rst : std_logic := '0';
signal led_duty_cycle  : unsigned(7 downto 0) := (others => '0');

begin

Led_Out <= (others => led_pwm_reg);

led_counter_rst <=  LED_Enable;

LED_COUNTER : COUNTER
    generic map (
        MAX_VAL     => LED_MAX_COUNT,
        SYNCH_Reset => SYN_RESET
    )
    port map (
        Max_Count => led_max_cnt,
        Clk       => Clk,
        Reset     => led_counter_rst
    );
   
LED_PWM : PWM
    generic map (
        BIT_DEPTH => 8,
        INPUT_CLK => INPUT_CLK,
        FREQ      => 50
    )
    port map (
        Pwm_Out    => led_pwm_reg,
        Duty_Cycle => std_logic_vector(led_duty_cycle),
        Clk        => Clk,
        Enable     => LED_Enable
    );

Led_Count_Proc : process(Clk)
begin
    if rising_edge(Clk) then
        if led_duty_cycle = to_unsigned(MAX_LED_DUTY, led_duty_cycle'length) then
            led_duty_cycle <= (others => '0');
        elsif led_max_cnt = '1' then 
            led_duty_cycle <= led_duty_cycle + 1;
        end if;
    end if;
end process Led_Count_Proc;

end Behavioral;
