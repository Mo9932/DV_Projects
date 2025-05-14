vlib work
vlog -f src_file.txt +define+SIM +cover 
vsim -voptargs=+acc work.top -cover 
coverage save -onexit -cvg -assert -codeAll fifo.ucdb

run 0 
add wave -position insertpoint sim:/top/DUT/*
add wave -position insertpoint sim:/top/MONITOR/fifo_sb
add wave -position insertpoint sim:/top/fifo_if/*
add wave /top/assert_rat_n /top/DUT/assert__wr_ack_assert /top/DUT/assert__over_flow_assert /top/DUT/assert__under_flow_assert /top/DUT/assert__empty_assert /top/DUT/assert__full_assert /top/DUT/assert__almostfull_assert /top/DUT/assert__almostempty_assert /top/DUT/assert__wr_ptr_wrap_assert /top/DUT/assert__rd_ptr_wrap_assert
add wave -position insertpoint  \
sim:/shared_pkg::error_count
run -all