//-------------------------------------------------------------------------------
//-- This is a generic memory module and is used as both the instruction and data
//-- memory in the single cycle MIPS processor.
//--
//-- Kekai Hu
//-- ECE 232
//-------------------------------------------------------------------------------

module Memory(
	      input clk,
	      input [7:0] in_Address, //address of 32-bit data blocks
	      input [7:0] in_Data,
	      input in_WriteEn,
	      input in_ReadEn,
	      output reg [31:0] out_Data
	      );
   
   parameter MEM_SIZE=256; //Memory size
   
   reg [7:0] 			Memory [0 : MEM_SIZE - 1];
   
   always @(posedge clk) begin
      //Read data
      if (in_ReadEn == 1'b1) begin //Read 4 bytes of data
      	 out_Data[31:24] <= Memory[in_Address + 3];
      	 out_Data[23:16] <= Memory[in_Address + 2];
      	 out_Data[15:8]  <= Memory[in_Address + 1];
      	 out_Data[7:0]   <= Memory[in_Address + 0]; 
      end
      else begin
	 out_Data <= 0;
      end

      //Write data
      if (in_WriteEn == 1'b1) begin
         Memory[in_Address]   <= in_Data;         
      end
      
   end
   
endmodule 

