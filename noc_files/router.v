module router(
	      input clk, rst_n,
	      input [3:0] ID,
	      input [12:0]indata_p,
	      input [12:0]indata_e,
	      input [12:0]indata_s,
	      input [12:0]indata_w,
	      input [12:0]indata_n,
	      output [12:0]outdata_p,
	      output [12:0]outdata_e,
	      output [12:0]outdata_s,
	      output [12:0]outdata_w,
	      output [12:0]outdata_n
 
	      );

   wire [4:0] 		   req_p;
   wire [4:0] 		   req_e;
   wire [4:0] 		   req_s;
   wire [4:0] 		   req_w;
   wire [4:0] 		   req_n;
   wire [4:0] 		   grant_p;
   wire [4:0] 		   grant_e;
   wire [4:0] 		   grant_s;
   wire [4:0] 		   grant_w;
   wire [4:0] 		   grant_n;
   wire 		   grant_done_p;   
   wire 		   grant_done_e;
   wire 		   grant_done_s;
   wire 		   grant_done_w;
   wire 		   grant_done_n;
   wire [4:0] 		   port_p;
   wire [4:0] 		   port_e;
   wire [4:0] 		   port_s;
   wire [4:0] 		   port_w;
   wire [4:0] 		   port_n;

   wire [11:0] 		   data_p;  
   wire [11:0] 		   data_e;  
   wire [11:0] 		   data_s;  
   wire [11:0] 		   data_w;  
   wire [11:0] 		   data_n;  

   wire 		   ready_e;
   wire 		   ready_s;
   wire 		   ready_w;
   wire 		   ready_n;
   wire 		   ready_p;
   wire 		   empty_e;
   wire 		   empty_s;
   wire 		   empty_w;
   wire 		   empty_n;
   wire 		   empty_p;
   

   syn_fifo east_buff( .clk(clk), .rst(rst_n),.wr_cs(1'b1),.rd_cs(1'b1),.data_in(indata_e[11:0]),.rd_en(ready_e&~empty_e),.wr_en(indata_e[12]),.data_out(data_e),.empty(empty_e),.full()); 

   syn_fifo south_buff( .clk(clk), .rst(rst_n),.wr_cs(1'b1),.rd_cs(1'b1),.data_in(indata_s[11:0]),.rd_en(ready_s&~empty_s),.wr_en(indata_s[12]),.data_out(data_s),.empty(empty_s),.full()); 

   syn_fifo west_buff(  .clk(clk), .rst(rst_n),.wr_cs(1'b1),.rd_cs(1'b1),.data_in(indata_w[11:0]),.rd_en(ready_w&~empty_w),.wr_en(indata_w[12]),.data_out(data_w),.empty(empty_w),.full()); 

   syn_fifo north_buff( .clk(clk), .rst(rst_n),.wr_cs(1'b1),.rd_cs(1'b1),.data_in(indata_n[11:0]),.rd_en(ready_n&~empty_n),.wr_en(indata_n[12]),.data_out(data_n),.empty(empty_n),.full()); 
   
   syn_fifo proc_buff(  .clk(clk), .rst(rst_n),.wr_cs(1'b1),.rd_cs(1'b1),.data_in(indata_p[11:0]),.rd_en(ready_p&~empty_p),.wr_en(indata_p[12]),.data_out(data_p),.empty(empty_p),.full()); 


   route_table route_p( .clk(clk), .rst_n(rst_n), .data_in(data_p), .ID(ID), .outport(port_p), .ready(ready_p), .empty(empty_p), .grant(grant_done_p) );

   route_table route_e( .clk(clk), .rst_n(rst_n), .data_in(data_e), .ID(ID), .outport(port_e), .ready(ready_e), .empty(empty_e), .grant(grant_done_e));

   route_table route_s( .clk(clk), .rst_n(rst_n), .data_in(data_s), .ID(ID), .outport(port_s), .ready(ready_s), .empty(empty_s), .grant(grant_done_s));

   route_table route_w( .clk(clk), .rst_n(rst_n), .data_in(data_w), .ID(ID), .outport(port_w), .ready(ready_w), .empty(empty_w), .grant(grant_done_w) );

   route_table route_n( .clk(clk), .rst_n(rst_n), .data_in(data_n), .ID(ID), .outport(port_n), .ready(ready_n), .empty(empty_n), .grant(grant_done_n));



   assign req_p = {port_n[0],port_w[0],port_s[0],port_e[0],port_p[0]};
   assign req_e = {port_n[1],port_w[1],port_s[1],port_e[1],port_p[1]};
   assign req_s = {port_n[2],port_w[2],port_s[2],port_e[2],port_p[2]};
   assign req_w = {port_n[3],port_w[3],port_s[3],port_e[3],port_p[3]};
   assign req_n = {port_n[4],port_w[4],port_s[4],port_e[4],port_p[4]};

   assign grant_done_p = grant_p[0] | grant_e[0] | grant_s[0] | grant_w[0] | grant_n[0];
   assign grant_done_e = grant_p[1] | grant_e[1] | grant_s[1] | grant_w[1] | grant_n[1]; 
   assign grant_done_s = grant_p[2] | grant_e[2] | grant_s[2] | grant_w[2] | grant_n[2];
   assign grant_done_w = grant_p[3] | grant_e[3] | grant_s[3] | grant_w[3] | grant_n[3];
   assign grant_done_n = grant_p[4] | grant_e[4] | grant_s[4] | grant_w[4] | grant_n[4];


   matrix5arb proc_arb ( .clk(clk), .rst_n(rst_n), .req(req_p), .grant(grant_p));
   matrix5arb east_arb ( .clk(clk), .rst_n(rst_n), .req(req_e), .grant(grant_e));
   matrix5arb south_arb( .clk(clk), .rst_n(rst_n), .req(req_s), .grant(grant_s));
   matrix5arb west_arb ( .clk(clk), .rst_n(rst_n), .req(req_w), .grant(grant_w));
   matrix5arb north_arb( .clk(clk), .rst_n(rst_n), .req(req_n), .grant(grant_n));


   crossbar crossbar_inst( 
			   .clk(clk), 
			   .rst_n(rst_n), 
			   .proc_in(data_p), 
			   .east_in(data_e), 
			   .south_in(data_s), 
			   .west_in(data_w), 
			   .north_in(data_n),
			   .proc_sel_code(grant_p), 
			   .east_sel_code(grant_e), 
			   .south_sel_code(grant_s),
			   .west_sel_code(grant_w),
			   .north_sel_code(grant_n),
			   .proc_out(outdata_p), 
			   .east_out(outdata_e), 
			   .south_out(outdata_s), 
			   .west_out(outdata_w), 
			   .north_out(outdata_n)
			   );


endmodule
