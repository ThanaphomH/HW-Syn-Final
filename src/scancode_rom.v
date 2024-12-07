module scancode_rom(
        input clk, 
        input wire [9:0] addr,
        output reg [7:0] data
    );

    (* rom_style = "block" *) 

    reg [9:0] addr_reg;
    
    always @(posedge clk)
        addr_reg <= addr;
        
    always @*
        case(addr_reg)
        10'b0000010110 : data = 8'h31;
        10'b0000011110 : data = 8'h32;
        10'b0000100110 : data = 8'h33;
        10'b0000100101 : data = 8'h34;
        10'b0000101110 : data = 8'h35;
        10'b0000110110 : data = 8'h36;
        10'b0000111101 : data = 8'h37;
        10'b0000111110 : data = 8'h38;
        10'b0001000110 : data = 8'h39;
        10'b0001000101 : data = 8'h30;
        10'b0001001110 : data = 8'h2D;
        10'b0001010101 : data = 8'h2D;
        10'b0000010101 : data = 8'h71;
        10'b0000011101 : data = 8'h77;
        10'b0000100100 : data = 8'h65;
        10'b0000101101 : data = 8'h72;
        10'b0000101100 : data = 8'h74;
        10'b0000110101 : data = 8'h79;
        10'b0000111100 : data = 8'h75;
        10'b0001000011 : data = 8'h69;
        10'b0001000100 : data = 8'h6F;
        10'b0001001101 : data = 8'h70;
        10'b0001010100 : data = 8'h2D;
        10'b0001011011 : data = 8'h2D;
        10'b0001011101 : data = 8'h2D;
        10'b0000011100 : data = 8'h61;
        10'b0000011011 : data = 8'h73;
        10'b0000100011 : data = 8'h64;
        10'b0000101011 : data = 8'h66;
        10'b0000110100 : data = 8'h67;
        10'b0000110011 : data = 8'h68;
        10'b0000111011 : data = 8'h6A;
        10'b0001000010 : data = 8'h6B;
        10'b0001001011 : data = 8'h6C;
        10'b0001001100 : data = 8'h2D;
        10'b0001010010 : data = 8'h2D;
        10'b0000011010 : data = 8'h7A;
        10'b0000100010 : data = 8'h78;
        10'b0000100001 : data = 8'h63;
        10'b0000101010 : data = 8'h76;
        10'b0000110010 : data = 8'h62;
        10'b0000110001 : data = 8'h6E;
        10'b0000111010 : data = 8'h6D;
        10'b0001000001 : data = 8'h2D;
        10'b0001001001 : data = 8'h2D;
        10'b0001001010 : data = 8'h2D;
        10'b0001011010 : data = 8'h0D;
        10'b0000010010 : data = 8'h00;
        10'b0001011001 : data = 8'h00;
        10'b0000101001 : data = 8'h20;
        10'b0001011000 : data = 8'h00;
        10'b0100010110 : data = 8'h2D;
        10'b0100011110 : data = 8'h2D;
        10'b0100100110 : data = 8'h2D;
        10'b0100100101 : data = 8'h2D;
        10'b0100101110 : data = 8'h2D;
        10'b0100110110 : data = 8'h2D;
        10'b0100111101 : data = 8'h2D;
        10'b0100111110 : data = 8'h2D;
        10'b0101000110 : data = 8'h2D;
        10'b0101000101 : data = 8'h2D;
        10'b0101001110 : data = 8'h2D;
        10'b0101010101 : data = 8'h2D;
        10'b0100010101 : data = 8'h51;
        10'b0100011101 : data = 8'h57;
        10'b0100100100 : data = 8'h45;
        10'b0100101101 : data = 8'h52;
        10'b0100101100 : data = 8'h54;
        10'b0100110101 : data = 8'h59;
        10'b0100111100 : data = 8'h55;
        10'b0101000011 : data = 8'h49;
        10'b0101000100 : data = 8'h4F;
        10'b0101001101 : data = 8'h50;
        10'b0101010100 : data = 8'h2D;
        10'b0101011011 : data = 8'h2D;
        10'b0101011101 : data = 8'h2D;
        10'b0100011100 : data = 8'h41;
        10'b0100011011 : data = 8'h53;
        10'b0100100011 : data = 8'h44;
        10'b0100101011 : data = 8'h46;
        10'b0100110100 : data = 8'h47;
        10'b0100110011 : data = 8'h48;
        10'b0100111011 : data = 8'h4A;
        10'b0101000010 : data = 8'h4B;
        10'b0101001011 : data = 8'h4C;
        10'b0101001100 : data = 8'h2D;
        10'b0101010010 : data = 8'h2D;
        10'b0100011010 : data = 8'h5A;
        10'b0100100010 : data = 8'h58;
        10'b0100100001 : data = 8'h43;
        10'b0100101010 : data = 8'h56;
        10'b0100110010 : data = 8'h42;
        10'b0100110001 : data = 8'h4E;
        10'b0100111010 : data = 8'h4D;
        10'b0101000001 : data = 8'h2D;
        10'b0101001001 : data = 8'h2D;
        10'b0101001010 : data = 8'h2D;
        10'b0101011010 : data = 8'h0D;
        10'b0100010010 : data = 8'h00;
        10'b0101011001 : data = 8'h00;
        10'b0100101001 : data = 8'h20;
        10'b0101011000 : data = 8'h00;
        10'b1000010110 : data = 8'hE45;
        10'b1000011110 : data = 8'h2D;
        10'b1000100110 : data = 8'h2D;
        10'b1000100101 : data = 8'hE20;
        10'b1000101110 : data = 8'hE16;
        10'b1000110110 : data = 8'hE38;
        10'b1000111101 : data = 8'hE36;
        10'b1000111110 : data = 8'hE04;
        10'b1001000110 : data = 8'hE15;
        10'b1001000101 : data = 8'hE08;
        10'b1001001110 : data = 8'hE02;
        10'b1001010101 : data = 8'hE0A;
        10'b1000010101 : data = 8'hE46;
        10'b1000011101 : data = 8'hE44;
        10'b1000100100 : data = 8'hE33;
        10'b1000101101 : data = 8'hE1E;
        10'b1000101100 : data = 8'hE30;
        10'b1000110101 : data = 8'hE31;
        10'b1000111100 : data = 8'hE35;
        10'b1001000011 : data = 8'hE23;
        10'b1001000100 : data = 8'hE19;
        10'b1001001101 : data = 8'hE22;
        10'b1001010100 : data = 8'hE1A;
        10'b1001011011 : data = 8'hE25;
        10'b1001011101 : data = 8'hE03;
        10'b1000011100 : data = 8'hE1F;
        10'b1000011011 : data = 8'hE2B;
        10'b1000100011 : data = 8'hE01;
        10'b1000101011 : data = 8'hE14;
        10'b1000110100 : data = 8'hE40;
        10'b1000110011 : data = 8'hE49;
        10'b1000111011 : data = 8'hE48;
        10'b1001000010 : data = 8'hE32;
        10'b1001001011 : data = 8'hE2A;
        10'b1001001100 : data = 8'hE27;
        10'b1001010010 : data = 8'hE07;
        10'b1000011010 : data = 8'hE1C;
        10'b1000100010 : data = 8'hE1B;
        10'b1000100001 : data = 8'hE41;
        10'b1000101010 : data = 8'hE2D;
        10'b1000110010 : data = 8'hE34;
        10'b1000110001 : data = 8'hE37;
        10'b1000111010 : data = 8'hE17;
        10'b1001000001 : data = 8'hE21;
        10'b1001001001 : data = 8'hE43;
        10'b1001001010 : data = 8'hE1D;
        10'b1001011010 : data = 8'h0D;
        10'b1000010010 : data = 8'h00;
        10'b1001011001 : data = 8'h00;
        10'b1000101001 : data = 8'h20;
        10'b1001011000 : data = 8'h00;
        10'b1100010110 : data = 8'h2D;
        10'b1100011110 : data = 8'h2D;
        10'b1100100110 : data = 8'h2D;
        10'b1100100101 : data = 8'h2D;
        10'b1100101110 : data = 8'h2D;
        10'b1100110110 : data = 8'hE39;
        10'b1100111101 : data = 8'h2D;
        10'b1100111110 : data = 8'h2D;
        10'b1101000110 : data = 8'h2D;
        10'b1101000101 : data = 8'h2D;
        10'b1101001110 : data = 8'h2D;
        10'b1101010101 : data = 8'h2D;
        10'b1100010101 : data = 8'h2D;
        10'b1100011101 : data = 8'h2D;
        10'b1100100100 : data = 8'hE0E;
        10'b1100101101 : data = 8'hE11;
        10'b1100101100 : data = 8'hE18;
        10'b1100110101 : data = 8'hE4D;
        10'b1100111100 : data = 8'hE4A;
        10'b1101000011 : data = 8'hE13;
        10'b1101000100 : data = 8'hE2F;
        10'b1101001101 : data = 8'hE0D;
        10'b1101010100 : data = 8'hE10;
        10'b1101011011 : data = 8'h2D;
        10'b1101011101 : data = 8'hE05;
        10'b1100011100 : data = 8'hE24;
        10'b1100011011 : data = 8'hE06;
        10'b1100100011 : data = 8'hE0F;
        10'b1100101011 : data = 8'hE42;
        10'b1100110100 : data = 8'hE0C;
        10'b1100110011 : data = 8'hE47;
        10'b1100111011 : data = 8'hE4B;
        10'b1101000010 : data = 8'hE29;
        10'b1101001011 : data = 8'hE28;
        10'b1101001100 : data = 8'hE0B;
        10'b1101010010 : data = 8'h2D;
        10'b1100011010 : data = 8'h2D;
        10'b1100100010 : data = 8'h2D;
        10'b1100100001 : data = 8'hE09;
        10'b1100101010 : data = 8'hE2E;
        10'b1100110010 : data = 8'h2D;
        10'b1100110001 : data = 8'hE4C;
        10'b1100111010 : data = 8'h2D;
        10'b1101000001 : data = 8'hE12;
        10'b1101001001 : data = 8'hE2C;
        10'b1101001010 : data = 8'hE26;
        10'b1101011010 : data = 8'h0D;
        10'b1100010010 : data = 8'h00;
        10'b1101011001 : data = 8'h00;
        10'b1100101001 : data = 8'h20;
        10'b1101011000 : data = 8'h00;


        default: data = 8'b00000000; // Default to zero
        endcase
 endmodule