# Modern Vitis HLS Flow using open_component
open_component -reset module1_packet_detect -flow_target vivado

# Add source files
add_files module1_packet_detect.cpp

# Add testbench files
add_files -tb module1_packet_detect_tb.cpp
add_files -tb ./HLS_GENERATION_COMPLETE.txt
add_files -tb ./HLS_OPTIMIZATION_COMPLETE.txt
add_files -tb ./module1_packet_detect_p10_waiver.txt

# Set top function
set_top module1_packet_detect

# Configure hardware
set_part {xc7z020clg400-1  }
create_clock -period 10.00ns
set_clock_uncertainty 12.5%

# Run C simulation
csim_design -clean

exit
