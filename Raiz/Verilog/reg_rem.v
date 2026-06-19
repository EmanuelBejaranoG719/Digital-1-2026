module reg_rem #(
    parameter WIDTH_REM = 10
)(
    input  wire                 clk,
    input  wire                 rst,
    input  wire                 init,
    input  wire                 en_calc,
    input  wire [WIDTH_REM-1:0] D_rem,
    output reg  [WIDTH_REM-1:0] Rem
);
    always @(posedge clk) begin
        if (rst)
            Rem <= {WIDTH_REM{1'b0}};
        else if (init)
            Rem <= {WIDTH_REM{1'b0}};
        else if (en_calc)
            Rem <= D_rem;
    end
endmodule
