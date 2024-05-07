`timescale 1ns / 1ps


module test();
reg clk;
wire [7:0] IR;
wire [7:0] DR;
wire [7:0] AC;
wire [3:0] PC;
wire [3:0] AR;
wire [3:0] SC;
wire E ; 
wire [7:0] OUTR ;
// instantiate device under test
BasicComputer dut(IR,DR,AC,PC,AR,clk,SC,OUTR,E);
always begin
	clk = 0; #5; clk = 1; #5;
end

endmodule
