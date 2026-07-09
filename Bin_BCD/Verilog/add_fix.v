//   Bcd_in[19:16] = dec_mil
//   Bcd_in[15:12] = mil
//   Bcd_in[11:8]  = cent
//   Bcd_in[7:4]   = decs
//   Bcd_in[3:0]   = unit

module add_fix #(
    parameter WIDTH_BCD = 20
)(
    input  wire [WIDTH_BCD-1:0] Bcd_in,
    output wire [WIDTH_BCD-1:0] Bcd_fix
);
    wire [3:0] unit_in      = Bcd_in[3:0];
    wire [3:0] decs_in       = Bcd_in[7:4];
    wire [3:0] cent_in      = Bcd_in[11:8];
    wire [3:0] mil_in         = Bcd_in[15:12];
    wire [3:0] dec_mil_in    = Bcd_in[19:16];

    wire [3:0] unit_fix   = (unit_in   >= 5) ? (unit_in   + 4'd3) : unit_in;
    wire [3:0] decs_fix    = (decs_in    >= 5) ? (decs_in    + 4'd3) : decs_in;
    wire [3:0] cent_fix   = (cent_in   >= 5) ? (cent_in   + 4'd3) : cent_in;
    wire [3:0] mil_fix      = (mil_in      >= 5) ? (mil_in      + 4'd3) : mil_in;
    wire [3:0] dec_mil_fix = (dec_mil_in >= 5) ? (dec_mil_in + 4'd3) : dec_mil_in;

    assign Bcd_fix = {dec_mil_fix, mil_fix, cent_fix, decs_fix, unit_fix};

endmodule
