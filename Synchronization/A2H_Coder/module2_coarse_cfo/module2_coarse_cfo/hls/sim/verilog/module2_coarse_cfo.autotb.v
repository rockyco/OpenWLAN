// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2024.2.2 (64-bit)
// Tool Version Limit: 2024.11
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
 `timescale 1ns/1ps


`define AUTOTB_DUT      module2_coarse_cfo
`define AUTOTB_DUT_INST AESL_inst_module2_coarse_cfo
`define AUTOTB_TOP      apatb_module2_coarse_cfo_top
`define AUTOTB_LAT_RESULT_FILE "module2_coarse_cfo.result.lat.rb"
`define AUTOTB_PER_RESULT_TRANS_FILE "module2_coarse_cfo.performance.result.transaction.xml"
`define AUTOTB_TOP_INST AESL_inst_apatb_module2_coarse_cfo_top
`define AUTOTB_MAX_ALLOW_LATENCY  15000000
`define AUTOTB_CLOCK_PERIOD_DIV2 5.00

`define AESL_FIFO_data_in AESL_autofifo_data_in
`define AESL_FIFO_INST_data_in AESL_autofifo_inst_data_in
`define AESL_FIFO_startOffset_in AESL_autofifo_startOffset_in
`define AESL_FIFO_INST_startOffset_in AESL_autofifo_inst_startOffset_in
`define AESL_FIFO_search_buffer_out AESL_autofifo_search_buffer_out
`define AESL_FIFO_INST_search_buffer_out AESL_autofifo_inst_search_buffer_out
`define AESL_FIFO_coarseFreqOff_out AESL_autofifo_coarseFreqOff_out
`define AESL_FIFO_INST_coarseFreqOff_out AESL_autofifo_inst_coarseFreqOff_out
`define AESL_FIFO_searchBufferLen_out AESL_autofifo_searchBufferLen_out
`define AESL_FIFO_INST_searchBufferLen_out AESL_autofifo_inst_searchBufferLen_out
`define AESL_FIFO_passthrough_out AESL_autofifo_passthrough_out
`define AESL_FIFO_INST_passthrough_out AESL_autofifo_inst_passthrough_out
`define AESL_FIFO_startOffset_fwd_out AESL_autofifo_startOffset_fwd_out
`define AESL_FIFO_INST_startOffset_fwd_out AESL_autofifo_inst_startOffset_fwd_out
`define AESL_DEPTH_num_samples 1
`define AUTOTB_TVIN_data_in  "../tv/cdatafile/c.module2_coarse_cfo.autotvin_data_in.dat"
`define AUTOTB_TVIN_startOffset_in  "../tv/cdatafile/c.module2_coarse_cfo.autotvin_startOffset_in.dat"
`define AUTOTB_TVIN_num_samples  "../tv/cdatafile/c.module2_coarse_cfo.autotvin_num_samples.dat"
`define AUTOTB_TVIN_data_in_out_wrapc  "../tv/rtldatafile/rtl.module2_coarse_cfo.autotvin_data_in.dat"
`define AUTOTB_TVIN_startOffset_in_out_wrapc  "../tv/rtldatafile/rtl.module2_coarse_cfo.autotvin_startOffset_in.dat"
`define AUTOTB_TVIN_num_samples_out_wrapc  "../tv/rtldatafile/rtl.module2_coarse_cfo.autotvin_num_samples.dat"
`define AUTOTB_TVOUT_search_buffer_out  "../tv/cdatafile/c.module2_coarse_cfo.autotvout_search_buffer_out.dat"
`define AUTOTB_TVOUT_coarseFreqOff_out  "../tv/cdatafile/c.module2_coarse_cfo.autotvout_coarseFreqOff_out.dat"
`define AUTOTB_TVOUT_searchBufferLen_out  "../tv/cdatafile/c.module2_coarse_cfo.autotvout_searchBufferLen_out.dat"
`define AUTOTB_TVOUT_passthrough_out  "../tv/cdatafile/c.module2_coarse_cfo.autotvout_passthrough_out.dat"
`define AUTOTB_TVOUT_startOffset_fwd_out  "../tv/cdatafile/c.module2_coarse_cfo.autotvout_startOffset_fwd_out.dat"
`define AUTOTB_TVOUT_search_buffer_out_out_wrapc  "../tv/rtldatafile/rtl.module2_coarse_cfo.autotvout_search_buffer_out.dat"
`define AUTOTB_TVOUT_coarseFreqOff_out_out_wrapc  "../tv/rtldatafile/rtl.module2_coarse_cfo.autotvout_coarseFreqOff_out.dat"
`define AUTOTB_TVOUT_searchBufferLen_out_out_wrapc  "../tv/rtldatafile/rtl.module2_coarse_cfo.autotvout_searchBufferLen_out.dat"
`define AUTOTB_TVOUT_passthrough_out_out_wrapc  "../tv/rtldatafile/rtl.module2_coarse_cfo.autotvout_passthrough_out.dat"
`define AUTOTB_TVOUT_startOffset_fwd_out_out_wrapc  "../tv/rtldatafile/rtl.module2_coarse_cfo.autotvout_startOffset_fwd_out.dat"
module `AUTOTB_TOP;

parameter AUTOTB_TRANSACTION_NUM = 1;
parameter PROGRESS_TIMEOUT = 10000000;
parameter LATENCY_ESTIMATION = -1;
parameter LENGTH_coarseFreqOff_out = 1;
parameter LENGTH_data_in = 26105;
parameter LENGTH_num_samples = 1;
parameter LENGTH_passthrough_out = 26105;
parameter LENGTH_searchBufferLen_out = 1;
parameter LENGTH_search_buffer_out = 640;
parameter LENGTH_startOffset_fwd_out = 1;
parameter LENGTH_startOffset_in = 1;

task read_token;
    input integer fp;
    output reg [231 : 0] token;
    integer ret;
    begin
        token = "";
        ret = 0;
        ret = $fscanf(fp,"%s",token);
    end
endtask

reg AESL_clock;
reg rst;
reg dut_rst;
reg start;
reg ce;
reg tb_continue;
wire AESL_start;
wire AESL_reset;
wire AESL_ce;
wire AESL_ready;
wire AESL_idle;
wire AESL_continue;
wire AESL_done;
reg AESL_done_delay = 0;
reg AESL_done_delay2 = 0;
reg AESL_ready_delay = 0;
wire ready;
wire ready_wire;
wire ap_start;
wire ap_done;
wire ap_idle;
wire ap_ready;
wire [31 : 0] data_in_dout;
wire  data_in_empty_n;
wire  data_in_read;
wire [15 : 0] startOffset_in_dout;
wire  startOffset_in_empty_n;
wire  startOffset_in_read;
wire [31 : 0] search_buffer_out_din;
wire  search_buffer_out_full_n;
wire  search_buffer_out_write;
wire [31 : 0] coarseFreqOff_out_din;
wire  coarseFreqOff_out_full_n;
wire  coarseFreqOff_out_write;
wire [15 : 0] searchBufferLen_out_din;
wire  searchBufferLen_out_full_n;
wire  searchBufferLen_out_write;
wire [31 : 0] passthrough_out_din;
wire  passthrough_out_full_n;
wire  passthrough_out_write;
wire [15 : 0] startOffset_fwd_out_din;
wire  startOffset_fwd_out_full_n;
wire  startOffset_fwd_out_write;
wire [31 : 0] num_samples;
integer done_cnt = 0;
integer AESL_ready_cnt = 0;
integer ready_cnt = 0;
reg ready_initial;
reg ready_initial_n;
reg ready_last_n;
reg ready_delay_last_n;
reg done_delay_last_n;
reg interface_done = 0;


wire ap_clk;
wire ap_rst;
wire ap_rst_n;

`AUTOTB_DUT `AUTOTB_DUT_INST(
    .ap_clk(ap_clk),
    .ap_rst(ap_rst),
    .ap_start(ap_start),
    .ap_done(ap_done),
    .ap_idle(ap_idle),
    .ap_ready(ap_ready),
    .data_in_dout(data_in_dout),
    .data_in_empty_n(data_in_empty_n),
    .data_in_read(data_in_read),
    .startOffset_in_dout(startOffset_in_dout),
    .startOffset_in_empty_n(startOffset_in_empty_n),
    .startOffset_in_read(startOffset_in_read),
    .search_buffer_out_din(search_buffer_out_din),
    .search_buffer_out_full_n(search_buffer_out_full_n),
    .search_buffer_out_write(search_buffer_out_write),
    .coarseFreqOff_out_din(coarseFreqOff_out_din),
    .coarseFreqOff_out_full_n(coarseFreqOff_out_full_n),
    .coarseFreqOff_out_write(coarseFreqOff_out_write),
    .searchBufferLen_out_din(searchBufferLen_out_din),
    .searchBufferLen_out_full_n(searchBufferLen_out_full_n),
    .searchBufferLen_out_write(searchBufferLen_out_write),
    .passthrough_out_din(passthrough_out_din),
    .passthrough_out_full_n(passthrough_out_full_n),
    .passthrough_out_write(passthrough_out_write),
    .startOffset_fwd_out_din(startOffset_fwd_out_din),
    .startOffset_fwd_out_full_n(startOffset_fwd_out_full_n),
    .startOffset_fwd_out_write(startOffset_fwd_out_write),
    .num_samples(num_samples));

// Assignment for control signal
assign ap_clk = AESL_clock;
assign ap_rst = dut_rst;
assign ap_rst_n = ~dut_rst;
assign AESL_reset = rst;
assign ap_start = AESL_start;
assign AESL_start = start;
assign AESL_done = ap_done;
assign AESL_idle = ap_idle;
assign AESL_ready = ap_ready;
assign AESL_ce = ce;
assign AESL_continue = tb_continue;
    always @(posedge AESL_clock) begin
        if (AESL_reset) begin
        end else begin
            if (AESL_done !== 1 && AESL_done !== 0) begin
                $display("ERROR: Control signal AESL_done is invalid!");
                $finish;
            end
        end
    end
    always @(posedge AESL_clock) begin
        if (AESL_reset) begin
        end else begin
            if (AESL_ready !== 1 && AESL_ready !== 0) begin
                $display("ERROR: Control signal AESL_ready is invalid!");
                $finish;
            end
        end
    end
// Fifo Instantiation data_in

wire fifodata_in_rd;
wire [31 : 0] fifodata_in_dout;
wire fifodata_in_empty_n;
wire fifodata_in_ready;
wire fifodata_in_done;
reg [31:0] ap_c_n_tvin_trans_num_data_in;
reg data_in_ready_reg;

`AESL_FIFO_data_in `AESL_FIFO_INST_data_in (
    .clk          (AESL_clock),
    .reset        (AESL_reset),
    .if_write     (),
    .if_din       (),
    .if_full_n    (),
    .if_read      (fifodata_in_rd),
    .if_dout      (fifodata_in_dout),
    .if_empty_n   (fifodata_in_empty_n),
    .ready        (fifodata_in_ready),
    .done         (fifodata_in_done)
);

// Assignment between dut and fifodata_in

// Assign input of fifodata_in
assign      fifodata_in_rd        =   data_in_read & data_in_empty_n;
assign    fifodata_in_ready   =   ready;
assign    fifodata_in_done    =   0;
// Assign input of dut
assign      data_in_dout       =   fifodata_in_dout;
reg   reg_fifodata_in_empty_n;
initial begin : gen_reg_fifodata_in_empty_n_process
    integer proc_rand;
    reg_fifodata_in_empty_n = fifodata_in_empty_n;
    while (1) begin
        @ (fifodata_in_empty_n);
        reg_fifodata_in_empty_n = fifodata_in_empty_n;
    end
end

assign      data_in_empty_n    =   reg_fifodata_in_empty_n;


// Fifo Instantiation startOffset_in

wire fifostartOffset_in_rd;
wire [15 : 0] fifostartOffset_in_dout;
wire fifostartOffset_in_empty_n;
wire fifostartOffset_in_ready;
wire fifostartOffset_in_done;
reg [31:0] ap_c_n_tvin_trans_num_startOffset_in;
reg startOffset_in_ready_reg;

`AESL_FIFO_startOffset_in `AESL_FIFO_INST_startOffset_in (
    .clk          (AESL_clock),
    .reset        (AESL_reset),
    .if_write     (),
    .if_din       (),
    .if_full_n    (),
    .if_read      (fifostartOffset_in_rd),
    .if_dout      (fifostartOffset_in_dout),
    .if_empty_n   (fifostartOffset_in_empty_n),
    .ready        (fifostartOffset_in_ready),
    .done         (fifostartOffset_in_done)
);

// Assignment between dut and fifostartOffset_in

// Assign input of fifostartOffset_in
assign      fifostartOffset_in_rd        =   startOffset_in_read & startOffset_in_empty_n;
assign    fifostartOffset_in_ready   =   ready;
assign    fifostartOffset_in_done    =   0;
// Assign input of dut
assign      startOffset_in_dout       =   fifostartOffset_in_dout;
reg   reg_fifostartOffset_in_empty_n;
initial begin : gen_reg_fifostartOffset_in_empty_n_process
    integer proc_rand;
    reg_fifostartOffset_in_empty_n = fifostartOffset_in_empty_n;
    while (1) begin
        @ (fifostartOffset_in_empty_n);
        reg_fifostartOffset_in_empty_n = fifostartOffset_in_empty_n;
    end
end

assign      startOffset_in_empty_n    =   reg_fifostartOffset_in_empty_n;


//------------------------Fifosearch_buffer_out Instantiation--------------

// The input and output of fifosearch_buffer_out
wire  fifosearch_buffer_out_wr;
wire  [31 : 0] fifosearch_buffer_out_din;
wire  fifosearch_buffer_out_full_n;
wire  fifosearch_buffer_out_ready;
wire  fifosearch_buffer_out_done;

`AESL_FIFO_search_buffer_out `AESL_FIFO_INST_search_buffer_out(
    .clk          (AESL_clock),
    .reset        (AESL_reset),
    .if_write     (fifosearch_buffer_out_wr),
    .if_din       (fifosearch_buffer_out_din),
    .if_full_n    (fifosearch_buffer_out_full_n),
    .if_read      (),
    .if_dout      (),
    .if_empty_n   (),
    .ready        (fifosearch_buffer_out_ready),
    .done         (fifosearch_buffer_out_done)
);

// Assignment between dut and fifosearch_buffer_out

// Assign input of fifosearch_buffer_out
assign      fifosearch_buffer_out_wr        =   search_buffer_out_write & search_buffer_out_full_n;
assign      fifosearch_buffer_out_din        =   search_buffer_out_din;
assign    fifosearch_buffer_out_ready   =  0;   //ready_initial | AESL_done_delay;
assign    fifosearch_buffer_out_done    =   AESL_done_delay;
// Assign input of dut
reg   reg_fifosearch_buffer_out_full_n;
initial begin : gen_reg_fifosearch_buffer_out_full_n_process
    integer proc_rand;
    reg_fifosearch_buffer_out_full_n = fifosearch_buffer_out_full_n;
    while (1) begin
        @ (fifosearch_buffer_out_full_n);
        reg_fifosearch_buffer_out_full_n = fifosearch_buffer_out_full_n;
    end
end

assign      search_buffer_out_full_n    =   reg_fifosearch_buffer_out_full_n;


//------------------------FifocoarseFreqOff_out Instantiation--------------

// The input and output of fifocoarseFreqOff_out
wire  fifocoarseFreqOff_out_wr;
wire  [31 : 0] fifocoarseFreqOff_out_din;
wire  fifocoarseFreqOff_out_full_n;
wire  fifocoarseFreqOff_out_ready;
wire  fifocoarseFreqOff_out_done;

`AESL_FIFO_coarseFreqOff_out `AESL_FIFO_INST_coarseFreqOff_out(
    .clk          (AESL_clock),
    .reset        (AESL_reset),
    .if_write     (fifocoarseFreqOff_out_wr),
    .if_din       (fifocoarseFreqOff_out_din),
    .if_full_n    (fifocoarseFreqOff_out_full_n),
    .if_read      (),
    .if_dout      (),
    .if_empty_n   (),
    .ready        (fifocoarseFreqOff_out_ready),
    .done         (fifocoarseFreqOff_out_done)
);

// Assignment between dut and fifocoarseFreqOff_out

// Assign input of fifocoarseFreqOff_out
assign      fifocoarseFreqOff_out_wr        =   coarseFreqOff_out_write & coarseFreqOff_out_full_n;
assign      fifocoarseFreqOff_out_din        =   coarseFreqOff_out_din;
assign    fifocoarseFreqOff_out_ready   =  0;   //ready_initial | AESL_done_delay;
assign    fifocoarseFreqOff_out_done    =   AESL_done_delay;
// Assign input of dut
reg   reg_fifocoarseFreqOff_out_full_n;
initial begin : gen_reg_fifocoarseFreqOff_out_full_n_process
    integer proc_rand;
    reg_fifocoarseFreqOff_out_full_n = fifocoarseFreqOff_out_full_n;
    while (1) begin
        @ (fifocoarseFreqOff_out_full_n);
        reg_fifocoarseFreqOff_out_full_n = fifocoarseFreqOff_out_full_n;
    end
end

assign      coarseFreqOff_out_full_n    =   reg_fifocoarseFreqOff_out_full_n;


//------------------------FifosearchBufferLen_out Instantiation--------------

// The input and output of fifosearchBufferLen_out
wire  fifosearchBufferLen_out_wr;
wire  [15 : 0] fifosearchBufferLen_out_din;
wire  fifosearchBufferLen_out_full_n;
wire  fifosearchBufferLen_out_ready;
wire  fifosearchBufferLen_out_done;

`AESL_FIFO_searchBufferLen_out `AESL_FIFO_INST_searchBufferLen_out(
    .clk          (AESL_clock),
    .reset        (AESL_reset),
    .if_write     (fifosearchBufferLen_out_wr),
    .if_din       (fifosearchBufferLen_out_din),
    .if_full_n    (fifosearchBufferLen_out_full_n),
    .if_read      (),
    .if_dout      (),
    .if_empty_n   (),
    .ready        (fifosearchBufferLen_out_ready),
    .done         (fifosearchBufferLen_out_done)
);

// Assignment between dut and fifosearchBufferLen_out

// Assign input of fifosearchBufferLen_out
assign      fifosearchBufferLen_out_wr        =   searchBufferLen_out_write & searchBufferLen_out_full_n;
assign      fifosearchBufferLen_out_din        =   searchBufferLen_out_din;
assign    fifosearchBufferLen_out_ready   =  0;   //ready_initial | AESL_done_delay;
assign    fifosearchBufferLen_out_done    =   AESL_done_delay;
// Assign input of dut
reg   reg_fifosearchBufferLen_out_full_n;
initial begin : gen_reg_fifosearchBufferLen_out_full_n_process
    integer proc_rand;
    reg_fifosearchBufferLen_out_full_n = fifosearchBufferLen_out_full_n;
    while (1) begin
        @ (fifosearchBufferLen_out_full_n);
        reg_fifosearchBufferLen_out_full_n = fifosearchBufferLen_out_full_n;
    end
end

assign      searchBufferLen_out_full_n    =   reg_fifosearchBufferLen_out_full_n;


//------------------------Fifopassthrough_out Instantiation--------------

// The input and output of fifopassthrough_out
wire  fifopassthrough_out_wr;
wire  [31 : 0] fifopassthrough_out_din;
wire  fifopassthrough_out_full_n;
wire  fifopassthrough_out_ready;
wire  fifopassthrough_out_done;

`AESL_FIFO_passthrough_out `AESL_FIFO_INST_passthrough_out(
    .clk          (AESL_clock),
    .reset        (AESL_reset),
    .if_write     (fifopassthrough_out_wr),
    .if_din       (fifopassthrough_out_din),
    .if_full_n    (fifopassthrough_out_full_n),
    .if_read      (),
    .if_dout      (),
    .if_empty_n   (),
    .ready        (fifopassthrough_out_ready),
    .done         (fifopassthrough_out_done)
);

// Assignment between dut and fifopassthrough_out

// Assign input of fifopassthrough_out
assign      fifopassthrough_out_wr        =   passthrough_out_write & passthrough_out_full_n;
assign      fifopassthrough_out_din        =   passthrough_out_din;
assign    fifopassthrough_out_ready   =  0;   //ready_initial | AESL_done_delay;
assign    fifopassthrough_out_done    =   AESL_done_delay;
// Assign input of dut
reg   reg_fifopassthrough_out_full_n;
initial begin : gen_reg_fifopassthrough_out_full_n_process
    integer proc_rand;
    reg_fifopassthrough_out_full_n = fifopassthrough_out_full_n;
    while (1) begin
        @ (fifopassthrough_out_full_n);
        reg_fifopassthrough_out_full_n = fifopassthrough_out_full_n;
    end
end

assign      passthrough_out_full_n    =   reg_fifopassthrough_out_full_n;


//------------------------FifostartOffset_fwd_out Instantiation--------------

// The input and output of fifostartOffset_fwd_out
wire  fifostartOffset_fwd_out_wr;
wire  [15 : 0] fifostartOffset_fwd_out_din;
wire  fifostartOffset_fwd_out_full_n;
wire  fifostartOffset_fwd_out_ready;
wire  fifostartOffset_fwd_out_done;

`AESL_FIFO_startOffset_fwd_out `AESL_FIFO_INST_startOffset_fwd_out(
    .clk          (AESL_clock),
    .reset        (AESL_reset),
    .if_write     (fifostartOffset_fwd_out_wr),
    .if_din       (fifostartOffset_fwd_out_din),
    .if_full_n    (fifostartOffset_fwd_out_full_n),
    .if_read      (),
    .if_dout      (),
    .if_empty_n   (),
    .ready        (fifostartOffset_fwd_out_ready),
    .done         (fifostartOffset_fwd_out_done)
);

// Assignment between dut and fifostartOffset_fwd_out

// Assign input of fifostartOffset_fwd_out
assign      fifostartOffset_fwd_out_wr        =   startOffset_fwd_out_write & startOffset_fwd_out_full_n;
assign      fifostartOffset_fwd_out_din        =   startOffset_fwd_out_din;
assign    fifostartOffset_fwd_out_ready   =  0;   //ready_initial | AESL_done_delay;
assign    fifostartOffset_fwd_out_done    =   AESL_done_delay;
// Assign input of dut
reg   reg_fifostartOffset_fwd_out_full_n;
initial begin : gen_reg_fifostartOffset_fwd_out_full_n_process
    integer proc_rand;
    reg_fifostartOffset_fwd_out_full_n = fifostartOffset_fwd_out_full_n;
    while (1) begin
        @ (fifostartOffset_fwd_out_full_n);
        reg_fifostartOffset_fwd_out_full_n = fifostartOffset_fwd_out_full_n;
    end
end

assign      startOffset_fwd_out_full_n    =   reg_fifostartOffset_fwd_out_full_n;


// The signal of port num_samples
reg [31: 0] AESL_REG_num_samples = 0;
assign num_samples = AESL_REG_num_samples;
initial begin : read_file_process_num_samples
    integer fp;
    integer err;
    integer ret;
    integer proc_rand;
    reg [231  : 0] token;
    integer i;
    reg transaction_finish;
    integer transaction_idx;
    transaction_idx = 0;
    wait(AESL_reset === 0);
    fp = $fopen(`AUTOTB_TVIN_num_samples,"r");
    if(fp == 0) begin       // Failed to open file
        $display("Failed to open file \"%s\"!", `AUTOTB_TVIN_num_samples);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    read_token(fp, token);
    if (token != "[[[runtime]]]") begin
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    read_token(fp, token);
    while (token != "[[[/runtime]]]") begin
        if (token != "[[transaction]]") begin
            $display("ERROR: Simulation using HLS TB failed.");
              $finish;
        end
        read_token(fp, token);  // skip transaction number
          read_token(fp, token);
            # 0.2;
            while(ready_wire !== 1) begin
                @(posedge AESL_clock);
                # 0.2;
            end
        if(token != "[[/transaction]]") begin
            ret = $sscanf(token, "0x%x", AESL_REG_num_samples);
              if (ret != 1) begin
                  $display("Failed to parse token!");
                $display("ERROR: Simulation using HLS TB failed.");
                  $finish;
              end
            @(posedge AESL_clock);
              read_token(fp, token);
        end
          read_token(fp, token);
    end
    $fclose(fp);
end


initial begin : generate_AESL_ready_cnt_proc
    AESL_ready_cnt = 0;
    wait(AESL_reset === 0);
    while(AESL_ready_cnt != AUTOTB_TRANSACTION_NUM) begin
        while(AESL_ready !== 1) begin
            @(posedge AESL_clock);
            # 0.4;
        end
        @(negedge AESL_clock);
        AESL_ready_cnt = AESL_ready_cnt + 1;
        @(posedge AESL_clock);
        # 0.4;
    end
end

    event next_trigger_ready_cnt;
    
    initial begin : gen_ready_cnt
        ready_cnt = 0;
        wait (AESL_reset === 0);
        forever begin
            @ (posedge AESL_clock);
            if (ready == 1) begin
                if (ready_cnt < AUTOTB_TRANSACTION_NUM) begin
                    ready_cnt = ready_cnt + 1;
                end
            end
            -> next_trigger_ready_cnt;
        end
    end
    
    wire all_finish = (done_cnt == AUTOTB_TRANSACTION_NUM);
    
    // done_cnt
    always @ (posedge AESL_clock) begin
        if (AESL_reset) begin
            done_cnt <= 0;
        end else begin
            if (AESL_done == 1) begin
                if (done_cnt < AUTOTB_TRANSACTION_NUM) begin
                    done_cnt <= done_cnt + 1;
                end
            end
        end
    end
    
    initial begin : finish_simulation
        wait (all_finish == 1);
        // last transaction is saved at negedge right after last done
        repeat(6) @ (posedge AESL_clock);
        $finish;
    end
    
initial begin
    AESL_clock = 0;
    forever #`AUTOTB_CLOCK_PERIOD_DIV2 AESL_clock = ~AESL_clock;
end


reg end_data_in;
reg [31:0] size_data_in;
reg [31:0] size_data_in_backup;
reg end_startOffset_in;
reg [31:0] size_startOffset_in;
reg [31:0] size_startOffset_in_backup;
reg end_num_samples;
reg [31:0] size_num_samples;
reg [31:0] size_num_samples_backup;
reg end_search_buffer_out;
reg [31:0] size_search_buffer_out;
reg [31:0] size_search_buffer_out_backup;
reg end_coarseFreqOff_out;
reg [31:0] size_coarseFreqOff_out;
reg [31:0] size_coarseFreqOff_out_backup;
reg end_searchBufferLen_out;
reg [31:0] size_searchBufferLen_out;
reg [31:0] size_searchBufferLen_out_backup;
reg end_passthrough_out;
reg [31:0] size_passthrough_out;
reg [31:0] size_passthrough_out_backup;
reg end_startOffset_fwd_out;
reg [31:0] size_startOffset_fwd_out;
reg [31:0] size_startOffset_fwd_out_backup;

initial begin : initial_process
    integer proc_rand;
    rst = 1;
    # 100;
    repeat(0+3) @ (posedge AESL_clock);
    # 0.1;
    rst = 0;
end
initial begin : initial_process_for_dut_rst
    integer proc_rand;
    dut_rst = 1;
    # 100;
    repeat(3) @ (posedge AESL_clock);
    # 0.1;
    dut_rst = 0;
end
initial begin : start_process
    integer proc_rand;
    reg [31:0] start_cnt;
    ce = 1;
    start = 0;
    start_cnt = 0;
    wait (AESL_reset === 0);
    @ (posedge AESL_clock);
    #0 start = 1;
    start_cnt = start_cnt + 1;
    forever begin
        if (start_cnt >= AUTOTB_TRANSACTION_NUM + 1) begin
            #0 start = 0;
        end
        @ (posedge AESL_clock);
        if (AESL_ready) begin
            start_cnt = start_cnt + 1;
        end
    end
end

always @(AESL_done)
begin
    tb_continue = AESL_done;
end

initial begin : ready_initial_process
    ready_initial = 0;
    wait (AESL_start === 1);
    ready_initial = 1;
    @(posedge AESL_clock);
    ready_initial = 0;
end

always @(posedge AESL_clock)
begin
    if(AESL_reset)
      AESL_ready_delay = 0;
  else
      AESL_ready_delay = AESL_ready;
end
initial begin : ready_last_n_process
  ready_last_n = 1;
  wait(ready_cnt == AUTOTB_TRANSACTION_NUM)
  @(posedge AESL_clock);
  ready_last_n <= 0;
end

always @(posedge AESL_clock)
begin
    if(AESL_reset)
      ready_delay_last_n = 0;
  else
      ready_delay_last_n <= ready_last_n;
end
assign ready = (ready_initial | AESL_ready_delay);
assign ready_wire = ready_initial | AESL_ready_delay;
initial begin : done_delay_last_n_process
  done_delay_last_n = 1;
  while(done_cnt < AUTOTB_TRANSACTION_NUM)
      @(posedge AESL_clock);
  # 0.1;
  done_delay_last_n = 0;
end

always @(posedge AESL_clock)
begin
    if(AESL_reset)
  begin
      AESL_done_delay <= 0;
      AESL_done_delay2 <= 0;
  end
  else begin
      AESL_done_delay <= AESL_done & done_delay_last_n;
      AESL_done_delay2 <= AESL_done_delay;
  end
end
always @(posedge AESL_clock)
begin
    if(AESL_reset)
      interface_done = 0;
  else begin
      # 0.01;
      if(ready === 1 && ready_cnt > 0 && ready_cnt < AUTOTB_TRANSACTION_NUM)
          interface_done = 1;
      else if(AESL_done_delay === 1 && done_cnt == AUTOTB_TRANSACTION_NUM)
          interface_done = 1;
      else
          interface_done = 0;
  end
end
task write_binary;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;

reg dump_tvout_finish_search_buffer_out;

initial begin : dump_tvout_runtime_sign_search_buffer_out
    integer fp;
    dump_tvout_finish_search_buffer_out = 0;
    fp = $fopen(`AUTOTB_TVOUT_search_buffer_out_out_wrapc, "w");
    if (fp == 0) begin
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_search_buffer_out_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[runtime]]]");
    $fclose(fp);
    wait (done_cnt == AUTOTB_TRANSACTION_NUM);
    // last transaction is saved at negedge right after last done
    repeat(5) @ (posedge AESL_clock);
    fp = $fopen(`AUTOTB_TVOUT_search_buffer_out_out_wrapc, "a");
    if (fp == 0) begin
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_search_buffer_out_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[/runtime]]]");
    $fclose(fp);
    dump_tvout_finish_search_buffer_out = 1;
