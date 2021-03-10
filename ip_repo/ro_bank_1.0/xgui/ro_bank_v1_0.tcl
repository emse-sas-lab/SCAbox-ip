# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "C_S_AXI_BASEADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S_AXI_HIGHADDR" -parent ${Page_0}

  set count_g [ipgui::add_param $IPINST -name "count_g"]
  set_property tooltip {Count of sensors} ${count_g}
  set depth_g [ipgui::add_param $IPINST -name "depth_g"]
  set_property tooltip {Depth of RO JRC counter} ${depth_g}
  set width_g [ipgui::add_param $IPINST -name "width_g"]
  set_property tooltip {Output data width} ${width_g}
  set mode_g [ipgui::add_param $IPINST -name "mode_g" -widget comboBox]
  set_property tooltip {Output mode} ${mode_g}
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


proc update_MODELPARAM_VALUE.count_g { MODELPARAM_VALUE.count_g PARAM_VALUE.count_g } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.count_g}] ${MODELPARAM_VALUE.count_g}
}

proc update_MODELPARAM_VALUE.depth_g { MODELPARAM_VALUE.depth_g PARAM_VALUE.depth_g } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.depth_g}] ${MODELPARAM_VALUE.depth_g}
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

