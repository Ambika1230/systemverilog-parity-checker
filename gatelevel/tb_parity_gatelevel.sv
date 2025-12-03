`timescale 1ns/1ps
package parity_pkg;

    // Base class with virtual run() function
    virtual class test_base;
        pure virtual task run(ref logic a, ref logic b, ref logic c, input logic y);
    endclass

    // Derived class: implements run() and self-checks with for loop
    class parity_test extends test_base;
        int error_count = 0;

        // Main test: for loop over all input combinations, self-checking
        virtual task run(ref logic a, ref logic b, ref logic c, input logic y);
            logic expected;
            for (int i = 0; i < 8; i++) begin
                {a, b, c} = i[2:0];
                #10;
                expected = a ^ b ^ c;
                if (y !== expected) begin
                    $error("Mismatch: a=%0b b=%0b c=%0b | DUT y=%0b, Expected=%0b", a, b, c, y, expected);
                    error_count++;
                end
            end
            if (error_count == 0)
                $display("All tests passed!");
            else
                $display("Test completed. Errors: %0d", error_count);
        endtask
    endclass

endpackage
module parity_tb;
    import parity_pkg::*;

    logic a, b, c, y;

    // Instantiate DUT
    parity_nor_gate dut(.a(a), .b(b), .c(c), .y(y));

    initial begin
        parity_test test = new();
        test.run(a, b, c, y);
        $finish;
    end
endmodule


