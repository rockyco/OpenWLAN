# Modern Vitis HLS Flow using open_component
open_component module1_packet_detect -flow_target vivado

# Configure hardware (required for synthesis)
set_part {xc7z020clg400-1  }
create_clock -period 10.00ns

# Run C synthesis
csynth_design

exit
