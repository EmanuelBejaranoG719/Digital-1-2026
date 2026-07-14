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
parameter WIDTH_BCD = 20;

reg                   clk;
reg                   rst;
reg                   start;
reg  [WIDTH_BIN-1:0]  Bin_in;

wire [WIDTH_BCD-1:0] BCD_out;
wire                 ready;


wire [3:0] dec_mil;
wire [3:0] mil;
wire [3:0] cent;
wire [3:0] decs;
wire [3:0] unit;

assign dec_mil = BCD_out[19:16];
assign mil     = BCD_out[15:12];
assign cent    = BCD_out[11:8];
assign decs    = BCD_out[7:4];
assign unit    = BCD_out[3:0];


top_bin2bcd #(
    .WIDTH_BIN(WIDTH_BIN),
    .WIDTH_BCD(WIDTH_BCD)
) UUT (
    .clk(clk),
    .rst(rst),
    .start(start),
    .Bin_in(Bin_in),
    .BCD_out(BCD_out),
    .ready(ready)
);

//--------------------------------------------------
// Clock
//--------------------------------------------------

always #5 clk = ~clk;

//--------------------------------------------------
// Estímulos
//--------------------------------------------------

initial begin

    $dumpfile("tb_bin2bcd.vcd");
    $dumpvars(0,tb_bin2bcd);

    clk   = 0;
    rst   = 1;
    start = 0;
    Bin_in = 0;

    #20;
    rst = 0;

    //--------------------------------------------------
    // Caso 1 : 156
    //--------------------------------------------------

    #10;
    Bin_in = 16'd156;
    start  = 1;
    #10;
    start  = 0;

    wait(ready);

    #1;
    $display("------------------------");
    $display("Bin_in = 156");
    $display("Esperado : 0 0 1 5 6");
    $display("Obtenido : %0d %0d %0d %0d %0d",
             dec_mil,mil,cent,decs,unit);

    //--------------------------------------------------
    // Reset
    //--------------------------------------------------

    #20;
    rst = 1;
    #10;
    rst = 0;

    //--------------------------------------------------
    // Caso 2 : 65535
    //--------------------------------------------------

    #10;
    Bin_in = 16'd65535;
    start  = 1;
    #10;
    start  = 0;

    wait(ready);

    #1;
    $display("------------------------");
    $display("Bin_in = 65535");
    $display("Esperado : 6 5 5 3 5");
    $display("Obtenido : %0d %0d %0d %0d %0d",
             dec_mil,mil,cent,decs,unit);

    //--------------------------------------------------
    // Reset
    //--------------------------------------------------

    #20;
    rst = 1;
    #10;
    rst = 0;

    //--------------------------------------------------
    // Caso 3 : 10000
    //--------------------------------------------------

    #10;
    Bin_in = 16'd10000;
    start  = 1;
    #10;
    start  = 0;

    wait(ready);

    #1;
    $display("------------------------");
    $display("Bin_in = 10000");
    $display("Esperado : 1 0 0 0 0");
    $display("Obtenido : %0d %0d %0d %0d %0d",
             dec_mil,mil,cent,decs,unit);

    //--------------------------------------------------
    // Reset
    //--------------------------------------------------

    #20;
    rst = 1;
    #10;
    rst = 0;

    //--------------------------------------------------
    // Caso 4 : 0
    //--------------------------------------------------

    #10;
    Bin_in = 16'd0;
    start  = 1;
    #10;
    start  = 0;

    wait(ready);

    #1;
    $display("------------------------");
    $display("Bin_in = 0");
    $display("Esperado : 0 0 0 0 0");
    $display("Obtenido : %0d %0d %0d %0d %0d",
             dec_mil,mil,cent,decs,unit);

    //--------------------------------------------------
    // Finalizar simulación
    //--------------------------------------------------

    #20;
    $finish;

end

endmodule
