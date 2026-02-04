; ModuleID = '/home/amd/UTS/MATLAB2HLS_SKILL_fresh/projects/wlanSync/module2_coarse_cfo/module2_coarse_cfo/hls/.autopilot/db/a.g.ld.5.gdce.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-i64:64-i128:128-i256:256-i512:512-i1024:1024-i2048:2048-i4096:4096-n8:16:32:64-S128-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "fpga64-xilinx-none"

%"class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>" = type { %"struct.ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>" }
%"struct.ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>" = type { %"struct.ap_fixed_base<32, 16, true, AP_TRN, AP_WRAP, 0>" }
%"struct.ap_fixed_base<32, 16, true, AP_TRN, AP_WRAP, 0>" = type { %"struct.ssdm_int<32, true>" }
%"struct.ssdm_int<32, true>" = type { i32 }
%"class.hls::stream<complex_t, 0>" = type { %struct.complex_t }
%struct.complex_t = type { %"struct.ap_fixed<16, 2, AP_TRN, AP_WRAP, 0>", %"struct.ap_fixed<16, 2, AP_TRN, AP_WRAP, 0>" }
%"struct.ap_fixed<16, 2, AP_TRN, AP_WRAP, 0>" = type { %"struct.ap_fixed_base<16, 2, true, AP_TRN, AP_WRAP, 0>" }
%"struct.ap_fixed_base<16, 2, true, AP_TRN, AP_WRAP, 0>" = type { %"struct.ssdm_int<16, true>" }
%"struct.ssdm_int<16, true>" = type { i16 }
%"class.hls::stream<ap_int<16>, 0>" = type { %"struct.ap_fixed<16, 2, AP_TRN, AP_WRAP, 0>" }

; Function Attrs: inaccessiblememonly nounwind willreturn
declare void @llvm.sideeffect() #0

