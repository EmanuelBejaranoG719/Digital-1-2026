// Module: div_fsm
module Control_div #(parameter N = 16)(
    input  wire clk,
    input  wire rst,
    input  wire start,
    input  wire N_in,      
    output reg  LD,       
    output reg  SHFT,      
    output reg  SUB,       
    output reg  Q0,       
    output reg  Q1,       
    output reg  DONE
);

    localparam [2:0]
        S_IDLE  = 3'd0,
        S_LOAD  = 3'd1,
        S_WAIT  = 3'd2,
        S_SHIFT = 3'd3,
        S_CHECK = 3'd4,
        S_DONE  = 3'd5;

    localparam CNT_W = 5;         

    reg [2:0]      state;
    reg [CNT_W-1:0] cnt;

// Valores iniciales

    initial begin
        LD    = 0;
        SHFT  = 0;
        SUB   = 0;
        Q0    = 0;
        Q1    = 0;
        DONE  = 0;
        state = S_IDLE;
        cnt   = 0;
    end


    always @(posedge clk) begin
        if (rst) begin
            state <= S_IDLE;
        end
        else begin
            case (state)

                S_IDLE: begin
                    LD   <= 0;
                    SHFT <= 0;
                    SUB  <= 0;
                    Q0   <= 0;
                    Q1   <= 0;
                    DONE <= 0;
                    cnt  <= 0;
                    if (start)
                        state <= S_LOAD;
                    else
                        state <= S_IDLE;
                end

                S_LOAD: begin
                    LD   <= 1;
                    SHFT <= 0;
                    SUB  <= 0;
                    Q0   <= 0;
                    Q1   <= 0;
                    DONE <= 0;
                    state <= S_WAIT;
                end

                S_WAIT: begin
                    LD   <= 0;
                    SHFT <= 0;
                    SUB  <= 0;
                    Q0   <= 0;
                    Q1   <= 0;
                    DONE <= 0;
                    state <= S_SHIFT;
                end

                S_SHIFT: begin
                    LD   <= 0;
                    SHFT <= 1;
                    SUB  <= 0;
                    Q0   <= 0;
                    Q1   <= 0;
                    DONE <= 0;
                    state <= S_CHECK;
                end

                S_CHECK: begin
                    LD   <= 0;
                    SHFT <= 0;
                    DONE <= 0;
                    if (N_in) begin
                        // Acm >= Dvs: restar y meter 1 al cociente
                        SUB <= 1;
                        Q1  <= 1;
                        Q0  <= 0;
                    end
                    else begin
                        // Acm < Dvs: NO restar y meter 0 al cociente
                        SUB <= 0;
                        Q1  <= 0;
                        Q0  <= 1;
                    end

                    if (cnt == N-1) begin
                        state <= S_DONE;
                    end
                    else begin
                        state <= S_SHIFT;
                        cnt   <= cnt + 1'b1;
                    end
                end

                S_DONE: begin
                    LD    <= 0;
                    SHFT  <= 0;
                    SUB   <= 0;
                    Q0    <= 0;
                    Q1    <= 0;
                    DONE  <= 1;
                    state <= S_IDLE;   // un solo ciclo de DONE
                end

                default: state <= S_IDLE;

            endcase
        end
    end

`ifdef BENCH
    reg [8*40:1] state_name;
    always @(*) begin
        case (state)
            S_IDLE  : state_name = "IDLE";
            S_LOAD  : state_name = "LOAD";
            S_WAIT  : state_name = "WAIT";
            S_SHIFT : state_name = "SHIFT";
            S_CHECK : state_name = "CHECK";
            S_DONE  : state_name = "DONE";
        endcase
    end
`endif

endmodule
