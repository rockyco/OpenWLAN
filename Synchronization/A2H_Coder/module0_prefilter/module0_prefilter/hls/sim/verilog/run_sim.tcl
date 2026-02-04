# ==============================================================
# Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2024.2.2 (64-bit)
# Tool Version Limit: 2024.11
# Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
# Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
# 
# ==============================================================
set ::env(LD_LIBRARY_PATH) /opt/Xilinx/Vitis/2024.2/lnx64/tools/fpo_v7_1:$::env(LD_LIBRARY_PATH)
set ::env(LD_LIBRARY_PATH) /opt/Xilinx/Vitis/2024.2/lnx64/tools/fft_v9_1:$::env(LD_LIBRARY_PATH)
set ::env(LD_LIBRARY_PATH) /opt/Xilinx/Vitis/2024.2/lnx64/tools/fir_v7_0:$::env(LD_LIBRARY_PATH)
set ::env(LD_LIBRARY_PATH) /opt/Xilinx/Vitis/2024.2/lnx64/tools/dds_v6_0:$::env(LD_LIBRARY_PATH)
set ::env(LD_LIBRARY_PATH) /opt/Xilinx/Vitis/2024.2/tps/lnx64/gcc-8.3.0/lib:$::env(LD_LIBRARY_PATH)
set ::env(LD_LIBRARY_PATH) /opt/Xilinx/Vitis/2024.2/lib/lnx64.o/Ubuntu:$::env(LD_LIBRARY_PATH)
set ::env(LD_LIBRARY_PATH) /usr/lib/x86_64-linux-gnu:$::env(LD_LIBRARY_PATH)
set_param hls.enable_hidden_option_error false

source check_sim.tcl
source dataflow_monitor_API.tcl

# --> test vector generation

::AP::printMsg INFO COSIM 302 COSIM_302_998

cd ../wrapc

file delete -force  "err.log"

if {![file exists cosim.tv.exe]} {
	::AP::printMsg ERR COSIM 321 COSIM_321_999
	return -code error -errorcode $::errorCode
}

set ret [catch {eval exec ./cosim.tv.exe | tee temp0.log >&@ stdout} err]

if {$ret == 1} {
	::AP::printMsg ERR COSIM 320 COSIM_320_1000
	return -code error -errorcode $::errorCode
}

if {[file isfile module0_prefilter.autotvin.dat]} {
	file delete -force module0_prefilter.autotvin.dat
}

if {[file isfile module0_prefilter.autotvout.dat]} {
	file delete -force module0_prefilter.autotvout.dat
}

sc_sim_check $ret $err "temp0.log"

cd ../tv/cdatafile
set ret [check_tvin_file]

if {$ret == 1} {
	::AP::printMsg ERR COSIM 344 COSIM_344_1005
	return -code error -errorcode $::errorCode
}

cd ../

# --> verilog simulation

::AP::printMsg INFO COSIM 323 COSIM_323_1007

::AP::printMsg INFO COSIM 15 COSIM_15_1011

cd ../verilog

file delete -force ".exit.err"
file delete -force ".aesl_error"
file delete -force "err.log"

catch {unset ::env(RDI_USE_JDK11)}
if {[file isfile run_xsim.sh]} {
	set ret [catch {eval exec "sh ./run_xsim.sh | tee temp2.log" >&@ stdout} err]
}
 set ::env(RDI_USE_JDK11) true
    df_record_move

cd ../tv/rtldatafile

set ret [check_tvout_file]

if {$ret == 1} {
	::AP::printMsg ERR COSIM 344 COSIM_344_1020
	return -code error -errorcode $::errorCode
}

cd ../../wrapc_pc

::AP::printMsg INFO COSIM 316 COSIM_316_1021

if {![file exists cosim.pc.exe]} {
    ::AP::printMsg ERR COSIM 320 COSIM_320_1022
    return -code error -errorcode $::errorCode
}

set ret [catch {eval exec ./cosim.pc.exe | tee temp0.log >&@ stdout} err]

sc_sim_check $ret $err "temp3.log"
