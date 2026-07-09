
module reg_bcd_out #(
    parameter WIDTH_BCD = 20
)(
    input  wire                   clk,
    input  wire                   rst,
    input  wire                   load_out,
    input  wire [WIDTH_BCD-1:0]   Bcd,
    output reg  [WIDTH_BCD-1:0]   Result
);
    always @(posedge clk) begin
        if (rst)
            Result <= {WIDTH_BCD{1'b0}};    // limpia la salida
        else if (load_out)
            Result <= Bcd;     // captura Bcd cuando la FSM indica que ya termino
    end
endmodule
