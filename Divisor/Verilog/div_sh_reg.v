//   DIR=1 → left shift
//   DIR=0 → right shift
//   LD    → carga paralela desde D
//   SHFT  → desplaza un bit

module div_sh_reg #(
    parameter N   = 16,
    parameter DIR = 1
)(
    input  wire         clk, rst,
    input  wire         LD, SHFT,
    input  wire [N-1:0] D,
    output reg  [N-1:0] Q,
    output wire         MSB,
    output wire         LSB
);
    assign MSB = Q[N-1];
    assign LSB = Q[0];

    always @(negedge clk or posedge rst) begin
        if (rst)       Q <= {N{1'b0}};
        else if (LD)   Q <= D;
        else if (SHFT) Q <= (DIR==1) ? {Q[N-2:0], 1'b0} : {1'b0, Q[N-1:1]};
    end
endmodule

