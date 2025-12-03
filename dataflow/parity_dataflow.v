`timescale 1ns/1ps
module parity_nand_gate(
    input  logic a, b, c,
    output logic y
);
    // 2-input XOR using NAND gates (dataflow)
    function automatic logic xor2(input logic x1, x2);
        logic t1, t2, t3;
        begin
            t1 = ~(x1 & x2);
            t2 = ~(x1 & t1);
            t3 = ~(x2 & t1);
            xor2 = ~(t2 & t3);
        end
    endfunction
logic ab_xor;
    assign ab_xor = xor2(a, b);
    assign y      = xor2(ab_xor, c);
endmodule

