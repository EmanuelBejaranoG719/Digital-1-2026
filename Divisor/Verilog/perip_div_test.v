module peripheral_test(clk , reset , d_in , cs , addr , rd , wr, d_out );
  
  input clk;
  input reset;
  input [15:0] d_in;
  input cs;
  input [4:0]  addr; // 4 LSB from j1_io_addr
  input rd;
  input wr;
  output reg [31:0]d_out;

//------------------------------------ regs and wires-------------------------------
reg [5:0] s; 	//selector mux_4  and write registers
reg [15:0] Dvd; //Dividendo
reg [15:0] Dvs; //Divisor
reg init;
wire [15:0] Q;	//Cociente
wire [15:0] R; // Restos
wire done;
//------------------------------------ regs and wires-------------------------------
always @(*) begin//------address_decoder------------------------------
if (cs) begin
  case (addr)
    5'h04: s =  6'b100000; // Dvd
    5'h08: s =  6'b100000; // Dvs
    5'h0C: s =  6'b100000; // init
    5'h10: s =  6'b100000; // Q : Cociente
    5'h14: s =  6'b100000; // R : Restos
    5'h18: s =  6'b100000; // Done
    default: s = 6'b000000;
  endcase
end
else
  s = 6'b000000;
end//------------------address_decoder--------------------------------

always @(posedge clk) begin//-------------------- escritura de registros 

  if(reset) begin
    init = 0;
    Dvd    = 0;
    Dvs    = 0;
  end
  else begin
    if (cs && wr) begin
      Dvd    = s[0] ? d_in    : Dvd;	//Write Registers
      Dvs    = s[1] ? d_in    : Dvs;	//Write Registers
      init = s[2] ? d_in[0] : init;
    end
  end

end//------------------------------------------- escritura de registros

always @(posedge clk) begin//-----------------------mux_4 :  multiplexa salidas del periferico
  if(reset)
    d_out = 0;
  else 
  if (cs) begin
    case (s[5:0])
      6'b001000: d_out    =  {16'b0, Q};
      6'b010000: d_out    =  {16'b0, R};
      6'b100000: d_out    = {31'b0, done};
    endcase
  end
end//-----------------------------------------------mux_4

//# ---------------------------------------#
//# ---------------------------------------#
//# Instanciacion Divisor#
//# ---------------------------------------#
//# ---------------------------------------#

top_div mult1 (
  .rst(reset),
  .clk(clk),
  .start(init),
  .done(done),
  .Q_out(Q),
  .R_out(R),
  .Dvd_in(Dvd),
  .Dvs_in(Dvs)
 );

endmodule
