# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  set length_coarse_g [ipgui::add_param $IPINST -name "length_coarse_g"]
  set_property tooltip {Length of coarse delay line} ${length_coarse_g}
  set length_fine_g [ipgui::add_param $IPINST -name "length_fine_g"]
  set_property tooltip {Length of fine delay line} ${length_fine_g}
  set depth_g [ipgui::add_param $IPINST -name "depth_g"]
  set_property tooltip {Depth of the sampling delay line} ${depth_g}
  set count_g [ipgui::add_param $IPINST -name "count_g"]
  set_property tooltip {Count of sensors} ${count_g}
  set width_g [ipgui::add_param $IPINST -name "width_g"]
  set_property tooltip {Output data width} ${width_g}
  set mode_g [ipgui::add_param $IPINST -name "mode_g" -widget comboBox]
  set_property tooltip {Output data mode} ${mode_g}
  ipgui::add_param $IPINST -name "C_S_AXI_DATA_WIDTH"
  ipgui::add_param $IPINST -name "C_S_AXI_ADDR_WIDTH"

}

proc update_PARAM_VALUE.C_S_AXI_ADDR_WIDTH { PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to update C_S_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_ADDR_WIDTH { PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_S_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXI_DATA_WIDTH { PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to update C_S_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_DATA_WIDTH { PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to validate C_S_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.count_g { PARAM_VALUE.count_g } {
	# Procedure called to update count_g when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.count_g { PARAM_VALUE.count_g } {
	# Procedure called to validate count_g
	return true
}

proc update_PARAM_VALUE.depth_g { PARAM_VALUE.depth_g } {
	# Procedure called to update depth_g when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.depth_g { PARAM_VALUE.depth_g } {
	# Procedure called to validate depth_g
	return true
}

proc update_PARAM_VALUE.length_coarse_g { PARAM_VALUE.length_coarse_g } {
	# Procedure called to update length_coarse_g when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.length_coarse_g { PARAM_VALUE.length_coarse_g } {
	# Procedure called to validate length_coarse_g
	return true
}

proc update_PARAM_VALUE.length_fine_g { PARAM_VALUE.length_fine_g } {
	# Procedure called to update length_fine_g when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.length_fine_g { PARAM_VALUE.length_fine_g } {
	# Procedure called to validate length_fine_g
	return true
}

proc update_PARAM_VALUE.mode_g { PARAM_VALUE.mode_g } {
	# Procedure called to update mode_g when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.mode_g { PARAM_VALUE.mode_g } {
	# Procedure called to validate mode_g
	return true
}

proc update_PARAM_VALUE.width_g { PARAM_VALUE.width_g } {
	# Procedure called to update width_g when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.width_g { PARAM_VALUE.width_g } {
	# Procedure called to validate width_g
	return true
}

proc update_PARAM_VALUE.C_S_AXI_BASEADDR { PARAM_VALUE.C_S_AXI_BASEADDR } {
	# Procedure called to update C_S_AXI_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_BASEADDR { PARAM_VALUE.C_S_AXI_BASEADDR } {
	# Procedure called to validate C_S_AXI_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_S_AXI_HIGHADDR { PARAM_VALUE.C_S_AXI_HIGHADDR } {
	# Procedure called to update C_S_AXI_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_HIGHADDR { PARAM_VALUE.C_S_AXI_HIGHADDR } {
	# Procedure called to validate C_S_AXI_HIGHADDR
	return true
}


proc update_MODELPARAM_VALUE.length_coarse_g { MODELPARAM_VALUE.length_coarse_g PARAM_VALUE.length_coarse_g } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.length_coarse_g}] ${MODELPARAM_VALUE.length_coarse_g}
}

proc update_MODELPARAM_VALUE.length_fine_g { MODELPARAM_VALUE.length_fine_g PARAM_VALUE.length_fine_g } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.length_fine_g}] ${MODELPARAM_VALUE.length_fine_g}
}

proc update_MODELPARAM_VALUE.depth_g { MODELPARAM_VALUE.depth_g PARAM_VALUE.depth_g } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.depth_g}] ${MODELPARAM_VALUE.depth_g}
}

proc update_MODELPARAM_VALUE.count_g { MODELPARAM_VALUE.count_g PARAM_VALUE.count_g } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.count_g}] ${MODELPARAM_VALUE.count_g}
}

proc update_MODELPARAM_VALUE.width_g { MODELPARAM_VALUE.width_g PARAM_VALUE.width_g } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.width_g}] ${MODELPARAM_VALUE.width_g}
}

proc update_MODELPARAM_VALUE.mode_g { MODELPARAM_VALUE.mode_g PARAM_VALUE.mode_g } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.mode_g}] ${MODELPARAM_VALUE.mode_g}
}

proc update_MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH}
}