; Function Attrs: noinline willreturn
define void @apatb_module2_coarse_cfo_ir(%"class.hls::stream<complex_t, 0>"* noalias nocapture nonnull dereferenceable(4) %data_in, %"class.hls::stream<ap_int<16>, 0>"* noalias nocapture nonnull dereferenceable(2) %startOffset_in, %"class.hls::stream<complex_t, 0>"* noalias nocapture nonnull dereferenceable(4) %search_buffer_out, %"class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>"* noalias nocapture nonnull dereferenceable(4) %coarseFreqOff_out, %"class.hls::stream<ap_int<16>, 0>"* noalias nocapture nonnull dereferenceable(2) %searchBufferLen_out, %"class.hls::stream<complex_t, 0>"* noalias nocapture nonnull dereferenceable(4) %passthrough_out, %"class.hls::stream<ap_int<16>, 0>"* noalias nocapture nonnull dereferenceable(2) %startOffset_fwd_out, i32 %num_samples) local_unnamed_addr #1 {
entry:
  %data_in_copy = alloca i32, align 512
  call void @llvm.sideeffect() #8 [ "stream_interface"(i32* %data_in_copy, i32 0) ]
  %startOffset_in_copy = alloca i16, align 512
  call void @llvm.sideeffect() #9 [ "stream_interface"(i16* %startOffset_in_copy, i32 0) ]
  %search_buffer_out_copy = alloca i32, align 512
  call void @llvm.sideeffect() #8 [ "stream_interface"(i32* %search_buffer_out_copy, i32 0) ]
  %coarseFreqOff_out_copy = alloca i32, align 512
  call void @llvm.sideeffect() #8 [ "stream_interface"(i32* %coarseFreqOff_out_copy, i32 0) ]
  %searchBufferLen_out_copy = alloca i16, align 512
  call void @llvm.sideeffect() #9 [ "stream_interface"(i16* %searchBufferLen_out_copy, i32 0) ]
  %passthrough_out_copy = alloca i32, align 512
  call void @llvm.sideeffect() #8 [ "stream_interface"(i32* %passthrough_out_copy, i32 0) ]
  %startOffset_fwd_out_copy = alloca i16, align 512
  call void @llvm.sideeffect() #9 [ "stream_interface"(i16* %startOffset_fwd_out_copy, i32 0) ]
  call fastcc void @copy_in(%"class.hls::stream<complex_t, 0>"* nonnull %data_in, i32* nonnull align 512 %data_in_copy, %"class.hls::stream<ap_int<16>, 0>"* nonnull %startOffset_in, i16* nonnull align 512 %startOffset_in_copy, %"class.hls::stream<complex_t, 0>"* nonnull %search_buffer_out, i32* nonnull align 512 %search_buffer_out_copy, %"class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>"* nonnull %coarseFreqOff_out, i32* nonnull align 512 %coarseFreqOff_out_copy, %"class.hls::stream<ap_int<16>, 0>"* nonnull %searchBufferLen_out, i16* nonnull align 512 %searchBufferLen_out_copy, %"class.hls::stream<complex_t, 0>"* nonnull %passthrough_out, i32* nonnull align 512 %passthrough_out_copy, %"class.hls::stream<ap_int<16>, 0>"* nonnull %startOffset_fwd_out, i16* nonnull align 512 %startOffset_fwd_out_copy)
  call void @apatb_module2_coarse_cfo_hw(i32* %data_in_copy, i16* %startOffset_in_copy, i32* %search_buffer_out_copy, i32* %coarseFreqOff_out_copy, i16* %searchBufferLen_out_copy, i32* %passthrough_out_copy, i16* %startOffset_fwd_out_copy, i32 %num_samples)
  call void @copy_back(%"class.hls::stream<complex_t, 0>"* %data_in, i32* %data_in_copy, %"class.hls::stream<ap_int<16>, 0>"* %startOffset_in, i16* %startOffset_in_copy, %"class.hls::stream<complex_t, 0>"* %search_buffer_out, i32* %search_buffer_out_copy, %"class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>"* %coarseFreqOff_out, i32* %coarseFreqOff_out_copy, %"class.hls::stream<ap_int<16>, 0>"* %searchBufferLen_out, i16* %searchBufferLen_out_copy, %"class.hls::stream<complex_t, 0>"* %passthrough_out, i32* %passthrough_out_copy, %"class.hls::stream<ap_int<16>, 0>"* %startOffset_fwd_out, i16* %startOffset_fwd_out_copy)
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @copy_in(%"class.hls::stream<complex_t, 0>"* noalias "unpacked"="0", i32* noalias align 512 "unpacked"="1", %"class.hls::stream<ap_int<16>, 0>"* noalias "unpacked"="2", i16* noalias nocapture align 512 "unpacked"="3.0", %"class.hls::stream<complex_t, 0>"* noalias "unpacked"="4", i32* noalias align 512 "unpacked"="5", %"class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>"* noalias "unpacked"="6", i32* noalias nocapture align 512 "unpacked"="7.0", %"class.hls::stream<ap_int<16>, 0>"* noalias "unpacked"="8", i16* noalias nocapture align 512 "unpacked"="9.0", %"class.hls::stream<complex_t, 0>"* noalias "unpacked"="10", i32* noalias align 512 "unpacked"="11", %"class.hls::stream<ap_int<16>, 0>"* noalias "unpacked"="12", i16* noalias nocapture align 512 "unpacked"="13.0") unnamed_addr #2 {
entry:
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<complex_t, 0>"(i32* align 512 %1, %"class.hls::stream<complex_t, 0>"* %0)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_int<16>, 0>.40"(i16* align 512 %3, %"class.hls::stream<ap_int<16>, 0>"* %2)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<complex_t, 0>"(i32* align 512 %5, %"class.hls::stream<complex_t, 0>"* %4)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>"(i32* align 512 %7, %"class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>"* %6)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_int<16>, 0>.40"(i16* align 512 %9, %"class.hls::stream<ap_int<16>, 0>"* %8)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<complex_t, 0>"(i32* align 512 %11, %"class.hls::stream<complex_t, 0>"* %10)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_int<16>, 0>.40"(i16* align 512 %13, %"class.hls::stream<ap_int<16>, 0>"* %12)
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>"(i32* noalias nocapture align 512 "unpacked"="0.0" %dst, %"class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>"* noalias "unpacked"="1" %src) unnamed_addr #3 {
entry:
  %0 = icmp eq %"class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>"* %src, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call fastcc void @"streamcpy_hls.p0class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>"(i32* align 512 %dst, %"class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>"* nonnull %src)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"streamcpy_hls.p0class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>"(i32* noalias nocapture align 512 "unpacked"="0.0", %"class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>"* noalias nocapture "unpacked"="1") unnamed_addr #4 {
