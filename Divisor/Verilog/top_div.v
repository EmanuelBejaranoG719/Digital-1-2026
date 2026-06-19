module top_div #(parameter N = 16)(
    input  wire         clk, rst, start,
    input  wire [N-1:0] Dvd_in,
    input  wire [N-1:0] Dvs_in,
    output wire [N-1:0] Q_out,
    output wire [N-1:0] R_out,
    output wire         done
);
 
    wire LD, SHFT, SUB, Q0, Q1;


    wire [N-1:0] Dvd_q;       
    wire [N-1:0] Acm_q;       
    wire [N-1:0] Dvs_q;       
    wire [N-1:0] C_q;         
    wire         Dvd_MSB;     
    wire         Acm_geq_Dvs; 
    // ---- dividendo----
    div_sh_reg #(.N(N), .DIR(1)) Dvd_REG (
        .clk(clk), .rst(rst),
        .LD(LD), .SHFT(SHFT),
        .D(Dvd_in),
        .Q(Dvd_q),
        .MSB(Dvd_MSB), .LSB()
    );

    // ---- divisor ----
    div_sh_reg #(.N(N), .DIR(1)) Dvs_REG (
        .clk(clk), .rst(rst),
        .LD(LD), .SHFT(1'b0),
        .D(Dvs_in),
        .Q(Dvs_q),
        .MSB(), .LSB()
    );

    // ---- acumulador ----
    acm_reg #(.N(N)) Acm_REG (
        .clk(clk), .rst(rst),
        .LD(LD),
        .SHFT(SHFT),
        .SUB(SUB),
        .Dvd_MSB(Dvd_MSB),
        .Dvs(Dvs_q),
        .Q(Acm_q)
    );

    // ---- cociente ----
    reg_c #(.N(N)) C_REG (
        .clk(clk), .rst(rst),
        .LD(LD),
        .Q0(Q0),
        .Q1(Q1),
        .Q(C_q)
    );

    // ---- Comparador ----
    div_comp #(.N(N)) COMP (
        .Dvd(Acm_q), .Dvs(Dvs_q),
        .Z(), .N_out(Acm_geq_Dvs)
    );

    // ---- FSM ----
    Control_div #(.N(N)) FSM (
        .clk(clk), .rst(rst), .start(start),
        .N_in(Acm_geq_Dvs),
        .LD(LD), .SHFT(SHFT), .SUB(SUB), .Q0(Q0), .Q1(Q1),
        .DONE(done)
    );

    assign Q_out = C_q;
    assign R_out = Acm_q;
endmodule
