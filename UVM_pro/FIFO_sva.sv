import FIFO_pkg::*;

module FIFO_sva (
    FIFO_if.DUT fifo_if
);

	
    always_comb begin 
        if(~fifo_if.rst_n) begin rst_n_assert: assert final ( fifo_if.data_out == 0 && DUT.count == 0 && DUT.wr_ptr == 0 && DUT.rd_ptr == 0 ) else $error("DUT.count = %0d, DUT.wr_ptr = %0d, DUT.rd_ptr = %0d, data_out = %0d", DUT.count, DUT.wr_ptr, DUT.rd_ptr, fifo_if.data_out );end
    end


	property wr_ack_assert;
		@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (fifo_if.wr_en && !fifo_if.full) |=> fifo_if.wr_ack ;
	endproperty

	property over_flow_assert;
		@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (fifo_if.wr_en && fifo_if.full) |=> fifo_if.overflow ;
	endproperty

	property under_flow_assert;
		@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (fifo_if.rd_en && fifo_if.empty) |=> fifo_if.underflow ;
	endproperty

	property empty_assert;
		@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (DUT.count==0) |-> fifo_if.empty ;
	endproperty

	property full_assert;
		@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (DUT.count==FIFO_DEPTH) |-> fifo_if.full ;
	endproperty
	
	property almostfull_assert;
		@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (DUT.count==FIFO_DEPTH-1) |-> fifo_if.almostfull ;
	endproperty
	
	property almostempty_assert;
		@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (DUT.count==1) |-> fifo_if.almostempty ;
	endproperty
	
	property wr_ptr_wrap_assert;
		@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (DUT.wr_ptr == FIFO_DEPTH-1 && fifo_if.wr_en && !fifo_if.full) |=> DUT.wr_ptr==0 ;
	endproperty

	property rd_ptr_wrap_assert;
		@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (DUT.rd_ptr == FIFO_DEPTH-1 && fifo_if.rd_en && !fifo_if.empty) |=> DUT.rd_ptr==0 ;
	endproperty

	/* addetional assertions */
	property rd_notfull_assert;
		@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (fifo_if.rd_en && fifo_if.full) |=> !fifo_if.full ;
	endproperty

	property wr_notempty_assert;
		@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (fifo_if.empty && fifo_if.wr_en) |=> !fifo_if.empty ;
	endproperty

	property wr_ack_full_assert;
		@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (fifo_if.full) |=> !fifo_if.wr_ack ;
	endproperty

	property almostempty_empty;
		@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (fifo_if.rd_en && !fifo_if.wr_en && fifo_if.almostempty) |=> fifo_if.empty ;
	endproperty

	property almostfull_full;
		@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (!fifo_if.rd_en && fifo_if.wr_en && fifo_if.almostfull) |=> fifo_if.full ;
	endproperty

	
	assert property (wr_ack_assert		);
	assert property (over_flow_assert	);
	assert property (under_flow_assert	);
	assert property (empty_assert		);
	assert property (full_assert		);
	assert property (almostfull_assert	);
	assert property (almostempty_assert	);
	assert property (wr_ptr_wrap_assert	);
	assert property (rd_ptr_wrap_assert	);

	assert property (rd_notfull_assert	);
	assert property (wr_notempty_assert	);
	assert property (wr_ack_full_assert	);
	assert property (almostempty_empty	);
	assert property (almostfull_full	);


	cover property (empty_assert		);
	cover property (full_assert			);
	cover property (almostfull_assert	);
	cover property (almostempty_assert	);
	cover property (wr_ptr_wrap_assert	);
	cover property (rd_ptr_wrap_assert	);
	cover property (wr_ack_assert		);
	cover property (over_flow_assert	);
	cover property (under_flow_assert	);

	cover property (rd_notfull_assert	);
	cover property (wr_notempty_assert	);
	cover property (wr_ack_full_assert	);
	cover property (almostempty_empty	);
	cover property (almostfull_full 	);
	
    
endmodule