entry:
  %2 = alloca %"class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>"
  %3 = alloca i32
  br label %empty

empty:                                            ; preds = %push, %entry
  %4 = bitcast %"class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>"* %1 to i8*
  %5 = call i1 @fpga_fifo_not_empty_4(i8* %4)
  br i1 %5, label %push, label %ret

push:                                             ; preds = %empty
  %6 = bitcast %"class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>"* %2 to i8*
  %7 = bitcast %"class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>"* %1 to i8*
  call void @fpga_fifo_pop_4(i8* %6, i8* %7)
  %8 = load volatile %"class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>", %"class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>"* %2
  %.evi = extractvalue %"class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>" %8, 0, 0, 0, 0
  store i32 %.evi, i32* %3
  %9 = bitcast i32* %3 to i8*
  %10 = bitcast i32* %0 to i8*
  call void @fpga_fifo_push_4(i8* %9, i8* %10)
  br label %empty, !llvm.loop !5

ret:                                              ; preds = %empty
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @copy_out(%"class.hls::stream<complex_t, 0>"* noalias "unpacked"="0", i32* noalias align 512 "unpacked"="1", %"class.hls::stream<ap_int<16>, 0>"* noalias "unpacked"="2", i16* noalias nocapture align 512 "unpacked"="3.0", %"class.hls::stream<complex_t, 0>"* noalias "unpacked"="4", i32* noalias align 512 "unpacked"="5", %"class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>"* noalias "unpacked"="6", i32* noalias nocapture align 512 "unpacked"="7.0", %"class.hls::stream<ap_int<16>, 0>"* noalias "unpacked"="8", i16* noalias nocapture align 512 "unpacked"="9.0", %"class.hls::stream<complex_t, 0>"* noalias "unpacked"="10", i32* noalias align 512 "unpacked"="11", %"class.hls::stream<ap_int<16>, 0>"* noalias "unpacked"="12", i16* noalias nocapture align 512 "unpacked"="13.0") unnamed_addr #5 {
entry:
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<complex_t, 0>.65"(%"class.hls::stream<complex_t, 0>"* %0, i32* align 512 %1)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_int<16>, 0>"(%"class.hls::stream<ap_int<16>, 0>"* %2, i16* align 512 %3)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<complex_t, 0>.65"(%"class.hls::stream<complex_t, 0>"* %4, i32* align 512 %5)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>.50"(%"class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>"* %6, i32* align 512 %7)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_int<16>, 0>"(%"class.hls::stream<ap_int<16>, 0>"* %8, i16* align 512 %9)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<complex_t, 0>.65"(%"class.hls::stream<complex_t, 0>"* %10, i32* align 512 %11)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_int<16>, 0>"(%"class.hls::stream<ap_int<16>, 0>"* %12, i16* align 512 %13)
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_int<16>, 0>"(%"class.hls::stream<ap_int<16>, 0>"* noalias "unpacked"="0" %dst, i16* noalias nocapture align 512 "unpacked"="1.0" %src) unnamed_addr #3 {
entry:
  %0 = icmp eq %"class.hls::stream<ap_int<16>, 0>"* %dst, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call fastcc void @"streamcpy_hls.p0class.hls::stream<ap_int<16>, 0>.35"(%"class.hls::stream<ap_int<16>, 0>"* nonnull %dst, i16* align 512 %src)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"streamcpy_hls.p0class.hls::stream<ap_int<16>, 0>.35"(%"class.hls::stream<ap_int<16>, 0>"* noalias nocapture "unpacked"="0", i16* noalias nocapture align 512 "unpacked"="1.0") unnamed_addr #4 {
entry:
  %2 = alloca i16
  %3 = alloca %"class.hls::stream<ap_int<16>, 0>"
  br label %empty

empty:                                            ; preds = %push, %entry
  %4 = bitcast i16* %1 to i8*
  %5 = call i1 @fpga_fifo_not_empty_2(i8* %4)
  br i1 %5, label %push, label %ret

