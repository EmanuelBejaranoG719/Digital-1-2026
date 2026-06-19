module multiplier #(parameter N = 16)(
    input  wire         clk, rst, start,
    input  wire [N-1:0] X_in, Y_in,
    output wire [N-1:0] P_out,
    output wire         done
);
    wire LD, SHIFT, ADD;
    wire Y_LSB, Y_ZERO;
    wire [N-1:0] X_shifted, Y_current;

    assign Y_ZERO = (Y_current == {N{1'b0}});

    shift_register #(.N(N),.DIR(1)) X_REG (.clk(clk),.rst(rst),.LD(LD),.SHIFT(SHIFT),.D(X_in),.Q(X_shifted),.LSB());
    shift_register #(.N(N),.DIR(0)) Y_REG (.clk(clk),.rst(rst),.LD(LD),.SHIFT(SHIFT),.D(Y_in),.Q(Y_current),.LSB(Y_LSB));
    accumulator    #(.N(N))         R_ACC (.clk(clk),.rst(rst),.LD(LD),.ADD(ADD),.X_in(X_shifted),.Q(P_out));
    control_unit                    FSM   (.clk(clk),.rst(rst),.start(start),.Y_LSB(Y_LSB),.Y_ZERO(Y_ZERO),.LD(LD),.SHIFT(SHIFT),.ADD(ADD),.DONE(done));
endmodule

