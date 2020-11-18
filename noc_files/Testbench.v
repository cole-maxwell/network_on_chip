//-------------------------------------------------------------------------------
//-- This is the testbench for the single cycle MIPS processor.
//-------------------------------------------------------------------------------

module Testbench ();

   //inputs to the DUT are reg type
   reg clk, rst_n, init_mem;
   integer i;

   parameter MEM_SIZE=64; //Memory size is 32 x 32

   //save contents of instruction mem and data register of each Tile's memory
   //from their corresponding hex files

   reg [8:0] counter;
   reg [7:0] address;

   reg [7:0] inst_mem0 [0 : MEM_SIZE * 4 - 1]; //instuction mem for beginning routers
   reg [7:0] inst_mem1 [0 : MEM_SIZE * 4 - 1]; //instuction mem for intermediate routers

   reg [7:0] data_mem0 [0 : MEM_SIZE * 4 - 1]; //data mem for beginning routers
   reg [7:0] data_mem1 [0 : MEM_SIZE * 4 - 1]; //data mem for intermediate routers


   //get an instance from the system
   system system_0(.clk(clk),.rst_n(rst_n), .init_mem(init_mem));


   initial
     begin
        $dumpfile("dump.vcd");
	$dumpvars(0); 

	// Initialize instruction and data memory
	$readmemh("instruction_startingTile.hex",inst_mem0);
	$readmemh("data_startingTile.hex",data_mem0);

	$readmemh("instruction_internalTile.hex",inst_mem1);
	$readmemh("data_internalTile.hex",data_mem1);

	clk = 1'b0;     // at time 0
	counter = 30'b000000000000000000000000000000;
	address = 32'b00000000000000000000000000000000;
	rst_n = 1'b0;        // reset is active
	init_mem =1'b0;
	#500 init_mem = 1'b1;
	
	#100000 $stop;  //stop the simulation
	
     end
   
   always
     #100 clk = ~clk;   // Generate clock
   
   //log information   
   always @(posedge clk)
     begin

	
	//-------check Tile0
	if(system_0.cpu2router_0[12] == 1'b1)
	  $display("Router (0,0) received packet [%1h,%1h,%2h] from PROC  @%7d",
		   system_0.cpu2router_0[11:10],
		   system_0.cpu2router_0[9:8],
		   system_0.cpu2router_0[7:0], $time);

	if(system_0.data_1w_0e[12] == 1'b1)
	  $display("Router (0,0) received packet [%1h,%1h,%2h] from east  @%7d",
		   system_0.data_1w_0e[11:10],
		   system_0.data_1w_0e[9:8],
		   system_0.data_1w_0e[7:0], $time);

	if(system_0.data_3n_0s[12] == 1'b1)
	  $display("Router (0,0) received packet [%1h,%1h,%2h] from south @%7d",
		   system_0.data_3n_0s[11:10],
		   system_0.data_3n_0s[9:8],
		   system_0.data_3n_0s[7:0], $time);

	
	//-------check Tile1
	if(system_0.cpu2router_1[12] == 1'b1)
	  $display("Router (0,1) received packet [%1h,%1h,%2h] from PROC  @%7d",
		   system_0.cpu2router_1[11:10],
		   system_0.cpu2router_1[9:8],
		   system_0.cpu2router_1[7:0], $time);

	if(system_0.data_2w_1e[12] == 1'b1)
	  $display("Router (0,1) received packet [%1h,%1h,%2h] from east  @%7d",
		   system_0.data_2w_1e[11:10],
		   system_0.data_2w_1e[9:8],
		   system_0.data_2w_1e[7:0], $time);

	if(system_0.data_4n_1s[12] == 1'b1)
	  $display("Router (0,1) received packet [%1h,%1h,%2h] from south @%7d",
		   system_0.data_4n_1s[11:10],
		   system_0.data_4n_1s[9:8],
		   system_0.data_4n_1s[7:0], $time);

	if(system_0.data_0e_1w[12] == 1'b1)
	  $display("Router (0,1) received packet [%1h,%1h,%2h] from west  @%7d",
		   system_0.data_0e_1w[11:10],
		   system_0.data_0e_1w[9:8],
		   system_0.data_0e_1w[7:0], $time);


	
	//-------check Tile2
	if(system_0.cpu2router_2[12] == 1'b1)
	  $display("Router (0,2) received packet [%1h,%1h,%2h] from PROC  @%7d",
		   system_0.cpu2router_2[11:10],
		   system_0.cpu2router_2[9:8],
		   system_0.cpu2router_2[7:0], $time);

	if(system_0.data_5n_2s[12] == 1'b1)
	  $display("Router (0,2) received packet [%1h,%1h,%2h] from south @%7d",
		   system_0.data_5n_2s[11:10],
		   system_0.data_5n_2s[9:8],
		   system_0.data_5n_2s[7:0], $time);

	if(system_0.data_1e_2w[12] == 1'b1)
	  $display("Router (0,2) received packet [%1h,%1h,%2h] from west  @%7d",
		   system_0.data_1e_2w[11:10],
		   system_0.data_1e_2w[9:8],
		   system_0.data_1e_2w[7:0], $time);


	
	//-------check Tile3
	if(system_0.cpu2router_3[12] == 1'b1)
	  $display("Router (1,0) received packet [%1h,%1h,%2h] from PROC  @%7d",
		   system_0.cpu2router_3[11:10],
		   system_0.cpu2router_3[9:8],
		   system_0.cpu2router_3[7:0], $time);

	if(system_0.data_4w_3e[12] == 1'b1)
	  $display("Router (1,0) received packet [%1h,%1h,%2h] from east  @%7d",
		   system_0.data_4w_3e[11:10],
		   system_0.data_4w_3e[9:8],
		   system_0.data_4w_3e[7:0], $time);

	if(system_0.data_6n_3s[12] == 1'b1)
	  $display("Router (1,0) received packet [%1h,%1h,%2h] from south @%7d",
		   system_0.data_6n_3s[11:10],
		   system_0.data_6n_3s[9:8],
		   system_0.data_6n_3s[7:0], $time);

	if(system_0.data_0s_3n[12] == 1'b1)
	  $display("Router (1,0) received packet [%1h,%1h,%2h] from north @%7d",
		   system_0.data_0s_3n[11:10],
		   system_0.data_0s_3n[9:8],
		   system_0.data_0s_3n[7:0], $time);

	
	
	//-------check Tile4
	if(system_0.cpu2router_4[12] == 1'b1)
	  $display("Router (1,1) received packet [%1h,%1h,%2h] from PROC  @%7d",
		   system_0.cpu2router_4[11:10],
		   system_0.cpu2router_4[9:8],
		   system_0.cpu2router_4[7:0], $time);

	if(system_0.data_5w_4e[12] == 1'b1)
	  $display("Router (1,1) received packet [%1h,%1h,%2h] from east  @%7d",
		   system_0.data_5w_4e[11:10],
		   system_0.data_5w_4e[9:8],
		   system_0.data_5w_4e[7:0], $time);

	if(system_0.data_7n_4s[12] == 1'b1)
	  $display("Router (1,1) received packet [%1h,%1h,%2h] from south @%7d",
		   system_0.data_7n_4s[11:10],
		   system_0.data_7n_4s[9:8],
		   system_0.data_7n_4s[7:0], $time);

	if(system_0.data_3e_4w[12] == 1'b1)
	  $display("Router (1,1) received packet [%1h,%1h,%2h] from west  @%7d",
		   system_0.data_3e_4w[11:10],
		   system_0.data_3e_4w[9:8],
		   system_0.data_3e_4w[7:0], $time);

	if(system_0.data_1s_4n[12] == 1'b1)
	  $display("Router (1,1) received packet [%1h,%1h,%2h] from north @%7d",
		   system_0.data_1s_4n[11:10],
		   system_0.data_1s_4n[9:8],
		   system_0.data_1s_4n[7:0], $time);


	
	//-------check Tile5
	if(system_0.cpu2router_5[12] == 1'b1)
	  $display("Router (1,2) received packet [%1h,%1h,%2h] from PROC  @%7d",
		   system_0.cpu2router_5[11:10],
		   system_0.cpu2router_5[9:8],
		   system_0.cpu2router_5[7:0], $time);
	
	if(system_0.data_8n_5s[12] == 1'b1)
	  $display("Router (1,2) received packet [%1h,%1h,%2h] from south @%7d",
		   system_0.data_8n_5s[11:10],
		   system_0.data_8n_5s[9:8],
		   system_0.data_8n_5s[7:0], $time);

	if(system_0.data_4e_5w[12] == 1'b1)
	  $display("Router (1,2) received packet [%1h,%1h,%2h] from west  @%7d",
		   system_0.data_4e_5w[11:10],
		   system_0.data_4e_5w[9:8],
		   system_0.data_4e_5w[7:0], $time);

	if(system_0.data_2s_5n[12] == 1'b1)
	  $display("Router (1,2) received packet [%1h,%1h,%2h] from north @%7d",
		   system_0.data_2s_5n[11:10],
		   system_0.data_2s_5n[9:8],
		   system_0.data_2s_5n[7:0], $time);


	
	//-------check Tile6
	if(system_0.cpu2router_6[12] == 1'b1)
	  $display("Router (2,0) received packet [%1h,%1h,%2h] from PROC  @%7d",
		   system_0.cpu2router_6[11:10],
		   system_0.cpu2router_6[9:8],
		   system_0.cpu2router_6[7:0], $time);

	if(system_0.data_7w_6e[12] == 1'b1)
	  $display("Router (2,0) received packet [%1h,%1h,%2h] from east  @%7d",
		   system_0.data_7w_6e[11:10],
		   system_0.data_7w_6e[9:8],
		   system_0.data_7w_6e[7:0], $time);

	if(system_0.data_3s_6n[12] == 1'b1)
	  $display("Router (2,0) received packet [%1h,%1h,%2h] from north @%7d",
		   system_0.data_3s_6n[11:10],
		   system_0.data_3s_6n[9:8],
		   system_0.data_3s_6n[7:0], $time);
	
		
	//-------check Tile7
	if(system_0.cpu2router_7[12] == 1'b1)
	  $display("Router (2,1) received packet [%1h,%1h,%2h] from PROC  @%7d",
		   system_0.cpu2router_7[11:10],
		   system_0.cpu2router_7[9:8],
		   system_0.cpu2router_7[7:0], $time);

	if(system_0.data_8w_7e[12] == 1'b1)
	  $display("Router (2,1) received packet [%1h,%1h,%2h] from east  @%7d",
		   system_0.data_8w_7e[11:10],
		   system_0.data_8w_7e[9:8],
		   system_0.data_8w_7e[7:0], $time);

	if(system_0.data_6e_7w[12] == 1'b1)
	  $display("Router (2,1) received packet [%1h,%1h,%2h] from west  @%7d",
		   system_0.data_6e_7w[11:10],
		   system_0.data_6e_7w[9:8],
		   system_0.data_6e_7w[7:0], $time);

	if(system_0.data_4s_7n[12] == 1'b1)
	  $display("Router (2,1) received packet [%1h,%1h,%2h] from north @%7d",
		   system_0.data_4s_7n[11:10],
		   system_0.data_4s_7n[9:8],
		   system_0.data_4s_7n[7:0], $time);


	//-------check Tile8
	if(system_0.cpu2router_8[12] == 1'b1)
	  $display("Router (2,2) received packet [%1h,%1h,%2h] from PROC  @%7d",
		   system_0.cpu2router_8[11:10],
		   system_0.cpu2router_8[9:8],
		   system_0.cpu2router_8[7:0], $time);

	if(system_0.data_7e_8w[12] == 1'b1)
	  $display("Router (2,2) received packet [%1h,%1h,%2h] from west  @%7d",
		   system_0.data_7e_8w[11:10],
		   system_0.data_7e_8w[9:8],
		   system_0.data_7e_8w[7:0], $time);

	if(system_0.data_5s_8n[12] == 1'b1)
	  $display("Router (2,2) received packet [%1h,%1h,%2h] from north @%7d",
		   system_0.data_5s_8n[11:10],
		   system_0.data_5s_8n[9:8],
		   system_0.data_5s_8n[7:0], $time);

	
     end

   always @(posedge clk) begin
      if (init_mem == 1'b1) 
  	if (counter < 9'b100000000) begin

	   system_0.address = counter[7:0];

	   system_0.data0 = data_mem0[counter];
	   system_0.data1 = data_mem1[counter];
	   system_0.data2 = data_mem1[counter];
	   system_0.data3 = data_mem1[counter];
	   system_0.data4 = data_mem1[counter];
	   system_0.data5 = data_mem1[counter];
 	   system_0.data6 = data_mem1[counter];
	   system_0.data7 = data_mem1[counter];
	   system_0.data8 = data_mem1[counter];

	   system_0.inst0 = inst_mem0[counter];
	   system_0.inst1 = inst_mem1[counter];
	   system_0.inst2 = inst_mem1[counter];
	   system_0.inst3 = inst_mem1[counter];
	   system_0.inst4 = inst_mem1[counter];
	   system_0.inst5 = inst_mem1[counter];
	   system_0.inst6 = inst_mem1[counter];
	   system_0.inst7 = inst_mem1[counter];
	   system_0.inst8 = inst_mem1[counter];

	   counter <= counter +1;
	end
  	else begin
  	   init_mem <= 1'b0; 
  	end
      if (init_mem == 1'b0 && counter >= 9'b100000000)
  	rst_n <= 1'b1;

   end

endmodule
