
package FIFO_sb_pkg;
    
import shared_pkg::*;
import FIFO_transaction_pkg::*;
class FIFO_sb;

    bit [FIFO_WIDTH-1:0] data_out_ref;
    bit wr_ack_ref, overflow_ref;
    bit full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;

    bit [FIFO_WIDTH-1:0] mem_ref [FIFO_DEPTH-1:0];
    int counter =0 ;
    localparam max_fifo_addr = $clog2(FIFO_DEPTH);
    bit [max_fifo_addr-1:0] w_ptr, r_ptr;



    function void   check_data(FIFO_transaction fifo_txn);
        refrence_model(fifo_txn);
        if( data_out_ref == fifo_txn.data_out && wr_ack_ref == fifo_txn.wr_ack  && 
            overflow_ref == fifo_txn.overflow && full_ref == fifo_txn.full      &&
            empty_ref    == fifo_txn.empty    && almostfull_ref == fifo_txn.almostfull &&
            almostempty_ref == fifo_txn.almostempty && underflow_ref == fifo_txn.underflow)
            corret_count++ ;
        else begin
            error_count++ ;
            $display("error @time:%0t data_ref      = %0h and data_out= %0h",$time, data_out_ref   , fifo_txn.data_out);
            $display("error @time:%0t overflow_ref  = %0h and data_out= %0h",$time, overflow_ref   , fifo_txn.overflow);
            $display("error @time:%0t empty_ref     = %0h and data_out= %0h",$time, empty_ref      , fifo_txn.empty);
            $display("error @time:%0t almostempt_ref= %0h and data_out= %0h",$time, almostempty_ref, fifo_txn.almostempty);
            $display("error @time:%0t wr_ack_ref    = %0h and data_out= %0h",$time, wr_ack_ref     , fifo_txn.wr_ack);
            $display("error @time:%0t almostfull_ref= %0h and data_out= %0h",$time, almostfull_ref , fifo_txn.almostfull);
            $display("error @time:%0t full_ref      = %0h and data_out= %0h",$time, full_ref , fifo_txn.full);
            $display("error @time:%0t underflow_ref = %0h and data_out= %0h",$time, underflow_ref  , fifo_txn.underflow);
            $display("%0p\n",mem_ref);
        end
    endfunction //

    function void refrence_model(FIFO_transaction fifo_txn);
        if(~fifo_txn.rst_n) begin
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
            if(fifo_txn.rd_en && !empty_ref)begin
                data_out_ref = mem_ref[r_ptr];
                r_ptr++;
                underflow_ref = 0;
                if(!fifo_txn.wr_en)
                    counter--;
                else if(fifo_txn.wr_en && full_ref)
                    counter--;
            end
            else if(fifo_txn.rd_en && empty_ref)
                underflow_ref = 1;
            else 
                underflow_ref = 0;

            if(fifo_txn.wr_en && !full_ref)begin
                mem_ref[w_ptr] = fifo_txn.data_in;
                w_ptr++     ;
                wr_ack_ref = 1;
                overflow_ref = 0;
                if(!fifo_txn.rd_en)
                    counter++   ;
                else if(fifo_txn.rd_en && empty_ref)
                    counter++;
            end
            else if(fifo_txn.wr_en && full_ref)begin
                wr_ack_ref = 0;
                overflow_ref = 1;
            end
            else  begin
                overflow_ref = 0;
                wr_ack_ref = 0;
            end


            
            full_ref = (counter == FIFO_DEPTH)? 1 : 0 ;
            empty_ref = (counter == 0)? 1 : 0 ;
            almostfull_ref = (counter == FIFO_DEPTH-2)? 1 : 0 ;
            almostempty_ref = (counter == 1)? 1 : 0 ;
        end
    endfunction //automatic
endclass //FIFO_sb

endpackage