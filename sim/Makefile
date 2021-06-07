
RESIDUE := work *.wlf transcript *.vcd

help :
	@echo "Commands: clean setup compile opt sim"

setup :
	vlib work

compile :
	vlog definesPkg.sv 
	vlog -cover bcsxef AHBSlave.sv 
	vlog -cover bcsxef AHBSlave_Top.sv 
	vlog AHB_pkg.sv 
	vlog AHB_interface.sv 
	vlog AHB_sequence_item.sv 
	vlog AHB_sequences.sv 
	vlog AHB_virtual_sequencer.sv 
	vlog AHB_virtual_sequence.sv 
	vlog AHB_packet.sv 
	vlog AHB_driver.sv 
	vlog AHB_monitor.sv 
	vlog AHB_coverage.sv 
	vlog AHB_agent.sv 
	vlog AHB_scoreboard.sv 
	vlog AHB_environment.sv 
	vlog AHB_test.sv 
	vlog AHB_TBtop.sv

sim:
	vsim -c +ASSERTTASK=2 -coverage work.AHB_TBtop -do 'run -all'

all : setup compile sim 

clean :
	rm -rf $(RESIDUE)
