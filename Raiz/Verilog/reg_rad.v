module reg_rad #(
    parameter WIDTH_RAD = 4
)(
    input  wire                 clk,
    input  wire                 rst,
    input  wire                 init,
    input  wire                 en_calc, // activo solo en CALC
    input  wire                 sel_rad,
    output reg  [WIDTH_RAD-1:0] Rad
);
    always @(posedge clk) begin
        if (rst)
            Rad <= {WIDTH_RAD{1'b0}};
        else if (init)
            Rad <= {WIDTH_RAD{1'b0}};
        else if (en_calc)
            Rad <= {Rad[WIDTH_RAD-2:0], sel_rad};
    end
endmodule
