`timescale 1ns / 1ps
// Reference book: "FPGA Prototyping by Verilog Examples"
//                    "Xilinx Spartan-3 Version"
// Authored by: Pong P. Chu
// Published by: Wiley, 2008
// Adapted for use on Basys 3 FPGA with Xilinx Artix-7
// by: David J. Marion aka FPGA Dude

module ascii_test(
    input clk,
    input video_on,
    input [9:0] x, y,
    output reg [11:0] rgb,
    input wire [7:0] ascii_code
    );
    
    // small index 10*10 with small 16*8
    // signal declarations
    wire [11:0] rom_addr;           // 11-bit text ROM address
//    wire [6:0] ascii_char;          // 7-bit ASCII character code
    wire [3:0] char_row;            // 4-bit row of ASCII character
    wire [2:0] bit_addr;            // column number of ROM data
    wire [7:0] rom_data;            // 8-bit row data from text ROM
    wire ascii_bit, ascii_bit_on;     // ROM bit and status signal
    
    // instantiate ASCII ROM
    ascii_rom rom(.clk(clk), .addr(rom_addr), .data(rom_data));

    // ASCII ROM interface
    assign rom_addr = {ascii_code, char_row};   // ROM address is ascii code + row
    assign ascii_bit = rom_data[~bit_addr];     // reverse bit order

//    assign ascii_char = {y[5:4], x[7:3]};   // 7-bit ascii code shift y 16 bit, shift x 8 bit
    assign char_row = y[3:0];               // row number of ascii character rom
    assign bit_addr = x[2:0];               // column number of ascii character rom
    // "on" region in center of screen
    assign ascii_bit_on = ((x >= 192 && x < 448) && (y >= 208 && y < 272)) ? ascii_bit : 1'b0;
    
    
    // graphic
    reg [11:0] char_color;
    wire [6:0] column_index;
    assign column_index = x[9:3];
    always @(*) begin
        case (column_index)
            7'b0011000: char_color = 12'hF00;
            7'b0011001: char_color = 12'hE10;
            7'b0011010: char_color = 12'hE30;
            7'b0011011: char_color = 12'hD41;
            7'b0011100: char_color = 12'hD51;
            7'b0011101: char_color = 12'hC72;
            7'b0011110: char_color = 12'hC82;
            7'b0011111: char_color = 12'hB93;
            7'b0100000: char_color = 12'hBA3;
            7'b0100001: char_color = 12'hAB4;
            7'b0100010: char_color = 12'hAC4;
            7'b0100011: char_color = 12'h9D5;
            7'b0100100: char_color = 12'h9E5;
            7'b0100101: char_color = 12'h8E6;
            7'b0100110: char_color = 12'h8E6;
            7'b0100111: char_color = 12'h7E7;
            7'b0101000: char_color = 12'h7E7;
            7'b0101001: char_color = 12'h6E8;
            7'b0101010: char_color = 12'h6E8;
            7'b0101011: char_color = 12'h5E9;
            7'b0101100: char_color = 12'h5D9;
            7'b0101101: char_color = 12'h4CA;
            7'b0101110: char_color = 12'h4BA;
            7'b0101111: char_color = 12'h3AB;
            7'b0110000: char_color = 12'h39B;
            7'b0110001: char_color = 12'h28C;
            7'b0110010: char_color = 12'h27C;
            7'b0110011: char_color = 12'h15D;
            7'b0110100: char_color = 12'h14D;
            7'b0110101: char_color = 12'h03E;
            7'b0110110: char_color = 12'h01E;
            7'b0110111: char_color = 12'h00F;
            
        default: char_color = 12'h000;
        endcase
    end
    
    // rgb multiplexing circuit
    always @(*) begin
        if(~video_on)
            rgb = 12'h000;      // blank
        else
            if(ascii_bit_on)
                rgb = char_color;  // letters color
            else
                if (y >= 472) 
                    rgb = 12'h0F0;
                else if ((x >= 180 && x < 460 && y >= 196 && y < 284) && !(x >= 184 && x < 456 && y >= 200 && y < 280))
                    rgb = 12'h000;
                else rgb = 12'hFFF;  // white background
     end
   
endmodule
