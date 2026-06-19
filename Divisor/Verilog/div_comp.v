module div_comp #(
    parameter N = 16
)(
    input  wire [N-1:0] Dvd, Dvs,
    output wire         Z,
    output wire         N_out
);
    assign Z     = (Dvd == Dvs);
    assign N_out = (Dvd >= Dvs);
endmodule

