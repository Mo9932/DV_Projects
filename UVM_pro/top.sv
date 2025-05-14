import FIFO_test_pkg::*;
import FIFO_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

module top;

    bit clk ;

    FIFO_if fifo_if(clk);
    FIFO DUT(fifo_if);
    bind FIFO FIFO_sva fifo_sva(fifo_if);

    initial begin
        clk = 1;
        forever begin
            #1 clk = ~clk;
        end
    end

    initial begin
        uvm_config_db #(virtual FIFO_if)::set(null,"*","fifo_vif",fifo_if);
        run_test("FIFO_test");
    end
    
endmodule