end


reg dump_tvout_finish_coarseFreqOff_out;

initial begin : dump_tvout_runtime_sign_coarseFreqOff_out
    integer fp;
    dump_tvout_finish_coarseFreqOff_out = 0;
    fp = $fopen(`AUTOTB_TVOUT_coarseFreqOff_out_out_wrapc, "w");
    if (fp == 0) begin
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_coarseFreqOff_out_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[runtime]]]");
    $fclose(fp);
    wait (done_cnt == AUTOTB_TRANSACTION_NUM);
    // last transaction is saved at negedge right after last done
    repeat(5) @ (posedge AESL_clock);
    fp = $fopen(`AUTOTB_TVOUT_coarseFreqOff_out_out_wrapc, "a");
    if (fp == 0) begin
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_coarseFreqOff_out_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[/runtime]]]");
    $fclose(fp);
    dump_tvout_finish_coarseFreqOff_out = 1;
end


reg dump_tvout_finish_searchBufferLen_out;

initial begin : dump_tvout_runtime_sign_searchBufferLen_out
    integer fp;
    dump_tvout_finish_searchBufferLen_out = 0;
    fp = $fopen(`AUTOTB_TVOUT_searchBufferLen_out_out_wrapc, "w");
    if (fp == 0) begin
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_searchBufferLen_out_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[runtime]]]");
    $fclose(fp);
    wait (done_cnt == AUTOTB_TRANSACTION_NUM);
    // last transaction is saved at negedge right after last done
    repeat(5) @ (posedge AESL_clock);
    fp = $fopen(`AUTOTB_TVOUT_searchBufferLen_out_out_wrapc, "a");
    if (fp == 0) begin
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_searchBufferLen_out_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[/runtime]]]");
    $fclose(fp);
    dump_tvout_finish_searchBufferLen_out = 1;
