package FIFO_agt_pkg;

import FIFO_seq_item_pkg::*;
import FIFO_sqr_pkg::*;
import FIFO_config_pkg::*;
import FIFO_driver_pkg::*;
import FIFO_seq_item_pkg::*;
import FIFO_mon_pkg::*;

import uvm_pkg::*;
`include "uvm_macros.svh"

class FIFO_agt extends uvm_agent;
`uvm_component_utils(FIFO_agt)

    uvm_analysis_port #(FIFO_seq_item) agt_ap;

    virtual FIFO_if fifo_vif;
    FIFO_cfg fifo_cfg;

    FIFO_sqr sqr;
    FIFO_driver driver;
    FIFO_mon mon;

    function new(string name = "FIFO_agt", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        fifo_cfg = FIFO_cfg::type_id::create("fifo_cfg"); 
        
        if(!uvm_config_db #(FIFO_cfg)::get(this, "","CFG", fifo_cfg))   
            `uvm_fatal("build phase","AGENT -Unable to get configration object from config db")
        mon     = FIFO_mon::type_id::create("mon",this);
        agt_ap = new("agt_ap", this);

        if(fifo_cfg.is_active == UVM_ACTIVE)begin
            sqr     = FIFO_sqr::type_id::create("sqr", this);
            driver  = FIFO_driver::type_id::create("driver", this);
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        mon.fifo_vif    = fifo_cfg.fifo_vif;
        mon.mon_ap.connect(agt_ap);

        if(fifo_cfg.is_active == UVM_ACTIVE)begin
            driver.fifo_vif = fifo_cfg.fifo_vif;
            driver.seq_item_port.connect(sqr.seq_item_export);   
        end
    endfunction

endclass //className extends superClass

endpackage