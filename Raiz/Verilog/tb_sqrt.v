`timescale 1ns/1ps
`include "top_sqrt.v"
`include "cont_sqrt.v"
`include "cont.v"
`include "reg_n.v"
`include "reg_rem.v"
`include "reg_rad.v"
`include "reg_out.v"
`include "sub.v"
`include "trial.v"

module tb_sqrt;

parameter WIDTH_N   = 16;
parameter WIDTH_RAD = WIDTH_N / 2;

reg                  clk;
reg                  rst;
reg                  start;
reg  [WIDTH_N-1:0]   N_in;

wire [WIDTH_RAD-1:0] raiz;
wire                 ready;

top_sqrt #(.WIDTH_N(WIDTH_N)) UUT (
    .clk(clk),
    .rst(rst),
    .start(start),
    .N_in(N_in),
    .raiz(raiz),
    .ready(ready)
);

always #5 clk = ~clk;

initial begin

    $dumpfile("tb_sqrt.vcd");
    $dumpvars(0, tb_sqrt);

    clk   = 0;
    rst   = 1;
    start = 0;
    N_in  = 0;

    #20;
    rst = 0;

// ── Caso 1
    #10;
    N_in  = 16'd79;
    start = 1;
    #10;
    start = 0;

    // ready=1 significa que raiz ya está estable en reg_out
    wait(ready);
    #1; // margen post-flanco

    $display("------------------------");
    $display("sqrt(%0d)", N_in);
    $display("Raiz: %0d" , raiz);

    // reset entre casos
    #10; rst = 1;
    #10; rst = 0;

// ── Caso 2 : sqrt(100^2 = 10000) ──────────────────────────────
    #10;
    N_in  = 16'd100;
    start = 1;
    #10;
    start = 0;

    wait(ready);
    #1;

    $display("------------------------");
    $display("sqrt(%0d)", N_in);
    $display("Raiz: %0d" , raiz);

    // reset entre casos
    #10; rst = 1;
    #10; rst = 0;

// ── Caso 3 : sqrt(255^2 = 65025) ──────────────────────────────
    #10;
    N_in  = 16'd625;
    start = 1;
    #10;
    start = 0;

    wait(ready);
    #1;

    $display("------------------------");
    $display("sqrt(%0d)", N_in);
    $display("Raiz: %0d" , raiz);

    #30;
    $finish;

end

endmodule
