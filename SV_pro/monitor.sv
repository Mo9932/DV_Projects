
import shared_pkg::*;
import FIFO_coverage_pkg::*;
import FIFO_transaction_pkg::*;
import FIFO_sb_pkg::*;

module monitor ( FIFO_if.MONITOR fifo_if );
    
    FIFO_coverage fifo_cvg = new;
    FIFO_sb fifo_sb = new;
    FIFO_transaction fifo_txn = new;

    initial begin
        forever begin

            @(trigger);
            if(test_finished)begin
                $display("test done... \n Number of correct tests: %0d \nNumber of failed tests: %0d", corret_count, error_count);
                $stop;
            end

            fifo_txn.rst_n      = fifo_if.rst_n     ;
            fifo_txn.wr_en      = fifo_if.wr_en     ;
            fifo_txn.rd_en      = fifo_if.rd_en     ;
            fifo_txn.data_in    = fifo_if.data_in   ;
            fifo_txn.data_out   = fifo_if.data_out  ;
            fifo_txn.wr_ack     = fifo_if.wr_ack    ;
            fifo_txn.overflow   = fifo_if.overflow  ;
            fifo_txn.full       = fifo_if.full      ;
            fifo_txn.empty      = fifo_if.empty     ;
            fifo_txn.almostfull = fifo_if.almostfull;
            fifo_txn.almostempty= fifo_if.almostempty;
            fifo_txn.underflow  = fifo_if.underflow ;

            fork
                fifo_cvg.sample_data(fifo_txn);
                fifo_sb.check_data(fifo_txn);
            join

        end
    end

endmodule