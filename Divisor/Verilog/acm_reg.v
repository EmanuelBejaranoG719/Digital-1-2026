module acm_reg #(
    parameter N = 16
)(
    input  wire         clk, rst,
    input  wire         LD,
    input  wire         SHFT,
    input  wire         SUB,
    input  wire         Dvd_MSB,
    input  wire [N-1:0] Dvs,
    output reg  [N-1:0] Q
);
    always @(negedge clk or posedge rst) begin
        if (rst)       Q <= {N{1'b0}};
        else if (LD)   Q <= {N{1'b0}};
        else if (SHFT) Q <= {Q[N-2:0], Dvd_MSB};
        else if (SUB)  Q <= Q - Dvs;
    end
endmodule
