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


// Registros

reg [4:0] s; //selector mux_4  and write registers
reg [15:0] Bin; //Numero binario
reg init;
wire [19:0] Bcd; //Numero decimal resultado
wire done;


// Address decoder

always @(*) begin
if(cs) begin
        case(addr)
            5'h04: s = 5'b00001;   // Bin
            5'h0C: s = 5'b00100;   // init
            5'h10: s = 5'b01000;   // Bcd
            5'h14: s = 5'b10000;   // done
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
        Bin  = 0;
        init = 0;
    end
    else begin 
      if (cs && wr) begin
        Bin  =s[0] ? d_in   : Bin;
        init =s[2] ? d_in[0]   :init; 
    end
  end
end


always @(posedge clk) begin//-----------------------mux_4 :  multiplexa salidas del periferico
  if(reset)
    d_out = 0;
  else 
  if (cs) begin
    case (s[4:0])
      5'b01000: d_out    =  {12'b0, Bcd};
//5'b01000: d_out    =  {16'b0, R};
      5'b10000: d_out    = {31'b0, done};
    endcase
  end
end

//------------------------------------------------
// Instancia del conversor bin2bcd
//------------------------------------------------

top_bin2bcd bin2bcd1(
    .rst(reset),
    .clk(clk),
    .start(init),
    .Bin_in(Bin),
    .BCD_out(Bcd),
    .ready(done)
 );

endmodule
