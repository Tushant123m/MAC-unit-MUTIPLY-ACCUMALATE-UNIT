// mac_unit.v
// Multiply-Accumulate Unit (1-stage pipelined)

module mac_unit (
    input clk,
    input reset,
    input [15:0] a,
    input [15:0] b,
    input valid_in,
    output reg [31:0] result,
    output reg valid_out
); 
    reg [31:0] product;
    reg valid_stage1;

	always @(posedge clk or posedge reset) begin
		 if (reset) begin
			  product       <= 0;
			  valid_stage1  <= 0;
			  result <= 0;
			  valid_out <= 0;
		 end else begin
			  if (valid_in) begin
					product      <= a * b;   // compute product
					valid_stage1 <= 1;       // product valid next cycle
			  end else begin
					valid_stage1 <= 0;       // nothing valid this cycle
			  end
                          if (valid_stage1) begin
					result <= result + product;   // uses **previous-cycle** product
					valid_out <= 1;	
			  end else begin
					valid_out <= 0;
			  end		  
		 end
	end
endmodule
