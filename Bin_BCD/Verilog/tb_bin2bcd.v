`timescale 1ns/1ps
`include "top_bin2bcd.v"
`include "bin2bcd_fsm.v"
`include "cont_shift.v"
`include "reg_bin.v"
`include "reg_bcd.v"
`include "reg_bcd_out.v"
`include "add_fix.v"

module tb_bin2bcd;

parameter WIDTH_BIN = 16;

reg clk;
reg rst;
reg start;
reg [WIDTH_BIN-1:0]  Bin_in;

wire [19:0] BCD_out;
wire ready;



wire [3:0] dec_mil = BCD_out[19:16];
wire [3:0] mil = BCD_out[15:12];
wire [3:0] cent = BCD_out[11:8];
wire [3:0] decs = BCD_out[7:4];
wire [3:0] unit = BCD_out[3:0];

top_bin2bcd #(.WIDTH_BIN(WIDTH_BIN)) UUT (
    .clk(clk),
    .rst(rst),
    .start(start),
    .Bin_in(Bin_in),
    .BCD_out(BCD_out),
    .ready(ready)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("tb_bin2bcd.vcd");
    $dumpvars(0, tb_bin2bcd);

    clk = 0; rst = 1; start = 0; Bin_in = 0;
    #20; rst = 0;

// Caso 1
    #10;
    Bin_in = 16'd156;
    start = 1; #10; start = 0;
    @(posedge clk); wait(ready); @(posedge clk); #1;
    $display("Bin_in = 156");
    $display("BCD_out = %05H", BCD_out);

    #20; rst = 1; #10; rst = 0;

//Caso 2
    #10;
    Bin_in = 16'd65535;
    start = 1; #10; start = 0;
    @(posedge clk); wait(ready); @(posedge clk); #1;
    $display("Bin_in = 65535 ");
    $display("BCD_out = %05H", BCD_out);

    #20; rst = 1; #10; rst = 0;

// Caso 3 
    #10;
    Bin_in = 16'd10000;
    start = 1; #10; start = 0;
    @(posedge clk); wait(ready); @(posedge clk); #1;
    $display("Bin_in = 10000");
    $display("BCD_out = %05H", BCD_out);
    #20; rst = 1; #10; rst = 0;



end

endmodule
