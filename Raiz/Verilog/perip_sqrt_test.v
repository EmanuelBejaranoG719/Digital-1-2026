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
reg [4:0] s; 	//selector mux_4  and write registers
reg [15:0] N; // Entrada
reg init;	
wire [15:0] sqrt; // Raiz
wire done;
//------------------------------------ regs and wires-------------------------------
always @(*) begin//------address_decoder------------------------------
if (cs) begin
  case (addr)
    5'h04: s =  5'b00001; // numero de entrada N
    5'h0C: s =  5'b00010; // init
    5'h10: s =  5'b00100; // sqrt resultado
    5'h14: s =  5'b10000; // done
    default: s = 5'b00000;
  endcase
end
else
  s = 5'b00000;
end//------------------address_decoder--------------------------------

always @(posedge clk) begin//-------------------- escritura de registros 

  if(reset) begin
    init = 0;
    N    = 0;
  end
  else begin
    if (cs && wr) begin
      N    = s[0] ? d_in    : N;	//Write Registers
      init = s[2] ? d_in[0] : init;
    end
  end

end//------------------------------------------- escritura de registros

always @(posedge clk) begin//-----------------------mux_4 :  multiplexa salidas del periferico
  if(reset)
    d_out = 0;
  else 
  if (cs) begin
    case (s[3:0])
      5'b01000: d_out    =  {16'b0, sqrt};
      5'b10000: d_out    =  {31'b0, done};
    endcase
  end
end//-----------------------------------------------mux_4

//# ---------------------------------------#
//# ---------------------------------------#
//# Instanciacion Raiz #
//# ---------------------------------------#
//# ---------------------------------------#

top_sqrt raiz1 (
  .rst(reset),
  .clk(clk),
  .start(init),
  .ready(done),
  .raiz(sqrt),
  .N_in(N)
 );

endmodule
