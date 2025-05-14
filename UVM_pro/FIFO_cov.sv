package FIFO_cov_pkg;

import FIFO_seq_item_pkg::*;
import FIFO_pkg::*;
    
import uvm_pkg::*;
`include "uvm_macros.svh"



class FIFO_cov extends uvm_component;
`uvm_component_utils(FIFO_cov)

uvm_analysis_export #(FIFO_seq_item) cov_export;
uvm_tlm_analysis_fifo #(FIFO_seq_item) cov_fifo;

FIFO_seq_item cov_seq_item;

    
        covergroup cvr_gp;
            wr_en_c : coverpoint cov_seq_item.wr_en;
            rd_en_c : coverpoint cov_seq_item.rd_en;
            wr_ack_c: coverpoint cov_seq_item.wr_ack;
            ovf_c   : coverpoint cov_seq_item.overflow;
            unf_c   : coverpoint cov_seq_item.underflow;
            full_c  : coverpoint cov_seq_item.full;
            empty_c : coverpoint cov_seq_item.empty;
            cross_1: cross wr_en_c, rd_en_c, wr_ack_c iff(cov_seq_item.rst_n){
                illegal_bins wr_rd_ack =    binsof(wr_en_c ) intersect {0} && 
                                            binsof(rd_en_c ) intersect {1} && 
                                            binsof(wr_ack_c) intersect {1}   ;
                illegal_bins nwr_nrd_ack =  binsof(wr_en_c ) intersect {0} &&
                                            binsof(rd_en_c ) intersect {0} && 
                                            binsof(wr_ack_c) intersect {1};
            }
            cross_2: cross wr_en_c, rd_en_c, ovf_c iff(cov_seq_item.rst_n){
                illegal_bins wr_rd_ovf =    binsof(wr_en_c) intersect {0} && 
                                            binsof(rd_en_c) intersect {1} && 
                                            binsof(ovf_c)intersect {1}   ;
                illegal_bins nwr_nrd_ovf =  binsof(wr_en_c)  intersect {0} &&
                                            binsof(rd_en_c) intersect {0}  && 
                                            binsof(ovf_c) intersect {1};
            }
            cross_3: cross wr_en_c, rd_en_c, unf_c  iff(cov_seq_item.rst_n){
                illegal_bins wr_rd_unf =    binsof(wr_en_c) intersect {1} && 
                                            binsof(rd_en_c) intersect {0} && 
                                            binsof(unf_c)intersect {1}   ;
                illegal_bins nwr_nrd_unf =  binsof(wr_en_c)  intersect {0} &&
                                            binsof(rd_en_c) intersect {0}  && 
                                            binsof(unf_c) intersect {1};
            }
            cross_4: cross wr_en_c, rd_en_c, full_c  iff(cov_seq_item.rst_n){
                illegal_bins nwr_nrd_full =  binsof(wr_en_c)  intersect {0} &&
                                            binsof(rd_en_c) intersect {1}  && 
                                            binsof(full_c) intersect {1};        

                illegal_bins wr_nrd_full =  binsof(wr_en_c)  intersect {1} &&
                                            binsof(rd_en_c) intersect {1}  && 
                                            binsof(full_c) intersect {1};           
            }
            cross_5: cross wr_en_c, rd_en_c, empty_c       iff(cov_seq_item.rst_n){
                illegal_bins nwr_nrd_empty =  binsof(wr_en_c)  intersect {1} &&
                                            binsof(rd_en_c) intersect {0}  && 
                                            binsof(empty_c) intersect {1};    
                illegal_bins wr_nrd_empty =  binsof(wr_en_c)  intersect {1} &&
                                            binsof(rd_en_c) intersect {1}  && 
                                            binsof(empty_c) intersect {1};    
            }
            cross_6: cross wr_en_c, rd_en_c, cov_seq_item.almostfull  iff(cov_seq_item.rst_n);
            cross_7: cross wr_en_c, rd_en_c, cov_seq_item.almostempty iff(cov_seq_item.rst_n) ;
        endgroup

    function new(string name = "FIFO_cov", uvm_component parent = null);
        super.new(name, parent);   
        cvr_gp = new();     
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        cov_export = new("cov_export",this);
        cov_fifo   = new("cov_fifo",this);
        
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        cov_export.connect(cov_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin

            cov_fifo.get(cov_seq_item);
            cvr_gp.sample();

        end
    endtask //

endclass //className extends superClass
endpackage