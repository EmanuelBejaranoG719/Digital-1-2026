module peripheral_test(
    input clk,
    input reset,
    input [15:0] d_in,
    input cs,
    input [4:0] addr,
    input rd,
    input wr,
    output reg [31:0] d_out
);

//------------------------------------------------
// Registros
//------------------------------------------------

reg [4:0] s;

reg [15:0] Bin;
reg init;

wire [19:0] BCD;
wire ready;

//------------------------------------------------
// Address decoder
//------------------------------------------------

always @(*) begin
    if(cs) begin
        case(addr)
            5'h04: s = 5'b00001;   // Bin
            5'h08: s = 5'b00010;   // start
            5'h0C: s = 5'b00100;   // BCD_out
            5'h10: s = 5'b01000;   // ready
            default: s = 5'b00000;
        endcase
    end
    else
        s = 5'b00000;
end

//------------------------------------------------
// Escritura
//------------------------------------------------

always @(posedge clk) begin

    if(reset) begin
        Bin  <= 16'd0;
        init <= 1'b0;
    end
    else if(cs && wr) begin

        if(s[0])
            Bin <= d_in;

        if(s[1])
            init <= d_in[0];

    end

end

//------------------------------------------------
// Lectura
//------------------------------------------------

always @(posedge clk) begin

    if(reset)
        d_out <= 32'd0;

    else if(cs && rd) begin

        case(s)

            5'b00100:
                d_out <= {12'd0,BCD};

            5'b01000:
                d_out <= {31'd0,ready};

            default:
                d_out <= 32'd0;

        endcase

    end

end

//------------------------------------------------
// Instancia del algoritmo
//------------------------------------------------

top_bin2bcd uut(

    .clk(clk),
    .rst(reset),
    .start(init),
    .Bin_in(Bin),
    .BCD_out(BCD),
    .ready(ready)

);

endmodule
