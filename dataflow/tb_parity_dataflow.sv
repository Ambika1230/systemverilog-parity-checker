`timescale 1ns/1ps
package parity_pkg;

    // Base class with virtual run() function
    virtual class test_base;
        pure virtual task run(ref logic a, ref logic b, ref logic c, input logic y, output logic ref_y);
    endclass

    // Derived class: input generation + output comparison
    class parity_test extends test_base;
        int error_count = 0;

        // Main test: calls all scenarios
        virtual task run(ref logic a, ref logic b, ref logic c, input logic y, output logic ref_y);
            $display("Starting exhaustive test...");
            test_all_combinations(a, b, c, y, ref_y);
            $display("Test completed. Errors: %0d", error_count);
        endtask

        // Task: Exhaustive test of all input combinations
        task test_all_combinations(ref logic a, ref logic b, ref logic c, input logic y, output logic ref_y);
            for (int i = 0; i < 8; i++) begin
                {a, b, c} = i[2:0];
                #10;
                ref_y = a ^ b ^ c; // Reference model
                if (y !== ref_y) begin
                    $error("Mismatch: a=%0b b=%0b c=%0b | DUT y=%0b, REF y=%0b", a, b, c, y, ref_y);
                    error_count++;
                end
            end
        endtask
    endclass

endpackage
module parity_tb;
    import parity_pkg::*;

    logic a, b, c, y;
    logic ref_y;

    parity_nand_gate dut(.a(a), .b(b), .c(c), .y(y));

    // Reference model always block
    always @(*) begin
        ref_y = a ^ b ^ c;
    end

    initial begin
        parity_test test = new();
        test.run(a, b, c, y, ref_y);
        $finish;
    end
endmodule

