#uses "xillib.tcl"

proc generate {drv_handle} {
    ::hsi::utils::define_include_file $drv_handle "xparameters.h" "XFIFO" "NUM_INSTANCES" "DEVICE_ID" "C_S_AXI_BASEADDR" "C_S_AXI_HIGHADDR" "depth_g" "width_g"
    ::hsi::utils::define_config_file $drv_handle "xfifo_g.c" "XFIFO" "DEVICE_ID" "C_S_AXI_BASEADDR" "depth_g" "width_g"
    ::hsi::utils::define_canonical_xpars $drv_handle "xparameters.h" "XFIFO" "NUM_INSTANCES" "DEVICE_ID" "C_S_AXI_BASEADDR" "C_S_AXI_HIGHADDR" "depth_g" "width_g"
}
