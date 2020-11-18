
// A basic 5-input matrix arbiter
// Brucek's code
// Added reset signal to make it synthesizable verilog (removed initial)

module matrix5arb (
   		   input clk,
   		   input rst_n,
   		   input [4:0] req,
   		   output [4:0] grant
   		   );

   // "State" contains the information "i before j"
   // e.g. if state12[7] = 1 then 12 has higher priority than 7
   // but  if state12[7] = 0 then 12 has lower priority than 7
   
   // Here's the matrix arbiter
   wire [4:0] 	row4,row3,row2,row1,row0;
   reg [3:0] 	nxt_state4;
   reg [2:0] 	nxt_state3;
   reg [1:0] 	nxt_state2;
   reg 		nxt_state1;
   reg [3:0] 	state4;
   reg [2:0] 	state3;
   reg [1:0] 	state2;
   reg 		state1;
   
   // Update the matrix with new priorities
   always @(grant or state4 or state3 or state2 or state1)
     begin
	if (grant[0]) 
	  begin
	     nxt_state4 = {state4[3:1],1'b1};
	     nxt_state3 = {state3[2:1],1'b1};
	     nxt_state2 = {state2[1],1'b1};
	     nxt_state1 = 1'b1;
	  end 

	else if (grant[1])
	  begin
	     nxt_state4 = {state4[3:2],1'b1,state4[0]};
	     nxt_state3 = {state3[2],1'b1,state3[0]};
	     nxt_state2 = {1'b1,state2[0]};
	     nxt_state1 = 1'b0;
	  end 
	else if (grant[2])
	  begin
	     nxt_state4 = {state4[3],1'b1,state4[1:0]};
	     nxt_state3 = {1'b1,state3[1:0]};
	     nxt_state2 = 2'b0;
	     nxt_state1 = state1;
	  end 
	else if (grant[3])
	  begin
	     nxt_state4 = {1'b1,state4[2:0]};
	     nxt_state3 = 3'b0;
	     nxt_state2 = state2;
	     nxt_state1 = state1;
	  end 
	else if (grant[4])
	  begin
	     nxt_state4 = 4'b0;
	     nxt_state3 = state3;
	     nxt_state2 = state2;
	     nxt_state1 = state1;
	  end 
	else 
	  begin
	     nxt_state4 = state4;
	     nxt_state3 = state3;
	     nxt_state2 = state2;
	     nxt_state1 = state1;
	  end
     end   
   
   // convert upper triangular matrix to full matrix
   assign row4  = {1'bx,state4};
   assign row3  = {~state4[3],1'bx,state3};
   assign row2  = {~state4[2],~state3[2],1'bx,state2};
   assign row1  = {~state4[1],~state3[1],~state2[1],1'bx,state1};
   assign row0  = {~state4[0],~state3[0],~state2[0],~state1,1'bx};
   
   
   // Use the matrix to compute the grant in logarithmic time
   assign grant[4] = ~( (~req[4])	 |
			(row3[4]&req[3]) |
			(row2[4]&req[2]) |
			(row1[4]&req[1]) |
			(row0[4]&req[0])    );
   
   assign grant[3] = ~( (row4[3]&req[4]) |
			(~req[3])	 |
			(row2[3]&req[2]) |
			(row1[3]&req[1]) |
			(row0[3]&req[0])    );
   
   assign grant[2] = ~( (row4[2]&req[4]) |
			(row3[2]&req[3]) |
			(~req[2])   	 |
			(row1[2]&req[1]) |
			(row0[2]&req[0])    );

   assign grant[1] = ~( (row4[1]&req[4]) |
			(row3[1]&req[3]) |
			(row2[1]&req[2]) |
			(~req[1])        |
			(row0[1]&req[0])    );

   assign grant[0] = ~( (row4[0]&req[4]) |
			(row3[0]&req[3]) |
			(row2[0]&req[2]) |
			(row1[0]&req[1]) |
			(~req[0])           );
   
   always @(posedge clk) 
     begin
	if (!rst_n)
	  begin
	     state4 <= 4'b0000;
	     state3 <= 3'b000;
	     state2 <= 2'b00;
	     state1 <= 1'b0;
	  end
	else
	  begin
	     state4 <= nxt_state4;
	     state3 <= nxt_state3;
	     state2 <= nxt_state2;
	     state1 <= nxt_state1;
	  end
     end

endmodule // matrix5arb