push:                                             ; preds = %empty
  %6 = bitcast i16* %2 to i8*
  %7 = bitcast i16* %1 to i8*
  call void @fpga_fifo_pop_2(i8* %6, i8* %7)
  %8 = load volatile i16, i16* %2
  %.ivi = insertvalue %"class.hls::stream<ap_int<16>, 0>" undef, i16 %8, 0, 0, 0, 0
  store %"class.hls::stream<ap_int<16>, 0>" %.ivi, %"class.hls::stream<ap_int<16>, 0>"* %3
  %9 = bitcast %"class.hls::stream<ap_int<16>, 0>"* %3 to i8*
  %10 = bitcast %"class.hls::stream<ap_int<16>, 0>"* %0 to i8*
  call void @fpga_fifo_push_2(i8* %9, i8* %10)
  br label %empty, !llvm.loop !7

ret:                                              ; preds = %empty
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_int<16>, 0>.40"(i16* noalias nocapture align 512 "unpacked"="0.0" %dst, %"class.hls::stream<ap_int<16>, 0>"* noalias "unpacked"="1" %src) unnamed_addr #3 {
entry:
  %0 = icmp eq %"class.hls::stream<ap_int<16>, 0>"* %src, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call fastcc void @"streamcpy_hls.p0class.hls::stream<ap_int<16>, 0>.43"(i16* align 512 %dst, %"class.hls::stream<ap_int<16>, 0>"* nonnull %src)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"streamcpy_hls.p0class.hls::stream<ap_int<16>, 0>.43"(i16* noalias nocapture align 512 "unpacked"="0.0", %"class.hls::stream<ap_int<16>, 0>"* noalias nocapture "unpacked"="1") unnamed_addr #4 {
entry:
  %2 = alloca %"class.hls::stream<ap_int<16>, 0>"
  %3 = alloca i16
  br label %empty

empty:                                            ; preds = %push, %entry
  %4 = bitcast %"class.hls::stream<ap_int<16>, 0>"* %1 to i8*
  %5 = call i1 @fpga_fifo_not_empty_2(i8* %4)
  br i1 %5, label %push, label %ret

push:                                             ; preds = %empty
  %6 = bitcast %"class.hls::stream<ap_int<16>, 0>"* %2 to i8*
  %7 = bitcast %"class.hls::stream<ap_int<16>, 0>"* %1 to i8*
  call void @fpga_fifo_pop_2(i8* %6, i8* %7)
  %8 = load volatile %"class.hls::stream<ap_int<16>, 0>", %"class.hls::stream<ap_int<16>, 0>"* %2
  %.evi = extractvalue %"class.hls::stream<ap_int<16>, 0>" %8, 0, 0, 0, 0
  store i16 %.evi, i16* %3
  %9 = bitcast i16* %3 to i8*
  %10 = bitcast i16* %0 to i8*
  call void @fpga_fifo_push_2(i8* %9, i8* %10)
  br label %empty, !llvm.loop !8

ret:                                              ; preds = %empty
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>.50"(%"class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>"* noalias "unpacked"="0" %dst, i32* noalias nocapture align 512 "unpacked"="1.0" %src) unnamed_addr #3 {
entry:
  %0 = icmp eq %"class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>"* %dst, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call fastcc void @"streamcpy_hls.p0class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>.53"(%"class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>"* nonnull %dst, i32* align 512 %src)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"streamcpy_hls.p0class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>.53"(%"class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>"* noalias nocapture "unpacked"="0", i32* noalias nocapture align 512 "unpacked"="1.0") unnamed_addr #4 {
entry:
  %2 = alloca i32
  %3 = alloca %"class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>"
  br label %empty

empty:                                            ; preds = %push, %entry
  %4 = bitcast i32* %1 to i8*
  %5 = call i1 @fpga_fifo_not_empty_4(i8* %4)
  br i1 %5, label %push, label %ret

push:                                             ; preds = %empty
  %6 = bitcast i32* %2 to i8*
  %7 = bitcast i32* %1 to i8*
  call void @fpga_fifo_pop_4(i8* %6, i8* %7)
  %8 = load volatile i32, i32* %2
  %.ivi = insertvalue %"class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>" undef, i32 %8, 0, 0, 0, 0
  store %"class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>" %.ivi, %"class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>"* %3
  %9 = bitcast %"class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>"* %3 to i8*
  %10 = bitcast %"class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>"* %0 to i8*
  call void @fpga_fifo_push_4(i8* %9, i8* %10)
  br label %empty, !llvm.loop !9

