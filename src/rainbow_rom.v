module rainbow_rom(
	input clk, 
	input wire [4:0] addr,
	output reg [11:0] data
	);

	(* rom_style = "block" *)	// Infer BRAM

	reg [4:0] addr_reg;
	
	always @(posedge clk)
		addr_reg <= addr;
		
	always @*
		case(addr_reg)
            5'b00000: data = 12'hF00;
            5'b00001: data = 12'hE10;
            5'b00010: data = 12'hE30;
            5'b00011: data = 12'hD41;
            5'b00100: data = 12'hD51;
            5'b00101: data = 12'hC72;
            5'b00110: data = 12'hC82;
            5'b00111: data = 12'hB93;
            5'b01000: data = 12'hBA3;
            5'b01001: data = 12'hAB4;
            5'b01010: data = 12'hAC4;
            5'b01011: data = 12'h9D5;
            5'b01100: data = 12'h9E5;
            5'b01101: data = 12'h8E6;
            5'b01110: data = 12'h8E6;
            5'b01111: data = 12'h7E7;
            5'b10000: data = 12'h7E7;
            5'b10001: data = 12'h6E8;
            5'b10010: data = 12'h6E8;
            5'b10011: data = 12'h5E9;
            5'b10100: data = 12'h5D9;
            5'b10101: data = 12'h4CA;
            5'b10110: data = 12'h4BA;
            5'b10111: data = 12'h3AB;
            5'b11000: data = 12'h39B;
            5'b11001: data = 12'h28C;
            5'b11010: data = 12'h27C;
            5'b11011: data = 12'h15D;
            5'b11100: data = 12'h14D;
            5'b11101: data = 12'h03E;
            5'b11110: data = 12'h01E;
            5'b11111: data = 12'h00F;
        endcase
endmodule