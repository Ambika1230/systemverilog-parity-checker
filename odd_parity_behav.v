`timescale 1ns/1ps
module parity_behav(
    input  wire a, b, c,
    output reg  y
);
    always @(*) begin
        y = a ^ b ^ c;
    end
endmodule
