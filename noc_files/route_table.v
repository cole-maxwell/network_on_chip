//  output[0] processor
//  output[1] east
//  output[2] south
//  output[3] west
//  output[4] north

//--------------------------
// Tiles by their IDs
// ID[1:0] corresponds to the column number and ID[3:2] corresponds to row number
//	0000	0001	0010
//	0100	0101	0110
//	1000	1001	1010
//--------------------------

module route_table (
		    input clk,
		    input rst_n,
		    input[11:0] data_in,
		    output reg[4:0] outport,
		    input empty,
		    input grant,
		    output reg ready,
		    input [3:0] ID
		    );

   reg [11:0] 			data_out;
   wire [11:0] 			flit;
   wire [3:0] 			dest;
   reg 				request;
   
   assign flit = data_in;
   assign dest = flit[11:8];

   always @(posedge clk)
     begin
	if(!rst_n) begin	   
	   request <= 1'b0;
	   ready   <= 1'b1;
	end
	else
	  begin
	     if(ready == 1'b1 && empty == 1'b0)
	       request <= 1'b1;
	     else
	       request <= 1'b0;

	     if(grant==1'b0 && request == 1'b1)
	       ready <= 1'b0;
	     else
	       ready <= 1'b1;	     	     
	  end
	
     end
   
   
   //XY routing strategy     
   always @(*) 
     begin
	if(request == 1'b0)
	  outport = 5'b00000; 
	else 
	  begin
	     if(ID == dest)
	       outport = 5'b00001; 
	     else if(ID[1:0] == dest[1:0]) //dest in this column, route in Y
	       begin 
		  if(ID[3:2] < dest[3:2])
		    outport = 5'b00100;   //go south
		  else
		    outport = 5'b10000;   //go north
	       end	   
	     else  //dest not in this column, route in X
	       begin 
		  if(ID[1:0] < dest[1:0])      
		    outport = 5'b00010;  //go east
		  else
		    outport = 5'b01000;  //go west
	       end
	  end
     end


endmodule