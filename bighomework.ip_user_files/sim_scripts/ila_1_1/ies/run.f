-makelib ies_lib/xil_defaultlib -sv \
  "D:/Vivado/2018.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "D:/Vivado/2018.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "D:/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../bighomework.srcs/sources_1/ip/ila_1_1/sim/ila_1.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

