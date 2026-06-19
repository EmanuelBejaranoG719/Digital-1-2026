// =============================================================
// Module: accumulator
// Description: N-bit accumulator (R).
//   LD  = 1 → R = 0
//   ADD = 1 → R = R + A_in
// =============================================================
module accumulator #(
    parameter N = 16
)(
    input  wire         clk,
    input  wire         rst,
    input  wire         LD,
    input  wire         ADD,
    input  wire [N-1:0] X_in,
    output reg  [N-1:0] Q
);
    always @(negedge clk or posedge rst) begin
        if (rst)       Q <= {N{1'b0}};
        else if (LD)   Q <= {N{1'b0}};
        else if (ADD)  Q <= Q + X_in;
    end
endmodule

