//-----------------------------------------------------
// Design Name : syn_fifo
// File Name   : syn_fifo.v
// Function    : Synchronous (single clock) FIFO
//
//-----------------------------------------------------
module syn_fifo (
		 clk, // Clock input
		 rst, // Active low reset
		 wr_cs, // Write chip select
		 rd_cs, // Read chipe select
		 data_in  , // Data input
		 rd_en, // Read enable
		 wr_en, // Write Enable
		 data_out, // Data Output
		 empty, // FIFO empty
		 full // FIFO full
		 );    
   
   // FIFO constants
   parameter DATA_WIDTH =12;// = 16;
   parameter ADDR_WIDTH=3 ;//= 2;
   parameter RAM_DEPTH=8 ;//= 1;
   // Port Declarations
   input clk ;
   input rst ;
   input rd_cs ;
   input wr_cs;
   input rd_en ;
   input wr_en ;
   input [DATA_WIDTH-1:0] data_in ;
   output 		  full ;
   output 		  empty ;
   output [DATA_WIDTH-1:0] data_out ;

   //-----------Internal variables-------------------
   reg [ADDR_WIDTH-1:0]    wr_pointer;
   reg [ADDR_WIDTH-1:0]    rd_pointer;
   integer 		   items;
   reg [DATA_WIDTH-1:0]    data_out ;
   wire [DATA_WIDTH-1:0]   data_ram ;

   //-----------Variable assignments---------------
   assign full = (items == (RAM_DEPTH-1));
   assign empty = (items == 0);

   //-----------Code Start---------------------------
   always @ (posedge clk)
     begin : WRITE_POINTER
	if (!rst)
	  begin
	     wr_pointer <= 0;
	  end
	else if (wr_cs && wr_en )
	  begin
	     wr_pointer <= wr_pointer + 1;
	  end
     end

   always @ (posedge clk)
     begin : READ_POINTER
	if (!rst)
	  begin
	     rd_pointer <= 0;
	  end
	else if (rd_cs && rd_en )
	  begin
	     rd_pointer <= rd_pointer + 1;
	  end
     end

   always  @ (posedge clk)
     begin : READ_DATA
	if (!rst)
	  begin
	     data_out <= 0;
	  end
	else if (rd_cs && rd_en )
	  begin
	     data_out <= data_ram;
	  end
     end

   always @ (posedge clk)
     begin : ITEMS //keep track of the number of items
	if (!rst)
	  begin
	     items <= 0;
	     // Read but no write.
	  end
	else if ((rd_cs && rd_en) && !(wr_cs && wr_en) && (items != 0))
	  begin
	     items <= items - 1;
	     // Write but no read.
	  end
	else if ((wr_cs && wr_en) && !(rd_cs && rd_en) && (items != RAM_DEPTH))
	  begin
	     items <= items + 1;
	  end
     end 

   ram_dp_ar_aw #(
		  .DATA_WIDTH(DATA_WIDTH),
		  .ADDR_WIDTH(ADDR_WIDTH),
		  .RAM_DEPTH(RAM_DEPTH)
		  ) DP_RAM (
			    .address_0 (wr_pointer) , // address_0 input 
			    .data_0    (data_in)    , // data_0 bi-directional
			    .cs_0      (wr_cs)      , // chip select
			    .we_0      (wr_en)      , // write enable
			    .address_1 (rd_pointer) , // address_q input
			    .data_1    (data_ram)   , // data_1 bi-directional
			    .cs_1      (rd_cs)      , // chip select
			    .we_1      (1'b0)       , // Read enable
			    .oe_1      (rd_en)        // output enable
			    );     
   
endmodule

