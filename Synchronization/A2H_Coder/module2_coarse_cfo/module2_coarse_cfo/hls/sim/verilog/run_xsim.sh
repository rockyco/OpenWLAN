
/opt/Xilinx/Vivado/2024.2/bin/xelab xil_defaultlib.apatb_module2_coarse_cfo_top glbl -Oenable_linking_all_libraries  -prj module2_coarse_cfo.prj -L smartconnect_v1_0 -L axi_protocol_checker_v1_1_12 -L axi_protocol_checker_v1_1_13 -L axis_protocol_checker_v1_1_11 -L axis_protocol_checker_v1_1_12 -L xil_defaultlib -L unisims_ver -L xpm  -L floating_point_v7_0_24 -L floating_point_v7_1_19 --lib "ieee_proposed=./ieee_proposed" -s module2_coarse_cfo -debug all
/opt/Xilinx/Vivado/2024.2/bin/xsim --noieeewarnings module2_coarse_cfo -tclbatch module2_coarse_cfo.tcl -view module2_coarse_cfo_dataflow_ana.wcfg -protoinst module2_coarse_cfo.protoinst

