package FIFO_coverage_pkg;
    
import shared_pkg::*;
import FIFO_transaction_pkg::*;

    class FIFO_coverage;

        FIFO_transaction  F_cvg_txn ;


        function void sample_data (FIFO_transaction F_txn) ;
            F_cvg_txn = F_txn;
            cvr_gp.sample();
            
        endfunction

        covergroup cvr_gp;
            wr_en_c : coverpoint F_cvg_txn.wr_en;
            rd_en_c : coverpoint F_cvg_txn.rd_en;
            wr_ack_c: coverpoint F_cvg_txn.wr_ack;
            ovf_c   : coverpoint F_cvg_txn.overflow;
            unf_c   : coverpoint F_cvg_txn.underflow;
            full_c  : coverpoint F_cvg_txn.full;
            empty_c  : coverpoint F_cvg_txn.empty;
            cross_1: cross wr_en_c, rd_en_c, wr_ack_c iff(F_cvg_txn.rst_n){
                illegal_bins wr_rd_ack =    binsof(wr_en_c ) intersect {0} && 
                                            binsof(rd_en_c ) intersect {1} && 
                                            binsof(wr_ack_c) intersect {1}   ;
                illegal_bins nwr_nrd_ack =  binsof(wr_en_c ) intersect {0} &&
                                            binsof(rd_en_c ) intersect {0} && 
                                            binsof(wr_ack_c) intersect {1};
            }
            cross_2: cross wr_en_c, rd_en_c, ovf_c iff(F_cvg_txn.rst_n){
                illegal_bins wr_rd_ovf =    binsof(wr_en_c) intersect {0} && 
                                            binsof(rd_en_c) intersect {1} && 
                                            binsof(ovf_c)intersect {1}   ;
                illegal_bins nwr_nrd_ovf =  binsof(wr_en_c)  intersect {0} &&
                                            binsof(rd_en_c) intersect {0}  && 
                                            binsof(ovf_c) intersect {1};
            }
            cross_3: cross wr_en_c, rd_en_c, unf_c  iff(F_cvg_txn.rst_n){
                illegal_bins wr_rd_unf =    binsof(wr_en_c) intersect {1} && 
                                            binsof(rd_en_c) intersect {0} && 
                                            binsof(unf_c)intersect {1}   ;
                illegal_bins nwr_nrd_unf =  binsof(wr_en_c)  intersect {0} &&
                                            binsof(rd_en_c) intersect {0}  && 
                                            binsof(unf_c) intersect {1};
            }
            cross_4: cross wr_en_c, rd_en_c, full_c  iff(F_cvg_txn.rst_n){
                illegal_bins nwr_nrd_unf =  binsof(wr_en_c)  intersect {0} &&
                                            binsof(rd_en_c) intersect {1}  && 
                                            binsof(full_c) intersect {1};           
            }
            cross_5: cross wr_en_c, rd_en_c, empty_c       iff(F_cvg_txn.rst_n){
                illegal_bins nwr_nrd_unf =  binsof(wr_en_c)  intersect {1} &&
                                            binsof(rd_en_c) intersect {0}  && 
                                            binsof(empty_c) intersect {1};    
            }
            cross_6: cross wr_en_c, rd_en_c, F_cvg_txn.almostfull  iff(F_cvg_txn.rst_n);
            cross_7: cross wr_en_c, rd_en_c, F_cvg_txn.almostempty iff(F_cvg_txn.rst_n) ;
        endgroup

        function new();
             F_cvg_txn = new();
             cvr_gp    = new();
        endfunction //new()

    endclass //FIFO_coverage 

endpackage