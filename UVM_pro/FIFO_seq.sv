package FIFO_seq_pkg;
import FIFO_pkg::*;
import FIFO_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class FIFO_read_only_seq extends uvm_sequence #(FIFO_seq_item);
`uvm_object_utils(FIFO_read_only_seq)

    FIFO_seq_item seq_item;

    function new(string name = "FIFO_read_only_seq");
        super.new(name);
    endfunction //new()

    task body();

        repeat(8)begin
            seq_item = FIFO_seq_item::type_id::create("seq_item");
            seq_item.constraint_mode(0);
            start_item(seq_item);
            // assert (seq_item.randomize());
            seq_item.wr_en = 0 ;
            seq_item.rd_en = 1 ;
            seq_item.rst_n = 1 ;
            finish_item(seq_item); 
        end
    endtask //body
endclass //className extends superClass

class FIFO_write_only_seq extends uvm_sequence #(FIFO_seq_item);
`uvm_object_utils(FIFO_write_only_seq)

    FIFO_seq_item seq_item;

    function new(string name = "FIFO_write_only_seq");
        super.new(name);
    endfunction //new()
    task body();
        repeat(8)begin
            seq_item = FIFO_seq_item::type_id::create("seq_item");
            seq_item.constraint_mode(0);
            start_item(seq_item);
            assert (seq_item.randomize());
            seq_item.wr_en = 1 ;
            seq_item.rd_en = 0 ;
            seq_item.rst_n = 1 ;
            finish_item(seq_item); 
        end
    endtask //body
endclass //className extends superClass

class FIFO_write_after_ovf_seq extends uvm_sequence #(FIFO_seq_item);
`uvm_object_utils(FIFO_write_after_ovf_seq)

    FIFO_seq_item seq_item;

    function new(string name = "FIFO_write_after_ovf_seq");
        super.new(name);
    endfunction //new()
    task body();
        repeat(16)begin
            seq_item = FIFO_seq_item::type_id::create("seq_item");
            seq_item.constraint_mode(0);
            start_item(seq_item);
            assert (seq_item.randomize());
            seq_item.wr_en = 1 ;
            seq_item.rd_en = 0 ;
            seq_item.rst_n = 1 ;
            finish_item(seq_item); 
        end
    endtask //body
endclass //className extends superClass

class FIFO_read_after_empty_seq extends uvm_sequence #(FIFO_seq_item);
`uvm_object_utils(FIFO_read_after_empty_seq)

    FIFO_seq_item seq_item;

    function new(string name = "FIFO_read_after_empty_seq");
        super.new(name);
    endfunction //new()
    task body();
        repeat(16)begin
            seq_item = FIFO_seq_item::type_id::create("seq_item");
            seq_item.constraint_mode(0);
            start_item(seq_item);
            assert (seq_item.randomize());
            seq_item.wr_en = 0 ;
            seq_item.rd_en = 1 ;
            seq_item.rst_n = 1 ;
            finish_item(seq_item); 
        end
    endtask //body
endclass //className extends superClass

class FIFO_write_read_seq extends uvm_sequence #(FIFO_seq_item);
`uvm_object_utils(FIFO_write_read_seq)

    FIFO_seq_item seq_item;

    function new(string name = "FIFO_write_read_seq");
        super.new(name);
    endfunction //new()

    task body();
        repeat(10000)begin
            seq_item = FIFO_seq_item::type_id::create("seq_item");
            seq_item.set_dist(); // default rd_en = 30% and wr_en = 70%
            start_item(seq_item);
            assert (seq_item.randomize());
            finish_item(seq_item); 
        end
    endtask //body
endclass //className extends superClass

class FIFO_rst_seq extends uvm_sequence #(FIFO_seq_item);
`uvm_object_utils(FIFO_rst_seq)

    FIFO_seq_item seq_item;

    function new(string name = "FIFO_rst_seq");
        super.new(name);
    endfunction //new()

    task body();
        seq_item = FIFO_seq_item::type_id::create("seq_item");

        start_item(seq_item);
        seq_item.rst_n = 0 ;
        finish_item(seq_item); 

        start_item(seq_item);
        seq_item.rst_n = 1 ;
        finish_item(seq_item); 

    endtask //body
endclass //className extends superClass
    
endpackage