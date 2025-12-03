`timescale 1ns/1ps
package parity_pkg;

    // Base class with virtual run() function
    virtual class test_base;
        pure virtual task run(ref logic a, ref logic b, ref logic c, input logic y);
    endclass

    // Derived class: implements run() and test scenarios as tasks
    class parity_test extends test_base;
        int error_count = 0;

        // Main entry point: call all major test scenarios
        virtual task run(ref logic a, ref logic b, ref logic c, input logic y);
            $display("Starting exhaustive test...");
            test_all_combinations(a, b, c, y);
            $display("Starting single case test...");
            test_single_case(a, b, c, y);
            $display("Starting repeated pattern test...");
            test_repeated_pattern(a, b, c, y);
            $display("Test completed. Errors: %0d", error_count);
        endtask

        // Task 1: Exhaustive test of all input combinations
        task test_all_combinations(ref logic a, ref logic b, ref logic c, input logic y);
            logic expected;
            for (int i = 0; i < 8; i++) begin
                {a, b, c} = i[2:0];
                #10;
                expected = a ^ b ^ c;
                if (y !== expected) begin
                    $error("Exhaustive: a=%0b b=%0b c=%0b | y=%0b (expected %0b)", a, b, c, y, expected);
                    error_count++;
                end
            end
        endtask

        // Task 2: Test a single specific case
        task test_single_case(ref logic a, ref logic b, ref logic c, input logic y);
            logic expected;
            a = 1; b = 0; c = 1;
            #10;
            expected = a ^ b ^ c;
            if (y !== expected) begin
                $error("Single case: a=%0b b=%0b c=%0b | y=%0b (expected %0b)", a, b, c, y, expected);
                error_count++;
            end
        endtask

        // Task 3: Test a repeated pattern
        task test_repeated_pattern(ref logic a, ref logic b, ref logic c, input logic y);
            logic expected;
            for (int i = 0; i < 4; i++) begin
                a = i[0]; b = ~i[0]; c = i[1];
                #10;
                expected = a ^ b ^ c;
                if (y !== expected) begin
                    $error("Pattern: a=%0b b=%0b c=%0b | y=%0b (expected %0b)", a, b, c, y, expected);
                    error_count++;
                end
            end
        endtask
    endclass

endpackage

module parity_tb;
 import parity_pkg::*;
logic a, b, c, y;
// Instantiate DUT
parity_behav dut(.a(a), .b(b), .c(c),.y(y));
initial 
    begin
parity_test test = new();
    test.run(a, b, c, y);
$;
end
    endmodule


