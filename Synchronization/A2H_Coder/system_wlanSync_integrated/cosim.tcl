# Modern Vitis HLS Flow using open_component
open_component system_top -flow_target vivado

# Configure hardware (required for co-simulation)
set_part {xc7z020clg400-1  }
create_clock -period 10.00ns

# Add testbench files with COSIM_SMALL_DATASET preprocessor definition
# (source files are already in component from csynth)
add_files -tb -cflags "-DCOSIM_SMALL_DATASET" system_top_tb.cpp

# Run C/RTL co-simulation
cosim_design -rtl verilog -trace_level all

exit
