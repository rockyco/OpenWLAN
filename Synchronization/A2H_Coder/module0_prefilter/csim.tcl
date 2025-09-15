# Modern Vitis HLS Flow using open_component
open_component -reset module0_prefilter -flow_target vivado

# Add source files
add_files -cflags "-DPHASE6" module0_prefilter.cpp

# Add testbench files
add_files -tb -cflags "-DPHASE6" module0_prefilter_tb.cpp
add_files -tb ./HLS_GENERATION_COMPLETE.txt
add_files -tb ./HLS_OPTIMIZATION_COMPLETE.txt
add_files -tb ./module0_prefilter_p10_waiver.txt
add_files -tb ./module0_prefilter_p4_waiver.txt

# Set top function
set_top module0_prefilter

# Configure hardware
set_part {xc7z020clg400-1  }
create_clock -period 10.00ns
set_clock_uncertainty 12.5%

# Run C simulation
csim_design -clean

exit
