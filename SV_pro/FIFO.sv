////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
import shared_pkg::*;
module FIFO(FIFO_if.DUT fifo_if);

 
localparam max_fifo_addr = $clog2(FIFO_DEPTH);

reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
	if (!fifo_if.rst_n) begin
		wr_ptr <= 0;
		fifo_if.wr_ack <= 0;
		fifo_if.overflow <= 0;
	end
	else if (fifo_if.wr_en && count < FIFO_DEPTH) begin
		mem[wr_ptr] <= fifo_if.data_in;
		fifo_if.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
		fifo_if.overflow <= 0;
	end
	else if(fifo_if.full & fifo_if.wr_en) begin 
		fifo_if.wr_ack <= 0; 
		fifo_if.overflow <= 1;
	end 
	else begin
		fifo_if.overflow <= 0;
		fifo_if.wr_ack <= 0;
	end
end

always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
	if (!fifo_if.rst_n) begin
		rd_ptr <= 0;
		fifo_if.data_out <= 0 ;
		fifo_if.underflow <= 0;
	end
	else if (fifo_if.rd_en && count != 0) begin
		fifo_if.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		fifo_if.underflow <= 0;
	end
	else if (fifo_if.rd_en && fifo_if.empty) begin
		fifo_if.underflow <= 1;
	end
	else begin
		fifo_if.underflow <= 0;
	end
end

always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
	if (!fifo_if.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({fifo_if.wr_en, fifo_if.rd_en} == 2'b10) && !fifo_if.full) 
			count <= count + 1;
		else if ( ({fifo_if.wr_en, fifo_if.rd_en} == 2'b01) && !fifo_if.empty)
			count <= count - 1;
		else if ( ({fifo_if.wr_en, fifo_if.rd_en} == 2'b11) && fifo_if.full)
			count <= count - 1;
		else if ( ({fifo_if.wr_en, fifo_if.rd_en} == 2'b11) && fifo_if.empty)
			count <= count + 1;
	end
end

assign fifo_if.full = (count == FIFO_DEPTH)? 1 : 0;
assign fifo_if.empty = (count == 0)? 1 : 0;

assign fifo_if.almostfull = (count == FIFO_DEPTH-1)? 1 : 0; 
assign fifo_if.almostempty = (count == 1)? 1 : 0;


`ifdef SIM

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
		@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (count==0) |-> fifo_if.empty ;
	endproperty

	property full_assert;
		@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (count==FIFO_DEPTH) |-> fifo_if.full ;
	endproperty
	
	property almostfull_assert;
		@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (count==FIFO_DEPTH-1) |-> fifo_if.almostfull ;
	endproperty
	
	property almostempty_assert;
		@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (count==1) |-> fifo_if.almostempty ;
	endproperty
	
	property wr_ptr_wrap_assert;
		@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (wr_ptr == FIFO_DEPTH-1 && fifo_if.wr_en && !fifo_if.full) |=> wr_ptr==0 ;
	endproperty

	property rd_ptr_wrap_assert;
		@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (rd_ptr == FIFO_DEPTH-1 && fifo_if.rd_en && !fifo_if.empty) |=> rd_ptr==0 ;
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

`endif



endmodule