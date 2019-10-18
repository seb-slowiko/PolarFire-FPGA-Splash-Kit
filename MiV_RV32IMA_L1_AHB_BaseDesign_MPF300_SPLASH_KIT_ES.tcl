set project_folder_name MiV_RV32IMA_L1_AHB_BaseDesign
set project_dir "./$project_folder_name"
set Libero_project_name MiV_BaseDesign

append Libero_project_name "_MPF300_SPLASH_KIT_ES"
append project_dir "_MPF300_SPLASH_KIT_ES"
append project_folder_name "_MPF300_SPLASH_KIT_ES"

set design_flow_stage [string toupper [lindex $argv 0]]

proc create_new_project_label { }\
{
    puts "-------------------------------------------------------------------------"
    puts "-----------------------CREATING NEW PROJECT------------------------------"
	puts "-------MiV_RV32IMA_L1_AHB_BaseDesign_MPF300_SPLASH_KIT_ES----------------"
    puts "-------------------------------------------------------------------------"
}

proc project_exists { }\
{
    puts "Project already exists in folder. Please rename or remove and rerun script."
}


if {[file exists $project_dir] == 1} then { 
	project_exists
} else { 
	create_new_project_label
	new_project -location $project_dir -name $Libero_project_name -project_description {} -block_mode 0 -standalone_peripheral_initialization 0 -instantiate_in_smartdesign 1 -ondemand_build_dh 1 -hdl {VERILOG} -family {PolarFire} -die {MPF300T_ES} -package {FCG484} -speed {-1} -die_voltage {1.0} -part_range {IND} -adv_options {IO_DEFT_STD:LVCMOS 1.8V} -adv_options {RESTRICTPROBEPINS:1} -adv_options {RESTRICTSPIPINS:0} -adv_options {TEMPR:IND} -adv_options {UNUSED_MSS_IO_RESISTOR_PULL:None} -adv_options {VCCI_1.2_VOLTR:EXT} -adv_options {VCCI_1.5_VOLTR:EXT} -adv_options {VCCI_1.8_VOLTR:EXT} -adv_options {VCCI_2.5_VOLTR:EXT} -adv_options {VCCI_3.3_VOLTR:EXT} -adv_options {VOLTR:IND} 
	source ./MPF300_SPLASH_KIT_ES/import_component_and_constraints_mpf300_splash_kit_es.tcl
	save_project
}

if {"$design_flow_stage" == "SYNTHESIZE"} then {
    puts "-------------------------------------------------------------------------"
    puts "-----------------------------SYNTHESIS-----------------------------------"
    puts "-------------------------------------------------------------------------"

    run_tool -name {SYNTHESIZE}
    save_project
	
} elseif {"$design_flow_stage" == "PLACE_AND_ROUTE"} then {
    puts "-------------------------------------------------------------------------"
    puts "--------------------------PLACE AND ROUTE--------------------------------"
    puts "-------------------------------------------------------------------------"
	
	configure_tool -name {PLACEROUTE} -params {TDPR:true} -params {IOREG_COMBINING:true} -params {INCRPLACEANDROUTE:false} -params {REPAIR_MIN_DELAY:true}
	run_tool -name {PLACEROUTE}
	run_tool -name {VERIFYTIMING}
	save_project

	
} elseif {"$design_flow_stage" == "GENERATE_BITSTREAM"} then {
    puts "-------------------------------------------------------------------------"
    puts "--------------------GENERATING PROGRAMMING FILES-------------------------"
    puts "-------------------------------------------------------------------------"

	run_tool -name {VERIFYTIMING}
    run_tool -name {GENERATEPROGRAMMINGDATA}
    run_tool -name {GENERATEPROGRAMMINGFILE}
    save_project

} elseif {"$design_flow_stage" == "EXPORT_PROGRAMMING_FILE"} then {
    puts "-------------------------------------------------------------------------"
    puts "----------------------EXPORT PROGRAMMING FILES---------------------------"
    puts "-------------------------------------------------------------------------"

	run_tool -name {VERIFYTIMING}
    export_prog_job \
        -job_file_name {BaseDesign_MPF300_SPLASH_KIT_ES-ProgramFile} \
        -export_dir {./} \
        -bitstream_file_type {TRUSTED_FACILITY} \
        -bitstream_file_components {}
    save_project
} else {
    puts "No design flow stage selected."
}


puts "-------------------------------------------------------------------------"
puts "-----------------------------Project Built-------------------------------"
puts "-------------------------------------------------------------------------"
puts "-------------------------------------------------------------------------"
puts "These scripted designs can also be executed to stages in the design flow"
puts "In order to this this execute the script by passing an argument along with"
puts "the selected file."
puts "                                                                          "
puts "Next time you execute a script type in one of the following arguments to"
puts "build the design to that stage in the design flow:"
puts "                                                                          "
puts " 1. SYNTHESIZE "
puts " 2. PLACE_AND_ROUTE"
puts " 3. GENERATE_BITSTREAM"
puts " 4. EXPORT_BITSTREAM"
puts "                  "
puts "These arguments are not case sensitive, but require an underscore between words instead of space"
puts "Sample designs are provided with place and route seeds that will allow user"
puts "to build the design quickly without the need route the design manually"
puts "using the 'PLACE_AND_ROUTE' argument will build the design with the best seed"