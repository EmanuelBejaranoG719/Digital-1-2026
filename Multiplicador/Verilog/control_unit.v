
module control_unit(
    input  wire clk,
    input  wire rst,
    input  wire start,    
    input  wire Y_LSB,   
    input  wire Y_ZERO,   
    output reg  LD,       
    output reg  SHIFT,    
    output reg  ADD,
    output reg  DONE      
);

    localparam [2:0]
        S_START = 3'd0,
        S_CHECK = 3'd1,
        S_ADD   = 3'd2,
        S_SHIFT = 3'd3,
        S_END   = 3'd4;

    localparam [4:0] HOLD_CYCLES = 5'd20;

    reg [2:0] state;
    reg [4:0] count;


    initial begin
        DONE  = 0;
        SHIFT = 0;
        LD    = 0;
        ADD   = 0;
        state = S_START;
        count = 0;
    end


    always @(posedge clk) begin
        if (rst) begin
            state <= S_START;
        end
        else begin
            case (state)

                S_START: begin
                    DONE  <= 0;
                    SHIFT <= 0;
                    LD    <= 1;   // reset/carga del datapath
                    ADD   <= 0;
                    count <= 5'd0;
                    if (start)
                        state <= S_CHECK;
                    else
                        state <= S_START;
                end

                S_CHECK: begin
                    DONE  <= 0;
                    SHIFT <= 0;
                    LD    <= 0;
                    ADD   <= 0;
                    if (Y_LSB)
                        state <= S_ADD;
                    else
                        state <= S_SHIFT;
                end

                S_ADD: begin
                    DONE  <= 0;
                    SHIFT <= 0;
                    LD    <= 0;
                    ADD   <= 1;
                    state <= S_SHIFT;
                end

                S_SHIFT: begin
                    DONE  <= 0;
                    SHIFT <= 1;
                    LD    <= 0;
                    ADD   <= 0;
                    if (Y_ZERO)
                        state <= S_END;
                    else
                        state <= S_CHECK;
                end

                S_END: begin
                    DONE  <= 1;
                    SHIFT <= 0;
                    LD    <= 0;
                    ADD   <= 0;
                    count <= count + 1'b1;
                    state <= (count > HOLD_CYCLES) ? S_START : S_END;
                end

                default: state <= S_START;

            endcase
        end
    end


`ifdef BENCH
    reg [8*40:1] state_name;
    always @(*) begin
        case (state)
            S_START : state_name = "START";
            S_CHECK : state_name = "CHECK";
            S_ADD   : state_name = "ADD";
            S_SHIFT : state_name = "SHIFT";
            S_END   : state_name = "END";
        endcase
    end
`endif

endmodule



