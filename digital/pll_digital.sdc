create_clock -name clk     -period 100 [get_ports clk]
create_clock -name vco_clk -period 9   [get_ports vco_clk]
set_clock_groups -asynchronous -group {clk} -group {vco_clk}
set_clock_uncertainty 0.25 [all_clocks]
set_clock_transition 0.15 [all_clocks]
set_input_delay  5 -clock clk [get_ports {rst_n kp_sel* ki_sel*}]
set_output_delay 5 -clock clk [get_ports {code* lock}]
set_output_delay 2 -clock vco_clk [get_ports clk_out]
set_load 0.07 [all_outputs]
