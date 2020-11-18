module RegisterFile(
		    input clk,
		    input rst_n,
		    input writeEn,
		    input [4:0] readReg1,
		    input [4:0] readReg2,
		    input [4:0] writeReg,
		    input [31:0] Datain,
		    output [31:0] Dataout1,
		    output [31:0] Dataout2
		    );
   
   // regFile has 32 32-bit registers
   reg [31:0] 			  regFile [0:31];

   integer 			  i; //indexing variable 

   // Read Data
   assign Dataout1 = regFile[readReg1];
   assign Dataout2 = regFile[readReg2];
   
   // Write Data
   always @(posedge clk) begin
      if (!rst_n) begin
	 for (i=0;i<32;i=i+1)
	   regFile[i] <= 32'b00000000000000000000000000000000;
      end
      else if (writeEn) begin
	 regFile[writeReg] <= Datain;
      end
   end

endmodule

