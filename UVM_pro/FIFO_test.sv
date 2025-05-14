package FIFO_test_pkg;

import FIFO_seq_item_pkg::*;
import FIFO_env_pkg::*;
import FIFO_seq_pkg::*;
import FIFO_config_pkg::*;


import uvm_pkg::*;
`include "uvm_macros.svh"

class FIFO_test extends uvm_test;
`uvm_component_utils(FIFO_test)

    FIFO_cfg fifo_cfg;
    virtual FIFO_if fifo_vif;
    FIFO_env env;
    FIFO_read_only_seq read_only_seq;
    FIFO_write_only_seq write_only_seq;
    FIFO_write_read_seq write_read_seq;
    FIFO_read_after_empty_seq read_after_empty_seq; 
    FIFO_write_after_ovf_seq  write_after_ovf_seq; 
    FIFO_rst_seq rst_seq;

    function new(string name = "FIFO_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        fifo_cfg   = FIFO_cfg::type_id::create("fifo_cfg");
        env        = FIFO_env::type_id::create("env", this);
        read_only_seq   = FIFO_read_only_seq::type_id::create("read_only_seq", this);
        write_only_seq   = FIFO_write_only_seq::type_id::create("write_only_seq", this);
        write_read_seq   = FIFO_write_read_seq::type_id::create("write_read_seq", this);
        read_after_empty_seq   = FIFO_read_after_empty_seq::type_id::create("read_after_empty_seq", this);
        write_after_ovf_seq   = FIFO_write_after_ovf_seq::type_id::create("write_after_ovf_seq", this);
        rst_seq    = FIFO_rst_seq::type_id::create("rst_seq", this);

        set_type_override_by_type(FIFO_seq_item::get_type(),FIFO_seq_item_disable_rst_n::get_type());

        if(!uvm_config_db #(virtual FIFO_if)::get(this, "","fifo_vif", fifo_cfg.fifo_vif))   
            `uvm_fatal("build phase","test -Unable to get v_if from config db")
        
        fifo_cfg.is_active = UVM_ACTIVE;
        uvm_config_db #(FIFO_cfg)::set(this, "*","CFG", fifo_cfg);

    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
        
        `uvm_info("run phase","Starting reset sequence",UVM_LOW)
        rst_seq.start(env.agt.sqr);
        `uvm_info("run phase","Finishing reset sequence",UVM_LOW)
        
        `uvm_info("run phase","Starting write only sequence",UVM_LOW)
        write_only_seq.start(env.agt.sqr);
        `uvm_info("run phase","Finishing write only sequence",UVM_LOW)

        `uvm_info("run phase","Starting read only sequence",UVM_LOW)
        read_only_seq.start(env.agt.sqr);
        `uvm_info("run phase","Finishing read only sequence",UVM_LOW)
        
        `uvm_info("run phase","Starting write read sequence",UVM_LOW)
        write_read_seq.start(env.agt.sqr);
        `uvm_info("run phase","Finishing write read sequence",UVM_LOW)

        `uvm_info("run phase","Starting write after overflow sequence",UVM_LOW)
        write_after_ovf_seq.start(env.agt.sqr);
        `uvm_info("run phase","Finishing write after overflow sequence",UVM_LOW)

        `uvm_info("run phase","Starting read after empty sequence",UVM_LOW)
        read_after_empty_seq.start(env.agt.sqr);
        `uvm_info("run phase","Finishing write after empty sequence",UVM_LOW)

        phase.drop_objection(this);

    endtask //fun_phase

    

endclass //FIFO_test extends superClass
    
endpackage