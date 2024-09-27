# add directories:
-i ../verif/env
-i ../verif/env/apb
-i ../verif/seqlib
-i ../verif/tests

# rtl files:
#../rtl/combinatorial_outputs_style/amba_apb.sv
../rtl/three_always_blocks_style/amba_apb.sv
#../rtl/one_always_block_style/amba_apb.sv


# verification packages:
../verif/globals_pkg.sv
../verif/env/apb/apb_pkg.sv
../verif/env/top_env_pkg.sv
../verif/seqlib/seqlib_pkg.sv
../verif/tests/test_list_pkg.sv

# interfaces:
../verif/env/apb/apb_interface.sv

# top TB file:
../verif/tb_top.sv