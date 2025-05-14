package FIFO_transaction_pkg;

import shared_pkg::*;

    class FIFO_transaction;

        int RD_EN_ON_DIST, WR_EN_ON_DIST;

        rand bit [FIFO_WIDTH-1:0] data_in;
        rand bit rst_n, wr_en, rd_en;

        logic [FIFO_WIDTH-1:0] data_out;
        logic wr_ack, overflow;
        logic full, empty, almostfull, almostempty, underflow;

        function new(int RD_EN_DIST = 30, int  WR_EN_DIST = 70);
            RD_EN_ON_DIST = RD_EN_DIST;
            WR_EN_ON_DIST = WR_EN_DIST;
        endfunction //new()

        constraint src_c{
            rst_n dist { 1:/199, 0:/1};
            wr_en dist { 1:/WR_EN_ON_DIST, 0:/(100 - WR_EN_ON_DIST)};
            rd_en dist { 1:/RD_EN_ON_DIST, 0:/(100 - RD_EN_ON_DIST)};
        }


    endclass //FIFO_transaction


endpackage