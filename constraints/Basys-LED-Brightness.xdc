## Clock - Basys 3 100 MHz
set_property PACKAGE_PIN W5 [get_ports Clk]
set_property IOSTANDARD LVCMOS33 [get_ports Clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports Clk]

## Switch SW0 - LED Enable
set_property PACKAGE_PIN V17 [get_ports LED_Enable]
set_property IOSTANDARD LVCMOS33 [get_ports LED_Enable]

## LEDs LD0-LD3
set_property PACKAGE_PIN U16 [get_ports {Led_Out[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Led_Out[0]}]

set_property PACKAGE_PIN E19 [get_ports {Led_Out[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Led_Out[1]}]

set_property PACKAGE_PIN U19 [get_ports {Led_Out[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Led_Out[2]}]

set_property PACKAGE_PIN V19 [get_ports {Led_Out[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Led_Out[3]}]
