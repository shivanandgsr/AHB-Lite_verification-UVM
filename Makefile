
RESIDUE := work *.wlf transcript *.vcd

help :
	@echo "Commands: clean setup compile opt sim"

setup :
	vlib work

compile :
	vlog -reportprogress 300 -work work definesPkg.sv 
	vlog -reportprogress 300 -work work AHBSlave.sv 
	vlog -reportprogress 300 -work work AHBSlave_Top.sv 
	vlog -reportprogress 300 -work work AHB_pkg.sv 
	vlog -reportprogress 300 -work work AHB_interface.sv 
	vlog -reportprogress 300 -work work AHB_sequence_item.sv 
	vlog -reportprogress 300 -work work AHB_sequences.sv 
	vlog -reportprogress 300 -work work AHB_virtual_sequencer.sv 
	vlog -reportprogress 300 -work work AHB_virtual_sequence.sv 
	vlog -reportprogress 300 -work work AHB_packet.sv 
	vlog -reportprogress 300 -work work AHB_driver.sv 
	vlog -reportprogress 300 -work work AHB_monitor.sv 
	vlog -reportprogress 300 -work work AHB_coverage.sv 
	vlog -reportprogress 300 -work work AHB_agent.sv 
	vlog -reportprogress 300 -work work AHB_scoreboard.sv 
	vlog -reportprogress 300 -work work AHB_environment.sv 
	vlog -reportprogress 300 -work work AHB_test.sv 
	vlog -reportprogress 300 -work work AHB_TBtop.sv

opt :
	vopt +cover=bcesxf top -o top_opt

sim:
	vsim -c +ASSERTTASK=2 -coverage top_opt -do 'run -all'

coverage_report:
	vsim -c -do 'run.do'


all : setup compile opt sim

clean :
	rm -rf $(RESIDUE)