ret:                                              ; preds = %empty
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"onebyonecpy_hls.p0class.hls::stream<complex_t, 0>.65"(%"class.hls::stream<complex_t, 0>"* noalias %dst, i32* noalias align 512 %src) unnamed_addr #3 {
entry:
  %0 = icmp eq %"class.hls::stream<complex_t, 0>"* %dst, null
  %1 = icmp eq i32* %src, null
  %2 = or i1 %0, %1
  br i1 %2, label %ret, label %copy

copy:                                             ; preds = %entry
  call fastcc void @"streamcpy_hls.p0class.hls::stream<complex_t, 0>.68"(%"class.hls::stream<complex_t, 0>"* nonnull %dst, i32* nonnull align 512 %src)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"streamcpy_hls.p0class.hls::stream<complex_t, 0>.68"(%"class.hls::stream<complex_t, 0>"* noalias nocapture, i32* noalias nocapture align 512) unnamed_addr #4 {
entry:
  %2 = alloca i32
  %3 = alloca %"class.hls::stream<complex_t, 0>"
  br label %empty

empty:                                            ; preds = %push, %entry
  %4 = bitcast i32* %1 to i8*
  %5 = call i1 @fpga_fifo_not_empty_4(i8* %4)
  br i1 %5, label %push, label %ret

push:                                             ; preds = %empty
  %6 = bitcast i32* %2 to i8*
  %7 = bitcast i32* %1 to i8*
  call void @fpga_fifo_pop_4(i8* %6, i8* %7)
  %8 = load volatile i32, i32* %2
  %9 = call { %"struct.ap_fixed<16, 2, AP_TRN, AP_WRAP, 0>", %"struct.ap_fixed<16, 2, AP_TRN, AP_WRAP, 0>" } @"_llvm.fpga.unpack.bits.s_class.hls::stream<complex_t, 0>s.i32"(i32 %8)
  %newret = extractvalue { %"struct.ap_fixed<16, 2, AP_TRN, AP_WRAP, 0>", %"struct.ap_fixed<16, 2, AP_TRN, AP_WRAP, 0>" } %9, 0
  %oldret1 = insertvalue %struct.complex_t undef, %"struct.ap_fixed<16, 2, AP_TRN, AP_WRAP, 0>" %newret, 0
  %newret2 = extractvalue { %"struct.ap_fixed<16, 2, AP_TRN, AP_WRAP, 0>", %"struct.ap_fixed<16, 2, AP_TRN, AP_WRAP, 0>" } %9, 1
  %oldret3 = insertvalue %struct.complex_t %oldret1, %"struct.ap_fixed<16, 2, AP_TRN, AP_WRAP, 0>" %newret2, 1
  %oldret = insertvalue %"class.hls::stream<complex_t, 0>" undef, %struct.complex_t %oldret3, 0
  store %"class.hls::stream<complex_t, 0>" %oldret, %"class.hls::stream<complex_t, 0>"* %3
  %10 = bitcast %"class.hls::stream<complex_t, 0>"* %3 to i8*
  %11 = bitcast %"class.hls::stream<complex_t, 0>"* %0 to i8*
  call void @fpga_fifo_push_4(i8* %10, i8* %11)
  br label %empty, !llvm.loop !10

ret:                                              ; preds = %empty
  ret void
}

