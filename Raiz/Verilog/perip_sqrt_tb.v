`timescale 1ns/1ps

module perip_sqrt_TB;

reg clk;
reg reset;
reg [15:0] d_in;
reg cs;
reg [4:0] addr;
reg rd;
reg wr;

wire [31:0] d_out;

peripheral_test uut(
    .clk(clk),
    .reset(reset),
    .d_in(d_in),
    .cs(cs),
    .addr(addr),
    .rd(rd),
    .wr(wr),
    .d_out(d_out)
);

always #10 clk = ~clk;

initial begin

    clk   = 0;
    reset = 1;
    cs    = 0;
    rd    = 0;
    wr    = 0;
    addr  = 0;
    d_in  = 0;

    $dumpfile("perip_sqrt.vcd");
    $dumpvars(0, perip_sqrt_TB);

    #40;
    reset = 0;

// Escribir entrada N
    @(posedge clk);
    cs   = 1;
    wr   = 1;
    addr = 5'h04;
    d_in = 16'd81;

    @(posedge clk);
    wr = 0;
    cs = 0;

    @(posedge clk);
    cs   = 1;
    wr   = 1;
    addr = 5'h0C;
    d_in = 16'd1;

    @(posedge clk);
    d_in = 16'd0;

    @(posedge clk);
    wr = 0;
    cs = 0;

// Esperar a done
    wait(uut.done);

    $display("--------------------------------");
    $display("Operacion terminada");
    $display("Raiz interna = %d", uut.sqrt);

// Leer el resultado
    @(posedge clk);
    cs   = 1;
    rd   = 1;
    addr = 5'h10;

    @(posedge clk);
    $display("d_out = %d", d_out);

    rd = 0;
    cs = 0;

    @(posedge clk);
    cs   = 1;
    rd   = 1;
    addr = 5'h14;

    @(posedge clk);
    $display("done = %d", d_out[0]);

    rd = 0;
    cs = 0;

    #100;
    $finish;

end

endmodule
