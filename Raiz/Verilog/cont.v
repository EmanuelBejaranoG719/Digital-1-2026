module cont #(
    parameter N_PAIRS = 4
)(
    input  wire                       clk,
    input  wire                       rst,
    input  wire                       init,
    input  wire                       decr,
    output reg  [$clog2(N_PAIRS)-1:0] C,
    output wire                       done
);
    localparam W        = $clog2(N_PAIRS);
    localparam INIT_VAL = N_PAIRS - 1;

    always @(posedge clk) begin
        if (rst)
            C <= {W{1'b0}};
        else if (init)
            C <= INIT_VAL[W-1:0];
        else if (decr && C != 0)
            C <= C - 1'b1;
 
    end

    assign done = (C == 0);

endmodule
