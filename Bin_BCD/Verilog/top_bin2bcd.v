// top_bin2bcd.v

module top_bin2bcd #(
    parameter WIDTH_BIN = 16,
    parameter WIDTH_BCD = 20,
    parameter N_SHIFTS  = WIDTH_BIN
)(
    input  wire                   clk,
    input  wire                   rst,
    input  wire                   start,
    input  wire [WIDTH_BIN-1:0]   Bin_in,
    output wire [3:0]             dec_mil,
    output wire [3:0]             mil,
    output wire [3:0]             cent,
    output wire [3:0]             decs,
    output wire [3:0]             unit,
    output wire                   ready
);

    //señales de control
    wire load_bin, init, en_calc, decr, load_out;


    wire [WIDTH_BIN-1:0]          Bin;
    wire [WIDTH_BCD-1:0]          Bcd;
    wire [$clog2(N_SHIFTS)-1:0]   Cont;
    wire                          done_cnt;

    wire [WIDTH_BCD-1:0] Bcd_fix;
    add_fix #(.WIDTH_BCD(WIDTH_BCD)) u_add3 (
        .Bcd_in  (Bcd),
        .Bcd_fix (Bcd_fix)
    );

    wire [WIDTH_BCD-1:0] Bcd_sh = {Bcd_fix[WIDTH_BCD-2:0], Bin[WIDTH_BIN-1]};

    //FSM del conversor
    bin2bcd_fsm u_fsm (
        .clk      (clk),
        .rst      (rst),
        .start    (start),
        .done     (done_cnt),
        .load_bin (load_bin),
        .init     (init),
        .en_calc  (en_calc),
        .decr     (decr),
        .load_out (load_out),
        .ready    (ready)
    );

    //contador de iteraciones
    cont_shift #(.N_SHIFTS(N_SHIFTS)) u_cont (
        .clk  (clk),
        .rst  (rst),
        .init (init),
        .decr (decr),
        .Cont (Cont),
        .done (done_cnt)
    );


// registro del binario de entrada 
    reg_bin #(.WIDTH_BIN(WIDTH_BIN)) u_reg_bin (
        .clk      (clk),
        .rst      (rst),
        .load_bin (load_bin),
        .en_calc  (en_calc),
        .Bin_in   (Bin_in),
        .Bin      (Bin)
    );
// registro
    reg_bcd #(.WIDTH_BCD(WIDTH_BCD)) u_reg_bcd (
        .clk      (clk),
        .rst      (rst),
        .init     (init),
        .en_calc  (en_calc),
        .Bcd_next (Bcd_sh),   
        .Bcd      (Bcd)
    );


    wire [WIDTH_BCD-1:0] Result;
    reg_bcd_out #(.WIDTH_BCD(WIDTH_BCD)) u_reg_out (
        .clk      (clk),
        .rst      (rst),
        .load_out (load_out),
        .Bcd      (Bcd),
        .Result   (Result)
    );


    assign dec_mil = Result[19:16];
    assign mil     = Result[15:12];
    assign cent    = Result[11:8];
    assign decs    = Result[7:4];
    assign unit    = Result[3:0];

endmodule
