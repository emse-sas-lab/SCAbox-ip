#uses "xillib.tcl"

proc generate {drv_handle} {
    ::hsi::utils::define_include_file $drv_handle "xparameters.h" "XRO" "NUM_INSTANCES" "DEVICE_ID" "C_S_AXI_BASEADDR" "C_S_AXI_HIGHADDR" "depth_g" "count_g"
    ::hsi::utils::define_config_file $drv_handle "xro_g.c" "XRO" "DEVICE_ID" "C_S_AXI_BASEADDR" "depth_g" "count_g"
    ::hsi::utils::define_canonical_xpars $drv_handle "xparameters.h" "XRO" "NUM_INSTANCES" "DEVICE_ID" "C_S_AXI_BASEADDR" "C_S_AXI_HIGHADDR" "depth_g" "count_g"
}
