`timescale 1ns/1ps
`include "top_div.v"
`include "div_sh_reg.v"
`include "div_comp.v"
`include "Control_div.v"
`include "acm_reg.v"
`include "reg_c.v"

module tb_div;

parameter N = 16;

reg clk;
reg rst;
reg start;

reg [N-1:0] Dvd_in;
reg [N-1:0] Dvs_in;

wire [N-1:0] Q_out;
wire [N-1:0] R_out;
wire done;

top_div #(N) UUT (
    .clk(clk), 
    .rst(rst),
    .start(start),
    .Dvd_in(Dvd_in),
    .Dvs_in(Dvs_in),
    .Q_out(Q_out),
    .R_out(R_out),
    .done(done)
);

always #5 clk = ~clk;

initial begin

    $dumpfile("tb_div.vcd");
    $dumpvars(0, tb_div);

    clk    = 0;
    rst    = 1;
    start  = 0;
    Dvd_in = 0;
    Dvs_in = 1;

// Reset
    #20;
    rst = 0;

// Caso 1 : 29 / 4
// ==========================
    #10;
    Dvd_in = 16'd29;
    Dvs_in = 16'd4;

    start = 1;
    #10;
    start = 0;

    wait(done);

    $display("---------------------");
    $display("29 / 4");
    $display("Q = %0d", Q_out);
    $display("R = %0d", R_out);

// reset
    #20;
    rst = 1;
    #10;
    rst = 0;

    
// Caso 2 : 318 / 3
// ==========================
    #10;
    Dvd_in = 16'd318;
    Dvs_in = 16'd3;

    start = 1;
    #10;
    start = 0;

    wait(done);

    $display("---------------------");
    $display("318 / 3");
    $display("Q = %0d", Q_out);
    $display("R = %0d", R_out);

    #20;
    rst = 1;
    #10;
    rst = 0;

// Caso 3 : 520 / 6
// ==========================
    #10;
    Dvd_in = 16'd520;
    Dvs_in = 16'd6;

    start = 1;
    #10;
    start = 0;

    wait(done);

    $display("---------------------");
    $display("520 / 6");
    $display("Q = %0d", Q_out);
    $display("R = %0d", R_out);

    #30;
    $finish;

end

endmodule
