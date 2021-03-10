#uses "xillib.tcl"

proc generate {drv_handle} {
	xdefine_include_file $drv_handle "xparameters.h" "XPRESENT" "NUM_INSTANCES" "DEVICE_ID"  "C_S_AXI_BASEADDR" "C_S_AXI_HIGHADDR"
	xdefine_config_file $drv_handle "xpresent_g.c" "XPRESENT" "DEVICE_ID" "C_S_AXI_BASEADDR"
    xdefine_canonical_xpars $drv_handle "xparameters.h" "XPRESENT" "NUM_INSTANCES" "DEVICE_ID" "C_S_AXI_BASEADDR" "C_S_AXI_HIGHADDR"
}
