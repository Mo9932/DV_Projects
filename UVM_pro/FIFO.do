vlib work
vlog -f src_file.txt +cover

vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover

coverage save -onexit -cvg -codeAll -assert FIFO.ucdb

run 0ns

add wave -position insertpoint  \
sim:/top/fifo_if/almostempty \
sim:/top/fifo_if/almostfull \
sim:/top/fifo_if/clk \
sim:/top/fifo_if/data_in \
sim:/top/fifo_if/data_out \
sim:/top/fifo_if/empty \
sim:/top/fifo_if/full \
sim:/top/fifo_if/overflow \
sim:/top/fifo_if/rd_en \
sim:/top/fifo_if/rst_n \
sim:/top/fifo_if/underflow \
sim:/top/fifo_if/wr_ack \
sim:/top/fifo_if/wr_en

add wave /top/DUT/fifo_sva/rst_n_assert
add wave /top/DUT/fifo_sva/assert__wr_ack_assert /top/DUT/fifo_sva/assert__over_flow_assert /top/DUT/fifo_sva/assert__under_flow_assert
add wave /top/DUT/fifo_sva/assert__rd_notfull_assert /top/DUT/fifo_sva/assert__wr_notempty_assert
add wave /top/DUT/fifo_sva/assert__wr_ack_full_assert /top/DUT/fifo_sva/assert__almostempty_empty /top/DUT/fifo_sva/assert__almostfull_full



run -all
