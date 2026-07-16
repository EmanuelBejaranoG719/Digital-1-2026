`timescale 1ns/1ps

module perip_bin2bcd_tb;

reg clk;
reg reset;
reg [15:0] d_in;
reg cs;
reg [4:0] addr;
reg rd;
reg wr;

wire [31:0] d_out;

//------------------------------------------------
// Instancia del periférico
//------------------------------------------------

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

//------------------------------------------------
// Clock
//------------------------------------------------

always #5 clk = ~clk;

//------------------------------------------------
// Simulación

initial begin

    $dumpfile("perip_bin2bcd.vcd");
    $dumpvars(0,perip_bin2bcd_tb);

    clk   = 0;
    reset = 1;
    cs    = 0;
    rd    = 0;
    wr    = 0;
    addr  = 0;
    d_in  = 0;


    #20;
    reset = 0;


// Escribir Bin = 156


    @(posedge clk);
    cs   = 1;
    wr   = 1;
    addr = 5'h04;
    d_in = 16'd156;

    @(posedge clk);
    cs   = 0;
    wr   = 0;


    @(posedge clk);
    cs   = 1;
    wr   = 1;
    addr = 5'h0C;
    d_in = 16'd1;

    @(posedge clk);
    cs   = 0;
    wr   = 0;

    @(posedge clk);
    cs   = 1;
    wr   = 1;
    addr = 5'h0C;
    d_in = 16'd0;

    @(posedge clk);
    cs   = 0;
    wr   = 0;

    
// Esperar done


    wait(uut.done);


// Leer resultado

    @(posedge clk);
    cs   = 1;
    rd   = 1;
    addr = 5'h10;

    @(posedge clk);

    $display("operación terminada");
    $display("Bin = %0d", uut.Bin);
    $display("BCD = %05h", d_out[19:0]);

    cs = 0;
    rd = 0;

 
// Segundo caso : 65535


    @(posedge clk);
    cs   = 1;
    wr   = 1;
    addr = 5'h04;
    d_in = 16'd65535;

    @(posedge clk);
    cs   = 0;
    wr   = 0;

    @(posedge clk);
    cs   = 1;
    wr   = 1;
    addr = 5'h0C;
    d_in = 16'd1;

    @(posedge clk);
    cs   = 0;
    wr   = 0;

    @(posedge clk);
    cs   = 1;
    wr   = 1;
    addr = 5'h0C;
    d_in = 16'd0;

    @(posedge clk);
    cs   = 0;
    wr   = 0;

    wait(uut.done);

    @(posedge clk);
    cs   = 1;
    rd   = 1;
    addr = 5'h10;

    @(posedge clk);

    $display("operación terminada");
    $display("Bin = %0d", uut.Bin);
    $display("BCD = %05h", d_out[19:0]);

    cs = 0;
    rd = 0;


 // Tercer caso : 10000


    @(posedge clk);
    cs   = 1;
    wr   = 1;
    addr = 5'h04;
    d_in = 16'd10000;

    @(posedge clk);
    cs   = 0;
    wr   = 0;

    @(posedge clk);
    cs   = 1;
    wr   = 1;
    addr = 5'h0C;
    d_in = 16'd1;

    @(posedge clk);
    cs   = 0;
    wr   = 0;

    @(posedge clk);
    cs   = 1;
    wr   = 1;
    addr = 5'h0C;
    d_in = 16'd0;

    @(posedge clk);
    cs   = 0;
    wr   = 0;

    wait(uut.done);

    @(posedge clk);
    cs   = 1;
    rd   = 1;
    addr = 5'h10;

    @(posedge clk);


    $display("operación terminada");
    $display("Bin = %0d", uut.Bin);
    $display("BCD = %05h", d_out[19:0]);

    cs = 0;
    rd = 0;

    #50;
    $finish;

end

endmodule
