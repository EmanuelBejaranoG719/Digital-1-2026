//   LD  → clear a 0
//   Q0  → entra 0 (Acm < Dvs)
//   Q1  → entra 1 (Acm >= Dvs)

module reg_c #(
    parameter N = 16
)(
    input  wire         clk, rst,
    input  wire         LD, Q0, Q1,
    output reg  [N-1:0] Q
);
    always @(negedge clk or posedge rst) begin
        if (rst)     Q <= {N{1'b0}};
        else if (LD) Q <= {N{1'b0}};
        else if (Q1) Q <= {Q[N-2:0], 1'b1};
        else if (Q0) Q <= {Q[N-2:0], 1'b0};
    end
endmodule