end


reg dump_tvout_finish_passthrough_out;

initial begin : dump_tvout_runtime_sign_passthrough_out
    integer fp;
    dump_tvout_finish_passthrough_out = 0;
    fp = $fopen(`AUTOTB_TVOUT_passthrough_out_out_wrapc, "w");
    if (fp == 0) begin
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_passthrough_out_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[runtime]]]");
    $fclose(fp);
    wait (done_cnt == AUTOTB_TRANSACTION_NUM);
    // last transaction is saved at negedge right after last done
    repeat(5) @ (posedge AESL_clock);
    fp = $fopen(`AUTOTB_TVOUT_passthrough_out_out_wrapc, "a");
    if (fp == 0) begin
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_passthrough_out_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[/runtime]]]");
    $fclose(fp);
    dump_tvout_finish_passthrough_out = 1;
end


reg dump_tvout_finish_startOffset_fwd_out;

initial begin : dump_tvout_runtime_sign_startOffset_fwd_out
    integer fp;
    dump_tvout_finish_startOffset_fwd_out = 0;
    fp = $fopen(`AUTOTB_TVOUT_startOffset_fwd_out_out_wrapc, "w");
    if (fp == 0) begin
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_startOffset_fwd_out_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[runtime]]]");
    $fclose(fp);
    wait (done_cnt == AUTOTB_TRANSACTION_NUM);
    // last transaction is saved at negedge right after last done
    repeat(5) @ (posedge AESL_clock);
    fp = $fopen(`AUTOTB_TVOUT_startOffset_fwd_out_out_wrapc, "a");
    if (fp == 0) begin
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_startOffset_fwd_out_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[/runtime]]]");
    $fclose(fp);
    dump_tvout_finish_startOffset_fwd_out = 1;
