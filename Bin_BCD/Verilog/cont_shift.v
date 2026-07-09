
module cont_shift #(
    parameter N_SHIFTS = 16
)(
    input  wire                          clk,
    input  wire                          rst,
    input  wire                          init,
    input  wire                          decr,
    output reg  [$clog2(N_SHIFTS)-1:0]   Cont,
    output wire                          done
);
    localparam W        = $clog2(N_SHIFTS);
    localparam INIT_VAL = N_SHIFTS - 1;

    always @(posedge clk) begin
        if (rst)
            Cont <= {W{1'b0}};
        else if (init)
            Cont <= INIT_VAL[W-1:0];
        else if (decr && Cont != 0)
            Cont <= Cont - 1'b1;
    end

    assign done = (Cont == 0);

endmodule
