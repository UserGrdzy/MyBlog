transcript on
if ![file isdirectory verilog_libs] {
	file mkdir verilog_libs
}

vlib verilog_libs/altera_ver
vmap altera_ver ./verilog_libs/altera_ver
vlog -vlog01compat -work altera_ver {c:/altera/13.1/quartus/eda/sim_lib/altera_primitives.v}

vlib verilog_libs/lpm_ver
vmap lpm_ver ./verilog_libs/lpm_ver
vlog -vlog01compat -work lpm_ver {c:/altera/13.1/quartus/eda/sim_lib/220model.v}

vlib verilog_libs/sgate_ver
vmap sgate_ver ./verilog_libs/sgate_ver
vlog -vlog01compat -work sgate_ver {c:/altera/13.1/quartus/eda/sim_lib/sgate.v}

vlib verilog_libs/altera_mf_ver
vmap altera_mf_ver ./verilog_libs/altera_mf_ver
vlog -vlog01compat -work altera_mf_ver {c:/altera/13.1/quartus/eda/sim_lib/altera_mf.v}

vlib verilog_libs/altera_lnsim_ver
vmap altera_lnsim_ver ./verilog_libs/altera_lnsim_ver
vlog -sv -work altera_lnsim_ver {c:/altera/13.1/quartus/eda/sim_lib/altera_lnsim.sv}

vlib verilog_libs/cycloneive_ver
vmap cycloneive_ver ./verilog_libs/cycloneive_ver
vlog -vlog01compat -work cycloneive_ver {c:/altera/13.1/quartus/eda/sim_lib/cycloneive_atoms.v}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/ganre/Desktop/exp14/trl {C:/Users/ganre/Desktop/exp14/trl/wav_display.v}
vlog -vlog01compat -work work +incdir+C:/Users/ganre/Desktop/exp14/trl {C:/Users/ganre/Desktop/exp14/trl/timing_gen_xy.v}
vlog -vlog01compat -work work +incdir+C:/Users/ganre/Desktop/exp14/trl {C:/Users/ganre/Desktop/exp14/trl/grid_display.v}
vlog -vlog01compat -work work +incdir+C:/Users/ganre/Desktop/exp14/trl {C:/Users/ganre/Desktop/exp14/trl/vga_ctrl.v}
vlog -vlog01compat -work work +incdir+C:/Users/ganre/Desktop/exp14/trl {C:/Users/ganre/Desktop/exp14/trl/par_to_ser.v}
vlog -vlog01compat -work work +incdir+C:/Users/ganre/Desktop/exp14/trl {C:/Users/ganre/Desktop/exp14/trl/hdmi_ctrl.v}
vlog -vlog01compat -work work +incdir+C:/Users/ganre/Desktop/exp14/trl {C:/Users/ganre/Desktop/exp14/trl/encode.v}
vlog -vlog01compat -work work +incdir+C:/Users/ganre/Desktop/exp14/trl {C:/Users/ganre/Desktop/exp14/trl/top_dds.v}
vlog -vlog01compat -work work +incdir+C:/Users/ganre/Desktop/exp14/trl {C:/Users/ganre/Desktop/exp14/trl/f_word_set.v}
vlog -vlog01compat -work work +incdir+C:/Users/ganre/Desktop/exp14/trl {C:/Users/ganre/Desktop/exp14/trl/dds.v}
vlog -vlog01compat -work work +incdir+C:/Users/ganre/Desktop/exp14/trl {C:/Users/ganre/Desktop/exp14/trl/key_filter.v}
vlog -vlog01compat -work work +incdir+C:/Users/ganre/Desktop/exp14/trl {C:/Users/ganre/Desktop/exp14/trl/key_ctl.v}
vlog -vlog01compat -work work +incdir+C:/Users/ganre/Desktop/exp14/q_prj/ip_core/rom_wave {C:/Users/ganre/Desktop/exp14/q_prj/ip_core/rom_wave/rom_wave.v}
vlog -vlog01compat -work work +incdir+C:/Users/ganre/Desktop/exp14/q_prj/ip_core/clk_gen {C:/Users/ganre/Desktop/exp14/q_prj/ip_core/clk_gen/clk_gen.v}
vlog -vlog01compat -work work +incdir+C:/Users/ganre/Desktop/exp14/q_prj/ip_core/ddio_out {C:/Users/ganre/Desktop/exp14/q_prj/ip_core/ddio_out/ddio_out.v}
vlog -vlog01compat -work work +incdir+C:/Users/ganre/Desktop/exp14/q_prj/db {C:/Users/ganre/Desktop/exp14/q_prj/db/clk_gen_altpll.v}

vlog -vlog01compat -work work +incdir+C:/Users/ganre/Desktop/exp14/q_prj/simulation/modelsim {C:/Users/ganre/Desktop/exp14/q_prj/simulation/modelsim/top_dds.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  top_dds_vlg_tst

add wave *
view structure
view signals
run -all
