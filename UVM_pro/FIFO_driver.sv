package FIFO_driver_pkg;

import FIFO_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class FIFO_driver extends uvm_driver #(FIFO_seq_item);
`uvm_component_utils(FIFO_driver)

    virtual FIFO_if fifo_vif;

    FIFO_seq_item seq_item;

    function new(string name = "FIFO_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            seq_item = FIFO_seq_item::type_id::create("seq_item");
            seq_item_port.get_next_item(seq_item);

            fifo_vif.rst_n      = seq_item.rst_n    ;
            fifo_vif.wr_en      = seq_item.wr_en    ;
            fifo_vif.rd_en      = seq_item.rd_en    ;
            fifo_vif.data_in    = seq_item.data_in  ;


            @(negedge fifo_vif.clk);

            seq_item_port.item_done();
            `uvm_info("run phase", seq_item.convert2string_stimulus(), UVM_HIGH)

        end
        
    endtask //run_phase
endclass //FIFO_driver extends uvm_driver #(FIFO_seq_item)
    
endpackage