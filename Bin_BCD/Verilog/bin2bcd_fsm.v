module bin2bcd_fsm (
    input  wire clk,
    input  wire rst,
    input  wire start,
    input  wire done,
    output reg  load_bin,
    output reg  init,
    output wire en_calc,   
    output wire decr,      
    output reg  load_out,
    output reg  ready
);
    localparam [2:0]
        S_IDLE = 3'd0,
        S_INIT = 3'd1,
        S_WAIT= 3'd2,
        S_CALC = 3'd3,
        S_DONE = 3'd4,
        S_OUT  = 3'd5;

    reg [2:0] state;

    assign en_calc = (state == S_CALC);
    assign decr    = (state == S_CALC);

    initial begin
        load_bin = 0;
        init     = 0;
        load_out = 0;
        ready    = 0;
        state    = S_IDLE;
    end

    always @(posedge clk) begin
        if (rst) begin
            state    <= S_IDLE;
            load_bin <= 0;
            init     <= 0;
            load_out <= 0;
            ready    <= 0;
        end
        else begin
            case (state)

                S_IDLE: begin
                    load_bin <= 0;
                    init     <= 0;
                    load_out <= 0;
                    ready    <= 0;
                    if (start)
                        state <= S_INIT;
                    else
                        state <= S_IDLE;
                end

                S_INIT: begin
                    load_bin <= 1;
                    init     <= 1;
                    load_out <= 0;
                    ready    <= 0;
                    state    <= S_WAIT;
                end

                S_WAIT: begin

                    load_bin <= 0;
                    init     <= 0;
                    load_out <= 0;
                    ready    <= 0;
                    state    <= S_CALC;
                end

                S_CALC: begin

                    load_bin <= 0;
                    init     <= 0;
                    load_out <= 0;
                    ready    <= 0;
                    if (done)
                        state <= S_DONE;
                    else
                        state <= S_CALC;
                end


                S_DONE: begin
                    load_bin <= 0;
                    init     <= 0;
                    load_out <= 1;
                    ready    <= 0;
                    state    <= S_OUT;
                end

                S_OUT: begin
                    load_bin <= 0;
                    init     <= 0;
                    load_out <= 0;
                    ready    <= 1;
                    state    <= S_IDLE;
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
            S_INIT  : state_name = "INIT";
            S_WAIT  : state_name = "WAIT";
            S_CALC  : state_name = "CALC";
            S_DONE  : state_name = "DONE";
            S_OUT   : state_name = "OUT";
        endcase
    end
`endif

endmodule
