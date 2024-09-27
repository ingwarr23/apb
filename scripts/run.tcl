exec xvlog -sv -f ../scripts/compile_list.f -L uvm ; 
exec xelab tb_top -relax -s top -timescale 1ns/1ps -debug all ;  
exec xsim top -testplusarg UVM_TESTNAME=normal_test -testplusarg UVM_VERBOSITY=UVM_LOW -gui -t ../scripts/batch_exec.tcl