; Function Attrs: alwaysinline nounwind readnone willreturn
define internal { %"struct.ap_fixed<16, 2, AP_TRN, AP_WRAP, 0>", %"struct.ap_fixed<16, 2, AP_TRN, AP_WRAP, 0>" } @"_llvm.fpga.unpack.bits.s_class.hls::stream<complex_t, 0>s.i32"(i32 %A) #6 {
  %1 = trunc i32 %A to i16
  %.0 = insertvalue %"struct.ssdm_int<16, true>" undef, i16 %1, 0
  %.01 = insertvalue %"struct.ap_fixed_base<16, 2, true, AP_TRN, AP_WRAP, 0>" undef, %"struct.ssdm_int<16, true>" %.0, 0
  %.02 = insertvalue %"struct.ap_fixed<16, 2, AP_TRN, AP_WRAP, 0>" undef, %"struct.ap_fixed_base<16, 2, true, AP_TRN, AP_WRAP, 0>" %.01, 0
  %2 = lshr i32 %A, 16
  %3 = trunc i32 %2 to i16
  %.04 = insertvalue %"struct.ssdm_int<16, true>" undef, i16 %3, 0
  %.05 = insertvalue %"struct.ap_fixed_base<16, 2, true, AP_TRN, AP_WRAP, 0>" undef, %"struct.ssdm_int<16, true>" %.04, 0
  %.06 = insertvalue %"struct.ap_fixed<16, 2, AP_TRN, AP_WRAP, 0>" undef, %"struct.ap_fixed_base<16, 2, true, AP_TRN, AP_WRAP, 0>" %.05, 0
  %newret = insertvalue { %"struct.ap_fixed<16, 2, AP_TRN, AP_WRAP, 0>", %"struct.ap_fixed<16, 2, AP_TRN, AP_WRAP, 0>" } undef, %"struct.ap_fixed<16, 2, AP_TRN, AP_WRAP, 0>" %.02, 0
  %newret2 = insertvalue { %"struct.ap_fixed<16, 2, AP_TRN, AP_WRAP, 0>", %"struct.ap_fixed<16, 2, AP_TRN, AP_WRAP, 0>" } %newret, %"struct.ap_fixed<16, 2, AP_TRN, AP_WRAP, 0>" %.06, 1
  ret { %"struct.ap_fixed<16, 2, AP_TRN, AP_WRAP, 0>", %"struct.ap_fixed<16, 2, AP_TRN, AP_WRAP, 0>" } %newret2
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"onebyonecpy_hls.p0class.hls::stream<complex_t, 0>"(i32* noalias align 512 %dst, %"class.hls::stream<complex_t, 0>"* noalias %src) unnamed_addr #3 {
entry:
  %0 = icmp eq i32* %dst, null
  %1 = icmp eq %"class.hls::stream<complex_t, 0>"* %src, null
  %2 = or i1 %0, %1
  br i1 %2, label %ret, label %copy

copy:                                             ; preds = %entry
  call fastcc void @"streamcpy_hls.p0class.hls::stream<complex_t, 0>.76"(i32* nonnull align 512 %dst, %"class.hls::stream<complex_t, 0>"* nonnull %src)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"streamcpy_hls.p0class.hls::stream<complex_t, 0>.76"(i32* noalias nocapture align 512, %"class.hls::stream<complex_t, 0>"* noalias nocapture) unnamed_addr #4 {
entry:
  %2 = alloca %"class.hls::stream<complex_t, 0>"
  %3 = alloca i32
  br label %empty

empty:                                            ; preds = %push, %entry
  %4 = bitcast %"class.hls::stream<complex_t, 0>"* %1 to i8*
  %5 = call i1 @fpga_fifo_not_empty_4(i8* %4)
  br i1 %5, label %push, label %ret

push:                                             ; preds = %empty
  %6 = bitcast %"class.hls::stream<complex_t, 0>"* %2 to i8*
  %7 = bitcast %"class.hls::stream<complex_t, 0>"* %1 to i8*
  call void @fpga_fifo_pop_4(i8* %6, i8* %7)
  %8 = load volatile %"class.hls::stream<complex_t, 0>", %"class.hls::stream<complex_t, 0>"* %2
  %9 = call i32 @"_llvm.fpga.pack.bits.i32.s_class.hls::stream<complex_t, 0>s"(%"class.hls::stream<complex_t, 0>" %8)
  store i32 %9, i32* %3
  %10 = bitcast i32* %3 to i8*
  %11 = bitcast i32* %0 to i8*
  call void @fpga_fifo_push_4(i8* %10, i8* %11)
  br label %empty, !llvm.loop !10

ret:                                              ; preds = %empty
  ret void
}

