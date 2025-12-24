// mac_unit_tb.v
// Testbench for mac_unit
`timescale 1ns/1ps

module mac_unit_tb;
    reg clk;
    reg reset;
    reg [15:0] a, b;
    reg valid_in;
    wire [31:0] result;
    wire valid_out;

    // Instantiate DUT (Device Under Test)
    mac_unit dut (
        .clk(clk),
        .reset(reset),
        .a(a),
        .b(b),
        .valid_in(valid_in),
        .result(result),
        .valid_out(valid_out)
    );

    // Clock generation: 10ns period (100MHz)
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // Monitor signals
        $monitor("Time=%0t | a=%d b=%d | valid_in=%b | result=%d | valid_out=%b",
                  $time, a, b, valid_in, result, valid_out);

        // Initialize
        reset = 1;
        valid_in = 0;
        a = 0;
        b = 0;
        #10;
        reset = 0;

        // Input sequence
        #10 a = 4; b = 2; valid_in = 1;
        #10 a = 5; b = 3; valid_in = 1;
        #10 a = 6; b = 2; valid_in = 1;
        #10 valid_in = 0;
        #50;

        $stop; // stop simulation
    end
endmodule
