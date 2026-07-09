
module reg_bcd #(
    parameter WIDTH_BCD = 20
)(
    input  wire                   clk,
    input  wire                   rst,
    input  wire                   init,      // habilitado en S_INIT
    input  wire                   en_calc,   // habilitado en S_CALC
    input  wire [WIDTH_BCD-1:0]   Bcd_next,
    output reg  [WIDTH_BCD-1:0]   Bcd
);
    always @(posedge clk) begin
        if (rst)
            Bcd <= {WIDTH_BCD{1'b0}};        // reset que limpia los 5 nibbles
        else if (init)
            Bcd <= {WIDTH_BCD{1'b0}};
        else if (en_calc)
            Bcd <= Bcd_next;                 // captura el valor BCD corregido y shifteado
    end
endmodule
