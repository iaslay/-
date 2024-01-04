-makelib xcelium_lib/xil_defaultlib -sv \
  "D:/Vivado/2018.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "D:/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../bighomework.srcs/sources_1/ip/key_0/key.v" \
  "../../../../bighomework.srcs/sources_1/ip/key_0/sim/key_0.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

