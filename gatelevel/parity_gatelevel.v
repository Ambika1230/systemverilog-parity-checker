timescale 1ns / 1ps
module xor_nor(input logic A, B, output logic Y);
    logic notA, notB, t1, t2, t3, t4;
    nor(notA, A, A);
    nor(notB, B, B);
    nor(t1, A, B);
    nor(t2, A, t1);
    nor(t3, B, t1);
    nor(t4, t2, t3);
    nor(Y, t4, t4);
endmodule
