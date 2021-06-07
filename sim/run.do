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
	vsim -coverage work.AHB_TBtop
	add wave -position end sim:/AHB_TBtop/intf/*
	add wave -position end sim:/AHB_TBtop/intf/driver_cb/*
	add wave -position 15 sim:/AHB_TBtop/intf/monitor_cb/*
	coverage report -output report.txt -srcfile=* -assert -directive -cvg -codeAll
	coverage report -output report_Details.txt -srcfile=* -detail -all -dump -annotate -option -assert -directive -cvg -codeAll