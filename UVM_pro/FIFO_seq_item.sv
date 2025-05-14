package FIFO_seq_item_pkg;

import FIFO_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class FIFO_seq_item extends uvm_sequence_item;
`uvm_object_utils(FIFO_seq_item)

    function new(string name = "FIFO_seq_item");
        super.new(name);
    endfunction //new()

    int RD_EN_ON_DIST, WR_EN_ON_DIST;

    function void set_dist(int rd_en_dist = 30, wr_en_dist = 70);
        RD_EN_ON_DIST = rd_en_dist;
        WR_EN_ON_DIST = wr_en_dist;
        
    endfunction

    rand bit [FIFO_WIDTH-1:0] data_in;
    rand bit rst_n, wr_en, rd_en;

    logic [FIFO_WIDTH-1:0] data_out;
    logic wr_ack, overflow;
    logic full, empty, almostfull, almostempty, underflow;

    constraint src_c{
        rst_n dist { 1:/199, 0:/1};
        wr_en dist { 1:/WR_EN_ON_DIST, 0:/(100 - WR_EN_ON_DIST)};
        rd_en dist { 1:/RD_EN_ON_DIST, 0:/(100 - RD_EN_ON_DIST)};
        }


    function string convert2string();
        
        return $sformatf("%s rst_n= 0b%0b, data_in = 0b%0b, wr_en = 0b%0b, rd_en = 0b%0b, data_out = 0b%0b, wr_ack = 0b%0b, overflow = 0b%0b,
                             full = 0b%0b, empty = 0b%0b, almostfull = 0b%0b, almostempty = 0b%0b, underflow = 0b%0b",super.convert2string(), rst_n, data_in, wr_en, rd_en, data_out,
                             wr_ack, overflow,full, empty, almostfull, almostempty, underflow);
        
    endfunction

    function string convert2string_stimulus();
        
        return $sformatf("rst_n= 0b%0b, data_in = 0b%0b, wr_en = 0b%0b, rd_en = 0b%0b, data_out = 0b%0b, wr_ack = 0b%0b, overflow = 0b%0b,
                             full = 0b%0b, empty = 0b%0b, almostfull = 0b%0b, almostempty = 0b%0b, underflow = 0b%0b", rst_n, data_in, wr_en, rd_en, data_out,
                             wr_ack, overflow,full, empty, almostfull, almostempty, underflow);
        
    endfunction


endclass //FIFO_seq_item extends uvm_sequence_item


class FIFO_seq_item_disable_rst_n extends FIFO_seq_item;

`uvm_object_utils(FIFO_seq_item_disable_rst_n)

    function new(string name = "FIFO_seq_item_disable_rst_n");
        super.new(name);
    endfunction //new()

    constraint rst{ rst_n == 0 ;}

endclass

endpackage