end


////////////////////////////////////////////
// progress and performance
////////////////////////////////////////////

task wait_start();
    while (~AESL_start) begin
        @ (posedge AESL_clock);
    end
endtask

reg [31:0] clk_cnt = 0;
reg AESL_ready_p1;
reg AESL_start_p1;

always @ (posedge AESL_clock) begin
    if (AESL_reset == 1) begin
        clk_cnt <= 32'h0;
        AESL_ready_p1 <= 1'b0;
        AESL_start_p1 <= 1'b0;
    end
    else begin
        clk_cnt <= clk_cnt + 1;
        AESL_ready_p1 <= AESL_ready;
        AESL_start_p1 <= AESL_start;
    end
end

reg [31:0] start_timestamp [0:AUTOTB_TRANSACTION_NUM - 1];
reg [31:0] start_cnt;
reg [31:0] ready_timestamp [0:AUTOTB_TRANSACTION_NUM - 1];
reg [31:0] ap_ready_cnt;
reg [31:0] finish_timestamp [0:AUTOTB_TRANSACTION_NUM - 1];
reg [31:0] finish_cnt;
reg [31:0] lat_total;
event report_progress;

always @(posedge AESL_clock)
begin
    if (finish_cnt == AUTOTB_TRANSACTION_NUM - 1 && AESL_done == 1'b1)
        lat_total = clk_cnt - start_timestamp[0];
end

initial begin
    start_cnt = 0;
    finish_cnt = 0;
    ap_ready_cnt = 0;
    wait (AESL_reset == 0);
    wait_start();
    start_timestamp[start_cnt] = clk_cnt;
    start_cnt = start_cnt + 1;
    if (AESL_done) begin
        finish_timestamp[finish_cnt] = clk_cnt;
        finish_cnt = finish_cnt + 1;
    end
    -> report_progress;
    forever begin
        @ (posedge AESL_clock);
        if (start_cnt < AUTOTB_TRANSACTION_NUM) begin
            if ((AESL_start && AESL_ready_p1)||(AESL_start && ~AESL_start_p1)) begin
                start_timestamp[start_cnt] = clk_cnt;
                start_cnt = start_cnt + 1;
            end
        end
        if (ap_ready_cnt < AUTOTB_TRANSACTION_NUM) begin
            if (AESL_start_p1 && AESL_ready_p1) begin
                ready_timestamp[ap_ready_cnt] = clk_cnt;
                ap_ready_cnt = ap_ready_cnt + 1;
            end
        end
        if (finish_cnt < AUTOTB_TRANSACTION_NUM) begin
            if (AESL_done) begin
                finish_timestamp[finish_cnt] = clk_cnt;
                finish_cnt = finish_cnt + 1;
            end
        end
        -> report_progress;
    end
end

reg [31:0] progress_timeout;

initial begin : simulation_progress
    real intra_progress;
    wait (AESL_reset == 0);
    progress_timeout = PROGRESS_TIMEOUT;
    $display("////////////////////////////////////////////////////////////////////////////////////");
    $display("// Inter-Transaction Progress: Completed Transaction / Total Transaction");
    $display("// Intra-Transaction Progress: Measured Latency / Latency Estimation * 100%%");
    $display("//");
    $display("// RTL Simulation : \"Inter-Transaction Progress\" [\"Intra-Transaction Progress\"] @ \"Simulation Time\"");
    $display("////////////////////////////////////////////////////////////////////////////////////");
    print_progress();
    while (finish_cnt < AUTOTB_TRANSACTION_NUM) begin
        @ (report_progress);
        if (finish_cnt < AUTOTB_TRANSACTION_NUM) begin
            if (AESL_done) begin
                print_progress();
                progress_timeout = PROGRESS_TIMEOUT;
            end else begin
                if (progress_timeout == 0) begin
                    print_progress();
                    progress_timeout = PROGRESS_TIMEOUT;
                end else begin
                    progress_timeout = progress_timeout - 1;
                end
            end
        end
    end
    print_progress();
    $display("////////////////////////////////////////////////////////////////////////////////////");
    calculate_performance();
end

task get_intra_progress(output real intra_progress);
    begin
        if (start_cnt > finish_cnt) begin
            intra_progress = clk_cnt - start_timestamp[finish_cnt];
        end else if(finish_cnt > 0) begin
            intra_progress = LATENCY_ESTIMATION;
        end else begin
            intra_progress = 0;
        end
        intra_progress = intra_progress / LATENCY_ESTIMATION;
    end
endtask

task print_progress();
    real intra_progress;
    begin
        if (LATENCY_ESTIMATION > 0) begin
            get_intra_progress(intra_progress);
            $display("// RTL Simulation : %0d / %0d [%2.2f%%] @ \"%0t\"", finish_cnt, AUTOTB_TRANSACTION_NUM, intra_progress * 100, $time);
        end else begin
            $display("// RTL Simulation : %0d / %0d [n/a] @ \"%0t\"", finish_cnt, AUTOTB_TRANSACTION_NUM, $time);
        end
    end
endtask

task calculate_performance();
    integer i;
    integer fp;
    reg [31:0] latency [0:AUTOTB_TRANSACTION_NUM - 1];
    reg [31:0] latency_min;
    reg [31:0] latency_max;
    reg [31:0] latency_total;
    reg [31:0] latency_average;
    reg [31:0] interval [0:AUTOTB_TRANSACTION_NUM - 2];
    reg [31:0] interval_min;
    reg [31:0] interval_max;
    reg [31:0] interval_total;
    reg [31:0] interval_average;
    reg [31:0] total_execute_time;
    begin
        latency_min = -1;
        latency_max = 0;
        latency_total = 0;
        interval_min = -1;
        interval_max = 0;
        interval_total = 0;
        total_execute_time = lat_total;

        for (i = 0; i < AUTOTB_TRANSACTION_NUM; i = i + 1) begin
            // calculate latency
            latency[i] = finish_timestamp[i] - start_timestamp[i];
            if (latency[i] > latency_max) latency_max = latency[i];
            if (latency[i] < latency_min) latency_min = latency[i];
            latency_total = latency_total + latency[i];
            // calculate interval
            if (AUTOTB_TRANSACTION_NUM == 1) begin
                interval[i] = 0;
                interval_max = 0;
                interval_min = 0;
                interval_total = 0;
            end else if (i < AUTOTB_TRANSACTION_NUM - 1) begin
                interval[i] = start_timestamp[i + 1] - start_timestamp[i];
                if (interval[i] > interval_max) interval_max = interval[i];
                if (interval[i] < interval_min) interval_min = interval[i];
                interval_total = interval_total + interval[i];
            end
        end

        latency_average = latency_total / AUTOTB_TRANSACTION_NUM;
        if (AUTOTB_TRANSACTION_NUM == 1) begin
            interval_average = 0;
        end else begin
            interval_average = interval_total / (AUTOTB_TRANSACTION_NUM - 1);
        end

        fp = $fopen(`AUTOTB_LAT_RESULT_FILE, "w");

        $fdisplay(fp, "$MAX_LATENCY = \"%0d\"", latency_max);
        $fdisplay(fp, "$MIN_LATENCY = \"%0d\"", latency_min);
        $fdisplay(fp, "$AVER_LATENCY = \"%0d\"", latency_average);
        $fdisplay(fp, "$MAX_THROUGHPUT = \"%0d\"", interval_max);
        $fdisplay(fp, "$MIN_THROUGHPUT = \"%0d\"", interval_min);
        $fdisplay(fp, "$AVER_THROUGHPUT = \"%0d\"", interval_average);
        $fdisplay(fp, "$TOTAL_EXECUTE_TIME = \"%0d\"", total_execute_time);

        $fclose(fp);

        fp = $fopen(`AUTOTB_PER_RESULT_TRANS_FILE, "w");

        $fdisplay(fp, "%20s%16s%16s", "", "latency", "interval");
        if (AUTOTB_TRANSACTION_NUM == 1) begin
            i = 0;
            $fdisplay(fp, "transaction%8d:%16d%16d", i, latency[i], interval[i]);
        end else begin
            for (i = 0; i < AUTOTB_TRANSACTION_NUM; i = i + 1) begin
                if (i < AUTOTB_TRANSACTION_NUM - 1) begin
                    $fdisplay(fp, "transaction%8d:%16d%16d", i, latency[i], interval[i]);
                end else begin
                    $fdisplay(fp, "transaction%8d:%16d               x", i, latency[i]);
                end
            end
        end

        $fclose(fp);
    end
endtask


////////////////////////////////////////////
// Dependence Check
////////////////////////////////////////////

`ifndef POST_SYN

`endif
///////////////////////////////////////////////////////
// dataflow status monitor
///////////////////////////////////////////////////////
dataflow_monitor U_dataflow_monitor(
    .clock(AESL_clock),
    .reset(rst),
    .finish(all_finish));

`include "fifo_para.vh"

endmodule
