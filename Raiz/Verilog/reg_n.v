module reg_n #(
    parameter WIDTH_N = 8
)(
    input  wire               clk,
    input  wire               rst,
    input  wire               load_n,
    input  wire [WIDTH_N-1:0] N_in,
    output reg  [WIDTH_N-1:0] N
);
    always @(posedge clk) begin
        if (rst)
            N <= {WIDTH_N{1'b0}};
        else if (load_n)
            N <= N_in;
    end
endmodule
