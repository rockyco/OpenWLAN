`timescale 1 ns / 1 ps

module AESL_deadlock_detector (
    input dl_reset,
    input all_finish,
    input dl_clock);

    wire [0:0] proc_0_data_FIFO_blk;
    wire [0:0] proc_0_data_PIPO_blk;
    wire [0:0] proc_0_start_FIFO_blk;
    wire [0:0] proc_0_TLF_FIFO_blk;
    wire [0:0] proc_0_input_sync_blk;
    wire [0:0] proc_0_output_sync_blk;
    wire [0:0] proc_dep_vld_vec_0;
    reg [0:0] proc_dep_vld_vec_0_reg;
    wire [1:0] in_chan_dep_vld_vec_0;
    wire [27:0] in_chan_dep_data_vec_0;
    wire [1:0] token_in_vec_0;
    wire [0:0] out_chan_dep_vld_vec_0;
    wire [13:0] out_chan_dep_data_0;
    wire [0:0] token_out_vec_0;
    wire dl_detect_out_0;
    wire dep_chan_vld_1_0;
    wire [13:0] dep_chan_data_1_0;
    wire token_1_0;
    wire dep_chan_vld_3_0;
    wire [13:0] dep_chan_data_3_0;
    wire token_3_0;
    wire [2:0] proc_1_data_FIFO_blk;
    wire [2:0] proc_1_data_PIPO_blk;
    wire [2:0] proc_1_start_FIFO_blk;
    wire [2:0] proc_1_TLF_FIFO_blk;
    wire [2:0] proc_1_input_sync_blk;
    wire [2:0] proc_1_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_1;
    reg [2:0] proc_dep_vld_vec_1_reg;
    wire [2:0] in_chan_dep_vld_vec_1;
    wire [41:0] in_chan_dep_data_vec_1;
    wire [2:0] token_in_vec_1;
    wire [2:0] out_chan_dep_vld_vec_1;
    wire [13:0] out_chan_dep_data_1;
    wire [2:0] token_out_vec_1;
    wire dl_detect_out_1;
    wire dep_chan_vld_0_1;
    wire [13:0] dep_chan_data_0_1;
    wire token_0_1;
    wire dep_chan_vld_2_1;
    wire [13:0] dep_chan_data_2_1;
    wire token_2_1;
    wire dep_chan_vld_3_1;
    wire [13:0] dep_chan_data_3_1;
    wire token_3_1;
    wire [3:0] proc_2_data_FIFO_blk;
    wire [3:0] proc_2_data_PIPO_blk;
    wire [3:0] proc_2_start_FIFO_blk;
    wire [3:0] proc_2_TLF_FIFO_blk;
    wire [3:0] proc_2_input_sync_blk;
    wire [3:0] proc_2_output_sync_blk;
    wire [3:0] proc_dep_vld_vec_2;
    reg [3:0] proc_dep_vld_vec_2_reg;
    wire [3:0] in_chan_dep_vld_vec_2;
    wire [55:0] in_chan_dep_data_vec_2;
    wire [3:0] token_in_vec_2;
    wire [3:0] out_chan_dep_vld_vec_2;
    wire [13:0] out_chan_dep_data_2;
    wire [3:0] token_out_vec_2;
    wire dl_detect_out_2;
    wire dep_chan_vld_1_2;
    wire [13:0] dep_chan_data_1_2;
    wire token_1_2;
    wire dep_chan_vld_5_2;
    wire [13:0] dep_chan_data_5_2;
    wire token_5_2;
    wire dep_chan_vld_12_2;
    wire [13:0] dep_chan_data_12_2;
    wire token_12_2;
    wire dep_chan_vld_13_2;
    wire [13:0] dep_chan_data_13_2;
    wire token_13_2;
    wire [2:0] proc_3_data_FIFO_blk;
    wire [2:0] proc_3_data_PIPO_blk;
    wire [2:0] proc_3_start_FIFO_blk;
    wire [2:0] proc_3_TLF_FIFO_blk;
    wire [2:0] proc_3_input_sync_blk;
    wire [2:0] proc_3_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_3;
    reg [2:0] proc_dep_vld_vec_3_reg;
    wire [1:0] in_chan_dep_vld_vec_3;
    wire [27:0] in_chan_dep_data_vec_3;
    wire [1:0] token_in_vec_3;
    wire [2:0] out_chan_dep_vld_vec_3;
    wire [13:0] out_chan_dep_data_3;
    wire [2:0] token_out_vec_3;
    wire dl_detect_out_3;
    wire dep_chan_vld_1_3;
    wire [13:0] dep_chan_data_1_3;
    wire token_1_3;
    wire dep_chan_vld_4_3;
    wire [13:0] dep_chan_data_4_3;
    wire token_4_3;
    wire [5:0] proc_4_data_FIFO_blk;
    wire [5:0] proc_4_data_PIPO_blk;
    wire [5:0] proc_4_start_FIFO_blk;
    wire [5:0] proc_4_TLF_FIFO_blk;
    wire [5:0] proc_4_input_sync_blk;
    wire [5:0] proc_4_output_sync_blk;
    wire [5:0] proc_dep_vld_vec_4;
    reg [5:0] proc_dep_vld_vec_4_reg;
    wire [5:0] in_chan_dep_vld_vec_4;
    wire [83:0] in_chan_dep_data_vec_4;
    wire [5:0] token_in_vec_4;
    wire [5:0] out_chan_dep_vld_vec_4;
    wire [13:0] out_chan_dep_data_4;
    wire [5:0] token_out_vec_4;
    wire dl_detect_out_4;
    wire dep_chan_vld_3_4;
    wire [13:0] dep_chan_data_3_4;
    wire token_3_4;
    wire dep_chan_vld_5_4;
    wire [13:0] dep_chan_data_5_4;
    wire token_5_4;
    wire dep_chan_vld_6_4;
    wire [13:0] dep_chan_data_6_4;
    wire token_6_4;
    wire dep_chan_vld_7_4;
    wire [13:0] dep_chan_data_7_4;
    wire token_7_4;
    wire dep_chan_vld_12_4;
    wire [13:0] dep_chan_data_12_4;
    wire token_12_4;
    wire dep_chan_vld_13_4;
    wire [13:0] dep_chan_data_13_4;
    wire token_13_4;
    wire [3:0] proc_5_data_FIFO_blk;
    wire [3:0] proc_5_data_PIPO_blk;
    wire [3:0] proc_5_start_FIFO_blk;
    wire [3:0] proc_5_TLF_FIFO_blk;
    wire [3:0] proc_5_input_sync_blk;
    wire [3:0] proc_5_output_sync_blk;
    wire [3:0] proc_dep_vld_vec_5;
    reg [3:0] proc_dep_vld_vec_5_reg;
    wire [3:0] in_chan_dep_vld_vec_5;
    wire [55:0] in_chan_dep_data_vec_5;
    wire [3:0] token_in_vec_5;
    wire [3:0] out_chan_dep_vld_vec_5;
    wire [13:0] out_chan_dep_data_5;
    wire [3:0] token_out_vec_5;
    wire dl_detect_out_5;
    wire dep_chan_vld_2_5;
    wire [13:0] dep_chan_data_2_5;
    wire token_2_5;
    wire dep_chan_vld_4_5;
    wire [13:0] dep_chan_data_4_5;
    wire token_4_5;
    wire dep_chan_vld_12_5;
    wire [13:0] dep_chan_data_12_5;
    wire token_12_5;
    wire dep_chan_vld_13_5;
    wire [13:0] dep_chan_data_13_5;
    wire token_13_5;
    wire [1:0] proc_6_data_FIFO_blk;
    wire [1:0] proc_6_data_PIPO_blk;
    wire [1:0] proc_6_start_FIFO_blk;
    wire [1:0] proc_6_TLF_FIFO_blk;
    wire [1:0] proc_6_input_sync_blk;
    wire [1:0] proc_6_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_6;
    reg [1:0] proc_dep_vld_vec_6_reg;
    wire [1:0] in_chan_dep_vld_vec_6;
    wire [27:0] in_chan_dep_data_vec_6;
    wire [1:0] token_in_vec_6;
    wire [1:0] out_chan_dep_vld_vec_6;
    wire [13:0] out_chan_dep_data_6;
    wire [1:0] token_out_vec_6;
    wire dl_detect_out_6;
    wire dep_chan_vld_4_6;
    wire [13:0] dep_chan_data_4_6;
    wire token_4_6;
    wire dep_chan_vld_12_6;
    wire [13:0] dep_chan_data_12_6;
    wire token_12_6;
    wire [4:0] proc_7_data_FIFO_blk;
    wire [4:0] proc_7_data_PIPO_blk;
    wire [4:0] proc_7_start_FIFO_blk;
    wire [4:0] proc_7_TLF_FIFO_blk;
    wire [4:0] proc_7_input_sync_blk;
    wire [4:0] proc_7_output_sync_blk;
    wire [4:0] proc_dep_vld_vec_7;
    reg [4:0] proc_dep_vld_vec_7_reg;
    wire [4:0] in_chan_dep_vld_vec_7;
    wire [69:0] in_chan_dep_data_vec_7;
    wire [4:0] token_in_vec_7;
    wire [4:0] out_chan_dep_vld_vec_7;
    wire [13:0] out_chan_dep_data_7;
    wire [4:0] token_out_vec_7;
    wire dl_detect_out_7;
    wire dep_chan_vld_4_7;
    wire [13:0] dep_chan_data_4_7;
    wire token_4_7;
    wire dep_chan_vld_8_7;
    wire [13:0] dep_chan_data_8_7;
    wire token_8_7;
    wire dep_chan_vld_9_7;
    wire [13:0] dep_chan_data_9_7;
    wire token_9_7;
    wire dep_chan_vld_10_7;
    wire [13:0] dep_chan_data_10_7;
    wire token_10_7;
    wire dep_chan_vld_11_7;
    wire [13:0] dep_chan_data_11_7;
    wire token_11_7;
    wire [0:0] proc_8_data_FIFO_blk;
    wire [0:0] proc_8_data_PIPO_blk;
    wire [0:0] proc_8_start_FIFO_blk;
    wire [0:0] proc_8_TLF_FIFO_blk;
    wire [0:0] proc_8_input_sync_blk;
    wire [0:0] proc_8_output_sync_blk;
    wire [0:0] proc_dep_vld_vec_8;
    reg [0:0] proc_dep_vld_vec_8_reg;
    wire [1:0] in_chan_dep_vld_vec_8;
    wire [27:0] in_chan_dep_data_vec_8;
    wire [1:0] token_in_vec_8;
    wire [0:0] out_chan_dep_vld_vec_8;
    wire [13:0] out_chan_dep_data_8;
    wire [0:0] token_out_vec_8;
    wire dl_detect_out_8;
    wire dep_chan_vld_7_8;
    wire [13:0] dep_chan_data_7_8;
    wire token_7_8;
    wire dep_chan_vld_11_8;
    wire [13:0] dep_chan_data_11_8;
    wire token_11_8;
    wire [0:0] proc_9_data_FIFO_blk;
    wire [0:0] proc_9_data_PIPO_blk;
    wire [0:0] proc_9_start_FIFO_blk;
    wire [0:0] proc_9_TLF_FIFO_blk;
    wire [0:0] proc_9_input_sync_blk;
    wire [0:0] proc_9_output_sync_blk;
    wire [0:0] proc_dep_vld_vec_9;
    reg [0:0] proc_dep_vld_vec_9_reg;
    wire [1:0] in_chan_dep_vld_vec_9;
    wire [27:0] in_chan_dep_data_vec_9;
    wire [1:0] token_in_vec_9;
    wire [0:0] out_chan_dep_vld_vec_9;
    wire [13:0] out_chan_dep_data_9;
    wire [0:0] token_out_vec_9;
    wire dl_detect_out_9;
    wire dep_chan_vld_7_9;
    wire [13:0] dep_chan_data_7_9;
    wire token_7_9;
    wire dep_chan_vld_11_9;
    wire [13:0] dep_chan_data_11_9;
    wire token_11_9;
    wire [0:0] proc_10_data_FIFO_blk;
    wire [0:0] proc_10_data_PIPO_blk;
    wire [0:0] proc_10_start_FIFO_blk;
    wire [0:0] proc_10_TLF_FIFO_blk;
    wire [0:0] proc_10_input_sync_blk;
    wire [0:0] proc_10_output_sync_blk;
    wire [0:0] proc_dep_vld_vec_10;
    reg [0:0] proc_dep_vld_vec_10_reg;
    wire [1:0] in_chan_dep_vld_vec_10;
    wire [27:0] in_chan_dep_data_vec_10;
    wire [1:0] token_in_vec_10;
    wire [0:0] out_chan_dep_vld_vec_10;
    wire [13:0] out_chan_dep_data_10;
    wire [0:0] token_out_vec_10;
    wire dl_detect_out_10;
    wire dep_chan_vld_7_10;
    wire [13:0] dep_chan_data_7_10;
    wire token_7_10;
    wire dep_chan_vld_11_10;
    wire [13:0] dep_chan_data_11_10;
    wire token_11_10;
    wire [4:0] proc_11_data_FIFO_blk;
    wire [4:0] proc_11_data_PIPO_blk;
    wire [4:0] proc_11_start_FIFO_blk;
    wire [4:0] proc_11_TLF_FIFO_blk;
    wire [4:0] proc_11_input_sync_blk;
    wire [4:0] proc_11_output_sync_blk;
    wire [4:0] proc_dep_vld_vec_11;
    reg [4:0] proc_dep_vld_vec_11_reg;
    wire [1:0] in_chan_dep_vld_vec_11;
    wire [27:0] in_chan_dep_data_vec_11;
    wire [1:0] token_in_vec_11;
    wire [4:0] out_chan_dep_vld_vec_11;
    wire [13:0] out_chan_dep_data_11;
    wire [4:0] token_out_vec_11;
    wire dl_detect_out_11;
    wire dep_chan_vld_7_11;
    wire [13:0] dep_chan_data_7_11;
    wire token_7_11;
    wire dep_chan_vld_12_11;
    wire [13:0] dep_chan_data_12_11;
    wire token_12_11;
    wire [5:0] proc_12_data_FIFO_blk;
    wire [5:0] proc_12_data_PIPO_blk;
    wire [5:0] proc_12_start_FIFO_blk;
    wire [5:0] proc_12_TLF_FIFO_blk;
    wire [5:0] proc_12_input_sync_blk;
    wire [5:0] proc_12_output_sync_blk;
    wire [5:0] proc_dep_vld_vec_12;
    reg [5:0] proc_dep_vld_vec_12_reg;
    wire [5:0] in_chan_dep_vld_vec_12;
    wire [83:0] in_chan_dep_data_vec_12;
    wire [5:0] token_in_vec_12;
    wire [5:0] out_chan_dep_vld_vec_12;
    wire [13:0] out_chan_dep_data_12;
    wire [5:0] token_out_vec_12;
    wire dl_detect_out_12;
    wire dep_chan_vld_2_12;
    wire [13:0] dep_chan_data_2_12;
    wire token_2_12;
    wire dep_chan_vld_4_12;
    wire [13:0] dep_chan_data_4_12;
    wire token_4_12;
    wire dep_chan_vld_5_12;
    wire [13:0] dep_chan_data_5_12;
    wire token_5_12;
    wire dep_chan_vld_6_12;
    wire [13:0] dep_chan_data_6_12;
    wire token_6_12;
    wire dep_chan_vld_11_12;
    wire [13:0] dep_chan_data_11_12;
    wire token_11_12;
    wire dep_chan_vld_13_12;
    wire [13:0] dep_chan_data_13_12;
    wire token_13_12;
    wire [3:0] proc_13_data_FIFO_blk;
    wire [3:0] proc_13_data_PIPO_blk;
    wire [3:0] proc_13_start_FIFO_blk;
    wire [3:0] proc_13_TLF_FIFO_blk;
    wire [3:0] proc_13_input_sync_blk;
    wire [3:0] proc_13_output_sync_blk;
    wire [3:0] proc_dep_vld_vec_13;
    reg [3:0] proc_dep_vld_vec_13_reg;
    wire [3:0] in_chan_dep_vld_vec_13;
    wire [55:0] in_chan_dep_data_vec_13;
    wire [3:0] token_in_vec_13;
    wire [3:0] out_chan_dep_vld_vec_13;
    wire [13:0] out_chan_dep_data_13;
    wire [3:0] token_out_vec_13;
    wire dl_detect_out_13;
    wire dep_chan_vld_2_13;
    wire [13:0] dep_chan_data_2_13;
    wire token_2_13;
    wire dep_chan_vld_4_13;
    wire [13:0] dep_chan_data_4_13;
    wire token_4_13;
    wire dep_chan_vld_5_13;
    wire [13:0] dep_chan_data_5_13;
    wire token_5_13;
    wire dep_chan_vld_12_13;
    wire [13:0] dep_chan_data_12_13;
    wire token_12_13;
    wire [13:0] dl_in_vec;
    wire dl_detect_out;
    wire token_clear;
    wire [13:0] origin;

    reg ap_done_reg_0;// for module AESL_inst_system_top.module1_packet_detect_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_0 <= 'b0;
        end
        else begin
            ap_done_reg_0 <= AESL_inst_system_top.module1_packet_detect_U0.ap_done & ~AESL_inst_system_top.module1_packet_detect_U0.ap_continue;
        end
    end

    reg ap_done_reg_1;// for module AESL_inst_system_top.consume_filteredLen_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_1 <= 'b0;
        end
        else begin
            ap_done_reg_1 <= AESL_inst_system_top.consume_filteredLen_U0.ap_done & ~AESL_inst_system_top.consume_filteredLen_U0.ap_continue;
        end
    end

    reg ap_done_reg_2;// for module AESL_inst_system_top.consume_searchBufferLen_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_2 <= 'b0;
        end
        else begin
            ap_done_reg_2 <= AESL_inst_system_top.consume_searchBufferLen_U0.ap_done & ~AESL_inst_system_top.consume_searchBufferLen_U0.ap_continue;
        end
    end

    reg ap_done_reg_3;// for module AESL_inst_system_top.module4_fine_cfo_apply_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_3 <= 'b0;
        end
        else begin
            ap_done_reg_3 <= AESL_inst_system_top.module4_fine_cfo_apply_U0.ap_done & ~AESL_inst_system_top.module4_fine_cfo_apply_U0.ap_continue;
        end
    end

    reg ap_done_reg_4;// for module AESL_inst_system_top.forward_coarseFreqOff_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_4 <= 'b0;
        end
        else begin
            ap_done_reg_4 <= AESL_inst_system_top.forward_coarseFreqOff_U0.ap_done & ~AESL_inst_system_top.forward_coarseFreqOff_U0.ap_continue;
        end
    end

reg [15:0] trans_in_cnt_0;// for process AESL_inst_system_top.module0_prefilter_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_0 <= 16'h0;
    end
    else if (AESL_inst_system_top.module0_prefilter_U0.start_write == 1'b1) begin
        trans_in_cnt_0 <= trans_in_cnt_0 + 16'h1;
    end
    else begin
        trans_in_cnt_0 <= trans_in_cnt_0;
    end
end

reg [15:0] trans_out_cnt_0;// for process AESL_inst_system_top.module0_prefilter_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_0 <= 16'h0;
    end
    else if (AESL_inst_system_top.module0_prefilter_U0.ap_done == 1'b1 && AESL_inst_system_top.module0_prefilter_U0.ap_continue == 1'b1) begin
        trans_out_cnt_0 <= trans_out_cnt_0 + 16'h1;
    end
    else begin
        trans_out_cnt_0 <= trans_out_cnt_0;
    end
end

reg [15:0] trans_in_cnt_1;// for process AESL_inst_system_top.module1_packet_detect_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_1 <= 16'h0;
    end
    else if (AESL_inst_system_top.module1_packet_detect_U0.start_write == 1'b1) begin
        trans_in_cnt_1 <= trans_in_cnt_1 + 16'h1;
    end
    else begin
        trans_in_cnt_1 <= trans_in_cnt_1;
    end
end

reg [15:0] trans_out_cnt_1;// for process AESL_inst_system_top.module1_packet_detect_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_1 <= 16'h0;
    end
    else if (AESL_inst_system_top.module1_packet_detect_U0.ap_done == 1'b1 && AESL_inst_system_top.module1_packet_detect_U0.ap_continue == 1'b1) begin
        trans_out_cnt_1 <= trans_out_cnt_1 + 16'h1;
    end
    else begin
        trans_out_cnt_1 <= trans_out_cnt_1;
    end
end

reg [15:0] trans_in_cnt_2;// for process AESL_inst_system_top.module2_coarse_cfo_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_2 <= 16'h0;
    end
    else if (AESL_inst_system_top.module2_coarse_cfo_U0.start_write == 1'b1) begin
        trans_in_cnt_2 <= trans_in_cnt_2 + 16'h1;
    end
    else begin
        trans_in_cnt_2 <= trans_in_cnt_2;
    end
end

reg [15:0] trans_out_cnt_2;// for process AESL_inst_system_top.module2_coarse_cfo_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_2 <= 16'h0;
    end
    else if (AESL_inst_system_top.module2_coarse_cfo_U0.ap_done == 1'b1 && AESL_inst_system_top.module2_coarse_cfo_U0.ap_continue == 1'b1) begin
        trans_out_cnt_2 <= trans_out_cnt_2 + 16'h1;
    end
    else begin
        trans_out_cnt_2 <= trans_out_cnt_2;
    end
end

reg [15:0] trans_in_cnt_3;// for process AESL_inst_system_top.module3_fine_sync_U0.split_input_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_3 <= 16'h0;
    end
    else if (AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.start_write == 1'b1) begin
        trans_in_cnt_3 <= trans_in_cnt_3 + 16'h1;
    end
    else begin
        trans_in_cnt_3 <= trans_in_cnt_3;
    end
end

reg [15:0] trans_out_cnt_3;// for process AESL_inst_system_top.module3_fine_sync_U0.split_input_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_3 <= 16'h0;
    end
    else if (AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.ap_done == 1'b1 && AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.ap_continue == 1'b1) begin
        trans_out_cnt_3 <= trans_out_cnt_3 + 16'h1;
    end
    else begin
        trans_out_cnt_3 <= trans_out_cnt_3;
    end
end

    // Process: AESL_inst_system_top.Block_entry_proc_U0
    AESL_deadlock_detect_unit #(14, 0, 2, 1) AESL_deadlock_detect_unit_0 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_0),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_0),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_0),
        .token_in_vec(token_in_vec_0),
        .dl_detect_in(dl_detect_out),
        .origin(origin[0]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_0),
        .out_chan_dep_data(out_chan_dep_data_0),
        .token_out_vec(token_out_vec_0),
        .dl_detect_out(dl_in_vec[0]));

    assign proc_0_data_FIFO_blk[0] = 1'b0;
    assign proc_0_data_PIPO_blk[0] = 1'b0;
    assign proc_0_start_FIFO_blk[0] = 1'b0;
    assign proc_0_TLF_FIFO_blk[0] = 1'b0;
    assign proc_0_input_sync_blk[0] = 1'b0 | (AESL_inst_system_top.ap_sync_Block_entry_proc_U0_ap_ready & AESL_inst_system_top.Block_entry_proc_U0.ap_idle & ~AESL_inst_system_top.ap_sync_module0_prefilter_U0_ap_ready);
    assign proc_0_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_0[0] = dl_detect_out ? proc_dep_vld_vec_0_reg[0] : (proc_0_data_FIFO_blk[0] | proc_0_data_PIPO_blk[0] | proc_0_start_FIFO_blk[0] | proc_0_TLF_FIFO_blk[0] | proc_0_input_sync_blk[0] | proc_0_output_sync_blk[0]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_0_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_0_reg <= proc_dep_vld_vec_0;
        end
    end
    assign in_chan_dep_vld_vec_0[0] = dep_chan_vld_1_0;
    assign in_chan_dep_data_vec_0[13 : 0] = dep_chan_data_1_0;
    assign token_in_vec_0[0] = token_1_0;
    assign in_chan_dep_vld_vec_0[1] = dep_chan_vld_3_0;
    assign in_chan_dep_data_vec_0[27 : 14] = dep_chan_data_3_0;
    assign token_in_vec_0[1] = token_3_0;
    assign dep_chan_vld_0_1 = out_chan_dep_vld_vec_0[0];
    assign dep_chan_data_0_1 = out_chan_dep_data_0;
    assign token_0_1 = token_out_vec_0[0];

    // Process: AESL_inst_system_top.module0_prefilter_U0
    AESL_deadlock_detect_unit #(14, 1, 3, 3) AESL_deadlock_detect_unit_1 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_1),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_1),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_1),
        .token_in_vec(token_in_vec_1),
        .dl_detect_in(dl_detect_out),
        .origin(origin[1]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_1),
        .out_chan_dep_data(out_chan_dep_data_1),
        .token_out_vec(token_out_vec_1),
        .dl_detect_out(dl_in_vec[1]));

    assign proc_1_data_FIFO_blk[0] = 1'b0 | (~AESL_inst_system_top.module0_prefilter_U0.grp_module0_prefilter_Pipeline_PREFILTER_LOOP_fu_41.m0_to_m1_data_blk_n);
    assign proc_1_data_PIPO_blk[0] = 1'b0;
    assign proc_1_start_FIFO_blk[0] = 1'b0;
    assign proc_1_TLF_FIFO_blk[0] = 1'b0;
    assign proc_1_input_sync_blk[0] = 1'b0;
    assign proc_1_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_1[0] = dl_detect_out ? proc_dep_vld_vec_1_reg[0] : (proc_1_data_FIFO_blk[0] | proc_1_data_PIPO_blk[0] | proc_1_start_FIFO_blk[0] | proc_1_TLF_FIFO_blk[0] | proc_1_input_sync_blk[0] | proc_1_output_sync_blk[0]);
    assign proc_1_data_FIFO_blk[1] = 1'b0 | (~AESL_inst_system_top.module0_prefilter_U0.m0_filteredLen_blk_n);
    assign proc_1_data_PIPO_blk[1] = 1'b0;
    assign proc_1_start_FIFO_blk[1] = 1'b0 | (~AESL_inst_system_top.start_for_consume_filteredLen_U0_U.if_full_n & AESL_inst_system_top.module0_prefilter_U0.ap_start & ~AESL_inst_system_top.module0_prefilter_U0.real_start & (trans_in_cnt_0 == trans_out_cnt_0) & ~AESL_inst_system_top.start_for_consume_filteredLen_U0_U.if_read);
    assign proc_1_TLF_FIFO_blk[1] = 1'b0;
    assign proc_1_input_sync_blk[1] = 1'b0;
    assign proc_1_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_1[1] = dl_detect_out ? proc_dep_vld_vec_1_reg[1] : (proc_1_data_FIFO_blk[1] | proc_1_data_PIPO_blk[1] | proc_1_start_FIFO_blk[1] | proc_1_TLF_FIFO_blk[1] | proc_1_input_sync_blk[1] | proc_1_output_sync_blk[1]);
    assign proc_1_data_FIFO_blk[2] = 1'b0;
    assign proc_1_data_PIPO_blk[2] = 1'b0;
    assign proc_1_start_FIFO_blk[2] = 1'b0;
    assign proc_1_TLF_FIFO_blk[2] = 1'b0;
    assign proc_1_input_sync_blk[2] = 1'b0 | (AESL_inst_system_top.ap_sync_module0_prefilter_U0_ap_ready & AESL_inst_system_top.module0_prefilter_U0.ap_idle & ~AESL_inst_system_top.ap_sync_Block_entry_proc_U0_ap_ready);
    assign proc_1_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_1[2] = dl_detect_out ? proc_dep_vld_vec_1_reg[2] : (proc_1_data_FIFO_blk[2] | proc_1_data_PIPO_blk[2] | proc_1_start_FIFO_blk[2] | proc_1_TLF_FIFO_blk[2] | proc_1_input_sync_blk[2] | proc_1_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_1_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_1_reg <= proc_dep_vld_vec_1;
        end
    end
    assign in_chan_dep_vld_vec_1[0] = dep_chan_vld_0_1;
    assign in_chan_dep_data_vec_1[13 : 0] = dep_chan_data_0_1;
    assign token_in_vec_1[0] = token_0_1;
    assign in_chan_dep_vld_vec_1[1] = dep_chan_vld_2_1;
    assign in_chan_dep_data_vec_1[27 : 14] = dep_chan_data_2_1;
    assign token_in_vec_1[1] = token_2_1;
    assign in_chan_dep_vld_vec_1[2] = dep_chan_vld_3_1;
    assign in_chan_dep_data_vec_1[41 : 28] = dep_chan_data_3_1;
    assign token_in_vec_1[2] = token_3_1;
    assign dep_chan_vld_1_3 = out_chan_dep_vld_vec_1[0];
    assign dep_chan_data_1_3 = out_chan_dep_data_1;
    assign token_1_3 = token_out_vec_1[0];
    assign dep_chan_vld_1_2 = out_chan_dep_vld_vec_1[1];
    assign dep_chan_data_1_2 = out_chan_dep_data_1;
    assign token_1_2 = token_out_vec_1[1];
    assign dep_chan_vld_1_0 = out_chan_dep_vld_vec_1[2];
    assign dep_chan_data_1_0 = out_chan_dep_data_1;
    assign token_1_0 = token_out_vec_1[2];

    // Process: AESL_inst_system_top.consume_filteredLen_U0
    AESL_deadlock_detect_unit #(14, 2, 4, 4) AESL_deadlock_detect_unit_2 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_2),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_2),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_2),
        .token_in_vec(token_in_vec_2),
        .dl_detect_in(dl_detect_out),
        .origin(origin[2]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_2),
        .out_chan_dep_data(out_chan_dep_data_2),
        .token_out_vec(token_out_vec_2),
        .dl_detect_out(dl_in_vec[2]));

    assign proc_2_data_FIFO_blk[0] = 1'b0 | (~AESL_inst_system_top.consume_filteredLen_U0.m0_filteredLen_blk_n);
    assign proc_2_data_PIPO_blk[0] = 1'b0;
    assign proc_2_start_FIFO_blk[0] = 1'b0 | (~AESL_inst_system_top.start_for_consume_filteredLen_U0_U.if_empty_n & AESL_inst_system_top.consume_filteredLen_U0.ap_idle & ~AESL_inst_system_top.start_for_consume_filteredLen_U0_U.if_write);
    assign proc_2_TLF_FIFO_blk[0] = 1'b0;
    assign proc_2_input_sync_blk[0] = 1'b0;
    assign proc_2_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_2[0] = dl_detect_out ? proc_dep_vld_vec_2_reg[0] : (proc_2_data_FIFO_blk[0] | proc_2_data_PIPO_blk[0] | proc_2_start_FIFO_blk[0] | proc_2_TLF_FIFO_blk[0] | proc_2_input_sync_blk[0] | proc_2_output_sync_blk[0]);
    assign proc_2_data_FIFO_blk[1] = 1'b0;
    assign proc_2_data_PIPO_blk[1] = 1'b0;
    assign proc_2_start_FIFO_blk[1] = 1'b0;
    assign proc_2_TLF_FIFO_blk[1] = 1'b0;
    assign proc_2_input_sync_blk[1] = 1'b0;
    assign proc_2_output_sync_blk[1] = 1'b0 | (ap_done_reg_1 & AESL_inst_system_top.consume_filteredLen_U0.ap_done & ~AESL_inst_system_top.consume_searchBufferLen_U0.ap_done);
    assign proc_dep_vld_vec_2[1] = dl_detect_out ? proc_dep_vld_vec_2_reg[1] : (proc_2_data_FIFO_blk[1] | proc_2_data_PIPO_blk[1] | proc_2_start_FIFO_blk[1] | proc_2_TLF_FIFO_blk[1] | proc_2_input_sync_blk[1] | proc_2_output_sync_blk[1]);
    assign proc_2_data_FIFO_blk[2] = 1'b0;
    assign proc_2_data_PIPO_blk[2] = 1'b0;
    assign proc_2_start_FIFO_blk[2] = 1'b0;
    assign proc_2_TLF_FIFO_blk[2] = 1'b0;
    assign proc_2_input_sync_blk[2] = 1'b0;
    assign proc_2_output_sync_blk[2] = 1'b0 | (ap_done_reg_1 & AESL_inst_system_top.consume_filteredLen_U0.ap_done & ~AESL_inst_system_top.module4_fine_cfo_apply_U0.ap_done);
    assign proc_dep_vld_vec_2[2] = dl_detect_out ? proc_dep_vld_vec_2_reg[2] : (proc_2_data_FIFO_blk[2] | proc_2_data_PIPO_blk[2] | proc_2_start_FIFO_blk[2] | proc_2_TLF_FIFO_blk[2] | proc_2_input_sync_blk[2] | proc_2_output_sync_blk[2]);
    assign proc_2_data_FIFO_blk[3] = 1'b0;
    assign proc_2_data_PIPO_blk[3] = 1'b0;
    assign proc_2_start_FIFO_blk[3] = 1'b0;
    assign proc_2_TLF_FIFO_blk[3] = 1'b0;
    assign proc_2_input_sync_blk[3] = 1'b0;
    assign proc_2_output_sync_blk[3] = 1'b0 | (ap_done_reg_1 & AESL_inst_system_top.consume_filteredLen_U0.ap_done & ~AESL_inst_system_top.forward_coarseFreqOff_U0.ap_done);
    assign proc_dep_vld_vec_2[3] = dl_detect_out ? proc_dep_vld_vec_2_reg[3] : (proc_2_data_FIFO_blk[3] | proc_2_data_PIPO_blk[3] | proc_2_start_FIFO_blk[3] | proc_2_TLF_FIFO_blk[3] | proc_2_input_sync_blk[3] | proc_2_output_sync_blk[3]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_2_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_2_reg <= proc_dep_vld_vec_2;
        end
    end
    assign in_chan_dep_vld_vec_2[0] = dep_chan_vld_1_2;
    assign in_chan_dep_data_vec_2[13 : 0] = dep_chan_data_1_2;
    assign token_in_vec_2[0] = token_1_2;
    assign in_chan_dep_vld_vec_2[1] = dep_chan_vld_5_2;
    assign in_chan_dep_data_vec_2[27 : 14] = dep_chan_data_5_2;
    assign token_in_vec_2[1] = token_5_2;
    assign in_chan_dep_vld_vec_2[2] = dep_chan_vld_12_2;
    assign in_chan_dep_data_vec_2[41 : 28] = dep_chan_data_12_2;
    assign token_in_vec_2[2] = token_12_2;
    assign in_chan_dep_vld_vec_2[3] = dep_chan_vld_13_2;
    assign in_chan_dep_data_vec_2[55 : 42] = dep_chan_data_13_2;
    assign token_in_vec_2[3] = token_13_2;
    assign dep_chan_vld_2_1 = out_chan_dep_vld_vec_2[0];
    assign dep_chan_data_2_1 = out_chan_dep_data_2;
    assign token_2_1 = token_out_vec_2[0];
    assign dep_chan_vld_2_5 = out_chan_dep_vld_vec_2[1];
    assign dep_chan_data_2_5 = out_chan_dep_data_2;
    assign token_2_5 = token_out_vec_2[1];
    assign dep_chan_vld_2_12 = out_chan_dep_vld_vec_2[2];
    assign dep_chan_data_2_12 = out_chan_dep_data_2;
    assign token_2_12 = token_out_vec_2[2];
    assign dep_chan_vld_2_13 = out_chan_dep_vld_vec_2[3];
    assign dep_chan_data_2_13 = out_chan_dep_data_2;
    assign token_2_13 = token_out_vec_2[3];

    // Process: AESL_inst_system_top.module1_packet_detect_U0
    AESL_deadlock_detect_unit #(14, 3, 2, 3) AESL_deadlock_detect_unit_3 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_3),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_3),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_3),
        .token_in_vec(token_in_vec_3),
        .dl_detect_in(dl_detect_out),
        .origin(origin[3]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_3),
        .out_chan_dep_data(out_chan_dep_data_3),
        .token_out_vec(token_out_vec_3),
        .dl_detect_out(dl_in_vec[3]));

    assign proc_3_data_FIFO_blk[0] = 1'b0 | (~AESL_inst_system_top.module1_packet_detect_U0.grp_module1_packet_detect_Pipeline_STREAM_LOOP_fu_71.m0_to_m1_data_blk_n);
    assign proc_3_data_PIPO_blk[0] = 1'b0;
    assign proc_3_start_FIFO_blk[0] = 1'b0;
    assign proc_3_TLF_FIFO_blk[0] = 1'b0;
    assign proc_3_input_sync_blk[0] = 1'b0;
    assign proc_3_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_3[0] = dl_detect_out ? proc_dep_vld_vec_3_reg[0] : (proc_3_data_FIFO_blk[0] | proc_3_data_PIPO_blk[0] | proc_3_start_FIFO_blk[0] | proc_3_TLF_FIFO_blk[0] | proc_3_input_sync_blk[0] | proc_3_output_sync_blk[0]);
    assign proc_3_data_FIFO_blk[1] = 1'b0 | (~AESL_inst_system_top.module1_packet_detect_U0.grp_module1_packet_detect_Pipeline_STREAM_LOOP_fu_71.m1_to_m2_data_blk_n) | (~AESL_inst_system_top.module1_packet_detect_U0.m1_startOffset_blk_n) | (~AESL_inst_system_top.module1_packet_detect_U0.grp_module1_packet_detect_Pipeline_STREAM_LOOP_fu_71.m1_startOffset_blk_n) | (~AESL_inst_system_top.module1_packet_detect_U0.add_loc_c1_blk_n);
    assign proc_3_data_PIPO_blk[1] = 1'b0;
    assign proc_3_start_FIFO_blk[1] = 1'b0 | (~AESL_inst_system_top.start_for_module2_coarse_cfo_U0_U.if_full_n & AESL_inst_system_top.module1_packet_detect_U0.ap_start & ~AESL_inst_system_top.module1_packet_detect_U0.real_start & (trans_in_cnt_1 == trans_out_cnt_1) & ~AESL_inst_system_top.start_for_module2_coarse_cfo_U0_U.if_read);
    assign proc_3_TLF_FIFO_blk[1] = 1'b0;
    assign proc_3_input_sync_blk[1] = 1'b0;
    assign proc_3_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_3[1] = dl_detect_out ? proc_dep_vld_vec_3_reg[1] : (proc_3_data_FIFO_blk[1] | proc_3_data_PIPO_blk[1] | proc_3_start_FIFO_blk[1] | proc_3_TLF_FIFO_blk[1] | proc_3_input_sync_blk[1] | proc_3_output_sync_blk[1]);
    assign proc_3_data_FIFO_blk[2] = 1'b0;
    assign proc_3_data_PIPO_blk[2] = 1'b0;
    assign proc_3_start_FIFO_blk[2] = 1'b0;
    assign proc_3_TLF_FIFO_blk[2] = 1'b0 | (~AESL_inst_system_top.add_loc_c2_channel_U.if_empty_n & AESL_inst_system_top.module1_packet_detect_U0.ap_idle & ~AESL_inst_system_top.add_loc_c2_channel_U.if_write);
    assign proc_3_input_sync_blk[2] = 1'b0;
    assign proc_3_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_3[2] = dl_detect_out ? proc_dep_vld_vec_3_reg[2] : (proc_3_data_FIFO_blk[2] | proc_3_data_PIPO_blk[2] | proc_3_start_FIFO_blk[2] | proc_3_TLF_FIFO_blk[2] | proc_3_input_sync_blk[2] | proc_3_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_3_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_3_reg <= proc_dep_vld_vec_3;
        end
    end
    assign in_chan_dep_vld_vec_3[0] = dep_chan_vld_1_3;
    assign in_chan_dep_data_vec_3[13 : 0] = dep_chan_data_1_3;
    assign token_in_vec_3[0] = token_1_3;
    assign in_chan_dep_vld_vec_3[1] = dep_chan_vld_4_3;
    assign in_chan_dep_data_vec_3[27 : 14] = dep_chan_data_4_3;
    assign token_in_vec_3[1] = token_4_3;
    assign dep_chan_vld_3_1 = out_chan_dep_vld_vec_3[0];
    assign dep_chan_data_3_1 = out_chan_dep_data_3;
    assign token_3_1 = token_out_vec_3[0];
    assign dep_chan_vld_3_4 = out_chan_dep_vld_vec_3[1];
    assign dep_chan_data_3_4 = out_chan_dep_data_3;
    assign token_3_4 = token_out_vec_3[1];
    assign dep_chan_vld_3_0 = out_chan_dep_vld_vec_3[2];
    assign dep_chan_data_3_0 = out_chan_dep_data_3;
    assign token_3_0 = token_out_vec_3[2];

    // Process: AESL_inst_system_top.module2_coarse_cfo_U0
    AESL_deadlock_detect_unit #(14, 4, 6, 6) AESL_deadlock_detect_unit_4 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_4),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_4),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_4),
        .token_in_vec(token_in_vec_4),
        .dl_detect_in(dl_detect_out),
        .origin(origin[4]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_4),
        .out_chan_dep_data(out_chan_dep_data_4),
        .token_out_vec(token_out_vec_4),
        .dl_detect_out(dl_in_vec[4]));

    assign proc_4_data_FIFO_blk[0] = 1'b0 | (~AESL_inst_system_top.module2_coarse_cfo_U0.grp_module2_coarse_cfo_Pipeline_PHASE_A_fu_312.m1_to_m2_data_blk_n) | (~AESL_inst_system_top.module2_coarse_cfo_U0.m1_startOffset_blk_n) | (~AESL_inst_system_top.module2_coarse_cfo_U0.grp_module2_coarse_cfo_Pipeline_PHASE_A_fu_312.m1_startOffset_blk_n) | (~AESL_inst_system_top.module2_coarse_cfo_U0.add_loc_blk_n);
    assign proc_4_data_PIPO_blk[0] = 1'b0;
    assign proc_4_start_FIFO_blk[0] = 1'b0 | (~AESL_inst_system_top.start_for_module2_coarse_cfo_U0_U.if_empty_n & AESL_inst_system_top.module2_coarse_cfo_U0.ap_idle & ~AESL_inst_system_top.start_for_module2_coarse_cfo_U0_U.if_write);
    assign proc_4_TLF_FIFO_blk[0] = 1'b0;
    assign proc_4_input_sync_blk[0] = 1'b0;
    assign proc_4_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_4[0] = dl_detect_out ? proc_dep_vld_vec_4_reg[0] : (proc_4_data_FIFO_blk[0] | proc_4_data_PIPO_blk[0] | proc_4_start_FIFO_blk[0] | proc_4_TLF_FIFO_blk[0] | proc_4_input_sync_blk[0] | proc_4_output_sync_blk[0]);
    assign proc_4_data_FIFO_blk[1] = 1'b0 | (~AESL_inst_system_top.module2_coarse_cfo_U0.grp_module2_coarse_cfo_Pipeline_PHASE_D_fu_342.m2_search_buffer_blk_n);
    assign proc_4_data_PIPO_blk[1] = 1'b0;
    assign proc_4_start_FIFO_blk[1] = 1'b0 | (~AESL_inst_system_top.start_for_module3_fine_sync_U0_U.if_full_n & AESL_inst_system_top.module2_coarse_cfo_U0.ap_start & ~AESL_inst_system_top.module2_coarse_cfo_U0.real_start & (trans_in_cnt_2 == trans_out_cnt_2) & ~AESL_inst_system_top.start_for_module3_fine_sync_U0_U.if_read);
    assign proc_4_TLF_FIFO_blk[1] = 1'b0;
    assign proc_4_input_sync_blk[1] = 1'b0;
    assign proc_4_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_4[1] = dl_detect_out ? proc_dep_vld_vec_4_reg[1] : (proc_4_data_FIFO_blk[1] | proc_4_data_PIPO_blk[1] | proc_4_start_FIFO_blk[1] | proc_4_TLF_FIFO_blk[1] | proc_4_input_sync_blk[1] | proc_4_output_sync_blk[1]);
    assign proc_4_data_FIFO_blk[2] = 1'b0 | (~AESL_inst_system_top.module2_coarse_cfo_U0.grp_module2_coarse_cfo_Pipeline_PHASE_D_fu_342.m2_search_buffer_blk_n);
    assign proc_4_data_PIPO_blk[2] = 1'b0;
    assign proc_4_start_FIFO_blk[2] = 1'b0;
    assign proc_4_TLF_FIFO_blk[2] = 1'b0;
    assign proc_4_input_sync_blk[2] = 1'b0;
    assign proc_4_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_4[2] = dl_detect_out ? proc_dep_vld_vec_4_reg[2] : (proc_4_data_FIFO_blk[2] | proc_4_data_PIPO_blk[2] | proc_4_start_FIFO_blk[2] | proc_4_TLF_FIFO_blk[2] | proc_4_input_sync_blk[2] | proc_4_output_sync_blk[2]);
    assign proc_4_data_FIFO_blk[3] = 1'b0 | (~AESL_inst_system_top.module2_coarse_cfo_U0.m2_coarseFreqOff_blk_n);
    assign proc_4_data_PIPO_blk[3] = 1'b0;
    assign proc_4_start_FIFO_blk[3] = 1'b0 | (~AESL_inst_system_top.start_for_forward_coarseFreqOff_U0_U.if_full_n & AESL_inst_system_top.module2_coarse_cfo_U0.ap_start & ~AESL_inst_system_top.module2_coarse_cfo_U0.real_start & (trans_in_cnt_2 == trans_out_cnt_2) & ~AESL_inst_system_top.start_for_forward_coarseFreqOff_U0_U.if_read);
    assign proc_4_TLF_FIFO_blk[3] = 1'b0;
    assign proc_4_input_sync_blk[3] = 1'b0;
    assign proc_4_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_4[3] = dl_detect_out ? proc_dep_vld_vec_4_reg[3] : (proc_4_data_FIFO_blk[3] | proc_4_data_PIPO_blk[3] | proc_4_start_FIFO_blk[3] | proc_4_TLF_FIFO_blk[3] | proc_4_input_sync_blk[3] | proc_4_output_sync_blk[3]);
    assign proc_4_data_FIFO_blk[4] = 1'b0 | (~AESL_inst_system_top.module2_coarse_cfo_U0.m2_searchBufferLen_blk_n);
    assign proc_4_data_PIPO_blk[4] = 1'b0;
    assign proc_4_start_FIFO_blk[4] = 1'b0 | (~AESL_inst_system_top.start_for_consume_searchBufferLen_U0_U.if_full_n & AESL_inst_system_top.module2_coarse_cfo_U0.ap_start & ~AESL_inst_system_top.module2_coarse_cfo_U0.real_start & (trans_in_cnt_2 == trans_out_cnt_2) & ~AESL_inst_system_top.start_for_consume_searchBufferLen_U0_U.if_read);
    assign proc_4_TLF_FIFO_blk[4] = 1'b0;
    assign proc_4_input_sync_blk[4] = 1'b0;
    assign proc_4_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_4[4] = dl_detect_out ? proc_dep_vld_vec_4_reg[4] : (proc_4_data_FIFO_blk[4] | proc_4_data_PIPO_blk[4] | proc_4_start_FIFO_blk[4] | proc_4_TLF_FIFO_blk[4] | proc_4_input_sync_blk[4] | proc_4_output_sync_blk[4]);
    assign proc_4_data_FIFO_blk[5] = 1'b0 | (~AESL_inst_system_top.module2_coarse_cfo_U0.grp_module2_coarse_cfo_Pipeline_PHASE_A_fu_312.m2_to_m4_data_blk_n) | (~AESL_inst_system_top.module2_coarse_cfo_U0.m2_to_m4_startOffset_blk_n) | (~AESL_inst_system_top.module2_coarse_cfo_U0.grp_module2_coarse_cfo_Pipeline_PHASE_A_fu_312.m2_to_m4_startOffset_blk_n) | (~AESL_inst_system_top.module2_coarse_cfo_U0.add_loc_c_blk_n);
    assign proc_4_data_PIPO_blk[5] = 1'b0;
    assign proc_4_start_FIFO_blk[5] = 1'b0 | (~AESL_inst_system_top.start_for_module4_fine_cfo_apply_U0_U.if_full_n & AESL_inst_system_top.module2_coarse_cfo_U0.ap_start & ~AESL_inst_system_top.module2_coarse_cfo_U0.real_start & (trans_in_cnt_2 == trans_out_cnt_2) & ~AESL_inst_system_top.start_for_module4_fine_cfo_apply_U0_U.if_read);
    assign proc_4_TLF_FIFO_blk[5] = 1'b0;
    assign proc_4_input_sync_blk[5] = 1'b0;
    assign proc_4_output_sync_blk[5] = 1'b0;
    assign proc_dep_vld_vec_4[5] = dl_detect_out ? proc_dep_vld_vec_4_reg[5] : (proc_4_data_FIFO_blk[5] | proc_4_data_PIPO_blk[5] | proc_4_start_FIFO_blk[5] | proc_4_TLF_FIFO_blk[5] | proc_4_input_sync_blk[5] | proc_4_output_sync_blk[5]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_4_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_4_reg <= proc_dep_vld_vec_4;
        end
    end
    assign in_chan_dep_vld_vec_4[0] = dep_chan_vld_3_4;
    assign in_chan_dep_data_vec_4[13 : 0] = dep_chan_data_3_4;
    assign token_in_vec_4[0] = token_3_4;
    assign in_chan_dep_vld_vec_4[1] = dep_chan_vld_5_4;
    assign in_chan_dep_data_vec_4[27 : 14] = dep_chan_data_5_4;
    assign token_in_vec_4[1] = token_5_4;
    assign in_chan_dep_vld_vec_4[2] = dep_chan_vld_6_4;
    assign in_chan_dep_data_vec_4[41 : 28] = dep_chan_data_6_4;
    assign token_in_vec_4[2] = token_6_4;
    assign in_chan_dep_vld_vec_4[3] = dep_chan_vld_7_4;
    assign in_chan_dep_data_vec_4[55 : 42] = dep_chan_data_7_4;
    assign token_in_vec_4[3] = token_7_4;
    assign in_chan_dep_vld_vec_4[4] = dep_chan_vld_12_4;
    assign in_chan_dep_data_vec_4[69 : 56] = dep_chan_data_12_4;
    assign token_in_vec_4[4] = token_12_4;
    assign in_chan_dep_vld_vec_4[5] = dep_chan_vld_13_4;
    assign in_chan_dep_data_vec_4[83 : 70] = dep_chan_data_13_4;
    assign token_in_vec_4[5] = token_13_4;
    assign dep_chan_vld_4_3 = out_chan_dep_vld_vec_4[0];
    assign dep_chan_data_4_3 = out_chan_dep_data_4;
    assign token_4_3 = token_out_vec_4[0];
    assign dep_chan_vld_4_6 = out_chan_dep_vld_vec_4[1];
    assign dep_chan_data_4_6 = out_chan_dep_data_4;
    assign token_4_6 = token_out_vec_4[1];
    assign dep_chan_vld_4_7 = out_chan_dep_vld_vec_4[2];
    assign dep_chan_data_4_7 = out_chan_dep_data_4;
    assign token_4_7 = token_out_vec_4[2];
    assign dep_chan_vld_4_13 = out_chan_dep_vld_vec_4[3];
    assign dep_chan_data_4_13 = out_chan_dep_data_4;
    assign token_4_13 = token_out_vec_4[3];
    assign dep_chan_vld_4_5 = out_chan_dep_vld_vec_4[4];
    assign dep_chan_data_4_5 = out_chan_dep_data_4;
    assign token_4_5 = token_out_vec_4[4];
    assign dep_chan_vld_4_12 = out_chan_dep_vld_vec_4[5];
    assign dep_chan_data_4_12 = out_chan_dep_data_4;
    assign token_4_12 = token_out_vec_4[5];

    // Process: AESL_inst_system_top.consume_searchBufferLen_U0
    AESL_deadlock_detect_unit #(14, 5, 4, 4) AESL_deadlock_detect_unit_5 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_5),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_5),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_5),
        .token_in_vec(token_in_vec_5),
        .dl_detect_in(dl_detect_out),
        .origin(origin[5]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_5),
        .out_chan_dep_data(out_chan_dep_data_5),
        .token_out_vec(token_out_vec_5),
        .dl_detect_out(dl_in_vec[5]));

    assign proc_5_data_FIFO_blk[0] = 1'b0 | (~AESL_inst_system_top.consume_searchBufferLen_U0.m2_searchBufferLen_blk_n);
    assign proc_5_data_PIPO_blk[0] = 1'b0;
    assign proc_5_start_FIFO_blk[0] = 1'b0 | (~AESL_inst_system_top.start_for_consume_searchBufferLen_U0_U.if_empty_n & AESL_inst_system_top.consume_searchBufferLen_U0.ap_idle & ~AESL_inst_system_top.start_for_consume_searchBufferLen_U0_U.if_write);
    assign proc_5_TLF_FIFO_blk[0] = 1'b0;
    assign proc_5_input_sync_blk[0] = 1'b0;
    assign proc_5_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_5[0] = dl_detect_out ? proc_dep_vld_vec_5_reg[0] : (proc_5_data_FIFO_blk[0] | proc_5_data_PIPO_blk[0] | proc_5_start_FIFO_blk[0] | proc_5_TLF_FIFO_blk[0] | proc_5_input_sync_blk[0] | proc_5_output_sync_blk[0]);
    assign proc_5_data_FIFO_blk[1] = 1'b0;
    assign proc_5_data_PIPO_blk[1] = 1'b0;
    assign proc_5_start_FIFO_blk[1] = 1'b0;
    assign proc_5_TLF_FIFO_blk[1] = 1'b0;
    assign proc_5_input_sync_blk[1] = 1'b0;
    assign proc_5_output_sync_blk[1] = 1'b0 | (ap_done_reg_2 & AESL_inst_system_top.consume_searchBufferLen_U0.ap_done & ~AESL_inst_system_top.consume_filteredLen_U0.ap_done);
    assign proc_dep_vld_vec_5[1] = dl_detect_out ? proc_dep_vld_vec_5_reg[1] : (proc_5_data_FIFO_blk[1] | proc_5_data_PIPO_blk[1] | proc_5_start_FIFO_blk[1] | proc_5_TLF_FIFO_blk[1] | proc_5_input_sync_blk[1] | proc_5_output_sync_blk[1]);
    assign proc_5_data_FIFO_blk[2] = 1'b0;
    assign proc_5_data_PIPO_blk[2] = 1'b0;
    assign proc_5_start_FIFO_blk[2] = 1'b0;
    assign proc_5_TLF_FIFO_blk[2] = 1'b0;
    assign proc_5_input_sync_blk[2] = 1'b0;
    assign proc_5_output_sync_blk[2] = 1'b0 | (ap_done_reg_2 & AESL_inst_system_top.consume_searchBufferLen_U0.ap_done & ~AESL_inst_system_top.module4_fine_cfo_apply_U0.ap_done);
    assign proc_dep_vld_vec_5[2] = dl_detect_out ? proc_dep_vld_vec_5_reg[2] : (proc_5_data_FIFO_blk[2] | proc_5_data_PIPO_blk[2] | proc_5_start_FIFO_blk[2] | proc_5_TLF_FIFO_blk[2] | proc_5_input_sync_blk[2] | proc_5_output_sync_blk[2]);
    assign proc_5_data_FIFO_blk[3] = 1'b0;
    assign proc_5_data_PIPO_blk[3] = 1'b0;
    assign proc_5_start_FIFO_blk[3] = 1'b0;
    assign proc_5_TLF_FIFO_blk[3] = 1'b0;
    assign proc_5_input_sync_blk[3] = 1'b0;
    assign proc_5_output_sync_blk[3] = 1'b0 | (ap_done_reg_2 & AESL_inst_system_top.consume_searchBufferLen_U0.ap_done & ~AESL_inst_system_top.forward_coarseFreqOff_U0.ap_done);
    assign proc_dep_vld_vec_5[3] = dl_detect_out ? proc_dep_vld_vec_5_reg[3] : (proc_5_data_FIFO_blk[3] | proc_5_data_PIPO_blk[3] | proc_5_start_FIFO_blk[3] | proc_5_TLF_FIFO_blk[3] | proc_5_input_sync_blk[3] | proc_5_output_sync_blk[3]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_5_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_5_reg <= proc_dep_vld_vec_5;
        end
    end
    assign in_chan_dep_vld_vec_5[0] = dep_chan_vld_2_5;
    assign in_chan_dep_data_vec_5[13 : 0] = dep_chan_data_2_5;
    assign token_in_vec_5[0] = token_2_5;
    assign in_chan_dep_vld_vec_5[1] = dep_chan_vld_4_5;
    assign in_chan_dep_data_vec_5[27 : 14] = dep_chan_data_4_5;
    assign token_in_vec_5[1] = token_4_5;
    assign in_chan_dep_vld_vec_5[2] = dep_chan_vld_12_5;
    assign in_chan_dep_data_vec_5[41 : 28] = dep_chan_data_12_5;
    assign token_in_vec_5[2] = token_12_5;
    assign in_chan_dep_vld_vec_5[3] = dep_chan_vld_13_5;
    assign in_chan_dep_data_vec_5[55 : 42] = dep_chan_data_13_5;
    assign token_in_vec_5[3] = token_13_5;
    assign dep_chan_vld_5_4 = out_chan_dep_vld_vec_5[0];
    assign dep_chan_data_5_4 = out_chan_dep_data_5;
    assign token_5_4 = token_out_vec_5[0];
    assign dep_chan_vld_5_2 = out_chan_dep_vld_vec_5[1];
    assign dep_chan_data_5_2 = out_chan_dep_data_5;
    assign token_5_2 = token_out_vec_5[1];
    assign dep_chan_vld_5_12 = out_chan_dep_vld_vec_5[2];
    assign dep_chan_data_5_12 = out_chan_dep_data_5;
    assign token_5_12 = token_out_vec_5[2];
    assign dep_chan_vld_5_13 = out_chan_dep_vld_vec_5[3];
    assign dep_chan_data_5_13 = out_chan_dep_data_5;
    assign token_5_13 = token_out_vec_5[3];

    // Process: AESL_inst_system_top.module3_fine_sync_U0
    AESL_deadlock_detect_unit #(14, 6, 2, 2) AESL_deadlock_detect_unit_6 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_6),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_6),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_6),
        .token_in_vec(token_in_vec_6),
        .dl_detect_in(dl_detect_out),
        .origin(origin[6]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_6),
        .out_chan_dep_data(out_chan_dep_data_6),
        .token_out_vec(token_out_vec_6),
        .dl_detect_out(dl_in_vec[6]));

    assign proc_6_data_FIFO_blk[0] = 1'b0 | (~AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.m2_search_buffer_blk_n);
    assign proc_6_data_PIPO_blk[0] = 1'b0;
    assign proc_6_start_FIFO_blk[0] = 1'b0 | (~AESL_inst_system_top.start_for_module3_fine_sync_U0_U.if_empty_n & AESL_inst_system_top.module3_fine_sync_U0.ap_idle & ~AESL_inst_system_top.start_for_module3_fine_sync_U0_U.if_write);
    assign proc_6_TLF_FIFO_blk[0] = 1'b0;
    assign proc_6_input_sync_blk[0] = 1'b0;
    assign proc_6_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_6[0] = dl_detect_out ? proc_dep_vld_vec_6_reg[0] : (proc_6_data_FIFO_blk[0] | proc_6_data_PIPO_blk[0] | proc_6_start_FIFO_blk[0] | proc_6_TLF_FIFO_blk[0] | proc_6_input_sync_blk[0] | proc_6_output_sync_blk[0]);
    assign proc_6_data_FIFO_blk[1] = 1'b0 | (~AESL_inst_system_top.module3_fine_sync_U0.combine_and_peak_U0.m3_fineOffset_blk_n);
    assign proc_6_data_PIPO_blk[1] = 1'b0;
    assign proc_6_start_FIFO_blk[1] = 1'b0;
    assign proc_6_TLF_FIFO_blk[1] = 1'b0;
    assign proc_6_input_sync_blk[1] = 1'b0;
    assign proc_6_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_6[1] = dl_detect_out ? proc_dep_vld_vec_6_reg[1] : (proc_6_data_FIFO_blk[1] | proc_6_data_PIPO_blk[1] | proc_6_start_FIFO_blk[1] | proc_6_TLF_FIFO_blk[1] | proc_6_input_sync_blk[1] | proc_6_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_6_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_6_reg <= proc_dep_vld_vec_6;
        end
    end
    assign in_chan_dep_vld_vec_6[0] = dep_chan_vld_4_6;
    assign in_chan_dep_data_vec_6[13 : 0] = dep_chan_data_4_6;
    assign token_in_vec_6[0] = token_4_6;
    assign in_chan_dep_vld_vec_6[1] = dep_chan_vld_12_6;
    assign in_chan_dep_data_vec_6[27 : 14] = dep_chan_data_12_6;
    assign token_in_vec_6[1] = token_12_6;
    assign dep_chan_vld_6_4 = out_chan_dep_vld_vec_6[0];
    assign dep_chan_data_6_4 = out_chan_dep_data_6;
    assign token_6_4 = token_out_vec_6[0];
    assign dep_chan_vld_6_12 = out_chan_dep_vld_vec_6[1];
    assign dep_chan_data_6_12 = out_chan_dep_data_6;
    assign token_6_12 = token_out_vec_6[1];

    // Process: AESL_inst_system_top.module3_fine_sync_U0.split_input_U0
    AESL_deadlock_detect_unit #(14, 7, 5, 5) AESL_deadlock_detect_unit_7 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_7),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_7),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_7),
        .token_in_vec(token_in_vec_7),
        .dl_detect_in(dl_detect_out),
        .origin(origin[7]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_7),
        .out_chan_dep_data(out_chan_dep_data_7),
        .token_out_vec(token_out_vec_7),
        .dl_detect_out(dl_in_vec[7]));

    assign proc_7_data_FIFO_blk[0] = 1'b0 | (~AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.m2_search_buffer_blk_n);
    assign proc_7_data_PIPO_blk[0] = 1'b0;
    assign proc_7_start_FIFO_blk[0] = 1'b0;
    assign proc_7_TLF_FIFO_blk[0] = 1'b0;
    assign proc_7_input_sync_blk[0] = 1'b0;
    assign proc_7_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_7[0] = dl_detect_out ? proc_dep_vld_vec_7_reg[0] : (proc_7_data_FIFO_blk[0] | proc_7_data_PIPO_blk[0] | proc_7_start_FIFO_blk[0] | proc_7_TLF_FIFO_blk[0] | proc_7_input_sync_blk[0] | proc_7_output_sync_blk[0]);
    assign proc_7_data_FIFO_blk[1] = 1'b0 | (~AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.re_stream_blk_n);
    assign proc_7_data_PIPO_blk[1] = 1'b0;
    assign proc_7_start_FIFO_blk[1] = 1'b0 | (~AESL_inst_system_top.module3_fine_sync_U0.start_for_run_1_U0_U.if_full_n & AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.ap_start & ~AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.real_start & (trans_in_cnt_3 == trans_out_cnt_3) & ~AESL_inst_system_top.module3_fine_sync_U0.start_for_run_1_U0_U.if_read);
    assign proc_7_TLF_FIFO_blk[1] = 1'b0;
    assign proc_7_input_sync_blk[1] = 1'b0;
    assign proc_7_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_7[1] = dl_detect_out ? proc_dep_vld_vec_7_reg[1] : (proc_7_data_FIFO_blk[1] | proc_7_data_PIPO_blk[1] | proc_7_start_FIFO_blk[1] | proc_7_TLF_FIFO_blk[1] | proc_7_input_sync_blk[1] | proc_7_output_sync_blk[1]);
    assign proc_7_data_FIFO_blk[2] = 1'b0 | (~AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.im_stream_blk_n);
    assign proc_7_data_PIPO_blk[2] = 1'b0;
    assign proc_7_start_FIFO_blk[2] = 1'b0 | (~AESL_inst_system_top.module3_fine_sync_U0.start_for_run_2_U0_U.if_full_n & AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.ap_start & ~AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.real_start & (trans_in_cnt_3 == trans_out_cnt_3) & ~AESL_inst_system_top.module3_fine_sync_U0.start_for_run_2_U0_U.if_read);
    assign proc_7_TLF_FIFO_blk[2] = 1'b0;
    assign proc_7_input_sync_blk[2] = 1'b0;
    assign proc_7_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_7[2] = dl_detect_out ? proc_dep_vld_vec_7_reg[2] : (proc_7_data_FIFO_blk[2] | proc_7_data_PIPO_blk[2] | proc_7_start_FIFO_blk[2] | proc_7_TLF_FIFO_blk[2] | proc_7_input_sync_blk[2] | proc_7_output_sync_blk[2]);
    assign proc_7_data_FIFO_blk[3] = 1'b0 | (~AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.sum_stream_blk_n);
    assign proc_7_data_PIPO_blk[3] = 1'b0;
    assign proc_7_start_FIFO_blk[3] = 1'b0 | (~AESL_inst_system_top.module3_fine_sync_U0.start_for_run_U0_U.if_full_n & AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.ap_start & ~AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.real_start & (trans_in_cnt_3 == trans_out_cnt_3) & ~AESL_inst_system_top.module3_fine_sync_U0.start_for_run_U0_U.if_read);
    assign proc_7_TLF_FIFO_blk[3] = 1'b0;
    assign proc_7_input_sync_blk[3] = 1'b0;
    assign proc_7_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_7[3] = dl_detect_out ? proc_dep_vld_vec_7_reg[3] : (proc_7_data_FIFO_blk[3] | proc_7_data_PIPO_blk[3] | proc_7_start_FIFO_blk[3] | proc_7_TLF_FIFO_blk[3] | proc_7_input_sync_blk[3] | proc_7_output_sync_blk[3]);
    assign proc_7_data_FIFO_blk[4] = 1'b0;
    assign proc_7_data_PIPO_blk[4] = 1'b0;
    assign proc_7_start_FIFO_blk[4] = 1'b0 | (~AESL_inst_system_top.module3_fine_sync_U0.start_for_combine_and_peak_U0_U.if_full_n & AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.ap_start & ~AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.real_start & (trans_in_cnt_3 == trans_out_cnt_3) & ~AESL_inst_system_top.module3_fine_sync_U0.start_for_combine_and_peak_U0_U.if_read);
    assign proc_7_TLF_FIFO_blk[4] = 1'b0;
    assign proc_7_input_sync_blk[4] = 1'b0;
    assign proc_7_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_7[4] = dl_detect_out ? proc_dep_vld_vec_7_reg[4] : (proc_7_data_FIFO_blk[4] | proc_7_data_PIPO_blk[4] | proc_7_start_FIFO_blk[4] | proc_7_TLF_FIFO_blk[4] | proc_7_input_sync_blk[4] | proc_7_output_sync_blk[4]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_7_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_7_reg <= proc_dep_vld_vec_7;
        end
    end
    assign in_chan_dep_vld_vec_7[0] = dep_chan_vld_4_7;
    assign in_chan_dep_data_vec_7[13 : 0] = dep_chan_data_4_7;
    assign token_in_vec_7[0] = token_4_7;
    assign in_chan_dep_vld_vec_7[1] = dep_chan_vld_8_7;
    assign in_chan_dep_data_vec_7[27 : 14] = dep_chan_data_8_7;
    assign token_in_vec_7[1] = token_8_7;
    assign in_chan_dep_vld_vec_7[2] = dep_chan_vld_9_7;
    assign in_chan_dep_data_vec_7[41 : 28] = dep_chan_data_9_7;
    assign token_in_vec_7[2] = token_9_7;
    assign in_chan_dep_vld_vec_7[3] = dep_chan_vld_10_7;
    assign in_chan_dep_data_vec_7[55 : 42] = dep_chan_data_10_7;
    assign token_in_vec_7[3] = token_10_7;
    assign in_chan_dep_vld_vec_7[4] = dep_chan_vld_11_7;
    assign in_chan_dep_data_vec_7[69 : 56] = dep_chan_data_11_7;
    assign token_in_vec_7[4] = token_11_7;
    assign dep_chan_vld_7_4 = out_chan_dep_vld_vec_7[0];
    assign dep_chan_data_7_4 = out_chan_dep_data_7;
    assign token_7_4 = token_out_vec_7[0];
    assign dep_chan_vld_7_8 = out_chan_dep_vld_vec_7[1];
    assign dep_chan_data_7_8 = out_chan_dep_data_7;
    assign token_7_8 = token_out_vec_7[1];
    assign dep_chan_vld_7_9 = out_chan_dep_vld_vec_7[2];
    assign dep_chan_data_7_9 = out_chan_dep_data_7;
    assign token_7_9 = token_out_vec_7[2];
    assign dep_chan_vld_7_10 = out_chan_dep_vld_vec_7[3];
    assign dep_chan_data_7_10 = out_chan_dep_data_7;
    assign token_7_10 = token_out_vec_7[3];
    assign dep_chan_vld_7_11 = out_chan_dep_vld_vec_7[4];
    assign dep_chan_data_7_11 = out_chan_dep_data_7;
    assign token_7_11 = token_out_vec_7[4];

    // Process: AESL_inst_system_top.module3_fine_sync_U0.run_1_U0
    AESL_deadlock_detect_unit #(14, 8, 2, 1) AESL_deadlock_detect_unit_8 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_8),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_8),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_8),
        .token_in_vec(token_in_vec_8),
        .dl_detect_in(dl_detect_out),
        .origin(origin[8]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_8),
        .out_chan_dep_data(out_chan_dep_data_8),
        .token_out_vec(token_out_vec_8),
        .dl_detect_out(dl_in_vec[8]));

    assign proc_8_data_FIFO_blk[0] = 1'b0;
    assign proc_8_data_PIPO_blk[0] = 1'b0;
    assign proc_8_start_FIFO_blk[0] = 1'b0 | (~AESL_inst_system_top.module3_fine_sync_U0.start_for_run_1_U0_U.if_empty_n & AESL_inst_system_top.module3_fine_sync_U0.run_1_U0.ap_idle & ~AESL_inst_system_top.module3_fine_sync_U0.start_for_run_1_U0_U.if_write);
    assign proc_8_TLF_FIFO_blk[0] = 1'b0;
    assign proc_8_input_sync_blk[0] = 1'b0;
    assign proc_8_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_8[0] = dl_detect_out ? proc_dep_vld_vec_8_reg[0] : (proc_8_data_FIFO_blk[0] | proc_8_data_PIPO_blk[0] | proc_8_start_FIFO_blk[0] | proc_8_TLF_FIFO_blk[0] | proc_8_input_sync_blk[0] | proc_8_output_sync_blk[0]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_8_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_8_reg <= proc_dep_vld_vec_8;
        end
    end
    assign in_chan_dep_vld_vec_8[0] = dep_chan_vld_7_8;
    assign in_chan_dep_data_vec_8[13 : 0] = dep_chan_data_7_8;
    assign token_in_vec_8[0] = token_7_8;
    assign in_chan_dep_vld_vec_8[1] = dep_chan_vld_11_8;
    assign in_chan_dep_data_vec_8[27 : 14] = dep_chan_data_11_8;
    assign token_in_vec_8[1] = token_11_8;
    assign dep_chan_vld_8_7 = out_chan_dep_vld_vec_8[0];
    assign dep_chan_data_8_7 = out_chan_dep_data_8;
    assign token_8_7 = token_out_vec_8[0];

    // Process: AESL_inst_system_top.module3_fine_sync_U0.run_2_U0
    AESL_deadlock_detect_unit #(14, 9, 2, 1) AESL_deadlock_detect_unit_9 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_9),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_9),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_9),
        .token_in_vec(token_in_vec_9),
        .dl_detect_in(dl_detect_out),
        .origin(origin[9]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_9),
        .out_chan_dep_data(out_chan_dep_data_9),
        .token_out_vec(token_out_vec_9),
        .dl_detect_out(dl_in_vec[9]));

    assign proc_9_data_FIFO_blk[0] = 1'b0;
    assign proc_9_data_PIPO_blk[0] = 1'b0;
    assign proc_9_start_FIFO_blk[0] = 1'b0 | (~AESL_inst_system_top.module3_fine_sync_U0.start_for_run_2_U0_U.if_empty_n & AESL_inst_system_top.module3_fine_sync_U0.run_2_U0.ap_idle & ~AESL_inst_system_top.module3_fine_sync_U0.start_for_run_2_U0_U.if_write);
    assign proc_9_TLF_FIFO_blk[0] = 1'b0;
    assign proc_9_input_sync_blk[0] = 1'b0;
    assign proc_9_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_9[0] = dl_detect_out ? proc_dep_vld_vec_9_reg[0] : (proc_9_data_FIFO_blk[0] | proc_9_data_PIPO_blk[0] | proc_9_start_FIFO_blk[0] | proc_9_TLF_FIFO_blk[0] | proc_9_input_sync_blk[0] | proc_9_output_sync_blk[0]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_9_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_9_reg <= proc_dep_vld_vec_9;
        end
    end
    assign in_chan_dep_vld_vec_9[0] = dep_chan_vld_7_9;
    assign in_chan_dep_data_vec_9[13 : 0] = dep_chan_data_7_9;
    assign token_in_vec_9[0] = token_7_9;
    assign in_chan_dep_vld_vec_9[1] = dep_chan_vld_11_9;
    assign in_chan_dep_data_vec_9[27 : 14] = dep_chan_data_11_9;
    assign token_in_vec_9[1] = token_11_9;
    assign dep_chan_vld_9_7 = out_chan_dep_vld_vec_9[0];
    assign dep_chan_data_9_7 = out_chan_dep_data_9;
    assign token_9_7 = token_out_vec_9[0];

    // Process: AESL_inst_system_top.module3_fine_sync_U0.run_U0
    AESL_deadlock_detect_unit #(14, 10, 2, 1) AESL_deadlock_detect_unit_10 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_10),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_10),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_10),
        .token_in_vec(token_in_vec_10),
        .dl_detect_in(dl_detect_out),
        .origin(origin[10]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_10),
        .out_chan_dep_data(out_chan_dep_data_10),
        .token_out_vec(token_out_vec_10),
        .dl_detect_out(dl_in_vec[10]));

    assign proc_10_data_FIFO_blk[0] = 1'b0;
    assign proc_10_data_PIPO_blk[0] = 1'b0;
    assign proc_10_start_FIFO_blk[0] = 1'b0 | (~AESL_inst_system_top.module3_fine_sync_U0.start_for_run_U0_U.if_empty_n & AESL_inst_system_top.module3_fine_sync_U0.run_U0.ap_idle & ~AESL_inst_system_top.module3_fine_sync_U0.start_for_run_U0_U.if_write);
    assign proc_10_TLF_FIFO_blk[0] = 1'b0;
    assign proc_10_input_sync_blk[0] = 1'b0;
    assign proc_10_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_10[0] = dl_detect_out ? proc_dep_vld_vec_10_reg[0] : (proc_10_data_FIFO_blk[0] | proc_10_data_PIPO_blk[0] | proc_10_start_FIFO_blk[0] | proc_10_TLF_FIFO_blk[0] | proc_10_input_sync_blk[0] | proc_10_output_sync_blk[0]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_10_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_10_reg <= proc_dep_vld_vec_10;
        end
    end
    assign in_chan_dep_vld_vec_10[0] = dep_chan_vld_7_10;
    assign in_chan_dep_data_vec_10[13 : 0] = dep_chan_data_7_10;
    assign token_in_vec_10[0] = token_7_10;
    assign in_chan_dep_vld_vec_10[1] = dep_chan_vld_11_10;
    assign in_chan_dep_data_vec_10[27 : 14] = dep_chan_data_11_10;
    assign token_in_vec_10[1] = token_11_10;
    assign dep_chan_vld_10_7 = out_chan_dep_vld_vec_10[0];
    assign dep_chan_data_10_7 = out_chan_dep_data_10;
    assign token_10_7 = token_out_vec_10[0];

    // Process: AESL_inst_system_top.module3_fine_sync_U0.combine_and_peak_U0
    AESL_deadlock_detect_unit #(14, 11, 2, 5) AESL_deadlock_detect_unit_11 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_11),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_11),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_11),
        .token_in_vec(token_in_vec_11),
        .dl_detect_in(dl_detect_out),
        .origin(origin[11]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_11),
        .out_chan_dep_data(out_chan_dep_data_11),
        .token_out_vec(token_out_vec_11),
        .dl_detect_out(dl_in_vec[11]));

    assign proc_11_data_FIFO_blk[0] = 1'b0 | (~AESL_inst_system_top.module3_fine_sync_U0.combine_and_peak_U0.grp_combine_and_peak_Pipeline_COMBINE_fu_45.re_out_blk_n);
    assign proc_11_data_PIPO_blk[0] = 1'b0;
    assign proc_11_start_FIFO_blk[0] = 1'b0;
    assign proc_11_TLF_FIFO_blk[0] = 1'b0;
    assign proc_11_input_sync_blk[0] = 1'b0;
    assign proc_11_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_11[0] = dl_detect_out ? proc_dep_vld_vec_11_reg[0] : (proc_11_data_FIFO_blk[0] | proc_11_data_PIPO_blk[0] | proc_11_start_FIFO_blk[0] | proc_11_TLF_FIFO_blk[0] | proc_11_input_sync_blk[0] | proc_11_output_sync_blk[0]);
    assign proc_11_data_FIFO_blk[1] = 1'b0 | (~AESL_inst_system_top.module3_fine_sync_U0.combine_and_peak_U0.grp_combine_and_peak_Pipeline_COMBINE_fu_45.im_out_blk_n);
    assign proc_11_data_PIPO_blk[1] = 1'b0;
    assign proc_11_start_FIFO_blk[1] = 1'b0;
    assign proc_11_TLF_FIFO_blk[1] = 1'b0;
    assign proc_11_input_sync_blk[1] = 1'b0;
    assign proc_11_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_11[1] = dl_detect_out ? proc_dep_vld_vec_11_reg[1] : (proc_11_data_FIFO_blk[1] | proc_11_data_PIPO_blk[1] | proc_11_start_FIFO_blk[1] | proc_11_TLF_FIFO_blk[1] | proc_11_input_sync_blk[1] | proc_11_output_sync_blk[1]);
    assign proc_11_data_FIFO_blk[2] = 1'b0 | (~AESL_inst_system_top.module3_fine_sync_U0.combine_and_peak_U0.grp_combine_and_peak_Pipeline_COMBINE_fu_45.sum_out_blk_n);
    assign proc_11_data_PIPO_blk[2] = 1'b0;
    assign proc_11_start_FIFO_blk[2] = 1'b0;
    assign proc_11_TLF_FIFO_blk[2] = 1'b0;
    assign proc_11_input_sync_blk[2] = 1'b0;
    assign proc_11_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_11[2] = dl_detect_out ? proc_dep_vld_vec_11_reg[2] : (proc_11_data_FIFO_blk[2] | proc_11_data_PIPO_blk[2] | proc_11_start_FIFO_blk[2] | proc_11_TLF_FIFO_blk[2] | proc_11_input_sync_blk[2] | proc_11_output_sync_blk[2]);
    assign proc_11_data_FIFO_blk[3] = 1'b0 | (~AESL_inst_system_top.module3_fine_sync_U0.combine_and_peak_U0.m3_fineOffset_blk_n);
    assign proc_11_data_PIPO_blk[3] = 1'b0;
    assign proc_11_start_FIFO_blk[3] = 1'b0;
    assign proc_11_TLF_FIFO_blk[3] = 1'b0;
    assign proc_11_input_sync_blk[3] = 1'b0;
    assign proc_11_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_11[3] = dl_detect_out ? proc_dep_vld_vec_11_reg[3] : (proc_11_data_FIFO_blk[3] | proc_11_data_PIPO_blk[3] | proc_11_start_FIFO_blk[3] | proc_11_TLF_FIFO_blk[3] | proc_11_input_sync_blk[3] | proc_11_output_sync_blk[3]);
    assign proc_11_data_FIFO_blk[4] = 1'b0;
    assign proc_11_data_PIPO_blk[4] = 1'b0;
    assign proc_11_start_FIFO_blk[4] = 1'b0 | (~AESL_inst_system_top.module3_fine_sync_U0.start_for_combine_and_peak_U0_U.if_empty_n & AESL_inst_system_top.module3_fine_sync_U0.combine_and_peak_U0.ap_idle & ~AESL_inst_system_top.module3_fine_sync_U0.start_for_combine_and_peak_U0_U.if_write);
    assign proc_11_TLF_FIFO_blk[4] = 1'b0;
    assign proc_11_input_sync_blk[4] = 1'b0;
    assign proc_11_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_11[4] = dl_detect_out ? proc_dep_vld_vec_11_reg[4] : (proc_11_data_FIFO_blk[4] | proc_11_data_PIPO_blk[4] | proc_11_start_FIFO_blk[4] | proc_11_TLF_FIFO_blk[4] | proc_11_input_sync_blk[4] | proc_11_output_sync_blk[4]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_11_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_11_reg <= proc_dep_vld_vec_11;
        end
    end
    assign in_chan_dep_vld_vec_11[0] = dep_chan_vld_7_11;
    assign in_chan_dep_data_vec_11[13 : 0] = dep_chan_data_7_11;
    assign token_in_vec_11[0] = token_7_11;
    assign in_chan_dep_vld_vec_11[1] = dep_chan_vld_12_11;
    assign in_chan_dep_data_vec_11[27 : 14] = dep_chan_data_12_11;
    assign token_in_vec_11[1] = token_12_11;
    assign dep_chan_vld_11_8 = out_chan_dep_vld_vec_11[0];
    assign dep_chan_data_11_8 = out_chan_dep_data_11;
    assign token_11_8 = token_out_vec_11[0];
    assign dep_chan_vld_11_9 = out_chan_dep_vld_vec_11[1];
    assign dep_chan_data_11_9 = out_chan_dep_data_11;
    assign token_11_9 = token_out_vec_11[1];
    assign dep_chan_vld_11_10 = out_chan_dep_vld_vec_11[2];
    assign dep_chan_data_11_10 = out_chan_dep_data_11;
    assign token_11_10 = token_out_vec_11[2];
    assign dep_chan_vld_11_12 = out_chan_dep_vld_vec_11[3];
    assign dep_chan_data_11_12 = out_chan_dep_data_11;
    assign token_11_12 = token_out_vec_11[3];
    assign dep_chan_vld_11_7 = out_chan_dep_vld_vec_11[4];
    assign dep_chan_data_11_7 = out_chan_dep_data_11;
    assign token_11_7 = token_out_vec_11[4];

    // Process: AESL_inst_system_top.module4_fine_cfo_apply_U0
    AESL_deadlock_detect_unit #(14, 12, 6, 6) AESL_deadlock_detect_unit_12 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_12),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_12),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_12),
        .token_in_vec(token_in_vec_12),
        .dl_detect_in(dl_detect_out),
        .origin(origin[12]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_12),
        .out_chan_dep_data(out_chan_dep_data_12),
        .token_out_vec(token_out_vec_12),
        .dl_detect_out(dl_in_vec[12]));

    assign proc_12_data_FIFO_blk[0] = 1'b0 | (~AESL_inst_system_top.module4_fine_cfo_apply_U0.grp_module4_fine_cfo_apply_Pipeline_POLL_START_fu_355.m2_to_m4_data_blk_n) | (~AESL_inst_system_top.module4_fine_cfo_apply_U0.m2_to_m4_startOffset_blk_n) | (~AESL_inst_system_top.module4_fine_cfo_apply_U0.add_loc_blk_n);
    assign proc_12_data_PIPO_blk[0] = 1'b0;
    assign proc_12_start_FIFO_blk[0] = 1'b0 | (~AESL_inst_system_top.start_for_module4_fine_cfo_apply_U0_U.if_empty_n & AESL_inst_system_top.module4_fine_cfo_apply_U0.ap_idle & ~AESL_inst_system_top.start_for_module4_fine_cfo_apply_U0_U.if_write);
    assign proc_12_TLF_FIFO_blk[0] = 1'b0;
    assign proc_12_input_sync_blk[0] = 1'b0;
    assign proc_12_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_12[0] = dl_detect_out ? proc_dep_vld_vec_12_reg[0] : (proc_12_data_FIFO_blk[0] | proc_12_data_PIPO_blk[0] | proc_12_start_FIFO_blk[0] | proc_12_TLF_FIFO_blk[0] | proc_12_input_sync_blk[0] | proc_12_output_sync_blk[0]);
    assign proc_12_data_FIFO_blk[1] = 1'b0 | (~AESL_inst_system_top.module4_fine_cfo_apply_U0.m3_fineOffset_blk_n);
    assign proc_12_data_PIPO_blk[1] = 1'b0;
    assign proc_12_start_FIFO_blk[1] = 1'b0;
    assign proc_12_TLF_FIFO_blk[1] = 1'b0;
    assign proc_12_input_sync_blk[1] = 1'b0;
    assign proc_12_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_12[1] = dl_detect_out ? proc_dep_vld_vec_12_reg[1] : (proc_12_data_FIFO_blk[1] | proc_12_data_PIPO_blk[1] | proc_12_start_FIFO_blk[1] | proc_12_TLF_FIFO_blk[1] | proc_12_input_sync_blk[1] | proc_12_output_sync_blk[1]);
    assign proc_12_data_FIFO_blk[2] = 1'b0 | (~AESL_inst_system_top.module4_fine_cfo_apply_U0.m3_fineOffset_blk_n);
    assign proc_12_data_PIPO_blk[2] = 1'b0;
    assign proc_12_start_FIFO_blk[2] = 1'b0;
    assign proc_12_TLF_FIFO_blk[2] = 1'b0;
    assign proc_12_input_sync_blk[2] = 1'b0;
    assign proc_12_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_12[2] = dl_detect_out ? proc_dep_vld_vec_12_reg[2] : (proc_12_data_FIFO_blk[2] | proc_12_data_PIPO_blk[2] | proc_12_start_FIFO_blk[2] | proc_12_TLF_FIFO_blk[2] | proc_12_input_sync_blk[2] | proc_12_output_sync_blk[2]);
    assign proc_12_data_FIFO_blk[3] = 1'b0;
    assign proc_12_data_PIPO_blk[3] = 1'b0;
    assign proc_12_start_FIFO_blk[3] = 1'b0;
    assign proc_12_TLF_FIFO_blk[3] = 1'b0;
    assign proc_12_input_sync_blk[3] = 1'b0;
    assign proc_12_output_sync_blk[3] = 1'b0 | (ap_done_reg_3 & AESL_inst_system_top.module4_fine_cfo_apply_U0.ap_done & ~AESL_inst_system_top.consume_filteredLen_U0.ap_done);
    assign proc_dep_vld_vec_12[3] = dl_detect_out ? proc_dep_vld_vec_12_reg[3] : (proc_12_data_FIFO_blk[3] | proc_12_data_PIPO_blk[3] | proc_12_start_FIFO_blk[3] | proc_12_TLF_FIFO_blk[3] | proc_12_input_sync_blk[3] | proc_12_output_sync_blk[3]);
    assign proc_12_data_FIFO_blk[4] = 1'b0;
    assign proc_12_data_PIPO_blk[4] = 1'b0;
    assign proc_12_start_FIFO_blk[4] = 1'b0;
    assign proc_12_TLF_FIFO_blk[4] = 1'b0;
    assign proc_12_input_sync_blk[4] = 1'b0;
    assign proc_12_output_sync_blk[4] = 1'b0 | (ap_done_reg_3 & AESL_inst_system_top.module4_fine_cfo_apply_U0.ap_done & ~AESL_inst_system_top.consume_searchBufferLen_U0.ap_done);
    assign proc_dep_vld_vec_12[4] = dl_detect_out ? proc_dep_vld_vec_12_reg[4] : (proc_12_data_FIFO_blk[4] | proc_12_data_PIPO_blk[4] | proc_12_start_FIFO_blk[4] | proc_12_TLF_FIFO_blk[4] | proc_12_input_sync_blk[4] | proc_12_output_sync_blk[4]);
    assign proc_12_data_FIFO_blk[5] = 1'b0;
    assign proc_12_data_PIPO_blk[5] = 1'b0;
    assign proc_12_start_FIFO_blk[5] = 1'b0;
    assign proc_12_TLF_FIFO_blk[5] = 1'b0;
    assign proc_12_input_sync_blk[5] = 1'b0;
    assign proc_12_output_sync_blk[5] = 1'b0 | (ap_done_reg_3 & AESL_inst_system_top.module4_fine_cfo_apply_U0.ap_done & ~AESL_inst_system_top.forward_coarseFreqOff_U0.ap_done);
    assign proc_dep_vld_vec_12[5] = dl_detect_out ? proc_dep_vld_vec_12_reg[5] : (proc_12_data_FIFO_blk[5] | proc_12_data_PIPO_blk[5] | proc_12_start_FIFO_blk[5] | proc_12_TLF_FIFO_blk[5] | proc_12_input_sync_blk[5] | proc_12_output_sync_blk[5]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_12_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_12_reg <= proc_dep_vld_vec_12;
        end
    end
    assign in_chan_dep_vld_vec_12[0] = dep_chan_vld_2_12;
    assign in_chan_dep_data_vec_12[13 : 0] = dep_chan_data_2_12;
    assign token_in_vec_12[0] = token_2_12;
    assign in_chan_dep_vld_vec_12[1] = dep_chan_vld_4_12;
    assign in_chan_dep_data_vec_12[27 : 14] = dep_chan_data_4_12;
    assign token_in_vec_12[1] = token_4_12;
    assign in_chan_dep_vld_vec_12[2] = dep_chan_vld_5_12;
    assign in_chan_dep_data_vec_12[41 : 28] = dep_chan_data_5_12;
    assign token_in_vec_12[2] = token_5_12;
    assign in_chan_dep_vld_vec_12[3] = dep_chan_vld_6_12;
    assign in_chan_dep_data_vec_12[55 : 42] = dep_chan_data_6_12;
    assign token_in_vec_12[3] = token_6_12;
    assign in_chan_dep_vld_vec_12[4] = dep_chan_vld_11_12;
    assign in_chan_dep_data_vec_12[69 : 56] = dep_chan_data_11_12;
    assign token_in_vec_12[4] = token_11_12;
    assign in_chan_dep_vld_vec_12[5] = dep_chan_vld_13_12;
    assign in_chan_dep_data_vec_12[83 : 70] = dep_chan_data_13_12;
    assign token_in_vec_12[5] = token_13_12;
    assign dep_chan_vld_12_4 = out_chan_dep_vld_vec_12[0];
    assign dep_chan_data_12_4 = out_chan_dep_data_12;
    assign token_12_4 = token_out_vec_12[0];
    assign dep_chan_vld_12_6 = out_chan_dep_vld_vec_12[1];
    assign dep_chan_data_12_6 = out_chan_dep_data_12;
    assign token_12_6 = token_out_vec_12[1];
    assign dep_chan_vld_12_11 = out_chan_dep_vld_vec_12[2];
    assign dep_chan_data_12_11 = out_chan_dep_data_12;
    assign token_12_11 = token_out_vec_12[2];
    assign dep_chan_vld_12_2 = out_chan_dep_vld_vec_12[3];
    assign dep_chan_data_12_2 = out_chan_dep_data_12;
    assign token_12_2 = token_out_vec_12[3];
    assign dep_chan_vld_12_5 = out_chan_dep_vld_vec_12[4];
    assign dep_chan_data_12_5 = out_chan_dep_data_12;
    assign token_12_5 = token_out_vec_12[4];
    assign dep_chan_vld_12_13 = out_chan_dep_vld_vec_12[5];
    assign dep_chan_data_12_13 = out_chan_dep_data_12;
    assign token_12_13 = token_out_vec_12[5];

    // Process: AESL_inst_system_top.forward_coarseFreqOff_U0
    AESL_deadlock_detect_unit #(14, 13, 4, 4) AESL_deadlock_detect_unit_13 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_13),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_13),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_13),
        .token_in_vec(token_in_vec_13),
        .dl_detect_in(dl_detect_out),
        .origin(origin[13]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_13),
        .out_chan_dep_data(out_chan_dep_data_13),
        .token_out_vec(token_out_vec_13),
        .dl_detect_out(dl_in_vec[13]));

    assign proc_13_data_FIFO_blk[0] = 1'b0 | (~AESL_inst_system_top.forward_coarseFreqOff_U0.m2_coarseFreqOff_blk_n);
    assign proc_13_data_PIPO_blk[0] = 1'b0;
    assign proc_13_start_FIFO_blk[0] = 1'b0 | (~AESL_inst_system_top.start_for_forward_coarseFreqOff_U0_U.if_empty_n & AESL_inst_system_top.forward_coarseFreqOff_U0.ap_idle & ~AESL_inst_system_top.start_for_forward_coarseFreqOff_U0_U.if_write);
    assign proc_13_TLF_FIFO_blk[0] = 1'b0;
    assign proc_13_input_sync_blk[0] = 1'b0;
    assign proc_13_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_13[0] = dl_detect_out ? proc_dep_vld_vec_13_reg[0] : (proc_13_data_FIFO_blk[0] | proc_13_data_PIPO_blk[0] | proc_13_start_FIFO_blk[0] | proc_13_TLF_FIFO_blk[0] | proc_13_input_sync_blk[0] | proc_13_output_sync_blk[0]);
    assign proc_13_data_FIFO_blk[1] = 1'b0;
    assign proc_13_data_PIPO_blk[1] = 1'b0;
    assign proc_13_start_FIFO_blk[1] = 1'b0;
    assign proc_13_TLF_FIFO_blk[1] = 1'b0;
    assign proc_13_input_sync_blk[1] = 1'b0;
    assign proc_13_output_sync_blk[1] = 1'b0 | (ap_done_reg_4 & AESL_inst_system_top.forward_coarseFreqOff_U0.ap_done & ~AESL_inst_system_top.consume_filteredLen_U0.ap_done);
    assign proc_dep_vld_vec_13[1] = dl_detect_out ? proc_dep_vld_vec_13_reg[1] : (proc_13_data_FIFO_blk[1] | proc_13_data_PIPO_blk[1] | proc_13_start_FIFO_blk[1] | proc_13_TLF_FIFO_blk[1] | proc_13_input_sync_blk[1] | proc_13_output_sync_blk[1]);
    assign proc_13_data_FIFO_blk[2] = 1'b0;
    assign proc_13_data_PIPO_blk[2] = 1'b0;
    assign proc_13_start_FIFO_blk[2] = 1'b0;
    assign proc_13_TLF_FIFO_blk[2] = 1'b0;
    assign proc_13_input_sync_blk[2] = 1'b0;
    assign proc_13_output_sync_blk[2] = 1'b0 | (ap_done_reg_4 & AESL_inst_system_top.forward_coarseFreqOff_U0.ap_done & ~AESL_inst_system_top.consume_searchBufferLen_U0.ap_done);
    assign proc_dep_vld_vec_13[2] = dl_detect_out ? proc_dep_vld_vec_13_reg[2] : (proc_13_data_FIFO_blk[2] | proc_13_data_PIPO_blk[2] | proc_13_start_FIFO_blk[2] | proc_13_TLF_FIFO_blk[2] | proc_13_input_sync_blk[2] | proc_13_output_sync_blk[2]);
    assign proc_13_data_FIFO_blk[3] = 1'b0;
    assign proc_13_data_PIPO_blk[3] = 1'b0;
    assign proc_13_start_FIFO_blk[3] = 1'b0;
    assign proc_13_TLF_FIFO_blk[3] = 1'b0;
    assign proc_13_input_sync_blk[3] = 1'b0;
    assign proc_13_output_sync_blk[3] = 1'b0 | (ap_done_reg_4 & AESL_inst_system_top.forward_coarseFreqOff_U0.ap_done & ~AESL_inst_system_top.module4_fine_cfo_apply_U0.ap_done);
    assign proc_dep_vld_vec_13[3] = dl_detect_out ? proc_dep_vld_vec_13_reg[3] : (proc_13_data_FIFO_blk[3] | proc_13_data_PIPO_blk[3] | proc_13_start_FIFO_blk[3] | proc_13_TLF_FIFO_blk[3] | proc_13_input_sync_blk[3] | proc_13_output_sync_blk[3]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_13_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_13_reg <= proc_dep_vld_vec_13;
        end
    end
    assign in_chan_dep_vld_vec_13[0] = dep_chan_vld_2_13;
    assign in_chan_dep_data_vec_13[13 : 0] = dep_chan_data_2_13;
    assign token_in_vec_13[0] = token_2_13;
    assign in_chan_dep_vld_vec_13[1] = dep_chan_vld_4_13;
    assign in_chan_dep_data_vec_13[27 : 14] = dep_chan_data_4_13;
    assign token_in_vec_13[1] = token_4_13;
    assign in_chan_dep_vld_vec_13[2] = dep_chan_vld_5_13;
    assign in_chan_dep_data_vec_13[41 : 28] = dep_chan_data_5_13;
    assign token_in_vec_13[2] = token_5_13;
    assign in_chan_dep_vld_vec_13[3] = dep_chan_vld_12_13;
    assign in_chan_dep_data_vec_13[55 : 42] = dep_chan_data_12_13;
    assign token_in_vec_13[3] = token_12_13;
    assign dep_chan_vld_13_4 = out_chan_dep_vld_vec_13[0];
    assign dep_chan_data_13_4 = out_chan_dep_data_13;
    assign token_13_4 = token_out_vec_13[0];
    assign dep_chan_vld_13_2 = out_chan_dep_vld_vec_13[1];
    assign dep_chan_data_13_2 = out_chan_dep_data_13;
    assign token_13_2 = token_out_vec_13[1];
    assign dep_chan_vld_13_5 = out_chan_dep_vld_vec_13[2];
    assign dep_chan_data_13_5 = out_chan_dep_data_13;
    assign token_13_5 = token_out_vec_13[2];
    assign dep_chan_vld_13_12 = out_chan_dep_vld_vec_13[3];
    assign dep_chan_data_13_12 = out_chan_dep_data_13;
    assign token_13_12 = token_out_vec_13[3];


    wire [13:0] dl_in_vec_comb = dl_in_vec & ~{13{all_finish}};
    AESL_deadlock_report_unit #(14) AESL_deadlock_report_unit_inst (
        .dl_reset(dl_reset),
        .dl_clock(dl_clock),
        .dl_in_vec(dl_in_vec_comb),
        .trans_in_cnt_0(trans_in_cnt_0),
        .trans_out_cnt_0(trans_out_cnt_0),
        .trans_in_cnt_1(trans_in_cnt_1),
        .trans_out_cnt_1(trans_out_cnt_1),
        .trans_in_cnt_2(trans_in_cnt_2),
        .trans_out_cnt_2(trans_out_cnt_2),
        .trans_in_cnt_3(trans_in_cnt_3),
        .trans_out_cnt_3(trans_out_cnt_3),
        .ap_done_reg_0(ap_done_reg_0),
        .ap_done_reg_1(ap_done_reg_1),
        .ap_done_reg_2(ap_done_reg_2),
        .ap_done_reg_3(ap_done_reg_3),
        .ap_done_reg_4(ap_done_reg_4),
        .dl_detect_out(dl_detect_out),
        .origin(origin),
        .token_clear(token_clear));

endmodule
