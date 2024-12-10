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
        7'b0011000: data = 12'hF00;
        7'b0011001: data = 12'hE10;
        7'b0011010: data = 12'hE30;
        7'b0011011: data = 12'hD41;
        7'b0011100: data = 12'hD51;
        7'b0011101: data = 12'hC72;
        7'b0011110: data = 12'hC82;
        7'b0011111: data = 12'hB93;
        7'b0100000: data = 12'hBA3;
        7'b0100001: data = 12'hAB4;
        7'b0100010: data = 12'hAC4;
        7'b0100011: data = 12'h9D5;
        7'b0100100: data = 12'h9E5;
        7'b0100101: data = 12'h8E6;
        7'b0100110: data = 12'h8E6;
        7'b0100111: data = 12'h7E7;
        7'b0101000: data = 12'h7E7;
        7'b0101001: data = 12'h6E8;
        7'b0101010: data = 12'h6E8;
        7'b0101011: data = 12'h5E9;
        7'b0101100: data = 12'h5D9;
        7'b0101101: data = 12'h4CA;
        7'b0101110: data = 12'h4BA;
        7'b0101111: data = 12'h3AB;
        7'b0110000: data = 12'h39B;
        7'b0110001: data = 12'h28C;
        7'b0110010: data = 12'h27C;
        7'b0110011: data = 12'h15D;
        7'b0110100: data = 12'h14D;
        7'b0110101: data = 12'h03E;
        7'b0110110: data = 12'h01E;
        7'b0110111: data = 12'h00F;


        default: data = 12'h00F; // Default to zero
        endcase
 endmodule