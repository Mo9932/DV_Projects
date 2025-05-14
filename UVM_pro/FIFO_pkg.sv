package FIFO_pkg;
    
    int error_count  ;
    int corret_count ;

    bit test_finished ;

    event trigger ;

    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;

endpackage