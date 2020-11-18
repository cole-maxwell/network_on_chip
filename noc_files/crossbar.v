module crossbar(
		input clk,
		input rst_n,
		input [11:0] proc_in,
		input [11:0] east_in,
		input [11:0] south_in,
		input [11:0] west_in,
		input [11:0] north_in,
		input [4:0] proc_sel_code,
		input [4:0] east_sel_code,
		input [4:0] south_sel_code,
		input [4:0] west_sel_code,
		input [4:0] north_sel_code,
		output reg [12:0] proc_out,
		output reg [12:0] east_out,
		output reg [12:0] south_out,
		output reg [12:0] west_out,
		output reg [12:0] north_out
		);

   wire [11:0] 	    flit_p;
   wire [11:0] 	    flit_e;
   wire [11:0] 	    flit_s;
   wire [11:0] 	    flit_w;
   wire [11:0] 	    flit_n;
   
   reg [2:0] 	    proc_sel;
   reg [2:0] 	    east_sel;
   reg [2:0] 	    west_sel;
   reg [2:0] 	    north_sel;
   reg [2:0] 	    south_sel;


   assign flit_p = proc_in;
   assign flit_e = east_in;
   assign flit_s = south_in;
   assign flit_w = west_in;
   assign flit_n = north_in;


   always @(posedge clk)
     begin
	if(!rst_n) begin
	   proc_sel  <= 3'b000;
	   north_sel <= 3'b000;
	   east_sel  <= 3'b000;
	   south_sel <= 3'b000;
	   west_sel  <= 3'b000;
	   proc_out  <= 13'b0000000000000;
	   east_out  <= 13'b0000000000000;
	   south_out <= 13'b0000000000000;
	   west_out  <= 13'b0000000000000;
	   north_out <= 13'b0000000000000;
	end

	else begin
	   case(proc_sel_code)
	     5'b00010: proc_sel <= 3'b100;
	     5'b00100: proc_sel <= 3'b101;
	     5'b01000: proc_sel <= 3'b110;
	     5'b10000: proc_sel <= 3'b111;
	     default:  proc_sel <= 3'b000;
	   endcase

	   case(north_sel_code)
	     5'b00001: north_sel <= 3'b100;
	     5'b00010: north_sel <= 3'b101;
	     5'b00100: north_sel <= 3'b110;
	     5'b01000: north_sel <= 3'b111;
	     default:  north_sel <= 3'b000;
	   endcase
	   
	   case(east_sel_code)
	     5'b00001: east_sel <= 3'b100;
	     5'b00100: east_sel <= 3'b101;
	     5'b01000: east_sel <= 3'b110;
	     5'b10000: east_sel <= 3'b111;
	     default:  east_sel <= 3'b000;
	   endcase

	   case(south_sel_code)
	     5'b00001: south_sel <= 3'b100;
	     5'b00010: south_sel <= 3'b101;
	     5'b01000: south_sel <= 3'b110;
	     5'b10000: south_sel <= 3'b111;
	     default:  south_sel <= 3'b000;
	   endcase

	   case(west_sel_code)
	     5'b00001: west_sel <= 3'b100;
	     5'b00010: west_sel <= 3'b101;
	     5'b00100: west_sel <= 3'b110;
	     5'b10000: west_sel <= 3'b111;
	     default:  west_sel <= 3'b000;
	   endcase

	   case(proc_sel[1:0])
	     2'b00: proc_out <= {proc_sel[2],flit_e}; 
	     2'b01: proc_out <= {proc_sel[2],flit_s}; 
	     2'b10: proc_out <= {proc_sel[2],flit_w}; 
	     2'b11: proc_out <= {proc_sel[2],flit_n};
	   endcase

	   case(east_sel[1:0])
	     2'b00: east_out <= {east_sel[2],flit_p}; 
	     2'b01: east_out <= {east_sel[2],flit_s}; 
	     2'b10: east_out <= {east_sel[2],flit_w}; 
	     2'b11: east_out <= {east_sel[2],flit_n};
	   endcase
	   
	   case(west_sel[1:0])
	     2'b00: west_out <= {west_sel[2],flit_p}; 
	     2'b01: west_out <= {west_sel[2],flit_e}; 
	     2'b10: west_out <= {west_sel[2],flit_s}; 
	     2'b11: west_out <= {west_sel[2],flit_n}; 
	   endcase

	   case(north_sel[1:0])
	     2'b00: north_out <= {north_sel[2],flit_p}; 
	     2'b01: north_out <= {north_sel[2],flit_e}; 
	     2'b10: north_out <= {north_sel[2],flit_s}; 
	     2'b11: north_out <= {north_sel[2],flit_w}; 
	   endcase

	   case(south_sel[1:0])
	     2'b00: south_out <= {south_sel[2],flit_p}; 
	     2'b01: south_out <= {south_sel[2],flit_e}; 
	     2'b10: south_out <= {south_sel[2],flit_w}; 
	     2'b11: south_out <= {south_sel[2],flit_n}; 
	   endcase

	end
     end

endmodule