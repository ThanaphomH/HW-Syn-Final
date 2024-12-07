module rainbow_rom(
        input clk, 
        input wire [6:0] addr,
        output reg [11:0] data
    );

    (* rom_style = "block" *) 

    reg [6:0] addr_reg;
    
    always @(posedge clk)
        addr_reg <= addr;
        
    always @(posedge clk)
        case(addr_reg)
        7'b11000: data = 12'hF00;
        7'b11001: data = 12'hE10;
        7'b11010: data = 12'hE30;
        7'b11011: data = 12'hD41;
        7'b11100: data = 12'hD51;
        7'b11101: data = 12'hC72;
        7'b11110: data = 12'hC82;
        7'b11111: data = 12'hB93;
        7'b100000: data = 12'hBA3;
        7'b100001: data = 12'hAB4;
        7'b100010: data = 12'hAC4;
        7'b100011: data = 12'h9D5;
        7'b100100: data = 12'h9E5;
        7'b100101: data = 12'h8E6;
        7'b100110: data = 12'h8E6;
        7'b100111: data = 12'h7E7;
        7'b101000: data = 12'h7E7;
        7'b101001: data = 12'h6E8;
        7'b101010: data = 12'h6E8;
        7'b101011: data = 12'h5E9;
        7'b101100: data = 12'h5D9;
        7'b101101: data = 12'h4CA;
        7'b101110: data = 12'h4BA;
        7'b101111: data = 12'h3AB;
        7'b110000: data = 12'h39B;
        7'b110001: data = 12'h28C;
        7'b110010: data = 12'h27C;
        7'b110011: data = 12'h15D;
        7'b110100: data = 12'h14D;
        7'b110101: data = 12'h03E;
        7'b110110: data = 12'h01E;
        7'b110111: data = 12'h00F;

        default: data = 12'h00F; // Default to zero
        endcase
 endmodule