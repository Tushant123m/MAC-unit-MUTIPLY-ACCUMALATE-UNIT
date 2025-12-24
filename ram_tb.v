`timescale 1ns/1ps

module ram_tb;
    reg clk;
    reg we_a, we_b;
    reg [4:0] addr_a, addr_b;
    reg [15:0] data_in_a, data_in_b;
    wire [15:0] data_out_a, data_out_b;

    // Instantiate RAM
    ram dut (
        .clk(clk),
        .we_a(we_a),
        .we_b(we_b),
        .addr_a(addr_a),
        .addr_b(addr_b),
        .data_in_a(data_in_a),
        .data_in_b(data_in_b),
        .data_out_a(data_out_a),
        .data_out_b(data_out_b)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    integer i; // loop variable

    initial begin
        // Initialize
        we_a = 0; we_b = 0;
        addr_a = 0; addr_b = 0;
        data_in_a = 0; data_in_b = 0;
        #10;

        // Write to port A
        we_a = 1;
        for (i = 0; i < 4; i = i + 1) begin
            addr_a = i;
            data_in_a = i*10 + 5;
            #10;
        end
        we_a = 0;

        // Write to port B
        we_b = 1;
        for (i = 0; i < 4; i = i + 1) begin
            addr_b = i;
            data_in_b = i*20 + 3;
            #10;
        end
        we_b = 0;

        // Read back
        for (i = 0; i < 4; i = i + 1) begin
            addr_a = i;
            addr_b = i;
            #10;
            $display("Addr=%0d | PortA=%0d | PortB=%0d", i, data_out_a, data_out_b);
        end

        $stop;
    end
endmodule
