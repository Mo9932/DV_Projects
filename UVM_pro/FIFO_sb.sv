package FIFO_sb_pkg;

import FIFO_seq_item_pkg::*;
import FIFO_config_pkg::*;
import FIFO_pkg::*;

import uvm_pkg::*;
`include "uvm_macros.svh"

class FIFO_sb extends uvm_scoreboard;
`uvm_component_utils(FIFO_sb)

    uvm_analysis_export #(FIFO_seq_item) sb_export;
    uvm_tlm_analysis_fifo #(FIFO_seq_item) sb_fifo;

    FIFO_cfg fifo_cfg ;

    FIFO_seq_item sb_seq_item;
    
    bit [FIFO_WIDTH-1:0] data_out_ref;
    bit wr_ack_ref, overflow_ref;
    bit full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;

    bit [FIFO_WIDTH-1:0] mem_ref [FIFO_DEPTH-1:0];
    int counter =0 ;
    localparam max_fifo_addr = $clog2(FIFO_DEPTH);
    bit [max_fifo_addr-1:0] w_ptr, r_ptr;



    function new(string name = "FIFO_sb", uvm_component parent = null);
        super.new(name, parent);        
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sb_export = new("sb_export",this);
        sb_fifo   = new("sb_fifo",this);
        fifo_cfg  = FIFO_cfg::type_id::create("fifo_cfg");
        if(! uvm_config_db #(FIFO_cfg)::get(this, "", "CFG",fifo_cfg))
            `uvm_fatal("build phse","sb -Unable to get configration from config db")
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        sb_export.connect(sb_fifo.analysis_export);
        
    endfunction


    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            sb_fifo.get(sb_seq_item);
            /*check res*/
            check_data(sb_seq_item);
            
        end
    endtask //

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);

        `uvm_info("report phase",$sformatf("Total succsessful transactions: %0d",corret_count),UVM_LOW)
        `uvm_info("report phase",$sformatf("Total failed transactions: %0d",error_count),UVM_LOW)
        
    endfunction




    function void   check_data(FIFO_seq_item sb_seq_item);
        refrence_model(sb_seq_item);
        if( data_out_ref == sb_seq_item.data_out && wr_ack_ref == sb_seq_item.wr_ack  && 
            overflow_ref == sb_seq_item.overflow && full_ref == sb_seq_item.full      &&
            empty_ref    == sb_seq_item.empty    && almostfull_ref == sb_seq_item.almostfull &&
            almostempty_ref == sb_seq_item.almostempty && underflow_ref == sb_seq_item.underflow)
            corret_count++ ;
        else begin
            error_count++ ;
            $display("error @time:%0t data_ref      = %0h and data      = %0h",$time, data_out_ref   , sb_seq_item.data_out);
            $display("error @time:%0t overflow_ref  = %0h and overflow  = %0h",$time, overflow_ref   , sb_seq_item.overflow);
            $display("error @time:%0t empty_ref     = %0h and empty     = %0h",$time, empty_ref      , sb_seq_item.empty);
            $display("error @time:%0t almostempt_ref= %0h and almostempt= %0h",$time, almostempty_ref, sb_seq_item.almostempty);
            $display("error @time:%0t wr_ack_ref    = %0h and wr_ack    = %0h",$time, wr_ack_ref     , sb_seq_item.wr_ack);
            $display("error @time:%0t almostfull_ref= %0h and almostfull= %0h",$time, almostfull_ref , sb_seq_item.almostfull);
            $display("error @time:%0t full_ref      = %0h and full      = %0h",$time, full_ref , sb_seq_item.full);
            $display("error @time:%0t underflow_ref = %0h and underflow = %0h",$time, underflow_ref  , sb_seq_item.underflow);
            $display("%0p\n",mem_ref);
        end
    endfunction //

    function void refrence_model(FIFO_seq_item sb_seq_item);
        if(~sb_seq_item.rst_n) begin
            data_out_ref    = 0 ;
            wr_ack_ref      = 0 ;
            overflow_ref    = 0 ;
            full_ref        = 0 ;
            empty_ref       = 1 ;
            almostfull_ref  = 0 ;
            almostempty_ref = 0 ;
            underflow_ref   = 0 ;
            counter         = 0 ;
            w_ptr           = 0 ;
            r_ptr           = 0 ;
        end
        else begin
            if(sb_seq_item.rd_en && !empty_ref)begin
                data_out_ref = mem_ref[r_ptr];
                r_ptr++;
                underflow_ref = 0;
                if(!sb_seq_item.wr_en)
                    counter--;
                else if(sb_seq_item.wr_en && full_ref)
                    counter--;
            end
            else if(sb_seq_item.rd_en && empty_ref)
                underflow_ref = 1;
            else 
                underflow_ref = 0;

            if(sb_seq_item.wr_en && !full_ref)begin
                mem_ref[w_ptr] = sb_seq_item.data_in;
                w_ptr++     ;
                wr_ack_ref = 1;
                overflow_ref = 0;
                if(!sb_seq_item.rd_en)
                    counter++   ;
                else if(sb_seq_item.rd_en && empty_ref)
                    counter++;
            end
            else if(sb_seq_item.wr_en && full_ref)begin
                wr_ack_ref = 0;
                overflow_ref = 1;
            end
            else  begin
                overflow_ref = 0;
                wr_ack_ref = 0;
            end

            full_ref = (counter == FIFO_DEPTH)? 1 : 0 ;
            empty_ref = (counter == 0)? 1 : 0 ;
            almostfull_ref = (counter == FIFO_DEPTH-1)? 1 : 0 ;
            almostempty_ref = (counter == 1)? 1 : 0 ;
            
        end
    endfunction 


endclass //FIFO_sb extends superClass
    
endpackage