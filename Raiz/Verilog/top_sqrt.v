module top_sqrt #(
    parameter WIDTH_N   = 16,
    parameter WIDTH_RAD = WIDTH_N / 2,
    parameter WIDTH_REM = WIDTH_N + 2,
    parameter N_PAIRS   = WIDTH_N / 2
)(
    input  wire                 clk,
    input  wire                 rst,
    input  wire                 start,
    input  wire [WIDTH_N-1:0]   N_in,
    output wire [WIDTH_RAD-1:0] raiz,
    output wire                 ready
);

    // ---- señales de control (FSM -> datapath) ----
    wire load_n, init, en_calc, decr, load_out;

    // ---- señales de datapath ----
    wire [WIDTH_N-1:0]          N;
    wire [WIDTH_REM-1:0]        Rem;
    wire [WIDTH_RAD-1:0]        Rad;
    wire [$clog2(N_PAIRS)-1:0]  C;
    wire                        done_cnt;

    // ---- par de bits actual: N[2C+1 : 2C] ----
    wire [1:0] pair = N >> (C * 2);

    // ---- residuo desplazado con el par entrante ----
    wire [WIDTH_REM-1:0] Rem_sh = (Rem << 2) | {{(WIDTH_REM-2){1'b0}}, pair};

    // ---- candidato Trial = {Rad, 2'b01} ----
    wire [WIDTH_RAD+1:0] Trial_w;
    trial #(.WIDTH_RAD(WIDTH_RAD)) u_trial (
        .Rad   (Rad),
        .Trial (Trial_w)
    );

    // ---- resta: Rem_sh - Trial ----
    wire [WIDTH_REM-1:0] Rem_next;
    wire                 borrow;
    wire                 update;   // 1 si Rem_sh >= Trial (bit de raiz = 1)
    sub #(.WIDTH(WIDTH_REM)) u_sub (
        .Rem      (Rem_sh),
        .Trial    ({{(WIDTH_REM-WIDTH_RAD-2){1'b0}}, Trial_w}),
        .Rem_next (Rem_next),
        .borrow   (borrow),
        .update   (update)
    );

    // ---- mux restaurador ----
    wire [WIDTH_REM-1:0] D_rem = update ? Rem_next : Rem_sh;

    // ---- FSM de control ----
    // NOTA: sel_rad ya NO es output de la FSM. 'update' llega
    // directamente a reg_rad como sel_rad (wire combinacional),
    // eliminando el desfase de 1 ciclo que causaba raiz=0.
    cont_sqrt u_fsm (
        .clk      (clk),
        .rst      (rst),
        .start    (start),
        .done     (done_cnt),
        .load_n   (load_n),
        .init     (init),
        .en_calc  (en_calc),
        .decr     (decr),
        .load_out (load_out),
        .ready    (ready)
    );

    // ---- contador de iteraciones ----
    cont #(.N_PAIRS(N_PAIRS)) u_cont (
        .clk  (clk),
        .rst  (rst),
        .init (init),
        .decr (decr),
        .C    (C),
        .done (done_cnt)
    );

    // ---- registro del radicando N ----
    reg_n #(.WIDTH_N(WIDTH_N)) u_reg_n (
        .clk    (clk),
        .rst    (rst),
        .load_n (load_n),
        .N_in   (N_in),
        .N      (N)
    );

    // ---- registro del residuo parcial Rem ----
    reg_rem #(.WIDTH_REM(WIDTH_REM)) u_reg_rem (
        .clk     (clk),
        .rst     (rst),
        .init    (init),
        .en_calc (en_calc),
        .D_rem   (D_rem),
        .Rem     (Rem)
    );

    // ---- registro de la raiz parcial Rad ----
    // sel_rad = update (wire combinacional directo, sin pasar por FSM)
    reg_rad #(.WIDTH_RAD(WIDTH_RAD)) u_reg_rad (
        .clk     (clk),
        .rst     (rst),
        .init    (init),
        .en_calc (en_calc),
        .sel_rad (update),   // <-- directo desde sub, no desde FSM
        .Rad     (Rad)
    );

    // ---- registro de salida ----
    reg_out #(.WIDTH_RAD(WIDTH_RAD)) u_reg_out (
        .clk      (clk),
        .rst      (rst),
        .load_out (load_out),
        .Rad      (Rad),
        .raiz     (raiz)
    );

endmodule
