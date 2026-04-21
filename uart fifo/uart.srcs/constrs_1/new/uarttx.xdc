# Clock (100MHz)
set_property PACKAGE_PIN R2 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 [get_ports clk]

# Reset button (Active Low)
set_property PACKAGE_PIN C18 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

# UART TX 
set_property PACKAGE_PIN R12 [get_ports usb_tx]
set_property IOSTANDARD LVCMOS33 [get_ports usb_tx]

# UART RX 
set_property PACKAGE_PIN V12 [get_ports usb_rx]
set_property IOSTANDARD LVCMOS33 [get_ports usb_rx]

# Optional LEDs for Status
set_property PACKAGE_PIN E18 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]

set_property PACKAGE_PIN F13 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]

set_property PACKAGE_PIN E13 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]

set_property PACKAGE_PIN H15 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]