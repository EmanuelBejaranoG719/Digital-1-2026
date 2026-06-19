module sub #(
    parameter WIDTH = 10
)(
    input  wire [WIDTH-1:0] Rem,
    input  wire [WIDTH-1:0] Trial,
    output wire [WIDTH-1:0] Rem_next,
    output wire             borrow,
    output wire             update
);
    wire [WIDTH:0] result;

    assign result   = {1'b0, Rem} - {1'b0, Trial};
    assign borrow   = result[WIDTH];   
    assign Rem_next = result[WIDTH-1:0];
    assign update   = ~borrow;          // Rem >= Trial
endmodule
