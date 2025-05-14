package FIFO_env_pkg;

import FIFO_sqr_pkg::*;
import FIFO_agt_pkg::*;
import FIFO_sb_pkg::*;
import FIFO_cov_pkg::*;

import uvm_pkg::*;
`include "uvm_macros.svh"

class FIFO_env extends uvm_env;
`uvm_component_utils(FIFO_env)

    FIFO_agt agt;
    FIFO_sb sb;
    FIFO_cov cov;

    function new(string name= "FIFO_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agt = FIFO_agt::type_id::create("agt",this);
        sb = FIFO_sb::type_id::create("sb",this);
        cov = FIFO_cov::type_id::create("FIFO_cov",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agt.agt_ap.connect(sb.sb_export);
        agt.agt_ap.connect(cov.cov_export);
    endfunction


endclass //FIFO_env extends superClass

endpackage