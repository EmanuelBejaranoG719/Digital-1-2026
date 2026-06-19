`timescale 1ns/1ps
`include "multiplier.v"
`include "accumulator.v"
`include "shift_register.v"
`include "control_unit.v"

module tb_multiplier;

    parameter N = 16;

    reg clk;
    reg rst;
    reg start;

    reg  [N-1:0] X_in;
    reg  [N-1:0] Y_in;

    wire [N-1:0] P_out;
    wire done;


    multiplier #(N) UUT (
        .clk(clk),
        .rst(rst),
        .start(start),
        .X_in(X_in),
        .Y_in(Y_in),
        .P_out(P_out),
        .done(done)
    );

    
    always #5 clk = ~clk;

   
    initial begin

        $dumpfile("multiplier.vcd");
        $dumpvars(0, tb_multiplier);

        clk   = 0;
        rst   = 1;
        start = 0;
        X_in  = 0;
        Y_in  = 0;

 
        #20;
        rst = 0;
        #10;
        X_in = 16'd15;
        Y_in = 16'd7;

        start = 1;
        #10;
        start = 0;

        wait(done);

        #20;
        rst = 1;
        #10;
        rst = 0;

        #10;
        X_in = 16'd63;
        Y_in = 16'd9;

        start = 1;
        #10;
        start = 0;

        wait(done);

        #30;

        $finish;
    end

endmodule

