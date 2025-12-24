module ram (
    input clk,
    input we_a, we_b, we_a_dut, we_b_dut,
    input [4:0] addr_a, addr_b, addr_a_dut, addr_b_dut,
    input [15:0] data_in_a, data_in_b,
    output reg [15:0] data_out_a, data_out_b
);
    reg [15:0] mem [0:31];

    always @(posedge clk) begin
        if (we_a ) mem[addr_a] <= data_in_a;
        data_out_a <= mem[addr_a];

        if (we_b) mem[addr_b] <= data_in_b;
        data_out_b <= mem[addr_b];
    end
	 
	     always @(posedge clk) begin
        if (!we_a_dut) data_out_a <= mem[addr_a_dut];
      

        if (!we_b_dut) data_out_b <= mem[addr_b_dut];
        
    end
endmodule