; Function Attrs: alwaysinline nounwind readnone willreturn
define internal i32 @"_llvm.fpga.pack.bits.i32.s_class.hls::stream<complex_t, 0>s"(%"class.hls::stream<complex_t, 0>" %A) #6 {
  %A.0 = extractvalue %"class.hls::stream<complex_t, 0>" %A, 0
  %A.0.0 = extractvalue %struct.complex_t %A.0, 0
  %A.0.0.0 = extractvalue %"struct.ap_fixed<16, 2, AP_TRN, AP_WRAP, 0>" %A.0.0, 0
  %A.0.0.0.0 = extractvalue %"struct.ap_fixed_base<16, 2, true, AP_TRN, AP_WRAP, 0>" %A.0.0.0, 0
  %A.0.0.0.0.0 = extractvalue %"struct.ssdm_int<16, true>" %A.0.0.0.0, 0
  %1 = zext i16 %A.0.0.0.0.0 to i32
  %A.0.1 = extractvalue %struct.complex_t %A.0, 1
  %A.0.1.0 = extractvalue %"struct.ap_fixed<16, 2, AP_TRN, AP_WRAP, 0>" %A.0.1, 0
  %A.0.1.0.0 = extractvalue %"struct.ap_fixed_base<16, 2, true, AP_TRN, AP_WRAP, 0>" %A.0.1.0, 0
  %A.0.1.0.0.0 = extractvalue %"struct.ssdm_int<16, true>" %A.0.1.0.0, 0
  %2 = zext i16 %A.0.1.0.0.0 to i32
  %3 = shl nuw i32 %2, 16
  %4 = or i32 %3, %1
  ret i32 %4
}

declare i8* @malloc(i64)

declare void @free(i8*)

declare void @apatb_module2_coarse_cfo_hw(i32*, i16*, i32*, i32*, i16*, i32*, i16*, i32)

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @copy_back(%"class.hls::stream<complex_t, 0>"* noalias "unpacked"="0", i32* noalias align 512 "unpacked"="1", %"class.hls::stream<ap_int<16>, 0>"* noalias "unpacked"="2", i16* noalias nocapture align 512 "unpacked"="3.0", %"class.hls::stream<complex_t, 0>"* noalias "unpacked"="4", i32* noalias align 512 "unpacked"="5", %"class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>"* noalias "unpacked"="6", i32* noalias nocapture align 512 "unpacked"="7.0", %"class.hls::stream<ap_int<16>, 0>"* noalias "unpacked"="8", i16* noalias nocapture align 512 "unpacked"="9.0", %"class.hls::stream<complex_t, 0>"* noalias "unpacked"="10", i32* noalias align 512 "unpacked"="11", %"class.hls::stream<ap_int<16>, 0>"* noalias "unpacked"="12", i16* noalias nocapture align 512 "unpacked"="13.0") unnamed_addr #5 {
entry:
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<complex_t, 0>.65"(%"class.hls::stream<complex_t, 0>"* %0, i32* align 512 %1)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_int<16>, 0>"(%"class.hls::stream<ap_int<16>, 0>"* %2, i16* align 512 %3)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<complex_t, 0>.65"(%"class.hls::stream<complex_t, 0>"* %4, i32* align 512 %5)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>.50"(%"class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>"* %6, i32* align 512 %7)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_int<16>, 0>"(%"class.hls::stream<ap_int<16>, 0>"* %8, i16* align 512 %9)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<complex_t, 0>.65"(%"class.hls::stream<complex_t, 0>"* %10, i32* align 512 %11)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_int<16>, 0>"(%"class.hls::stream<ap_int<16>, 0>"* %12, i16* align 512 %13)
  ret void
}

declare void @module2_coarse_cfo_hw_stub(%"class.hls::stream<complex_t, 0>"* noalias nocapture nonnull, %"class.hls::stream<ap_int<16>, 0>"* noalias nocapture nonnull, %"class.hls::stream<complex_t, 0>"* noalias nocapture nonnull, %"class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>"* noalias nocapture nonnull, %"class.hls::stream<ap_int<16>, 0>"* noalias nocapture nonnull, %"class.hls::stream<complex_t, 0>"* noalias nocapture nonnull, %"class.hls::stream<ap_int<16>, 0>"* noalias nocapture nonnull, i32)

