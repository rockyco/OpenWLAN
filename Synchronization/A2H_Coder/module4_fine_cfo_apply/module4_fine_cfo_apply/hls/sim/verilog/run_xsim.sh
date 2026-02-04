
/opt/Xilinx/Vivado/2024.2/bin/xelab xil_defaultlib.apatb_module4_fine_cfo_apply_top glbl -Oenable_linking_all_libraries  -prj module4_fine_cfo_apply.prj -L smartconnect_v1_0 -L axi_protocol_checker_v1_1_12 -L axi_protocol_checker_v1_1_13 -L axis_protocol_checker_v1_1_11 -L axis_protocol_checker_v1_1_12 -L xil_defaultlib -L unisims_ver -L xpm  -L floating_point_v7_0_24 -L floating_point_v7_1_19 --lib "ieee_proposed=./ieee_proposed" -s module4_fine_cfo_apply -debug all
/opt/Xilinx/Vivado/2024.2/bin/xsim --noieeewarnings module4_fine_cfo_apply -tclbatch module4_fine_cfo_apply.tcl -view module4_fine_cfo_apply_dataflow_ana.wcfg -protoinst module4_fine_cfo_apply.protoinst

