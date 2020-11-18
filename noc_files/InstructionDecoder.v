module InstructionDecoder(
			  input [31:0] instruction,
			  output [5:0] opcode,
			  output [4:0] RS,
			  output [4:0] RT,
			  output [4:0] RD,
			  output [4:0] shamt,
			  output [5:0] funct,
			  output [15:0] IAddress,
			  output [25:0] JAddress
			  );
   
   assign opcode   = instruction[31:26];
   assign RS       = instruction[25:21];
   assign RT       = instruction[20:16];
   assign RD       = instruction[15:11];
   assign shamt    = instruction[10:6];
   assign funct    = instruction[5:0];
   assign IAddress = instruction[15:0];
   assign JAddress = instruction[25:0];

endmodule
