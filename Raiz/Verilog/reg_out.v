module reg_out #(
    parameter WIDTH_RAD = 4
)(
    input  wire                 clk,
    input  wire                 rst,
    input  wire                 load_out,
    input  wire [WIDTH_RAD-1:0] Rad,
    output reg  [WIDTH_RAD-1:0] raiz
);
    always @(posedge clk) begin
        if (rst)
            raiz <= {WIDTH_RAD{1'b0}};
        else if (load_out)
            raiz <= Rad;
    end
endmodule
