package FIFO_config_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

class FIFO_cfg extends uvm_object;
`uvm_object_utils(FIFO_cfg)

virtual FIFO_if fifo_vif;
uvm_active_passive_enum is_active;


    function new(string name = "FIFO_cfg");
        super.new(name);
    endfunction //new()
endclass //FIFO_cfg extends superClass
endpackage