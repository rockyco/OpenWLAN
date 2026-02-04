
log_wave -r /
set designtopgroup [add_wave_group "Design Top Signals"]
set coutputgroup [add_wave_group "C Outputs" -into $designtopgroup]
set return_group [add_wave_group return(fifo) -into $coutputgroup]
add_wave /apatb_module0_prefilter_top/AESL_inst_module0_prefilter/filteredLen_out_write -into $return_group -color #ffff00 -radix hex
add_wave /apatb_module0_prefilter_top/AESL_inst_module0_prefilter/filteredLen_out_full_n -into $return_group -color #ffff00 -radix hex
add_wave /apatb_module0_prefilter_top/AESL_inst_module0_prefilter/filteredLen_out_din -into $return_group -radix hex
add_wave /apatb_module0_prefilter_top/AESL_inst_module0_prefilter/data_out_write -into $return_group -color #ffff00 -radix hex
add_wave /apatb_module0_prefilter_top/AESL_inst_module0_prefilter/data_out_full_n -into $return_group -color #ffff00 -radix hex
add_wave /apatb_module0_prefilter_top/AESL_inst_module0_prefilter/data_out_din -into $return_group -radix hex
set cinputgroup [add_wave_group "C Inputs" -into $designtopgroup]
set return_group [add_wave_group return(fifo) -into $cinputgroup]
add_wave /apatb_module0_prefilter_top/AESL_inst_module0_prefilter/num_samples -into $return_group -radix hex
add_wave /apatb_module0_prefilter_top/AESL_inst_module0_prefilter/data_in_read -into $return_group -color #ffff00 -radix hex
add_wave /apatb_module0_prefilter_top/AESL_inst_module0_prefilter/data_in_empty_n -into $return_group -color #ffff00 -radix hex
add_wave /apatb_module0_prefilter_top/AESL_inst_module0_prefilter/data_in_dout -into $return_group -radix hex
set blocksiggroup [add_wave_group "Block-level IO Handshake" -into $designtopgroup]
add_wave /apatb_module0_prefilter_top/AESL_inst_module0_prefilter/ap_start -into $blocksiggroup
add_wave /apatb_module0_prefilter_top/AESL_inst_module0_prefilter/ap_done -into $blocksiggroup
add_wave /apatb_module0_prefilter_top/AESL_inst_module0_prefilter/ap_idle -into $blocksiggroup
add_wave /apatb_module0_prefilter_top/AESL_inst_module0_prefilter/ap_ready -into $blocksiggroup
set resetgroup [add_wave_group "Reset" -into $designtopgroup]
add_wave /apatb_module0_prefilter_top/AESL_inst_module0_prefilter/ap_rst -into $resetgroup
set clockgroup [add_wave_group "Clock" -into $designtopgroup]
add_wave /apatb_module0_prefilter_top/AESL_inst_module0_prefilter/ap_clk -into $clockgroup
set testbenchgroup [add_wave_group "Test Bench Signals"]
set tbinternalsiggroup [add_wave_group "Internal Signals" -into $testbenchgroup]
set tb_simstatus_group [add_wave_group "Simulation Status" -into $tbinternalsiggroup]
set tb_portdepth_group [add_wave_group "Port Depth" -into $tbinternalsiggroup]
add_wave /apatb_module0_prefilter_top/AUTOTB_TRANSACTION_NUM -into $tb_simstatus_group -radix hex
add_wave /apatb_module0_prefilter_top/ready_cnt -into $tb_simstatus_group -radix hex
add_wave /apatb_module0_prefilter_top/done_cnt -into $tb_simstatus_group -radix hex
add_wave /apatb_module0_prefilter_top/LENGTH_data_in -into $tb_portdepth_group -radix hex
add_wave /apatb_module0_prefilter_top/LENGTH_data_out -into $tb_portdepth_group -radix hex
add_wave /apatb_module0_prefilter_top/LENGTH_filteredLen_out -into $tb_portdepth_group -radix hex
add_wave /apatb_module0_prefilter_top/LENGTH_num_samples -into $tb_portdepth_group -radix hex
set tbcoutputgroup [add_wave_group "C Outputs" -into $testbenchgroup]
set tb_return_group [add_wave_group return(fifo) -into $tbcoutputgroup]
add_wave /apatb_module0_prefilter_top/filteredLen_out_write -into $tb_return_group -color #ffff00 -radix hex
add_wave /apatb_module0_prefilter_top/filteredLen_out_full_n -into $tb_return_group -color #ffff00 -radix hex
add_wave /apatb_module0_prefilter_top/filteredLen_out_din -into $tb_return_group -radix hex
add_wave /apatb_module0_prefilter_top/data_out_write -into $tb_return_group -color #ffff00 -radix hex
add_wave /apatb_module0_prefilter_top/data_out_full_n -into $tb_return_group -color #ffff00 -radix hex
add_wave /apatb_module0_prefilter_top/data_out_din -into $tb_return_group -radix hex
set tbcinputgroup [add_wave_group "C Inputs" -into $testbenchgroup]
set tb_return_group [add_wave_group return(fifo) -into $tbcinputgroup]
add_wave /apatb_module0_prefilter_top/num_samples -into $tb_return_group -radix hex
add_wave /apatb_module0_prefilter_top/data_in_read -into $tb_return_group -color #ffff00 -radix hex
add_wave /apatb_module0_prefilter_top/data_in_empty_n -into $tb_return_group -color #ffff00 -radix hex
add_wave /apatb_module0_prefilter_top/data_in_dout -into $tb_return_group -radix hex
save_wave_config module0_prefilter.wcfg
run all
quit

