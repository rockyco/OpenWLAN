
log_wave -r /
set designtopgroup [add_wave_group "Design Top Signals"]
set coutputgroup [add_wave_group "C Outputs" -into $designtopgroup]
set return_group [add_wave_group return(fifo) -into $coutputgroup]
add_wave /apatb_module4_fine_cfo_apply_top/AESL_inst_module4_fine_cfo_apply/fineFreqOff_out_write -into $return_group -color #ffff00 -radix hex
add_wave /apatb_module4_fine_cfo_apply_top/AESL_inst_module4_fine_cfo_apply/fineFreqOff_out_full_n -into $return_group -color #ffff00 -radix hex
add_wave /apatb_module4_fine_cfo_apply_top/AESL_inst_module4_fine_cfo_apply/fineFreqOff_out_din -into $return_group -radix hex
add_wave /apatb_module4_fine_cfo_apply_top/AESL_inst_module4_fine_cfo_apply/corrected_out_write -into $return_group -color #ffff00 -radix hex
add_wave /apatb_module4_fine_cfo_apply_top/AESL_inst_module4_fine_cfo_apply/corrected_out_full_n -into $return_group -color #ffff00 -radix hex
add_wave /apatb_module4_fine_cfo_apply_top/AESL_inst_module4_fine_cfo_apply/corrected_out_din -into $return_group -radix hex
set cinputgroup [add_wave_group "C Inputs" -into $designtopgroup]
set return_group [add_wave_group return(fifo) -into $cinputgroup]
add_wave /apatb_module4_fine_cfo_apply_top/AESL_inst_module4_fine_cfo_apply/num_samples -into $return_group -radix hex
add_wave /apatb_module4_fine_cfo_apply_top/AESL_inst_module4_fine_cfo_apply/fineOffset_in_read -into $return_group -color #ffff00 -radix hex
add_wave /apatb_module4_fine_cfo_apply_top/AESL_inst_module4_fine_cfo_apply/fineOffset_in_empty_n -into $return_group -color #ffff00 -radix hex
add_wave /apatb_module4_fine_cfo_apply_top/AESL_inst_module4_fine_cfo_apply/fineOffset_in_dout -into $return_group -radix hex
add_wave /apatb_module4_fine_cfo_apply_top/AESL_inst_module4_fine_cfo_apply/startOffset_in_read -into $return_group -color #ffff00 -radix hex
add_wave /apatb_module4_fine_cfo_apply_top/AESL_inst_module4_fine_cfo_apply/startOffset_in_empty_n -into $return_group -color #ffff00 -radix hex
add_wave /apatb_module4_fine_cfo_apply_top/AESL_inst_module4_fine_cfo_apply/startOffset_in_dout -into $return_group -radix hex
add_wave /apatb_module4_fine_cfo_apply_top/AESL_inst_module4_fine_cfo_apply/data_in_read -into $return_group -color #ffff00 -radix hex
add_wave /apatb_module4_fine_cfo_apply_top/AESL_inst_module4_fine_cfo_apply/data_in_empty_n -into $return_group -color #ffff00 -radix hex
add_wave /apatb_module4_fine_cfo_apply_top/AESL_inst_module4_fine_cfo_apply/data_in_dout -into $return_group -radix hex
set blocksiggroup [add_wave_group "Block-level IO Handshake" -into $designtopgroup]
add_wave /apatb_module4_fine_cfo_apply_top/AESL_inst_module4_fine_cfo_apply/ap_start -into $blocksiggroup
add_wave /apatb_module4_fine_cfo_apply_top/AESL_inst_module4_fine_cfo_apply/ap_done -into $blocksiggroup
add_wave /apatb_module4_fine_cfo_apply_top/AESL_inst_module4_fine_cfo_apply/ap_idle -into $blocksiggroup
add_wave /apatb_module4_fine_cfo_apply_top/AESL_inst_module4_fine_cfo_apply/ap_ready -into $blocksiggroup
set resetgroup [add_wave_group "Reset" -into $designtopgroup]
add_wave /apatb_module4_fine_cfo_apply_top/AESL_inst_module4_fine_cfo_apply/ap_rst -into $resetgroup
set clockgroup [add_wave_group "Clock" -into $designtopgroup]
add_wave /apatb_module4_fine_cfo_apply_top/AESL_inst_module4_fine_cfo_apply/ap_clk -into $clockgroup
set testbenchgroup [add_wave_group "Test Bench Signals"]
set tbinternalsiggroup [add_wave_group "Internal Signals" -into $testbenchgroup]
set tb_simstatus_group [add_wave_group "Simulation Status" -into $tbinternalsiggroup]
set tb_portdepth_group [add_wave_group "Port Depth" -into $tbinternalsiggroup]
add_wave /apatb_module4_fine_cfo_apply_top/AUTOTB_TRANSACTION_NUM -into $tb_simstatus_group -radix hex
add_wave /apatb_module4_fine_cfo_apply_top/ready_cnt -into $tb_simstatus_group -radix hex
add_wave /apatb_module4_fine_cfo_apply_top/done_cnt -into $tb_simstatus_group -radix hex
add_wave /apatb_module4_fine_cfo_apply_top/LENGTH_corrected_out -into $tb_portdepth_group -radix hex
add_wave /apatb_module4_fine_cfo_apply_top/LENGTH_data_in -into $tb_portdepth_group -radix hex
add_wave /apatb_module4_fine_cfo_apply_top/LENGTH_fineFreqOff_out -into $tb_portdepth_group -radix hex
add_wave /apatb_module4_fine_cfo_apply_top/LENGTH_fineOffset_in -into $tb_portdepth_group -radix hex
add_wave /apatb_module4_fine_cfo_apply_top/LENGTH_num_samples -into $tb_portdepth_group -radix hex
add_wave /apatb_module4_fine_cfo_apply_top/LENGTH_startOffset_in -into $tb_portdepth_group -radix hex
set tbcoutputgroup [add_wave_group "C Outputs" -into $testbenchgroup]
set tb_return_group [add_wave_group return(fifo) -into $tbcoutputgroup]
add_wave /apatb_module4_fine_cfo_apply_top/fineFreqOff_out_write -into $tb_return_group -color #ffff00 -radix hex
add_wave /apatb_module4_fine_cfo_apply_top/fineFreqOff_out_full_n -into $tb_return_group -color #ffff00 -radix hex
add_wave /apatb_module4_fine_cfo_apply_top/fineFreqOff_out_din -into $tb_return_group -radix hex
add_wave /apatb_module4_fine_cfo_apply_top/corrected_out_write -into $tb_return_group -color #ffff00 -radix hex
add_wave /apatb_module4_fine_cfo_apply_top/corrected_out_full_n -into $tb_return_group -color #ffff00 -radix hex
add_wave /apatb_module4_fine_cfo_apply_top/corrected_out_din -into $tb_return_group -radix hex
set tbcinputgroup [add_wave_group "C Inputs" -into $testbenchgroup]
set tb_return_group [add_wave_group return(fifo) -into $tbcinputgroup]
add_wave /apatb_module4_fine_cfo_apply_top/num_samples -into $tb_return_group -radix hex
add_wave /apatb_module4_fine_cfo_apply_top/fineOffset_in_read -into $tb_return_group -color #ffff00 -radix hex
add_wave /apatb_module4_fine_cfo_apply_top/fineOffset_in_empty_n -into $tb_return_group -color #ffff00 -radix hex
add_wave /apatb_module4_fine_cfo_apply_top/fineOffset_in_dout -into $tb_return_group -radix hex
add_wave /apatb_module4_fine_cfo_apply_top/startOffset_in_read -into $tb_return_group -color #ffff00 -radix hex
add_wave /apatb_module4_fine_cfo_apply_top/startOffset_in_empty_n -into $tb_return_group -color #ffff00 -radix hex
add_wave /apatb_module4_fine_cfo_apply_top/startOffset_in_dout -into $tb_return_group -radix hex
add_wave /apatb_module4_fine_cfo_apply_top/data_in_read -into $tb_return_group -color #ffff00 -radix hex
add_wave /apatb_module4_fine_cfo_apply_top/data_in_empty_n -into $tb_return_group -color #ffff00 -radix hex
add_wave /apatb_module4_fine_cfo_apply_top/data_in_dout -into $tb_return_group -radix hex
save_wave_config module4_fine_cfo_apply.wcfg
run all
quit

