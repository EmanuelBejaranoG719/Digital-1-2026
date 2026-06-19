// =============================================================
// Module: shift_register
// Description: N-bit register with parallel load and shift.
//   DIR=1 → left  shift (X REG: X << 1)
//   DIR=0 → right shift (Y REG: Y >> 1, LSB disponible)
// =============================================================
module shift_register #(
    parameter N   = 16,
    parameter DIR = 0
)(
    input  wire         clk,
    input  wire         rst,
    input  wire         LD,
    input  wire         SHIFT,
    input  wire [N-1:0] D,
    output reg  [N-1:0] Q,
    output wire         LSB
);
    assign LSB = Q[0];

    always @(negedge clk or posedge rst) begin
        if (rst)        Q <= {N{1'b0}};
        else if (LD)    Q <= D;
        else if (SHIFT) begin
            if (DIR == 1) Q <= {Q[N-2:0], 1'b0};   // X << 1
            else          Q <= {1'b0, Q[N-1:1]};    // Y >> 1
        end
    end
endmodule

