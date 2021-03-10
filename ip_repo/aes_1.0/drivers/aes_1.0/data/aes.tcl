#uses "xillib.tcl"

proc generate {drv_handle} {
    ::hsi::utils::define_include_file $drv_handle "xparameters.h" "XAES" "NUM_INSTANCES" "DEVICE_ID" "C_S_AXI_BASEADDR" "C_S_AXI_HIGHADDR"
    ::hsi::utils::define_config_file $drv_handle "xaes_g.c" "XAES" "DEVICE_ID" "C_S_AXI_BASEADDR"
    ::hsi::utils::define_canonical_xpars $drv_handle "xparameters.h" "XAES" "NUM_INSTANCES" "DEVICE_ID" "C_S_AXI_BASEADDR" "C_S_AXI_HIGHADDR"
}
