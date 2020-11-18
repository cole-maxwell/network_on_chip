module ALU32(
	     input [3:0] operation,
	     input [31:0] in_A,
	     input [31:0] in_B,
	     output reg [31:0] out_Result,
	     output wire out_Zero
	     );


   assign out_Zero = (out_Result == 32'b0);
   
   
   always @(operation or in_A or in_B) begin 

      case (operation)
	4'b0001: //ADD ALUOP = 0001
	  begin
	     out_Result = in_A + in_B; 	
	  end

	4'b0010: //SUB ALUOP = 0010
	  begin
	     out_Result = in_A - in_B; 	
	  end

	4'b0011: //AND ALUOP = 0011
	  begin
	     out_Result = in_A & in_B; 	
	  end

	4'b0100: //OR ALUOP = 0100
	  begin
	     out_Result = in_A | in_B; 	
	  end

	4'b0111: //slt ALUOP = 0111
	  begin
	     if (in_A < in_B) 
	       out_Result = 32'b1;
	     else 
	       out_Result = 32'b0;	     
	  end
	
	4'b1000: //OR ALUOP = 0100
	  begin
	     out_Result = in_B << 16; 	
	  end

	default: 
	  begin 
	     out_Result = 32'b0;
	  end
      endcase

   end
endmodule
