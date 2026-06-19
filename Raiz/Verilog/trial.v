module trial #(
    parameter WIDTH_RAD = 4
)(
    input  wire [WIDTH_RAD-1:0]   Rad,
    output wire [WIDTH_RAD+1:0]   Trial
);
    assign Trial = {Rad, 2'b01};
endmodule
