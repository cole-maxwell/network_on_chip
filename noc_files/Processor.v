module Processor(
		 input clk,
		 input rst_n,
		 output reg [31:0] PC, //program counter 
		 input [31:0] Instruction, //Instruction Memory
		 output [31:0] DataAddress,
		 output [31:0] MemWriteData,
		 output MemWriteEn,
		 output MemReadEn,
		 output wire NoCWrite, //flag to initiate writing to NoC
		 input [31:0] MemReadData 
		 );


   wire [31:0] 		      NextAddress, BranchAddress, JumpAddress;
   
   //Instruction Decoder
   wire [5:0] 		      Opcode, Funct;
   wire [4:0] 		      RS, RT, RD, Shamt;
   wire [15:0] 		      IAddress;
   wire [25:0] 		      JAddress;
   
   //Controller
   wire 		      RegDst, Branch, MemRead, MemWrite, MemtoReg, ALUSrc, RegWrite, Jump;
   wire [3:0] 		      ALUOp;
   
   //Register File
   wire [4:0] 		      WriteReg;
   wire [31:0] 		      RegData1, RegData2, WriteBackData;
   
   //Sign Extender
   wire [31:0] 		      ExtendedAddress;
   
   //ALU
   wire [31:0] 		      InputA, InputB, ALUResult;
   wire 		      ZeroFlag;
   
   //Data Memory
   wire [31:0] 		      MemoryData;
   
   assign DataAddress = ALUResult;
   //use the lower bits of instruction as the NOC packet
   assign MemWriteData = (Opcode==6'b110000) ? {20'b0,Instruction[11:0]} : RegData2;
   assign NoCWrite = (Opcode==6'b110000);
   
   assign MemWriteEn = MemWrite;
   assign MemReadEn = MemRead;
   assign MemoryData = MemReadData;
   
   //-- Instantiate the instruction decoder.
   InstructionDecoder InstructionDecode(
					.instruction(Instruction),
					.opcode(Opcode),
					.RS(RS),
					.RT(RT),
					.RD(RD),
					.shamt(Shamt),
					.funct(Funct),
					.IAddress(IAddress),
					.JAddress(JAddress)
  					);
   
   //-- Instantiate the main control block.
   Controller Control(
		      .opcode(Opcode),
		      .funct(Funct),
		      .regDst(RegDst),
		      .branch(Branch),
		      .memRead(MemRead),
		      .memWrite(MemWrite),
		      .ALUOp(ALUOp),
		      .memtoReg(MemtoReg),
		      .ALUSrc(ALUSrc),
		      .regWrite(RegWrite),
		      .jump(Jump)
  		      );
   
   //-- Instantiate the register file.
   assign WriteReg = (RegDst) ? RD : RT;
   assign WriteBackData = (MemtoReg) ? MemoryData : ALUResult;
   
   RegisterFile RegFile(
			.clk(clk),
			.rst_n(rst_n),
			.readReg1(RS),
			.readReg2(RT),
			.writeReg(WriteReg),
			.Datain(WriteBackData),
			.writeEn(RegWrite),
			.Dataout1(RegData1),
			.Dataout2(RegData2)
  			);
   
   //-- sign extend.
   assign ExtendedAddress = {{16{IAddress[15]}},IAddress};
   
   //-- Instantiate the ALU.
   assign InputA = RegData1;
   assign InputB = (ALUSrc) ? ExtendedAddress : RegData2;
   
   ALU32  ALU(
	      .operation(ALUOp),
	      .in_A(InputA),
	      .in_B(InputB),
	      .out_Result(ALUResult),
	      .out_Zero(ZeroFlag)
	      );
   
   
   //-- Update the program counter.
   assign NextAddress   = PC + 4;
   assign BranchAddress = PC + (ExtendedAddress<<2);
   assign JumpAddress   = {NextAddress[31:28],JAddress,2'b00};
   
   always @ (posedge clk)
     begin
	if (!rst_n)
	  PC <= 32'h0;
	else begin
	   if (Jump)
	     PC <= JumpAddress;
	   else if (Branch && ZeroFlag) 
	     PC <= BranchAddress;
	   else 
	     PC <= NextAddress;
	end 
     end

endmodule
