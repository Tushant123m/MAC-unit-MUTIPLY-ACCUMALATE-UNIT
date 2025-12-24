
`timescale 1ns/1ps

module mac_with_ram_tb;
    // Clock / reset
    reg clk;
    reg reset;

    // RAM interface (dual-port behavioral ram)
    reg we_a, we_b;
    reg [4:0] addr_a, addr_b;
    reg [15:0] data_in_a, data_in_b;
    wire [15:0] data_out_a, data_out_b;

    // MAC interface
    reg [15:0] mac_a, mac_b;
    reg valid_in;
    wire [31:0] result; 
    wire valid_out;

    // Instantiate RAM (behavioral)
    ram ram_inst (
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

    // Instantiate MAC
    mac_unit mac_inst (
        .clk(clk),
        .reset(reset),
        .a(mac_a),
        .b(mac_b),
        .valid_in(valid_in),
        .result(result),
        .valid_out(valid_out)
    );

    // Clock: 10 ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Parameters and arrays
    parameter N = 4;
    reg [15:0] a_vec [0:N-1];
    reg [15:0] b_vec [0:N-1];

    integer i;
    integer OFFSET;  // moved here — Quartus requires declarations at module level

    initial begin
        OFFSET = 16;  // where to store results in RAM

        // sample inputs
        a_vec[0] = 4; a_vec[1] = 5; a_vec[2] = 6; a_vec[3] = 7;
        b_vec[0] = 3; b_vec[1] = 3; b_vec[2] = 2; b_vec[3] = 1;

        // init signals
        reset = 1;
        we_a = 0; we_b = 0;
        addr_a = 0; addr_b = 0;
        data_in_a = 0; data_in_b = 0;
        mac_a = 0; mac_b = 0; valid_in = 0;
        #20;                // wait 2 clock cycles
        reset = 0;
        #10;

        // -----------------------------------------------------------------
        // Phase 1: Preload RAM with input arrays on both ports
        // -----------------------------------------------------------------
        $display("Preloading RAM with inputs...");
        for (i = 0; i < N; i = i + 1) begin
				we_a = 1; we_b = 1;
            addr_a = i; addr_b = i;
            data_in_a = a_vec[i];
            data_in_b = b_vec[i];
            #10; // one clock period (writes occur on posedge)
        end
        we_a = 0; we_b = 0;
       

        // -----------------------------------------------------------------
        // Phase 2: Read from RAM, feed MAC, store results
        // -----------------------------------------------------------------
        $display("Processing: read inputs, run MAC, store results...");
        reset = 1; #10; reset = 0; 


		  for (i = 0; i < N; i = i + 1) begin
				 // 1) Issue read address and wait two posedges for synchronous RAM data
				 addr_a = i; addr_b = i;
				 @(posedge clk);      // RAM captures address
				 @(posedge clk);      // RAM drives data_out_a/data_out_b (now valid)

				 // 2) Present operands to MAC and assert valid_in before the posedge
				 mac_a = data_out_a;
				 mac_b = data_out_b;
				 valid_in = 1;
				 @(posedge clk);      // MAC samples mac_a/mac_b when valid_in=1
				 valid_in = 0;

				 // 3) Wait for MAC to assert valid_out (synchronized), then align to posedge
				 wait (valid_out == 1);
				 @(posedge clk);      // now 'result' is stable

				 $display("a =%d, b = %d, result = %d, time=%t ",mac_a, mac_b, result, $time);

				 // 4) Write back result to RAM synchronously
				 we_b = 1;
				 addr_b = OFFSET + i;
				 data_in_b = result[15:0];
				 @(posedge clk);      // write occurs on this posedge
				 we_b = 0;
				 @(posedge clk);      // a cycle gap before next iteration 
		  end


        // -----------------------------------------------------------------
        // Phase 3: Read back stored results
        // -----------------------------------------------------------------
        $display("Reading back stored results...");
        for (i = 0; i < N; i = i + 1) begin
            addr_b = OFFSET + i;
            #10;
            $display("Result addr %0d => %0d (time=%0t)", OFFSET + i, data_out_b, $time);
        end

        $stop;
    end
endmodule
