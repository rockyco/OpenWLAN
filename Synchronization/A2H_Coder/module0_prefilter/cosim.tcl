# Modern Vitis HLS Flow using open_component
open_component module0_prefilter -flow_target vivado

# Configure hardware (required for co-simulation)
set_part {xc7z020clg400-1  }
create_clock -period 10.00ns

# Add testbench files with COSIM_SMALL_DATASET preprocessor definition
# (source files are already in component from csynth)
add_files -tb -cflags "-DCOSIM_SMALL_DATASET" module0_prefilter_tb.cpp
add_files -tb ./HLS_GENERATION_COMPLETE.txt
add_files -tb ./HLS_OPTIMIZATION_COMPLETE.txt
add_files -tb ./module0_prefilter_p10_waiver.txt
add_files -tb ./module0_prefilter_p4_waiver.txt

# Run C/RTL co-simulation
cosim_design -rtl verilog -trace_level all

exit
