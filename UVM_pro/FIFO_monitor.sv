package FIFO_mon_pkg;

import FIFO_pkg::*;
import FIFO_seq_item_pkg::*;

import uvm_pkg::*;
`include "uvm_macros.svh"

class FIFO_mon extends uvm_monitor;
`uvm_component_utils(FIFO_mon)

    uvm_analysis_port #(FIFO_seq_item) mon_ap;

    FIFO_seq_item res_seq_item;

    virtual FIFO_if fifo_vif;

    function new(string name = "FIFO_mon", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon_ap = new("mon_ap", this);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        forever begin
            res_seq_item = FIFO_seq_item::type_id::create("res_seq_item");

            @(negedge fifo_vif.clk);

            res_seq_item.rst_n       = fifo_vif.rst_n      ;
            res_seq_item.wr_en       = fifo_vif.wr_en      ;
            res_seq_item.rd_en       = fifo_vif.rd_en      ;
            res_seq_item.data_in     = fifo_vif.data_in    ;
            res_seq_item.data_out    = fifo_vif.data_out   ;
            res_seq_item.wr_ack      = fifo_vif.wr_ack     ;
            res_seq_item.overflow    = fifo_vif.overflow   ;
            res_seq_item.full        = fifo_vif.full       ;
            res_seq_item.empty       = fifo_vif.empty      ;
            res_seq_item.almostfull  = fifo_vif.almostfull ;
            res_seq_item.almostempty = fifo_vif.almostempty;
            res_seq_item.underflow   = fifo_vif.underflow  ;

            
            mon_ap.write(res_seq_item);
            `uvm_info("run_phase",res_seq_item.convert2string_stimulus(),UVM_HIGH)
        end
    endtask //run_phase

endclass // FIFO_mon extends superClass

    
endpackage