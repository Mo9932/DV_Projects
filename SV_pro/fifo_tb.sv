import shared_pkg::*;
import FIFO_transaction_pkg::*;

module fifo_tb (FIFO_if.TEST fifo_if);
    
    FIFO_transaction fifo_txn = new;

    initial begin
        fifo_if.rst_n   = 0;
        fifo_if.data_in = 0;
        fifo_if.wr_en   = 0;
        fifo_if.rd_en   = 0;

            fifo_if.rst_n = 1;
        @(negedge fifo_if.clk)
            fifo_if.rst_n = 0;
        @(negedge fifo_if.clk)
            fifo_if.rst_n = 1;

        repeat(10000)begin
            @(negedge fifo_if.clk);
            assert(fifo_txn.randomize());
            fifo_if.rst_n   = fifo_txn.rst_n   ;
            fifo_if.data_in = fifo_txn.data_in ;
            fifo_if.wr_en   = fifo_txn.wr_en   ;
            fifo_if.rd_en   = fifo_txn.rd_en   ;
            @(negedge fifo_if.clk);
            -> trigger;
        end
        test_finished = 1;
        -> trigger;
    end

endmodule