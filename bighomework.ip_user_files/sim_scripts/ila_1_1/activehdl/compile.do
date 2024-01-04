vlib work
vlib activehdl

vlib activehdl/xil_defaultlib
vlib activehdl/xpm

vmap xil_defaultlib activehdl/xil_defaultlib
vmap xpm activehdl/xpm

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../bighomework.srcs/sources_1/ip/ila_1_1/hdl/verilog" "+incdir+../../../../bighomework.srcs/sources_1/ip/ila_1_1/hdl/verilog" \
"D:/Vivado/2018.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/Vivado/2018.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"D:/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../bighomework.srcs/sources_1/ip/ila_1_1/hdl/verilog" "+incdir+../../../../bighomework.srcs/sources_1/ip/ila_1_1/hdl/verilog" \
"../../../../bighomework.srcs/sources_1/ip/ila_1_1/sim/ila_1.v" \

vlog -work xil_defaultlib \
"glbl.v"

