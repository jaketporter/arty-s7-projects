# Clock
set_property PACKAGE_PIN R2 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 [get_ports clk]

# Reset button
set_property PACKAGE_PIN C18 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

# Send button (BTN0)
set_property PACKAGE_PIN G15 [get_ports send]
set_property IOSTANDARD LVCMOS33 [get_ports send]

# UART TX
set_property PACKAGE_PIN R12 [get_ports serialout]
set_property IOSTANDARD LVCMOS33 [get_ports serialout]

# Busy LED (LD2)
set_property PACKAGE_PIN E18 [get_ports busy]
set_property IOSTANDARD LVCMOS33 [get_ports busy]

