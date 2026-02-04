// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2024.2.2 (64-bit)
// Tool Version Limit: 2024.11
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================

`timescale 1ns/1ps

module module3_fine_sync_run_1
#(parameter
   INPUT_WIDTH  = 16,
   OUTPUT_WIDTH = 40,
   COEF_WIDTH   = 16
)
(
    input  wire                    ap_clk,
    input  wire                    ap_rst,
    input  wire                    ap_start,
    input  wire                    ap_continue,
    input  wire                    ap_ce,
    output reg                     ap_done,
    output reg                     ap_ready,
    output wire                    ap_idle,
    input  wire [INPUT_WIDTH-1:0]  in_V_dout,
    input  wire                    in_V_empty_n,
    output wire                    in_V_read,
    output wire [OUTPUT_WIDTH-1:0] out_V_din,
    input  wire                    out_V_full_n,
    output wire                    out_V_write
);
//------------------------Local signal-------------------
wire aresetn;
wire in_V_tready;
wire out_V_tvalid;
wire out_V_tlast;
wire out_V_full_n_i;

//------------------------Instantiation------------------
module3_fine_sync_run_1_core_ip inst (
  .aclk                             ( ap_clk ),
  .aclken                           ( ap_ce ),
  .aresetn                          ( aresetn ),
  .m_axis_data_tvalid               ( out_V_tvalid ),
  .m_axis_data_tready               ( out_V_full_n_i ),
  .m_axis_data_tdata                ( out_V_din ),
  .m_axis_data_tlast                ( out_V_tlast ),
  .s_axis_data_tvalid               ( in_V_empty_n ),
  .s_axis_data_tready               ( in_V_tready ),
  .s_axis_data_tdata                ( in_V_dout ),
  .s_axis_data_tlast                ( 1'b0 )
);

//------------------------Body---------------------------
assign aresetn                 = ap_rst ^ 1'b1;
assign in_V_read               = ap_ce & in_V_empty_n & in_V_tready;
assign out_V_write             = ap_ce & out_V_full_n_i & out_V_tvalid;
assign out_V_full_n_i          = out_V_full_n & (!ap_done | ap_continue);

always @(posedge ap_clk) begin
   if (ap_rst == 1'b1)
       ap_done <= 1'b0;
   else if (ap_ce) begin
       if (out_V_write)
           ap_done <= 1'b1;
       else if (ap_continue)
           ap_done <= 1'b0;
   end
end

always @(posedge ap_clk) begin
   if (ap_rst == 1'b1)
       ap_ready <= 1'b0;
   else if (ap_ce) begin
       if (out_V_write)
           ap_ready <= 1'b1;
       else
           ap_ready <= 1'b0;
   end
end

endmodule
