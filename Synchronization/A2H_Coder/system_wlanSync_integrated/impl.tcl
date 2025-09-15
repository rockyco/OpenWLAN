# Modern Vitis HLS Flow using open_component
open_component system_top -flow_target vivado

# Configure hardware (required for implementation)
set_part {xc7z020clg400-1  }

# Export design for implementation (uses existing synthesis)
export_design -flow impl -rtl verilog -format ip_catalog

exit