define void @module2_coarse_cfo_hw_stub_wrapper(i32*, i16*, i32*, i32*, i16*, i32*, i16*, i32) #7 {
entry:
  %8 = call i8* @malloc(i64 4)
  %9 = bitcast i8* %8 to %"class.hls::stream<complex_t, 0>"*
  %10 = call i8* @malloc(i64 2)
  %11 = bitcast i8* %10 to %"class.hls::stream<ap_int<16>, 0>"*
  %12 = call i8* @malloc(i64 4)
  %13 = bitcast i8* %12 to %"class.hls::stream<complex_t, 0>"*
  %14 = call i8* @malloc(i64 4)
  %15 = bitcast i8* %14 to %"class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>"*
  %16 = call i8* @malloc(i64 2)
  %17 = bitcast i8* %16 to %"class.hls::stream<ap_int<16>, 0>"*
  %18 = call i8* @malloc(i64 4)
  %19 = bitcast i8* %18 to %"class.hls::stream<complex_t, 0>"*
  %20 = call i8* @malloc(i64 2)
  %21 = bitcast i8* %20 to %"class.hls::stream<ap_int<16>, 0>"*
  call void @copy_out(%"class.hls::stream<complex_t, 0>"* %9, i32* %0, %"class.hls::stream<ap_int<16>, 0>"* %11, i16* %1, %"class.hls::stream<complex_t, 0>"* %13, i32* %2, %"class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>"* %15, i32* %3, %"class.hls::stream<ap_int<16>, 0>"* %17, i16* %4, %"class.hls::stream<complex_t, 0>"* %19, i32* %5, %"class.hls::stream<ap_int<16>, 0>"* %21, i16* %6)
  call void @module2_coarse_cfo_hw_stub(%"class.hls::stream<complex_t, 0>"* %9, %"class.hls::stream<ap_int<16>, 0>"* %11, %"class.hls::stream<complex_t, 0>"* %13, %"class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>"* %15, %"class.hls::stream<ap_int<16>, 0>"* %17, %"class.hls::stream<complex_t, 0>"* %19, %"class.hls::stream<ap_int<16>, 0>"* %21, i32 %7)
  call void @copy_in(%"class.hls::stream<complex_t, 0>"* %9, i32* %0, %"class.hls::stream<ap_int<16>, 0>"* %11, i16* %1, %"class.hls::stream<complex_t, 0>"* %13, i32* %2, %"class.hls::stream<ap_fixed<32, 16, AP_TRN, AP_WRAP, 0>, 0>"* %15, i32* %3, %"class.hls::stream<ap_int<16>, 0>"* %17, i16* %4, %"class.hls::stream<complex_t, 0>"* %19, i32* %5, %"class.hls::stream<ap_int<16>, 0>"* %21, i16* %6)
  call void @free(i8* %8)
  call void @free(i8* %10)
  call void @free(i8* %12)
  call void @free(i8* %14)
  call void @free(i8* %16)
  call void @free(i8* %18)
  call void @free(i8* %20)
  ret void
}

declare i1 @fpga_fifo_not_empty_4(i8*)

declare i1 @fpga_fifo_not_empty_2(i8*)

declare void @fpga_fifo_pop_4(i8*, i8*)

declare void @fpga_fifo_pop_2(i8*, i8*)

declare void @fpga_fifo_push_4(i8*, i8*)

declare void @fpga_fifo_push_2(i8*, i8*)

attributes #0 = { inaccessiblememonly nounwind willreturn }
attributes #1 = { noinline willreturn "fpga.wrapper.func"="wrapper" }
attributes #2 = { argmemonly noinline willreturn "fpga.wrapper.func"="copyin" }
attributes #3 = { argmemonly noinline willreturn "fpga.wrapper.func"="onebyonecpy_hls" }
attributes #4 = { argmemonly noinline willreturn "fpga.wrapper.func"="streamcpy_hls" }
attributes #5 = { argmemonly noinline willreturn "fpga.wrapper.func"="copyout" }
attributes #6 = { alwaysinline nounwind readnone willreturn }
attributes #7 = { "fpga.wrapper.func"="stub" }
attributes #8 = { inaccessiblememonly nounwind willreturn "xlx.port.bitwidth"="32" "xlx.source"="user" }
attributes #9 = { inaccessiblememonly nounwind willreturn "xlx.port.bitwidth"="16" "xlx.source"="user" }

!llvm.dbg.cu = !{}
!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3}
!blackbox_cfg = !{!4}

!0 = !{!"clang version 7.0.0 "}
!1 = !{i32 2, !"Dwarf Version", i32 4}
!2 = !{i32 2, !"Debug Info Version", i32 3}
!3 = !{i32 1, !"wchar_size", i32 4}
!4 = !{}
!5 = distinct !{!5, !6}
!6 = !{!"llvm.loop.rotate.disable"}
!7 = distinct !{!7, !6}
!8 = distinct !{!8, !6}
!9 = distinct !{!9, !6}
!10 = distinct !{!10, !6}
