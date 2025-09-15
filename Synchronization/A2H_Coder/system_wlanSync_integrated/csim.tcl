# Modern Vitis HLS Flow using open_component
open_component -reset system_top -flow_target vivado

# Add source files
add_files -cflags "-DPHASE6" system_top.cpp
add_files -cflags "-DPHASE6" ../module0_prefilter/module0_prefilter.cpp
add_files -cflags "-DPHASE6" ../module1_packet_detect/module1_packet_detect.cpp
add_files -cflags "-DPHASE6" ../module2_coarse_cfo/module2_coarse_cfo.cpp
add_files -cflags "-DPHASE6" ../module3_fine_sync/module3_fine_sync.cpp
add_files -cflags "-DPHASE6" ../module4_fine_cfo_apply/module4_fine_cfo_apply.cpp

# Add testbench files
add_files -tb -cflags "-DPHASE6" system_top_tb.cpp

# Set top function
set_top system_top

# Configure hardware
set_part {xc7z020clg400-1  }
create_clock -period 10.00ns
set_clock_uncertainty 12.5%

# Run C simulation
csim_design -clean

exit
