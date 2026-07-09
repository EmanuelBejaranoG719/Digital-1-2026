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

reg                   clk;
reg                   rst;
reg                   start;
reg  [WIDTH_BIN-1:0]  Bin_in;

wire [3:0] dec_mil, mil, cent, decs, unit;
wire       ready;

top_bin2bcd #(.WIDTH_BIN(WIDTH_BIN)) UUT (
    .clk        (clk),
    .rst        (rst),
    .start      (start),
    .Bin_in     (Bin_in),
    .dec_mil (dec_mil),
    .mil      (mil),
    .cent   (cent),
    .decs    (decs),
    .unit   (unit),
    .ready      (ready)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("tb_bin2bcd.vcd");
    $dumpvars(0, tb_bin2bcd);

    clk = 0; rst = 1; start = 0; Bin_in = 0;
    #20; rst = 0;

// Caso 1 : 156 
    #10;
    Bin_in = 16'd156;
    start = 1; #10; start = 0;
    @(posedge clk); wait(ready); @(posedge clk); #1;
    $display("------------------------");
    $display("Bin_in = 156");
    $display("Esperado : 0 0 1 5 6");
    $display("Obtenido : %0d %0d %0d %0d %0d", dec_mil, mil, cent, decs, unit);

    #20; rst = 1; #10; rst = 0;

// Caso 2 : 65535 
    #10;
    Bin_in = 16'd65535;
    start = 1; #10; start = 0;
    @(posedge clk); wait(ready); @(posedge clk); #1;
    $display("------------------------");
    $display("Bin_in = 65535  [maximo 16 bits]");
    $display("Esperado : 6 5 5 3 5");
    $display("Obtenido : %0d %0d %0d %0d %0d", dec_mil, mil, cent, decs, unit);

    #20; rst = 1; #10; rst = 0;

// Caso 3 
    #10;
    Bin_in = 16'd10000;
    start = 1; #10; start = 0;
    @(posedge clk); wait(ready); @(posedge clk); #1;
    $display("------------------------");
    $display("Bin_in = 10000  [borde decena de mil]");
    $display("Esperado : 1 0 0 0 0");
    $display("Obtenido : %0d %0d %0d %0d %0d", dec_mil, mil, cent, decs, unit);

    #20; rst = 1; #10; rst = 0;

// Caso 4 
    #10;
    Bin_in = 16'd32767;
    start = 1; #10; start = 0;
    @(posedge clk); wait(ready); @(posedge clk); #1;
    $display("------------------------");
    $display("Bin_in = 32767");
    $display("Esperado : 3 2 7 6 7");
    $display("Obtenido : %0d %0d %0d %0d %0d", dec_mil, mil, cent, decs, unit);

    #20; rst = 1; #10; rst = 0;


end

endmodule
