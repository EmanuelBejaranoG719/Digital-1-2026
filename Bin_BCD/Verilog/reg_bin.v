
module reg_bin #(
    parameter WIDTH_BIN = 16
)(
    input  wire                   clk,
    input  wire                   rst,
    input  wire                   load_bin,
    input  wire                   en_calc,
    input  wire [WIDTH_BIN-1:0]   Bin_in,
    output reg  [WIDTH_BIN-1:0]   Bin
);
    always @(posedge clk) begin
        if (rst)
            Bin <= {WIDTH_BIN{1'b0}};
        else if (load_bin)
            Bin <= Bin_in;
        else if (en_calc)
            Bin <= {Bin[WIDTH_BIN-2:0], 1'b0};  //saca el MSB hacia Bcd, entra 0
    end
endmodule
