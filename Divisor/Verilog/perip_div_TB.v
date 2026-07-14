`timescale 1ns/1ps

module perip_div_TB;

reg clk;
reg reset;

reg cs;
reg rd;
reg wr;

reg [4:0]  addr;
reg [15:0] d_in;

wire [31:0] d_out;

peripheral_test DUT(
    .clk(clk),
    .reset(reset),
    .d_in(d_in),
    .cs(cs),
    .addr(addr),
    .rd(rd),
    .wr(wr),
    .d_out(d_out)
);

always #5 clk = ~clk;

initial begin

    $dumpfile("perip_div.vcd");
    $dumpvars(0,perip_div_TB);

    clk   = 0;
    reset = 1;

    cs    = 0;
    rd    = 0;
    wr    = 0;

    addr  = 0;
    d_in  = 0;

    #20;
    reset = 0;

    @(posedge clk);
    cs   = 1;
    wr   = 1;
    addr = 5'h04;
    d_in = 16'd67;

    @(posedge clk);
    cs = 0;
    wr = 0;


    @(posedge clk);
    cs   = 1;
    wr   = 1;
    addr = 5'h08;
    d_in = 16'd9;

    @(posedge clk);
    cs = 0;
    wr = 0;

    @(posedge clk);
    cs   = 1;
    wr   = 1;
    addr = 5'h0C;
    d_in = 16'd1;

    @(posedge clk);
    cs   = 0;
    wr   = 0;
    d_in = 0;

    wait(DUT.done);

    $display("--------------------------------");
    $display("Division terminada");
    $display("Q = %d", DUT.Q);


    @(posedge clk);
    cs   = 1;
    rd   = 1;
    addr = 5'h10;

    @(posedge clk);
    $display("d_out = %d", d_out);

    cs = 0;
    rd = 0;


    @(posedge clk);
    cs   = 1;
    rd   = 1;
    addr = 5'h14;

    @(posedge clk);
    $display("done = %d", d_out);

    #20;
    $finish;

end

endmodule
