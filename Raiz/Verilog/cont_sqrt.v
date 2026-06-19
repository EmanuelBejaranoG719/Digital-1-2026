module cont_sqrt (
    input  wire clk,
    input  wire rst,
    input  wire start,
    input  wire done,
    output reg  load_n,
    output reg  init,
    output reg  en_calc,
    output reg  decr,
    output reg  load_out,
    output reg  ready
);

    localparam [2:0]
        S_IDLE  = 3'd0,
        S_INIT  = 3'd1,
        S_WAIT1 = 3'd2,
        S_CALC  = 3'd3,
        S_WAIT2 = 3'd4,
        S_DONE  = 3'd5,
        S_OUT   = 3'd6;

    reg [2:0] state;

    initial begin
        load_n   = 0;
        init     = 0;
        en_calc  = 0;
        decr     = 0;
        load_out = 0;
        ready    = 0;
        state    = S_IDLE;
    end

    always @(posedge clk) begin
        if (rst) begin
            state    <= S_IDLE;
            load_n   <= 0;
            init     <= 0;
            en_calc  <= 0;
            decr     <= 0;
            load_out <= 0;
            ready    <= 0;
        end
        else begin
            case (state)

                S_IDLE: begin
                    load_n   <= 0;
                    init     <= 0;
                    en_calc  <= 0;
                    decr     <= 0;
                    load_out <= 0;
                    ready    <= 0;
                    if (start)
                        state <= S_INIT;
                    else
                        state <= S_IDLE;
                end

                S_INIT: begin
                    load_n   <= 1;
                    init     <= 1;
                    en_calc  <= 0;
                    decr     <= 0;
                    load_out <= 0;
                    ready    <= 0;
                    state    <= S_WAIT1;
                end

                S_WAIT1: begin
                    load_n   <= 0;
                    init     <= 0;
                    en_calc  <= 0;
                    decr     <= 0;
                    load_out <= 0;
                    ready    <= 0;
                    state    <= S_CALC;
                end

                S_CALC: begin
                    load_n   <= 0;
                    init     <= 0;
                    // Cuando done=1 este es el último par: el en_calc=1
                    // que SALE este ciclo (asignado en el ciclo anterior)
                    // ya procesa C=0 correctamente en reg_rad.
                    // Asignamos en_calc<=0 para que en S_WAIT2 salga 0
                    // y reg_rad no haga un shift extra.
                    en_calc  <= done ? 1'b0 : 1'b1;
                    decr     <= done ? 1'b0 : 1'b1;
                    load_out <= 0;
                    ready    <= 0;
                    if (done)
                        state <= S_WAIT2;
                    else
                        state <= S_CALC;
                end

                S_WAIT2: begin
                    // en_calc sale 0 (asignado en último S_CALC) → sin shift extra
                    // Rad tiene el valor final correcto
                    load_n   <= 0;
                    init     <= 0;
                    en_calc  <= 0;
                    decr     <= 0;
                    load_out <= 0;
                    ready    <= 0;
                    state    <= S_DONE;
                end

                S_DONE: begin
                    // load_out sale 1 → reg_out captura Rad este flanco ✓
                    load_n   <= 0;
                    init     <= 0;
                    en_calc  <= 0;
                    decr     <= 0;
                    load_out <= 1;
                    ready    <= 0;
                    state    <= S_OUT;
                end

                S_OUT: begin
                    // raiz estable → ready sale 1, TB puede leer
                    load_n   <= 0;
                    init     <= 0;
                    en_calc  <= 0;
                    decr     <= 0;
                    load_out <= 0;
                    ready    <= 1;
                    state    <= S_IDLE;
                end

                default: state <= S_IDLE;

            endcase
        end
    end

`ifdef BENCH
    reg [8*6:1] state_name;
    always @(*) begin
        case (state)
            S_IDLE  : state_name = "IDLE  ";
            S_INIT  : state_name = "INIT  ";
            S_WAIT1 : state_name = "WAIT1 ";
            S_CALC  : state_name = "CALC  ";
            S_WAIT2 : state_name = "WAIT2 ";
            S_DONE  : state_name = "DONE  ";
            S_OUT   : state_name = "OUT   ";
            default : state_name = "???   ";
        endcase
    end
`endif

endmodule
