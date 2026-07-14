
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity PWM is
    Generic(
        BIT_DEPTH : integer := 8;
        INPUT_CLK : integer := 50000000;
        FREQ : integer := 50
    );
    Port (
        Pwm_Out : out std_logic;
        Duty_Cycle : in std_logic_vector(BIT_DEPTH - 1 downto 0);
        Clk : in std_logic;
        Enable : in std_logic
    );
end PWM;

architecture Behavioral of PWM is

constant max_freq_count : integer := INPUT_CLK / FREQ;
constant pwm_step : integer := max_freq_count / (2**BIT_DEPTH);

signal pwm_value : std_logic := '0';
signal freq_count : integer range 0 to max_freq_count := 0;
signal pwm_count : integer range 0 to 2**BIT_DEPTH := 0;
signal max_pwm_count : integer range 0 to 2**BIT_DEPTH := 0;
signal pwm_step_count : integer range 0 to max_freq_count := 0;

begin

    max_pwm_count <= to_integer(unsigned(Duty_Cycle));
    Pwm_Out <= pwm_value;
    
    freq_counter: process(Clk)
    begin
        if rising_edge(Clk) then

            if Enable = '1' then

                if freq_count < max_freq_count then
                    freq_count <= freq_count + 1;

                    if pwm_count < max_pwm_count then
                        pwm_value <= '1';
                    else
                        pwm_value <= '0';
                    end if;

                    if pwm_step_count < pwm_step then
                        pwm_step_count <= pwm_step_count + 1;
                    else
                        pwm_step_count <= 0;
                        pwm_count <= pwm_count + 1;
                    end if;

                else
                    freq_count <= 0;
                    pwm_count <= 0;
                    pwm_step_count <= 0;
                    pwm_value <= '0';
                end if;

            else
                freq_count <= 0;
                pwm_count <= 0;
                pwm_step_count <= 0;
                pwm_value <= '0';
            end if;

        end if;
    end process freq_counter;

end Behavioral;
