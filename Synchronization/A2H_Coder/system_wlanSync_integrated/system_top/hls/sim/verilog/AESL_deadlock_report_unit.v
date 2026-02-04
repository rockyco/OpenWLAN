`timescale 1 ns / 1 ps

module AESL_deadlock_report_unit #( parameter PROC_NUM = 4 ) (
    input dl_reset,
    input dl_clock,
    input [PROC_NUM - 1:0] dl_in_vec,
    input [15:0] trans_in_cnt_0,
    input [15:0] trans_out_cnt_0,
    input [15:0] trans_in_cnt_1,
    input [15:0] trans_out_cnt_1,
    input [15:0] trans_in_cnt_2,
    input [15:0] trans_out_cnt_2,
    input [15:0] trans_in_cnt_3,
    input [15:0] trans_out_cnt_3,
    input ap_done_reg_0,
    input ap_done_reg_1,
    input ap_done_reg_2,
    input ap_done_reg_3,
    input ap_done_reg_4,
    output dl_detect_out,
    output reg [PROC_NUM - 1:0] origin,
    output token_clear);
   
    // FSM states
    localparam ST_IDLE = 3'b000;
    localparam ST_FILTER_FAKE = 3'b001;
    localparam ST_DL_DETECTED = 3'b010;
    localparam ST_DL_REPORT = 3'b100;

    reg find_df_deadlock;
    reg [2:0] CS_fsm;
    reg [2:0] NS_fsm;
    reg [PROC_NUM - 1:0] dl_detect_reg;
    reg [PROC_NUM - 1:0] dl_done_reg;
    reg [PROC_NUM - 1:0] origin_reg;
    reg [PROC_NUM - 1:0] dl_in_vec_reg;
    reg [31:0] dl_keep_cnt;
    reg stop_report_path;
    reg [PROC_NUM - 1:0] reported_proc;
    integer i;
    integer fp;

    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            reported_proc <= 'b0;
        end
        else if (CS_fsm == ST_DL_REPORT) begin
            reported_proc <= reported_proc | dl_in_vec;
        end
        else if (CS_fsm == ST_DL_DETECTED) begin
            reported_proc <= 'b0;
        end
    end

    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            stop_report_path <= 1'b0;
        end
        else if (CS_fsm == ST_DL_REPORT && (|(dl_in_vec & reported_proc))) begin
            stop_report_path <= 1'b1;
        end
        else if (CS_fsm == ST_IDLE) begin
            stop_report_path <= 1'b0;
        end
    end

    // FSM State machine
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            CS_fsm <= ST_IDLE;
        end
        else begin
            CS_fsm <= NS_fsm;
        end
    end

    always @ (CS_fsm or dl_in_vec or dl_detect_reg or dl_done_reg or dl_in_vec or origin_reg or dl_keep_cnt) begin
        case (CS_fsm)
            ST_IDLE : begin
                if (|dl_in_vec) begin
                    NS_fsm = ST_FILTER_FAKE;
                end
                else begin
                    NS_fsm = ST_IDLE;
                end
            end
            ST_FILTER_FAKE: begin
                if (dl_keep_cnt >= 32'd1000) begin
                    NS_fsm = ST_DL_DETECTED;
                end
                else if (dl_detect_reg != (dl_detect_reg & dl_in_vec)) begin
                    NS_fsm = ST_IDLE;
                end
                else begin
                    NS_fsm = ST_FILTER_FAKE;
                end
            end
            ST_DL_DETECTED: begin
                // has unreported deadlock cycle
                if ((dl_detect_reg != dl_done_reg) && stop_report_path == 1'b0) begin
                    NS_fsm = ST_DL_REPORT;
                end
                else begin
                    NS_fsm = ST_DL_DETECTED;
                end
            end
            ST_DL_REPORT: begin
                if (|(dl_in_vec & origin_reg)) begin
                    NS_fsm = ST_DL_DETECTED;
                end
                // avoid report deadlock ring.
                else if (|(dl_in_vec & reported_proc)) begin
                    NS_fsm = ST_DL_DETECTED;
                end
                else begin
                    NS_fsm = ST_DL_REPORT;
                end
            end
            default: NS_fsm = ST_IDLE;
        endcase
    end

    // dl_detect_reg record the procs that first detect deadlock
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            dl_detect_reg <= 'b0;
        end
        else begin
            if (CS_fsm == ST_IDLE) begin
                dl_detect_reg <= dl_in_vec;
            end
        end
    end

    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            dl_keep_cnt <= 32'h0;
        end
        else begin
            if (CS_fsm == ST_FILTER_FAKE && (dl_detect_reg == (dl_detect_reg & dl_in_vec))) begin
                dl_keep_cnt <= dl_keep_cnt + 32'h1;
            end
            else if (CS_fsm == ST_FILTER_FAKE && (dl_detect_reg != (dl_detect_reg & dl_in_vec))) begin
                dl_keep_cnt <= 32'h0;
            end
        end
    end

    // dl_detect_out keeps in high after deadlock detected
    assign dl_detect_out = (|dl_detect_reg) && (CS_fsm == ST_DL_DETECTED || CS_fsm == ST_DL_REPORT);

    // dl_done_reg record the cycles has been reported
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            dl_done_reg <= 'b0;
        end
        else begin
            if ((CS_fsm == ST_DL_REPORT) && (|(dl_in_vec & dl_detect_reg) == 'b1)) begin
                dl_done_reg <= dl_done_reg | dl_in_vec;
            end
        end
    end

    // clear token once a cycle is done
    assign token_clear = (CS_fsm == ST_DL_REPORT) ? ((|(dl_in_vec & origin_reg)) ? 'b1 : 'b0) : 'b0;

    // origin_reg record the current cycle start id
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            origin_reg <= 'b0;
        end
        else begin
            if (CS_fsm == ST_DL_DETECTED) begin
                origin_reg <= origin;
            end
        end
    end
   
    // origin will be valid for only one cycle
    wire [PROC_NUM*PROC_NUM - 1:0] origin_tmp;
    assign origin_tmp[PROC_NUM - 1:0] = (dl_detect_reg[0] & ~dl_done_reg[0]) ? 'b1 : 'b0;
    genvar j;
    generate
    for(j = 1;j < PROC_NUM;j = j + 1) begin: F1
        assign origin_tmp[j*PROC_NUM +: PROC_NUM] = (dl_detect_reg[j] & ~dl_done_reg[j]) ? ('b1 << j) : origin_tmp[(j - 1)*PROC_NUM +: PROC_NUM];
    end
    endgenerate
    always @ (CS_fsm or origin_tmp) begin
        if (CS_fsm == ST_DL_DETECTED) begin
            origin = origin_tmp[(PROC_NUM - 1)*PROC_NUM +: PROC_NUM];
        end
        else begin
            origin = 'b0;
        end
    end

    
    // dl_in_vec_reg record the current cycle dl_in_vec
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            dl_in_vec_reg <= 'b0;
        end
        else begin
            if (CS_fsm == ST_DL_DETECTED) begin
                dl_in_vec_reg <= origin;
            end
            else if (CS_fsm == ST_DL_REPORT) begin
                dl_in_vec_reg <= dl_in_vec;
            end
        end
    end
    
    // find_df_deadlock to report the deadlock
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            find_df_deadlock <= 1'b0;
        end
        else begin
            if (CS_fsm == ST_DL_DETECTED && ((dl_detect_reg == dl_done_reg) || (stop_report_path == 1'b1))) begin
                find_df_deadlock <= 1'b1;
            end
            else if (CS_fsm == ST_IDLE) begin
                find_df_deadlock <= 1'b0;
            end
        end
    end
    
    // get the first valid proc index in dl vector
    function integer proc_index(input [PROC_NUM - 1:0] dl_vec);
        begin
            proc_index = 0;
            for (i = 0; i < PROC_NUM; i = i + 1) begin
                if (dl_vec[i]) begin
                    proc_index = i;
                end
            end
        end
    endfunction

    // get the proc path based on dl vector
    function [488:0] proc_path(input [PROC_NUM - 1:0] dl_vec);
        integer index;
        begin
            index = proc_index(dl_vec);
            case (index)
                0 : begin
                    proc_path = "system_top.Block_entry_proc_U0";
                end
                1 : begin
                    proc_path = "system_top.module0_prefilter_U0";
                end
                2 : begin
                    proc_path = "system_top.consume_filteredLen_U0";
                end
                3 : begin
                    proc_path = "system_top.module1_packet_detect_U0";
                end
                4 : begin
                    proc_path = "system_top.module2_coarse_cfo_U0";
                end
                5 : begin
                    proc_path = "system_top.consume_searchBufferLen_U0";
                end
                6 : begin
                    proc_path = "system_top.module3_fine_sync_U0";
                end
                7 : begin
                    proc_path = "system_top.module3_fine_sync_U0.split_input_U0";
                end
                8 : begin
                    proc_path = "system_top.module3_fine_sync_U0.run_1_U0";
                end
                9 : begin
                    proc_path = "system_top.module3_fine_sync_U0.run_2_U0";
                end
                10 : begin
                    proc_path = "system_top.module3_fine_sync_U0.run_U0";
                end
                11 : begin
                    proc_path = "system_top.module3_fine_sync_U0.combine_and_peak_U0";
                end
                12 : begin
                    proc_path = "system_top.module4_fine_cfo_apply_U0";
                end
                13 : begin
                    proc_path = "system_top.forward_coarseFreqOff_U0";
                end
                default : begin
                    proc_path = "unknown";
                end
            endcase
        end
    endfunction

    // print the headlines of deadlock detection
    task print_dl_head;
        begin
            $display("\n//////////////////////////////////////////////////////////////////////////////");
            $display("// ERROR!!! DEADLOCK DETECTED at %0t ns! SIMULATION WILL BE STOPPED! //", $time);
            $display("//////////////////////////////////////////////////////////////////////////////");
            fp = $fopen("deadlock_db.dat", "w");
        end
    endtask

    // print the start of a cycle
    task print_cycle_start(input reg [488:0] proc_path, input integer cycle_id);
        begin
            $display("/////////////////////////");
            $display("// Dependence cycle %0d:", cycle_id);
            $display("// (1): Process: %0s", proc_path);
            $fdisplay(fp, "Dependence_Cycle_ID %0d", cycle_id);
            $fdisplay(fp, "Dependence_Process_ID 1");
            $fdisplay(fp, "Dependence_Process_path %0s", proc_path);
        end
    endtask

    // print the end of deadlock detection
    task print_dl_end(input integer num, input integer record_time);
        begin
            $display("////////////////////////////////////////////////////////////////////////");
            $display("// Totally %0d cycles detected!", num);
            $display("////////////////////////////////////////////////////////////////////////");
            $fdisplay(fp, "Dependence_Cycle_Number %0d", num);
            $fclose(fp);
        end
    endtask

    // print one proc component in the cycle
    task print_cycle_proc_comp(input reg [488:0] proc_path, input integer cycle_comp_id);
        begin
            $display("// (%0d): Process: %0s", cycle_comp_id, proc_path);
            $fdisplay(fp, "Dependence_Process_ID %0d", cycle_comp_id);
            $fdisplay(fp, "Dependence_Process_path %0s", proc_path);
        end
    endtask

    // print one channel component in the cycle
    task print_cycle_chan_comp(input [PROC_NUM - 1:0] dl_vec1, input [PROC_NUM - 1:0] dl_vec2);
        reg [584:0] chan_path;
        integer index1;
        integer index2;
        begin
            index1 = proc_index(dl_vec1);
            index2 = proc_index(dl_vec2);
            case (index1)
                0 : begin // for proc 'system_top.Block_entry_proc_U0'
                    case(index2)
                    1: begin //  for dep proc 'system_top.module0_prefilter_U0'
// for dep channel '' info is :
// blk sig is {{AESL_inst_system_top.ap_sync_Block_entry_proc_U0_ap_ready & AESL_inst_system_top.Block_entry_proc_U0.ap_idle & ~AESL_inst_system_top.ap_sync_module0_prefilter_U0_ap_ready} input_sync}
                        if ((AESL_inst_system_top.ap_sync_Block_entry_proc_U0_ap_ready & AESL_inst_system_top.Block_entry_proc_U0.ap_idle & ~AESL_inst_system_top.ap_sync_module0_prefilter_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'system_top.module0_prefilter_U0'");
                        end
                    end
                    endcase
                end
                1 : begin // for proc 'system_top.module0_prefilter_U0'
                    case(index2)
                    3: begin //  for dep proc 'system_top.module1_packet_detect_U0'
// for dep channel 'system_top.m0_to_m1_data_U' info is :
// blk sig is {~AESL_inst_system_top.module0_prefilter_U0.grp_module0_prefilter_Pipeline_PREFILTER_LOOP_fu_41.m0_to_m1_data_blk_n data_FIFO}
                        if ((~AESL_inst_system_top.module0_prefilter_U0.grp_module0_prefilter_Pipeline_PREFILTER_LOOP_fu_41.m0_to_m1_data_blk_n)) begin
                            if (~AESL_inst_system_top.m0_to_m1_data_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'system_top.m0_to_m1_data_U' written by process 'system_top.module1_packet_detect_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m0_to_m1_data_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~AESL_inst_system_top.m0_to_m1_data_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'system_top.m0_to_m1_data_U' read by process 'system_top.module1_packet_detect_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m0_to_m1_data_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    2: begin //  for dep proc 'system_top.consume_filteredLen_U0'
// for dep channel 'system_top.m0_filteredLen_U' info is :
// blk sig is {~AESL_inst_system_top.module0_prefilter_U0.m0_filteredLen_blk_n data_FIFO}
                        if ((~AESL_inst_system_top.module0_prefilter_U0.m0_filteredLen_blk_n)) begin
                            if (~AESL_inst_system_top.m0_filteredLen_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'system_top.m0_filteredLen_U' written by process 'system_top.consume_filteredLen_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m0_filteredLen_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~AESL_inst_system_top.m0_filteredLen_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'system_top.m0_filteredLen_U' read by process 'system_top.consume_filteredLen_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m0_filteredLen_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'system_top.start_for_consume_filteredLen_U0_U' info is :
// blk sig is {{~AESL_inst_system_top.start_for_consume_filteredLen_U0_U.if_full_n & AESL_inst_system_top.module0_prefilter_U0.ap_start & ~AESL_inst_system_top.module0_prefilter_U0.real_start & (trans_in_cnt_0 == trans_out_cnt_0) & ~AESL_inst_system_top.start_for_consume_filteredLen_U0_U.if_read} start_FIFO}
                        if ((~AESL_inst_system_top.start_for_consume_filteredLen_U0_U.if_full_n & AESL_inst_system_top.module0_prefilter_U0.ap_start & ~AESL_inst_system_top.module0_prefilter_U0.real_start & (trans_in_cnt_0 == trans_out_cnt_0) & ~AESL_inst_system_top.start_for_consume_filteredLen_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'system_top.start_for_consume_filteredLen_U0_U' read by process 'system_top.consume_filteredLen_U0',");
                        end
                    end
                    0: begin //  for dep proc 'system_top.Block_entry_proc_U0'
// for dep channel '' info is :
// blk sig is {{AESL_inst_system_top.ap_sync_module0_prefilter_U0_ap_ready & AESL_inst_system_top.module0_prefilter_U0.ap_idle & ~AESL_inst_system_top.ap_sync_Block_entry_proc_U0_ap_ready} input_sync}
                        if ((AESL_inst_system_top.ap_sync_module0_prefilter_U0_ap_ready & AESL_inst_system_top.module0_prefilter_U0.ap_idle & ~AESL_inst_system_top.ap_sync_Block_entry_proc_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'system_top.Block_entry_proc_U0'");
                        end
                    end
                    endcase
                end
                2 : begin // for proc 'system_top.consume_filteredLen_U0'
                    case(index2)
                    1: begin //  for dep proc 'system_top.module0_prefilter_U0'
// for dep channel 'system_top.m0_filteredLen_U' info is :
// blk sig is {~AESL_inst_system_top.consume_filteredLen_U0.m0_filteredLen_blk_n data_FIFO}
                        if ((~AESL_inst_system_top.consume_filteredLen_U0.m0_filteredLen_blk_n)) begin
                            if (~AESL_inst_system_top.m0_filteredLen_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'system_top.m0_filteredLen_U' written by process 'system_top.module0_prefilter_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m0_filteredLen_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~AESL_inst_system_top.m0_filteredLen_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'system_top.m0_filteredLen_U' read by process 'system_top.module0_prefilter_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m0_filteredLen_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'system_top.start_for_consume_filteredLen_U0_U' info is :
// blk sig is {{~AESL_inst_system_top.start_for_consume_filteredLen_U0_U.if_empty_n & AESL_inst_system_top.consume_filteredLen_U0.ap_idle & ~AESL_inst_system_top.start_for_consume_filteredLen_U0_U.if_write} start_FIFO}
                        if ((~AESL_inst_system_top.start_for_consume_filteredLen_U0_U.if_empty_n & AESL_inst_system_top.consume_filteredLen_U0.ap_idle & ~AESL_inst_system_top.start_for_consume_filteredLen_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'system_top.start_for_consume_filteredLen_U0_U' written by process 'system_top.module0_prefilter_U0',");
                        end
                    end
                    5: begin //  for dep proc 'system_top.consume_searchBufferLen_U0'
// for dep channel '' info is :
// blk sig is {{ap_done_reg_1 & AESL_inst_system_top.consume_filteredLen_U0.ap_done & ~AESL_inst_system_top.consume_searchBufferLen_U0.ap_done} output_sync}
                        if ((ap_done_reg_1 & AESL_inst_system_top.consume_filteredLen_U0.ap_done & ~AESL_inst_system_top.consume_searchBufferLen_U0.ap_done)) begin
                            $display("//      Blocked by output sync logic with process : 'system_top.consume_searchBufferLen_U0'");
                        end
                    end
                    12: begin //  for dep proc 'system_top.module4_fine_cfo_apply_U0'
// for dep channel '' info is :
// blk sig is {{ap_done_reg_1 & AESL_inst_system_top.consume_filteredLen_U0.ap_done & ~AESL_inst_system_top.module4_fine_cfo_apply_U0.ap_done} output_sync}
                        if ((ap_done_reg_1 & AESL_inst_system_top.consume_filteredLen_U0.ap_done & ~AESL_inst_system_top.module4_fine_cfo_apply_U0.ap_done)) begin
                            $display("//      Blocked by output sync logic with process : 'system_top.module4_fine_cfo_apply_U0'");
                        end
                    end
                    13: begin //  for dep proc 'system_top.forward_coarseFreqOff_U0'
// for dep channel '' info is :
// blk sig is {{ap_done_reg_1 & AESL_inst_system_top.consume_filteredLen_U0.ap_done & ~AESL_inst_system_top.forward_coarseFreqOff_U0.ap_done} output_sync}
                        if ((ap_done_reg_1 & AESL_inst_system_top.consume_filteredLen_U0.ap_done & ~AESL_inst_system_top.forward_coarseFreqOff_U0.ap_done)) begin
                            $display("//      Blocked by output sync logic with process : 'system_top.forward_coarseFreqOff_U0'");
                        end
                    end
                    endcase
                end
                3 : begin // for proc 'system_top.module1_packet_detect_U0'
                    case(index2)
                    1: begin //  for dep proc 'system_top.module0_prefilter_U0'
// for dep channel 'system_top.m0_to_m1_data_U' info is :
// blk sig is {~AESL_inst_system_top.module1_packet_detect_U0.grp_module1_packet_detect_Pipeline_STREAM_LOOP_fu_71.m0_to_m1_data_blk_n data_FIFO}
                        if ((~AESL_inst_system_top.module1_packet_detect_U0.grp_module1_packet_detect_Pipeline_STREAM_LOOP_fu_71.m0_to_m1_data_blk_n)) begin
                            if (~AESL_inst_system_top.m0_to_m1_data_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'system_top.m0_to_m1_data_U' written by process 'system_top.module0_prefilter_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m0_to_m1_data_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~AESL_inst_system_top.m0_to_m1_data_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'system_top.m0_to_m1_data_U' read by process 'system_top.module0_prefilter_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m0_to_m1_data_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    4: begin //  for dep proc 'system_top.module2_coarse_cfo_U0'
// for dep channel 'system_top.m1_to_m2_data_U' info is :
// blk sig is {~AESL_inst_system_top.module1_packet_detect_U0.grp_module1_packet_detect_Pipeline_STREAM_LOOP_fu_71.m1_to_m2_data_blk_n data_FIFO}
                        if ((~AESL_inst_system_top.module1_packet_detect_U0.grp_module1_packet_detect_Pipeline_STREAM_LOOP_fu_71.m1_to_m2_data_blk_n)) begin
                            if (~AESL_inst_system_top.m1_to_m2_data_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'system_top.m1_to_m2_data_U' written by process 'system_top.module2_coarse_cfo_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m1_to_m2_data_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~AESL_inst_system_top.m1_to_m2_data_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'system_top.m1_to_m2_data_U' read by process 'system_top.module2_coarse_cfo_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m1_to_m2_data_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'system_top.m1_startOffset_U' info is :
// blk sig is {~AESL_inst_system_top.module1_packet_detect_U0.m1_startOffset_blk_n data_FIFO} {~AESL_inst_system_top.module1_packet_detect_U0.grp_module1_packet_detect_Pipeline_STREAM_LOOP_fu_71.m1_startOffset_blk_n data_FIFO}
                        if ((~AESL_inst_system_top.module1_packet_detect_U0.m1_startOffset_blk_n) | (~AESL_inst_system_top.module1_packet_detect_U0.grp_module1_packet_detect_Pipeline_STREAM_LOOP_fu_71.m1_startOffset_blk_n)) begin
                            if (~AESL_inst_system_top.m1_startOffset_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'system_top.m1_startOffset_U' written by process 'system_top.module2_coarse_cfo_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m1_startOffset_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~AESL_inst_system_top.m1_startOffset_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'system_top.m1_startOffset_U' read by process 'system_top.module2_coarse_cfo_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m1_startOffset_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'system_top.add_loc_c1_U' info is :
// blk sig is {~AESL_inst_system_top.module1_packet_detect_U0.add_loc_c1_blk_n data_FIFO}
                        if ((~AESL_inst_system_top.module1_packet_detect_U0.add_loc_c1_blk_n)) begin
                            if (~AESL_inst_system_top.add_loc_c1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'system_top.add_loc_c1_U' written by process 'system_top.module2_coarse_cfo_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.add_loc_c1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~AESL_inst_system_top.add_loc_c1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'system_top.add_loc_c1_U' read by process 'system_top.module2_coarse_cfo_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.add_loc_c1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'system_top.start_for_module2_coarse_cfo_U0_U' info is :
// blk sig is {{~AESL_inst_system_top.start_for_module2_coarse_cfo_U0_U.if_full_n & AESL_inst_system_top.module1_packet_detect_U0.ap_start & ~AESL_inst_system_top.module1_packet_detect_U0.real_start & (trans_in_cnt_1 == trans_out_cnt_1) & ~AESL_inst_system_top.start_for_module2_coarse_cfo_U0_U.if_read} start_FIFO}
                        if ((~AESL_inst_system_top.start_for_module2_coarse_cfo_U0_U.if_full_n & AESL_inst_system_top.module1_packet_detect_U0.ap_start & ~AESL_inst_system_top.module1_packet_detect_U0.real_start & (trans_in_cnt_1 == trans_out_cnt_1) & ~AESL_inst_system_top.start_for_module2_coarse_cfo_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'system_top.start_for_module2_coarse_cfo_U0_U' read by process 'system_top.module2_coarse_cfo_U0',");
                        end
                    end
                    0: begin //  for dep proc 'system_top.Block_entry_proc_U0'
// for dep channel 'system_top.add_loc_c2_channel_U' info is :
// blk sig is {{~AESL_inst_system_top.add_loc_c2_channel_U.if_empty_n & AESL_inst_system_top.module1_packet_detect_U0.ap_idle & ~AESL_inst_system_top.add_loc_c2_channel_U.if_write} TLF_FIFO}
                        if ((~AESL_inst_system_top.add_loc_c2_channel_U.if_empty_n & AESL_inst_system_top.module1_packet_detect_U0.ap_idle & ~AESL_inst_system_top.add_loc_c2_channel_U.if_write)) begin
                            if (~AESL_inst_system_top.add_loc_c2_channel_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'system_top.add_loc_c2_channel_U' written by process 'system_top.Block_entry_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.add_loc_c2_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~AESL_inst_system_top.add_loc_c2_channel_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'system_top.add_loc_c2_channel_U' read by process 'system_top.Block_entry_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.add_loc_c2_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                4 : begin // for proc 'system_top.module2_coarse_cfo_U0'
                    case(index2)
                    3: begin //  for dep proc 'system_top.module1_packet_detect_U0'
// for dep channel 'system_top.m1_to_m2_data_U' info is :
// blk sig is {~AESL_inst_system_top.module2_coarse_cfo_U0.grp_module2_coarse_cfo_Pipeline_PHASE_A_fu_312.m1_to_m2_data_blk_n data_FIFO}
                        if ((~AESL_inst_system_top.module2_coarse_cfo_U0.grp_module2_coarse_cfo_Pipeline_PHASE_A_fu_312.m1_to_m2_data_blk_n)) begin
                            if (~AESL_inst_system_top.m1_to_m2_data_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'system_top.m1_to_m2_data_U' written by process 'system_top.module1_packet_detect_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m1_to_m2_data_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~AESL_inst_system_top.m1_to_m2_data_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'system_top.m1_to_m2_data_U' read by process 'system_top.module1_packet_detect_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m1_to_m2_data_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'system_top.m1_startOffset_U' info is :
// blk sig is {~AESL_inst_system_top.module2_coarse_cfo_U0.m1_startOffset_blk_n data_FIFO} {~AESL_inst_system_top.module2_coarse_cfo_U0.grp_module2_coarse_cfo_Pipeline_PHASE_A_fu_312.m1_startOffset_blk_n data_FIFO}
                        if ((~AESL_inst_system_top.module2_coarse_cfo_U0.m1_startOffset_blk_n) | (~AESL_inst_system_top.module2_coarse_cfo_U0.grp_module2_coarse_cfo_Pipeline_PHASE_A_fu_312.m1_startOffset_blk_n)) begin
                            if (~AESL_inst_system_top.m1_startOffset_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'system_top.m1_startOffset_U' written by process 'system_top.module1_packet_detect_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m1_startOffset_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~AESL_inst_system_top.m1_startOffset_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'system_top.m1_startOffset_U' read by process 'system_top.module1_packet_detect_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m1_startOffset_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'system_top.add_loc_c1_U' info is :
// blk sig is {~AESL_inst_system_top.module2_coarse_cfo_U0.add_loc_blk_n data_FIFO}
                        if ((~AESL_inst_system_top.module2_coarse_cfo_U0.add_loc_blk_n)) begin
                            if (~AESL_inst_system_top.add_loc_c1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'system_top.add_loc_c1_U' written by process 'system_top.module1_packet_detect_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.add_loc_c1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~AESL_inst_system_top.add_loc_c1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'system_top.add_loc_c1_U' read by process 'system_top.module1_packet_detect_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.add_loc_c1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'system_top.start_for_module2_coarse_cfo_U0_U' info is :
// blk sig is {{~AESL_inst_system_top.start_for_module2_coarse_cfo_U0_U.if_empty_n & AESL_inst_system_top.module2_coarse_cfo_U0.ap_idle & ~AESL_inst_system_top.start_for_module2_coarse_cfo_U0_U.if_write} start_FIFO}
                        if ((~AESL_inst_system_top.start_for_module2_coarse_cfo_U0_U.if_empty_n & AESL_inst_system_top.module2_coarse_cfo_U0.ap_idle & ~AESL_inst_system_top.start_for_module2_coarse_cfo_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'system_top.start_for_module2_coarse_cfo_U0_U' written by process 'system_top.module1_packet_detect_U0',");
                        end
                    end
                    6: begin //  for dep proc 'system_top.module3_fine_sync_U0'
// for dep channel 'system_top.m2_search_buffer_U' info is :
// blk sig is {~AESL_inst_system_top.module2_coarse_cfo_U0.grp_module2_coarse_cfo_Pipeline_PHASE_D_fu_342.m2_search_buffer_blk_n data_FIFO}
                        if ((~AESL_inst_system_top.module2_coarse_cfo_U0.grp_module2_coarse_cfo_Pipeline_PHASE_D_fu_342.m2_search_buffer_blk_n)) begin
                            if (~AESL_inst_system_top.m2_search_buffer_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'system_top.m2_search_buffer_U' written by process 'system_top.module3_fine_sync_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m2_search_buffer_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~AESL_inst_system_top.m2_search_buffer_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'system_top.m2_search_buffer_U' read by process 'system_top.module3_fine_sync_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m2_search_buffer_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'system_top.start_for_module3_fine_sync_U0_U' info is :
// blk sig is {{~AESL_inst_system_top.start_for_module3_fine_sync_U0_U.if_full_n & AESL_inst_system_top.module2_coarse_cfo_U0.ap_start & ~AESL_inst_system_top.module2_coarse_cfo_U0.real_start & (trans_in_cnt_2 == trans_out_cnt_2) & ~AESL_inst_system_top.start_for_module3_fine_sync_U0_U.if_read} start_FIFO}
                        if ((~AESL_inst_system_top.start_for_module3_fine_sync_U0_U.if_full_n & AESL_inst_system_top.module2_coarse_cfo_U0.ap_start & ~AESL_inst_system_top.module2_coarse_cfo_U0.real_start & (trans_in_cnt_2 == trans_out_cnt_2) & ~AESL_inst_system_top.start_for_module3_fine_sync_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'system_top.start_for_module3_fine_sync_U0_U' read by process 'system_top.module3_fine_sync_U0',");
                        end
                    end
                    7: begin //  for dep proc 'system_top.module3_fine_sync_U0.split_input_U0'
// for dep channel 'system_top.m2_search_buffer_U' info is :
// blk sig is {~AESL_inst_system_top.module2_coarse_cfo_U0.grp_module2_coarse_cfo_Pipeline_PHASE_D_fu_342.m2_search_buffer_blk_n data_FIFO}
                        if ((~AESL_inst_system_top.module2_coarse_cfo_U0.grp_module2_coarse_cfo_Pipeline_PHASE_D_fu_342.m2_search_buffer_blk_n)) begin
                            if (~AESL_inst_system_top.m2_search_buffer_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'system_top.m2_search_buffer_U' written by process 'system_top.module3_fine_sync_U0.split_input_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m2_search_buffer_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~AESL_inst_system_top.m2_search_buffer_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'system_top.m2_search_buffer_U' read by process 'system_top.module3_fine_sync_U0.split_input_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m2_search_buffer_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    13: begin //  for dep proc 'system_top.forward_coarseFreqOff_U0'
// for dep channel 'system_top.m2_coarseFreqOff_U' info is :
// blk sig is {~AESL_inst_system_top.module2_coarse_cfo_U0.m2_coarseFreqOff_blk_n data_FIFO}
                        if ((~AESL_inst_system_top.module2_coarse_cfo_U0.m2_coarseFreqOff_blk_n)) begin
                            if (~AESL_inst_system_top.m2_coarseFreqOff_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'system_top.m2_coarseFreqOff_U' written by process 'system_top.forward_coarseFreqOff_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m2_coarseFreqOff_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~AESL_inst_system_top.m2_coarseFreqOff_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'system_top.m2_coarseFreqOff_U' read by process 'system_top.forward_coarseFreqOff_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m2_coarseFreqOff_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'system_top.start_for_forward_coarseFreqOff_U0_U' info is :
// blk sig is {{~AESL_inst_system_top.start_for_forward_coarseFreqOff_U0_U.if_full_n & AESL_inst_system_top.module2_coarse_cfo_U0.ap_start & ~AESL_inst_system_top.module2_coarse_cfo_U0.real_start & (trans_in_cnt_2 == trans_out_cnt_2) & ~AESL_inst_system_top.start_for_forward_coarseFreqOff_U0_U.if_read} start_FIFO}
                        if ((~AESL_inst_system_top.start_for_forward_coarseFreqOff_U0_U.if_full_n & AESL_inst_system_top.module2_coarse_cfo_U0.ap_start & ~AESL_inst_system_top.module2_coarse_cfo_U0.real_start & (trans_in_cnt_2 == trans_out_cnt_2) & ~AESL_inst_system_top.start_for_forward_coarseFreqOff_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'system_top.start_for_forward_coarseFreqOff_U0_U' read by process 'system_top.forward_coarseFreqOff_U0',");
                        end
                    end
                    5: begin //  for dep proc 'system_top.consume_searchBufferLen_U0'
// for dep channel 'system_top.m2_searchBufferLen_U' info is :
// blk sig is {~AESL_inst_system_top.module2_coarse_cfo_U0.m2_searchBufferLen_blk_n data_FIFO}
                        if ((~AESL_inst_system_top.module2_coarse_cfo_U0.m2_searchBufferLen_blk_n)) begin
                            if (~AESL_inst_system_top.m2_searchBufferLen_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'system_top.m2_searchBufferLen_U' written by process 'system_top.consume_searchBufferLen_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m2_searchBufferLen_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~AESL_inst_system_top.m2_searchBufferLen_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'system_top.m2_searchBufferLen_U' read by process 'system_top.consume_searchBufferLen_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m2_searchBufferLen_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'system_top.start_for_consume_searchBufferLen_U0_U' info is :
// blk sig is {{~AESL_inst_system_top.start_for_consume_searchBufferLen_U0_U.if_full_n & AESL_inst_system_top.module2_coarse_cfo_U0.ap_start & ~AESL_inst_system_top.module2_coarse_cfo_U0.real_start & (trans_in_cnt_2 == trans_out_cnt_2) & ~AESL_inst_system_top.start_for_consume_searchBufferLen_U0_U.if_read} start_FIFO}
                        if ((~AESL_inst_system_top.start_for_consume_searchBufferLen_U0_U.if_full_n & AESL_inst_system_top.module2_coarse_cfo_U0.ap_start & ~AESL_inst_system_top.module2_coarse_cfo_U0.real_start & (trans_in_cnt_2 == trans_out_cnt_2) & ~AESL_inst_system_top.start_for_consume_searchBufferLen_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'system_top.start_for_consume_searchBufferLen_U0_U' read by process 'system_top.consume_searchBufferLen_U0',");
                        end
                    end
                    12: begin //  for dep proc 'system_top.module4_fine_cfo_apply_U0'
// for dep channel 'system_top.m2_to_m4_data_U' info is :
// blk sig is {~AESL_inst_system_top.module2_coarse_cfo_U0.grp_module2_coarse_cfo_Pipeline_PHASE_A_fu_312.m2_to_m4_data_blk_n data_FIFO}
                        if ((~AESL_inst_system_top.module2_coarse_cfo_U0.grp_module2_coarse_cfo_Pipeline_PHASE_A_fu_312.m2_to_m4_data_blk_n)) begin
                            if (~AESL_inst_system_top.m2_to_m4_data_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'system_top.m2_to_m4_data_U' written by process 'system_top.module4_fine_cfo_apply_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m2_to_m4_data_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~AESL_inst_system_top.m2_to_m4_data_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'system_top.m2_to_m4_data_U' read by process 'system_top.module4_fine_cfo_apply_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m2_to_m4_data_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'system_top.m2_to_m4_startOffset_U' info is :
// blk sig is {~AESL_inst_system_top.module2_coarse_cfo_U0.m2_to_m4_startOffset_blk_n data_FIFO} {~AESL_inst_system_top.module2_coarse_cfo_U0.grp_module2_coarse_cfo_Pipeline_PHASE_A_fu_312.m2_to_m4_startOffset_blk_n data_FIFO}
                        if ((~AESL_inst_system_top.module2_coarse_cfo_U0.m2_to_m4_startOffset_blk_n) | (~AESL_inst_system_top.module2_coarse_cfo_U0.grp_module2_coarse_cfo_Pipeline_PHASE_A_fu_312.m2_to_m4_startOffset_blk_n)) begin
                            if (~AESL_inst_system_top.m2_to_m4_startOffset_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'system_top.m2_to_m4_startOffset_U' written by process 'system_top.module4_fine_cfo_apply_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m2_to_m4_startOffset_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~AESL_inst_system_top.m2_to_m4_startOffset_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'system_top.m2_to_m4_startOffset_U' read by process 'system_top.module4_fine_cfo_apply_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m2_to_m4_startOffset_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'system_top.add_loc_c_U' info is :
// blk sig is {~AESL_inst_system_top.module2_coarse_cfo_U0.add_loc_c_blk_n data_FIFO}
                        if ((~AESL_inst_system_top.module2_coarse_cfo_U0.add_loc_c_blk_n)) begin
                            if (~AESL_inst_system_top.add_loc_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'system_top.add_loc_c_U' written by process 'system_top.module4_fine_cfo_apply_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.add_loc_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~AESL_inst_system_top.add_loc_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'system_top.add_loc_c_U' read by process 'system_top.module4_fine_cfo_apply_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.add_loc_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'system_top.start_for_module4_fine_cfo_apply_U0_U' info is :
// blk sig is {{~AESL_inst_system_top.start_for_module4_fine_cfo_apply_U0_U.if_full_n & AESL_inst_system_top.module2_coarse_cfo_U0.ap_start & ~AESL_inst_system_top.module2_coarse_cfo_U0.real_start & (trans_in_cnt_2 == trans_out_cnt_2) & ~AESL_inst_system_top.start_for_module4_fine_cfo_apply_U0_U.if_read} start_FIFO}
                        if ((~AESL_inst_system_top.start_for_module4_fine_cfo_apply_U0_U.if_full_n & AESL_inst_system_top.module2_coarse_cfo_U0.ap_start & ~AESL_inst_system_top.module2_coarse_cfo_U0.real_start & (trans_in_cnt_2 == trans_out_cnt_2) & ~AESL_inst_system_top.start_for_module4_fine_cfo_apply_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'system_top.start_for_module4_fine_cfo_apply_U0_U' read by process 'system_top.module4_fine_cfo_apply_U0',");
                        end
                    end
                    endcase
                end
                5 : begin // for proc 'system_top.consume_searchBufferLen_U0'
                    case(index2)
                    4: begin //  for dep proc 'system_top.module2_coarse_cfo_U0'
// for dep channel 'system_top.m2_searchBufferLen_U' info is :
// blk sig is {~AESL_inst_system_top.consume_searchBufferLen_U0.m2_searchBufferLen_blk_n data_FIFO}
                        if ((~AESL_inst_system_top.consume_searchBufferLen_U0.m2_searchBufferLen_blk_n)) begin
                            if (~AESL_inst_system_top.m2_searchBufferLen_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'system_top.m2_searchBufferLen_U' written by process 'system_top.module2_coarse_cfo_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m2_searchBufferLen_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~AESL_inst_system_top.m2_searchBufferLen_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'system_top.m2_searchBufferLen_U' read by process 'system_top.module2_coarse_cfo_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m2_searchBufferLen_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'system_top.start_for_consume_searchBufferLen_U0_U' info is :
// blk sig is {{~AESL_inst_system_top.start_for_consume_searchBufferLen_U0_U.if_empty_n & AESL_inst_system_top.consume_searchBufferLen_U0.ap_idle & ~AESL_inst_system_top.start_for_consume_searchBufferLen_U0_U.if_write} start_FIFO}
                        if ((~AESL_inst_system_top.start_for_consume_searchBufferLen_U0_U.if_empty_n & AESL_inst_system_top.consume_searchBufferLen_U0.ap_idle & ~AESL_inst_system_top.start_for_consume_searchBufferLen_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'system_top.start_for_consume_searchBufferLen_U0_U' written by process 'system_top.module2_coarse_cfo_U0',");
                        end
                    end
                    2: begin //  for dep proc 'system_top.consume_filteredLen_U0'
// for dep channel '' info is :
// blk sig is {{ap_done_reg_2 & AESL_inst_system_top.consume_searchBufferLen_U0.ap_done & ~AESL_inst_system_top.consume_filteredLen_U0.ap_done} output_sync}
                        if ((ap_done_reg_2 & AESL_inst_system_top.consume_searchBufferLen_U0.ap_done & ~AESL_inst_system_top.consume_filteredLen_U0.ap_done)) begin
                            $display("//      Blocked by output sync logic with process : 'system_top.consume_filteredLen_U0'");
                        end
                    end
                    12: begin //  for dep proc 'system_top.module4_fine_cfo_apply_U0'
// for dep channel '' info is :
// blk sig is {{ap_done_reg_2 & AESL_inst_system_top.consume_searchBufferLen_U0.ap_done & ~AESL_inst_system_top.module4_fine_cfo_apply_U0.ap_done} output_sync}
                        if ((ap_done_reg_2 & AESL_inst_system_top.consume_searchBufferLen_U0.ap_done & ~AESL_inst_system_top.module4_fine_cfo_apply_U0.ap_done)) begin
                            $display("//      Blocked by output sync logic with process : 'system_top.module4_fine_cfo_apply_U0'");
                        end
                    end
                    13: begin //  for dep proc 'system_top.forward_coarseFreqOff_U0'
// for dep channel '' info is :
// blk sig is {{ap_done_reg_2 & AESL_inst_system_top.consume_searchBufferLen_U0.ap_done & ~AESL_inst_system_top.forward_coarseFreqOff_U0.ap_done} output_sync}
                        if ((ap_done_reg_2 & AESL_inst_system_top.consume_searchBufferLen_U0.ap_done & ~AESL_inst_system_top.forward_coarseFreqOff_U0.ap_done)) begin
                            $display("//      Blocked by output sync logic with process : 'system_top.forward_coarseFreqOff_U0'");
                        end
                    end
                    endcase
                end
                6 : begin // for proc 'system_top.module3_fine_sync_U0'
                    case(index2)
                    4: begin //  for dep proc 'system_top.module2_coarse_cfo_U0'
// for dep channel 'system_top.m2_search_buffer_U' info is :
// blk sig is {~AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.m2_search_buffer_blk_n data_FIFO}
                        if ((~AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.m2_search_buffer_blk_n)) begin
                            if (~AESL_inst_system_top.m2_search_buffer_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'system_top.m2_search_buffer_U' written by process 'system_top.module2_coarse_cfo_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m2_search_buffer_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~AESL_inst_system_top.m2_search_buffer_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'system_top.m2_search_buffer_U' read by process 'system_top.module2_coarse_cfo_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m2_search_buffer_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'system_top.start_for_module3_fine_sync_U0_U' info is :
// blk sig is {{~AESL_inst_system_top.start_for_module3_fine_sync_U0_U.if_empty_n & AESL_inst_system_top.module3_fine_sync_U0.ap_idle & ~AESL_inst_system_top.start_for_module3_fine_sync_U0_U.if_write} start_FIFO}
                        if ((~AESL_inst_system_top.start_for_module3_fine_sync_U0_U.if_empty_n & AESL_inst_system_top.module3_fine_sync_U0.ap_idle & ~AESL_inst_system_top.start_for_module3_fine_sync_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'system_top.start_for_module3_fine_sync_U0_U' written by process 'system_top.module2_coarse_cfo_U0',");
                        end
                    end
                    12: begin //  for dep proc 'system_top.module4_fine_cfo_apply_U0'
// for dep channel 'system_top.m3_fineOffset_U' info is :
// blk sig is {~AESL_inst_system_top.module3_fine_sync_U0.combine_and_peak_U0.m3_fineOffset_blk_n data_FIFO}
                        if ((~AESL_inst_system_top.module3_fine_sync_U0.combine_and_peak_U0.m3_fineOffset_blk_n)) begin
                            if (~AESL_inst_system_top.m3_fineOffset_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'system_top.m3_fineOffset_U' written by process 'system_top.module4_fine_cfo_apply_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m3_fineOffset_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~AESL_inst_system_top.m3_fineOffset_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'system_top.m3_fineOffset_U' read by process 'system_top.module4_fine_cfo_apply_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m3_fineOffset_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                7 : begin // for proc 'system_top.module3_fine_sync_U0.split_input_U0'
                    case(index2)
                    4: begin //  for dep proc 'system_top.module2_coarse_cfo_U0'
// for dep channel 'system_top.m2_search_buffer_U' info is :
// blk sig is {~AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.m2_search_buffer_blk_n data_FIFO}
                        if ((~AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.m2_search_buffer_blk_n)) begin
                            if (~AESL_inst_system_top.m2_search_buffer_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'system_top.m2_search_buffer_U' written by process 'system_top.module2_coarse_cfo_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m2_search_buffer_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~AESL_inst_system_top.m2_search_buffer_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'system_top.m2_search_buffer_U' read by process 'system_top.module2_coarse_cfo_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m2_search_buffer_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    8: begin //  for dep proc 'system_top.module3_fine_sync_U0.run_1_U0'
// for dep channel 'system_top.module3_fine_sync_U0.re_stream_U' info is :
// blk sig is {~AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.re_stream_blk_n data_FIFO}
                        if ((~AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.re_stream_blk_n)) begin
                            if (~AESL_inst_system_top.module3_fine_sync_U0.re_stream_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'system_top.module3_fine_sync_U0.re_stream_U' written by process 'system_top.module3_fine_sync_U0.run_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.module3_fine_sync_U0.re_stream_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~AESL_inst_system_top.module3_fine_sync_U0.re_stream_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'system_top.module3_fine_sync_U0.re_stream_U' read by process 'system_top.module3_fine_sync_U0.run_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.module3_fine_sync_U0.re_stream_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'system_top.module3_fine_sync_U0.start_for_run_1_U0_U' info is :
// blk sig is {{~AESL_inst_system_top.module3_fine_sync_U0.start_for_run_1_U0_U.if_full_n & AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.ap_start & ~AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.real_start & (trans_in_cnt_3 == trans_out_cnt_3) & ~AESL_inst_system_top.module3_fine_sync_U0.start_for_run_1_U0_U.if_read} start_FIFO}
                        if ((~AESL_inst_system_top.module3_fine_sync_U0.start_for_run_1_U0_U.if_full_n & AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.ap_start & ~AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.real_start & (trans_in_cnt_3 == trans_out_cnt_3) & ~AESL_inst_system_top.module3_fine_sync_U0.start_for_run_1_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'system_top.module3_fine_sync_U0.start_for_run_1_U0_U' read by process 'system_top.module3_fine_sync_U0.run_1_U0',");
                        end
                    end
                    9: begin //  for dep proc 'system_top.module3_fine_sync_U0.run_2_U0'
// for dep channel 'system_top.module3_fine_sync_U0.im_stream_U' info is :
// blk sig is {~AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.im_stream_blk_n data_FIFO}
                        if ((~AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.im_stream_blk_n)) begin
                            if (~AESL_inst_system_top.module3_fine_sync_U0.im_stream_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'system_top.module3_fine_sync_U0.im_stream_U' written by process 'system_top.module3_fine_sync_U0.run_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.module3_fine_sync_U0.im_stream_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~AESL_inst_system_top.module3_fine_sync_U0.im_stream_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'system_top.module3_fine_sync_U0.im_stream_U' read by process 'system_top.module3_fine_sync_U0.run_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.module3_fine_sync_U0.im_stream_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'system_top.module3_fine_sync_U0.start_for_run_2_U0_U' info is :
// blk sig is {{~AESL_inst_system_top.module3_fine_sync_U0.start_for_run_2_U0_U.if_full_n & AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.ap_start & ~AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.real_start & (trans_in_cnt_3 == trans_out_cnt_3) & ~AESL_inst_system_top.module3_fine_sync_U0.start_for_run_2_U0_U.if_read} start_FIFO}
                        if ((~AESL_inst_system_top.module3_fine_sync_U0.start_for_run_2_U0_U.if_full_n & AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.ap_start & ~AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.real_start & (trans_in_cnt_3 == trans_out_cnt_3) & ~AESL_inst_system_top.module3_fine_sync_U0.start_for_run_2_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'system_top.module3_fine_sync_U0.start_for_run_2_U0_U' read by process 'system_top.module3_fine_sync_U0.run_2_U0',");
                        end
                    end
                    10: begin //  for dep proc 'system_top.module3_fine_sync_U0.run_U0'
// for dep channel 'system_top.module3_fine_sync_U0.sum_stream_U' info is :
// blk sig is {~AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.sum_stream_blk_n data_FIFO}
                        if ((~AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.sum_stream_blk_n)) begin
                            if (~AESL_inst_system_top.module3_fine_sync_U0.sum_stream_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'system_top.module3_fine_sync_U0.sum_stream_U' written by process 'system_top.module3_fine_sync_U0.run_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.module3_fine_sync_U0.sum_stream_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~AESL_inst_system_top.module3_fine_sync_U0.sum_stream_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'system_top.module3_fine_sync_U0.sum_stream_U' read by process 'system_top.module3_fine_sync_U0.run_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.module3_fine_sync_U0.sum_stream_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'system_top.module3_fine_sync_U0.start_for_run_U0_U' info is :
// blk sig is {{~AESL_inst_system_top.module3_fine_sync_U0.start_for_run_U0_U.if_full_n & AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.ap_start & ~AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.real_start & (trans_in_cnt_3 == trans_out_cnt_3) & ~AESL_inst_system_top.module3_fine_sync_U0.start_for_run_U0_U.if_read} start_FIFO}
                        if ((~AESL_inst_system_top.module3_fine_sync_U0.start_for_run_U0_U.if_full_n & AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.ap_start & ~AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.real_start & (trans_in_cnt_3 == trans_out_cnt_3) & ~AESL_inst_system_top.module3_fine_sync_U0.start_for_run_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'system_top.module3_fine_sync_U0.start_for_run_U0_U' read by process 'system_top.module3_fine_sync_U0.run_U0',");
                        end
                    end
                    11: begin //  for dep proc 'system_top.module3_fine_sync_U0.combine_and_peak_U0'
// for dep channel 'system_top.module3_fine_sync_U0.start_for_combine_and_peak_U0_U' info is :
// blk sig is {{~AESL_inst_system_top.module3_fine_sync_U0.start_for_combine_and_peak_U0_U.if_full_n & AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.ap_start & ~AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.real_start & (trans_in_cnt_3 == trans_out_cnt_3) & ~AESL_inst_system_top.module3_fine_sync_U0.start_for_combine_and_peak_U0_U.if_read} start_FIFO}
                        if ((~AESL_inst_system_top.module3_fine_sync_U0.start_for_combine_and_peak_U0_U.if_full_n & AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.ap_start & ~AESL_inst_system_top.module3_fine_sync_U0.split_input_U0.real_start & (trans_in_cnt_3 == trans_out_cnt_3) & ~AESL_inst_system_top.module3_fine_sync_U0.start_for_combine_and_peak_U0_U.if_read)) begin
                            $display("//      Blocked by full output start propagation FIFO 'system_top.module3_fine_sync_U0.start_for_combine_and_peak_U0_U' read by process 'system_top.module3_fine_sync_U0.combine_and_peak_U0',");
                        end
                    end
                    endcase
                end
                8 : begin // for proc 'system_top.module3_fine_sync_U0.run_1_U0'
                    case(index2)
                    7: begin //  for dep proc 'system_top.module3_fine_sync_U0.split_input_U0'
// for dep channel 'system_top.module3_fine_sync_U0.start_for_run_1_U0_U' info is :
// blk sig is {{~AESL_inst_system_top.module3_fine_sync_U0.start_for_run_1_U0_U.if_empty_n & AESL_inst_system_top.module3_fine_sync_U0.run_1_U0.ap_idle & ~AESL_inst_system_top.module3_fine_sync_U0.start_for_run_1_U0_U.if_write} start_FIFO}
                        if ((~AESL_inst_system_top.module3_fine_sync_U0.start_for_run_1_U0_U.if_empty_n & AESL_inst_system_top.module3_fine_sync_U0.run_1_U0.ap_idle & ~AESL_inst_system_top.module3_fine_sync_U0.start_for_run_1_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'system_top.module3_fine_sync_U0.start_for_run_1_U0_U' written by process 'system_top.module3_fine_sync_U0.split_input_U0',");
                        end
                    end
                    endcase
                end
                9 : begin // for proc 'system_top.module3_fine_sync_U0.run_2_U0'
                    case(index2)
                    7: begin //  for dep proc 'system_top.module3_fine_sync_U0.split_input_U0'
// for dep channel 'system_top.module3_fine_sync_U0.start_for_run_2_U0_U' info is :
// blk sig is {{~AESL_inst_system_top.module3_fine_sync_U0.start_for_run_2_U0_U.if_empty_n & AESL_inst_system_top.module3_fine_sync_U0.run_2_U0.ap_idle & ~AESL_inst_system_top.module3_fine_sync_U0.start_for_run_2_U0_U.if_write} start_FIFO}
                        if ((~AESL_inst_system_top.module3_fine_sync_U0.start_for_run_2_U0_U.if_empty_n & AESL_inst_system_top.module3_fine_sync_U0.run_2_U0.ap_idle & ~AESL_inst_system_top.module3_fine_sync_U0.start_for_run_2_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'system_top.module3_fine_sync_U0.start_for_run_2_U0_U' written by process 'system_top.module3_fine_sync_U0.split_input_U0',");
                        end
                    end
                    endcase
                end
                10 : begin // for proc 'system_top.module3_fine_sync_U0.run_U0'
                    case(index2)
                    7: begin //  for dep proc 'system_top.module3_fine_sync_U0.split_input_U0'
// for dep channel 'system_top.module3_fine_sync_U0.start_for_run_U0_U' info is :
// blk sig is {{~AESL_inst_system_top.module3_fine_sync_U0.start_for_run_U0_U.if_empty_n & AESL_inst_system_top.module3_fine_sync_U0.run_U0.ap_idle & ~AESL_inst_system_top.module3_fine_sync_U0.start_for_run_U0_U.if_write} start_FIFO}
                        if ((~AESL_inst_system_top.module3_fine_sync_U0.start_for_run_U0_U.if_empty_n & AESL_inst_system_top.module3_fine_sync_U0.run_U0.ap_idle & ~AESL_inst_system_top.module3_fine_sync_U0.start_for_run_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'system_top.module3_fine_sync_U0.start_for_run_U0_U' written by process 'system_top.module3_fine_sync_U0.split_input_U0',");
                        end
                    end
                    endcase
                end
                11 : begin // for proc 'system_top.module3_fine_sync_U0.combine_and_peak_U0'
                    case(index2)
                    8: begin //  for dep proc 'system_top.module3_fine_sync_U0.run_1_U0'
// for dep channel 'system_top.module3_fine_sync_U0.re_out_U' info is :
// blk sig is {~AESL_inst_system_top.module3_fine_sync_U0.combine_and_peak_U0.grp_combine_and_peak_Pipeline_COMBINE_fu_45.re_out_blk_n data_FIFO}
                        if ((~AESL_inst_system_top.module3_fine_sync_U0.combine_and_peak_U0.grp_combine_and_peak_Pipeline_COMBINE_fu_45.re_out_blk_n)) begin
                            if (~AESL_inst_system_top.module3_fine_sync_U0.re_out_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'system_top.module3_fine_sync_U0.re_out_U' written by process 'system_top.module3_fine_sync_U0.run_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.module3_fine_sync_U0.re_out_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~AESL_inst_system_top.module3_fine_sync_U0.re_out_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'system_top.module3_fine_sync_U0.re_out_U' read by process 'system_top.module3_fine_sync_U0.run_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.module3_fine_sync_U0.re_out_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    9: begin //  for dep proc 'system_top.module3_fine_sync_U0.run_2_U0'
// for dep channel 'system_top.module3_fine_sync_U0.im_out_U' info is :
// blk sig is {~AESL_inst_system_top.module3_fine_sync_U0.combine_and_peak_U0.grp_combine_and_peak_Pipeline_COMBINE_fu_45.im_out_blk_n data_FIFO}
                        if ((~AESL_inst_system_top.module3_fine_sync_U0.combine_and_peak_U0.grp_combine_and_peak_Pipeline_COMBINE_fu_45.im_out_blk_n)) begin
                            if (~AESL_inst_system_top.module3_fine_sync_U0.im_out_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'system_top.module3_fine_sync_U0.im_out_U' written by process 'system_top.module3_fine_sync_U0.run_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.module3_fine_sync_U0.im_out_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~AESL_inst_system_top.module3_fine_sync_U0.im_out_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'system_top.module3_fine_sync_U0.im_out_U' read by process 'system_top.module3_fine_sync_U0.run_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.module3_fine_sync_U0.im_out_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    10: begin //  for dep proc 'system_top.module3_fine_sync_U0.run_U0'
// for dep channel 'system_top.module3_fine_sync_U0.sum_out_U' info is :
// blk sig is {~AESL_inst_system_top.module3_fine_sync_U0.combine_and_peak_U0.grp_combine_and_peak_Pipeline_COMBINE_fu_45.sum_out_blk_n data_FIFO}
                        if ((~AESL_inst_system_top.module3_fine_sync_U0.combine_and_peak_U0.grp_combine_and_peak_Pipeline_COMBINE_fu_45.sum_out_blk_n)) begin
                            if (~AESL_inst_system_top.module3_fine_sync_U0.sum_out_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'system_top.module3_fine_sync_U0.sum_out_U' written by process 'system_top.module3_fine_sync_U0.run_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.module3_fine_sync_U0.sum_out_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~AESL_inst_system_top.module3_fine_sync_U0.sum_out_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'system_top.module3_fine_sync_U0.sum_out_U' read by process 'system_top.module3_fine_sync_U0.run_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.module3_fine_sync_U0.sum_out_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    12: begin //  for dep proc 'system_top.module4_fine_cfo_apply_U0'
// for dep channel 'system_top.m3_fineOffset_U' info is :
// blk sig is {~AESL_inst_system_top.module3_fine_sync_U0.combine_and_peak_U0.m3_fineOffset_blk_n data_FIFO}
                        if ((~AESL_inst_system_top.module3_fine_sync_U0.combine_and_peak_U0.m3_fineOffset_blk_n)) begin
                            if (~AESL_inst_system_top.m3_fineOffset_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'system_top.m3_fineOffset_U' written by process 'system_top.module4_fine_cfo_apply_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m3_fineOffset_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~AESL_inst_system_top.m3_fineOffset_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'system_top.m3_fineOffset_U' read by process 'system_top.module4_fine_cfo_apply_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m3_fineOffset_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    7: begin //  for dep proc 'system_top.module3_fine_sync_U0.split_input_U0'
// for dep channel 'system_top.module3_fine_sync_U0.start_for_combine_and_peak_U0_U' info is :
// blk sig is {{~AESL_inst_system_top.module3_fine_sync_U0.start_for_combine_and_peak_U0_U.if_empty_n & AESL_inst_system_top.module3_fine_sync_U0.combine_and_peak_U0.ap_idle & ~AESL_inst_system_top.module3_fine_sync_U0.start_for_combine_and_peak_U0_U.if_write} start_FIFO}
                        if ((~AESL_inst_system_top.module3_fine_sync_U0.start_for_combine_and_peak_U0_U.if_empty_n & AESL_inst_system_top.module3_fine_sync_U0.combine_and_peak_U0.ap_idle & ~AESL_inst_system_top.module3_fine_sync_U0.start_for_combine_and_peak_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'system_top.module3_fine_sync_U0.start_for_combine_and_peak_U0_U' written by process 'system_top.module3_fine_sync_U0.split_input_U0',");
                        end
                    end
                    endcase
                end
                12 : begin // for proc 'system_top.module4_fine_cfo_apply_U0'
                    case(index2)
                    4: begin //  for dep proc 'system_top.module2_coarse_cfo_U0'
// for dep channel 'system_top.m2_to_m4_data_U' info is :
// blk sig is {~AESL_inst_system_top.module4_fine_cfo_apply_U0.grp_module4_fine_cfo_apply_Pipeline_POLL_START_fu_355.m2_to_m4_data_blk_n data_FIFO}
                        if ((~AESL_inst_system_top.module4_fine_cfo_apply_U0.grp_module4_fine_cfo_apply_Pipeline_POLL_START_fu_355.m2_to_m4_data_blk_n)) begin
                            if (~AESL_inst_system_top.m2_to_m4_data_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'system_top.m2_to_m4_data_U' written by process 'system_top.module2_coarse_cfo_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m2_to_m4_data_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~AESL_inst_system_top.m2_to_m4_data_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'system_top.m2_to_m4_data_U' read by process 'system_top.module2_coarse_cfo_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m2_to_m4_data_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'system_top.m2_to_m4_startOffset_U' info is :
// blk sig is {~AESL_inst_system_top.module4_fine_cfo_apply_U0.m2_to_m4_startOffset_blk_n data_FIFO}
                        if ((~AESL_inst_system_top.module4_fine_cfo_apply_U0.m2_to_m4_startOffset_blk_n)) begin
                            if (~AESL_inst_system_top.m2_to_m4_startOffset_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'system_top.m2_to_m4_startOffset_U' written by process 'system_top.module2_coarse_cfo_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m2_to_m4_startOffset_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~AESL_inst_system_top.m2_to_m4_startOffset_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'system_top.m2_to_m4_startOffset_U' read by process 'system_top.module2_coarse_cfo_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m2_to_m4_startOffset_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'system_top.add_loc_c_U' info is :
// blk sig is {~AESL_inst_system_top.module4_fine_cfo_apply_U0.add_loc_blk_n data_FIFO}
                        if ((~AESL_inst_system_top.module4_fine_cfo_apply_U0.add_loc_blk_n)) begin
                            if (~AESL_inst_system_top.add_loc_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'system_top.add_loc_c_U' written by process 'system_top.module2_coarse_cfo_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.add_loc_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~AESL_inst_system_top.add_loc_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'system_top.add_loc_c_U' read by process 'system_top.module2_coarse_cfo_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.add_loc_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'system_top.start_for_module4_fine_cfo_apply_U0_U' info is :
// blk sig is {{~AESL_inst_system_top.start_for_module4_fine_cfo_apply_U0_U.if_empty_n & AESL_inst_system_top.module4_fine_cfo_apply_U0.ap_idle & ~AESL_inst_system_top.start_for_module4_fine_cfo_apply_U0_U.if_write} start_FIFO}
                        if ((~AESL_inst_system_top.start_for_module4_fine_cfo_apply_U0_U.if_empty_n & AESL_inst_system_top.module4_fine_cfo_apply_U0.ap_idle & ~AESL_inst_system_top.start_for_module4_fine_cfo_apply_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'system_top.start_for_module4_fine_cfo_apply_U0_U' written by process 'system_top.module2_coarse_cfo_U0',");
                        end
                    end
                    6: begin //  for dep proc 'system_top.module3_fine_sync_U0'
// for dep channel 'system_top.m3_fineOffset_U' info is :
// blk sig is {~AESL_inst_system_top.module4_fine_cfo_apply_U0.m3_fineOffset_blk_n data_FIFO}
                        if ((~AESL_inst_system_top.module4_fine_cfo_apply_U0.m3_fineOffset_blk_n)) begin
                            if (~AESL_inst_system_top.m3_fineOffset_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'system_top.m3_fineOffset_U' written by process 'system_top.module3_fine_sync_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m3_fineOffset_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~AESL_inst_system_top.m3_fineOffset_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'system_top.m3_fineOffset_U' read by process 'system_top.module3_fine_sync_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m3_fineOffset_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    11: begin //  for dep proc 'system_top.module3_fine_sync_U0.combine_and_peak_U0'
// for dep channel 'system_top.m3_fineOffset_U' info is :
// blk sig is {~AESL_inst_system_top.module4_fine_cfo_apply_U0.m3_fineOffset_blk_n data_FIFO}
                        if ((~AESL_inst_system_top.module4_fine_cfo_apply_U0.m3_fineOffset_blk_n)) begin
                            if (~AESL_inst_system_top.m3_fineOffset_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'system_top.m3_fineOffset_U' written by process 'system_top.module3_fine_sync_U0.combine_and_peak_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m3_fineOffset_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~AESL_inst_system_top.m3_fineOffset_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'system_top.m3_fineOffset_U' read by process 'system_top.module3_fine_sync_U0.combine_and_peak_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m3_fineOffset_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    2: begin //  for dep proc 'system_top.consume_filteredLen_U0'
// for dep channel '' info is :
// blk sig is {{ap_done_reg_3 & AESL_inst_system_top.module4_fine_cfo_apply_U0.ap_done & ~AESL_inst_system_top.consume_filteredLen_U0.ap_done} output_sync}
                        if ((ap_done_reg_3 & AESL_inst_system_top.module4_fine_cfo_apply_U0.ap_done & ~AESL_inst_system_top.consume_filteredLen_U0.ap_done)) begin
                            $display("//      Blocked by output sync logic with process : 'system_top.consume_filteredLen_U0'");
                        end
                    end
                    5: begin //  for dep proc 'system_top.consume_searchBufferLen_U0'
// for dep channel '' info is :
// blk sig is {{ap_done_reg_3 & AESL_inst_system_top.module4_fine_cfo_apply_U0.ap_done & ~AESL_inst_system_top.consume_searchBufferLen_U0.ap_done} output_sync}
                        if ((ap_done_reg_3 & AESL_inst_system_top.module4_fine_cfo_apply_U0.ap_done & ~AESL_inst_system_top.consume_searchBufferLen_U0.ap_done)) begin
                            $display("//      Blocked by output sync logic with process : 'system_top.consume_searchBufferLen_U0'");
                        end
                    end
                    13: begin //  for dep proc 'system_top.forward_coarseFreqOff_U0'
// for dep channel '' info is :
// blk sig is {{ap_done_reg_3 & AESL_inst_system_top.module4_fine_cfo_apply_U0.ap_done & ~AESL_inst_system_top.forward_coarseFreqOff_U0.ap_done} output_sync}
                        if ((ap_done_reg_3 & AESL_inst_system_top.module4_fine_cfo_apply_U0.ap_done & ~AESL_inst_system_top.forward_coarseFreqOff_U0.ap_done)) begin
                            $display("//      Blocked by output sync logic with process : 'system_top.forward_coarseFreqOff_U0'");
                        end
                    end
                    endcase
                end
                13 : begin // for proc 'system_top.forward_coarseFreqOff_U0'
                    case(index2)
                    4: begin //  for dep proc 'system_top.module2_coarse_cfo_U0'
// for dep channel 'system_top.m2_coarseFreqOff_U' info is :
// blk sig is {~AESL_inst_system_top.forward_coarseFreqOff_U0.m2_coarseFreqOff_blk_n data_FIFO}
                        if ((~AESL_inst_system_top.forward_coarseFreqOff_U0.m2_coarseFreqOff_blk_n)) begin
                            if (~AESL_inst_system_top.m2_coarseFreqOff_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'system_top.m2_coarseFreqOff_U' written by process 'system_top.module2_coarse_cfo_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m2_coarseFreqOff_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~AESL_inst_system_top.m2_coarseFreqOff_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'system_top.m2_coarseFreqOff_U' read by process 'system_top.module2_coarse_cfo_U0'");
                                $fdisplay(fp, "Dependence_Channel_path system_top.m2_coarseFreqOff_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'system_top.start_for_forward_coarseFreqOff_U0_U' info is :
// blk sig is {{~AESL_inst_system_top.start_for_forward_coarseFreqOff_U0_U.if_empty_n & AESL_inst_system_top.forward_coarseFreqOff_U0.ap_idle & ~AESL_inst_system_top.start_for_forward_coarseFreqOff_U0_U.if_write} start_FIFO}
                        if ((~AESL_inst_system_top.start_for_forward_coarseFreqOff_U0_U.if_empty_n & AESL_inst_system_top.forward_coarseFreqOff_U0.ap_idle & ~AESL_inst_system_top.start_for_forward_coarseFreqOff_U0_U.if_write)) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'system_top.start_for_forward_coarseFreqOff_U0_U' written by process 'system_top.module2_coarse_cfo_U0',");
                        end
                    end
                    2: begin //  for dep proc 'system_top.consume_filteredLen_U0'
// for dep channel '' info is :
// blk sig is {{ap_done_reg_4 & AESL_inst_system_top.forward_coarseFreqOff_U0.ap_done & ~AESL_inst_system_top.consume_filteredLen_U0.ap_done} output_sync}
                        if ((ap_done_reg_4 & AESL_inst_system_top.forward_coarseFreqOff_U0.ap_done & ~AESL_inst_system_top.consume_filteredLen_U0.ap_done)) begin
                            $display("//      Blocked by output sync logic with process : 'system_top.consume_filteredLen_U0'");
                        end
                    end
                    5: begin //  for dep proc 'system_top.consume_searchBufferLen_U0'
// for dep channel '' info is :
// blk sig is {{ap_done_reg_4 & AESL_inst_system_top.forward_coarseFreqOff_U0.ap_done & ~AESL_inst_system_top.consume_searchBufferLen_U0.ap_done} output_sync}
                        if ((ap_done_reg_4 & AESL_inst_system_top.forward_coarseFreqOff_U0.ap_done & ~AESL_inst_system_top.consume_searchBufferLen_U0.ap_done)) begin
                            $display("//      Blocked by output sync logic with process : 'system_top.consume_searchBufferLen_U0'");
                        end
                    end
                    12: begin //  for dep proc 'system_top.module4_fine_cfo_apply_U0'
// for dep channel '' info is :
// blk sig is {{ap_done_reg_4 & AESL_inst_system_top.forward_coarseFreqOff_U0.ap_done & ~AESL_inst_system_top.module4_fine_cfo_apply_U0.ap_done} output_sync}
                        if ((ap_done_reg_4 & AESL_inst_system_top.forward_coarseFreqOff_U0.ap_done & ~AESL_inst_system_top.module4_fine_cfo_apply_U0.ap_done)) begin
                            $display("//      Blocked by output sync logic with process : 'system_top.module4_fine_cfo_apply_U0'");
                        end
                    end
                    endcase
                end
            endcase
        end
    endtask

    // report
    initial begin : report_deadlock
        integer cycle_id;
        integer cycle_comp_id;
        integer record_time;
        wait (dl_reset == 1);
        cycle_id = 1;
        record_time = 0;
        while (1) begin
            @ (negedge dl_clock);
            case (CS_fsm)
                ST_DL_DETECTED: begin
                    cycle_comp_id = 2;
                    if (dl_detect_reg != dl_done_reg && stop_report_path == 1'b0) begin
                        if (dl_done_reg == 'b0) begin
                            print_dl_head;
                            record_time = $time;
                        end
                        print_cycle_start(proc_path(origin), cycle_id);
                        cycle_id = cycle_id + 1;
                    end
                    else begin
                        print_dl_end((cycle_id - 1),record_time);
                        @(negedge dl_clock);
                        @(negedge dl_clock);
                        $finish;
                    end
                end
                ST_DL_REPORT: begin
                    if ((|(dl_in_vec)) & ~(|(dl_in_vec & origin_reg)) & ~(|(reported_proc & dl_in_vec))) begin
                        print_cycle_chan_comp(dl_in_vec_reg, dl_in_vec);
                        print_cycle_proc_comp(proc_path(dl_in_vec), cycle_comp_id);
                        cycle_comp_id = cycle_comp_id + 1;
                    end
                    else if (~(|(dl_in_vec)))begin
                        print_cycle_chan_comp(dl_in_vec_reg, dl_in_vec);
                    end
                end
            endcase
        end
    end
 
endmodule
