module top ();
    bit clk ;

    initial begin
        forever
            #5 clk = ~clk;
    end

    FIFO_if fifo_if(clk);
    FIFO DUT(fifo_if);
    fifo_tb TEST(fifo_if);
    monitor MONITOR(fifo_if);

    always_comb begin 
        if(!fifo_if.rst_n)
            assert_rat_n: assert final (    fifo_if.data_out == 0 &&
                                            DUT.count == 0 &&
                                            DUT.wr_ptr == 0 &&
                                            DUT.rd_ptr == 0 );
    end
endmodule