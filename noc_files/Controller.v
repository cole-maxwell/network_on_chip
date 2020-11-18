module Controller (
		   input [5:0] opcode,   
		   input [5:0] funct, 
		   output reg regDst,   
		   output reg branch, 
		   output reg memRead,  
		   output reg memWrite,
		   output reg [3:0] ALUOp,   
		   output reg memtoReg, 
		   output reg ALUSrc, 
		   output reg regWrite,
		   output reg jump
		   );
   
   //-------------------------------------------------------------------------------
   //  control logic.
   //-------------------------------------------------------------------------------
   always@(opcode or funct) begin
      case(opcode)

	6'b110000: //A fake opcode for writing to NoC
	  begin
	     regDst   <= 1'b0;
	     branch   <= 1'b0;
	     memRead  <= 1'b0;
	     memWrite <= 1'b0;
	     ALUOp    <= 4'b0000;
	     memtoReg <= 1'b0;
	     ALUSrc   <= 1'b0;
	     regWrite <= 1'b0;
	     jump     <= 1'b0;
	  end

	
	6'b000100: //Branch on Equal
	  begin
	     regDst   <= 1'b0;
	     branch   <= 1'b1;
	     memRead  <= 1'b0;
	     memWrite <= 1'b0;
	     ALUOp    <= 4'b0010;
	     memtoReg <= 1'b0;
	     ALUSrc   <= 1'b0;
	     regWrite <= 1'b0;
	     jump     <= 1'b0;
	  end

	6'b100011: //Load Word
	  begin
	     regDst   <= 1'b0;
	     branch   <= 1'b0;
	     memRead  <= 1'b1;
	     memWrite <= 1'b0;
	     ALUOp    <= 4'b0001;
	     memtoReg <= 1'b1;
	     ALUSrc   <= 1'b1;
	     regWrite <= 1'b1;
	     jump     <= 1'b0;
	  end

	6'b101011: //Store Word
	  begin
	     regDst   <= 1'b0;
	     branch   <= 1'b0;
	     memRead  <= 1'b0;
	     memWrite <= 1'b1;
	     ALUOp    <= 4'b0001;
	     memtoReg <= 1'b1;
	     ALUSrc   <= 1'b1;
	     regWrite <= 1'b0;
	     jump     <= 1'b0;
	  end

	6'b100000: //Load byte
	  begin
	     regDst   <= 1'b0;
	     branch   <= 1'b0;
	     memRead  <= 1'b1;
	     memWrite <= 1'b0;
	     ALUOp    <= 4'b0001;
	     memtoReg <= 1'b1;
	     ALUSrc   <= 1'b1;
	     regWrite <= 1'b1;
	     jump     <= 1'b0;
	  end

	6'b101000: //Store Word
	  begin
	     regDst   <= 1'b0;
	     branch   <= 1'b0;
	     memRead  <= 1'b0;
	     memWrite <= 1'b1;
	     ALUOp    <= 4'b0001;
	     memtoReg <= 1'b1;
	     ALUSrc   <= 1'b1;
	     regWrite <= 1'b0;
	     jump     <= 1'b0;
	  end

	6'b001111: //lui
	  begin
	     regDst   <= 1'b0;
	     branch   <= 1'b0;
	     memRead  <= 1'b0;
	     memWrite <= 1'b0;
	     ALUOp    <= 4'b1000;
	     memtoReg <= 1'b0;
	     ALUSrc   <= 1'b1;
	     regWrite <= 1'b1;
	     jump     <= 1'b0;
	  end

	6'b001000: //addi
	  begin
	     regDst   <= 1'b0;
	     branch   <= 1'b0;
	     memRead  <= 1'b0;
	     memWrite <= 1'b0;
	     ALUOp    <= 4'b0001;
	     memtoReg <= 1'b0;
	     ALUSrc   <= 1'b1;
	     regWrite <= 1'b1;
	     jump     <= 1'b0;
	  end

	6'b000010: //Jump
	  begin
	     regDst   <= 1'b0;
	     branch   <= 1'b0;
	     memRead  <= 1'b0;
	     memWrite <= 1'b0;
	     ALUOp    <= 4'b0000;
	     memtoReg <= 1'b0;
	     ALUSrc   <= 1'b0;
	     regWrite <= 1'b0;
	     jump     <= 1'b1;
	  end

	6'b000000: //R-type
	  begin
	     regDst   <= 1'b1;
	     branch   <= 1'b0;
	     memRead  <= 1'b0;
	     memWrite <= 1'b0;
	     memtoReg <= 1'b0;
	     ALUSrc   <= 1'b0;
	     regWrite <= 1'b1;
	     jump     <= 1'b0;
	     case (funct)
	       6'b100000: ALUOp <= 4'b0001; //ADD
	       6'b100010: ALUOp <= 4'b0010; //SUB
	       6'b100100: ALUOp <= 4'b0011; //AND
	       6'b100101: ALUOp <= 4'b0100; //OR
	       6'b101010: ALUOp <= 4'b0111; //SLT
	       default:   ALUOp <= 4'b0;
	     endcase
	  end

	default:
	  begin
	     regDst   <= 1'b0;
	     branch   <= 1'b0;
	     memRead  <= 1'b0;
	     memWrite <= 1'b0;
	     ALUOp    <= 4'b0000;
	     memtoReg <= 1'b0;
	     ALUSrc   <= 1'b0;
	     regWrite <= 1'b0;
	     jump     <= 1'b0;
	  end 
      endcase
   end
   
endmodule
