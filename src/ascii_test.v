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
    wire [10:0] rom_addr;           // 11-bit text ROM address
//    wire [6:0] ascii_char;          // 7-bit ASCII character code
    wire [3:0] char_row;            // 4-bit row of ASCII character
    wire [2:0] bit_addr;            // column number of ROM data
    wire [7:0] rom_data, thai_data;            // 8-bit row data from text ROM
    wire ascii_bit, ascii_bit_on;     // ROM bit and status signal
    
    // instantiate ASCII ROM
    ascii_rom rom(.clk(clk), .addr(rom_addr), .data(rom_data));
    thai_rom trom(.clk(clk), .addr(rom_addr), .data(thai_data));

    wire lang;
    assign lang = ascii_code[7];

    // ASCII ROM interface
    assign rom_addr = {ascii_code[6:0], char_row};   // ROM address is ascii code + row
    assign ascii_bit = rom_data[~bit_addr];     // reverse bit order
    assign thai_bit = thai_data[~bit_addr];     // reverse bit order

//    assign ascii_char = {y[5:4], x[7:3]};   // 7-bit ascii code shift y 16 bit, shift x 8 bit
    assign char_row = y[3:0];               // row number of ascii character rom
    assign bit_addr = x[2:0];               // column number of ascii character rom
    // "on" region in center of screen
    assign ascii_bit_on = ((x >= 192 && x < 448) && (y >= 208 && y < 272)) ? (lang ? thai_bit : ascii_bit) : 1'b0;
    
    
    // graphic
    wire [6:0] column_index;
    assign column_index = x[9:3];
    
    // rgb multiplexing circuit
    always @(*) begin
        if(~video_on)
            rgb = 12'h000;      // blank
        else
            if(ascii_bit_on)             // set letters color
                if (column_index < 28) rgb = 12'hF00;    // start from col 24
                else if (column_index < 32) rgb = 12'h881;
                else if (column_index < 36) rgb = 12'h8F1;
                else if (column_index < 40) rgb = 12'h0F0;
                else if (column_index < 44) rgb = 12'h00F;
                else if (column_index < 48) rgb = 12'h408;
                else if (column_index < 52) rgb = 12'hF0F;
                else if (column_index < 56) rgb = 12'hF08;
                else rgb = 12'h000;
            else
                // Frame
                if ((x >= 184 && x < 456 && y >= 200 && y < 280))
                    if (x >= 180 && x < 460 && y >= 196 && y < 284) rgb = 12'hFFF;
                    else rgb = 12'h000;
                else 
                    // Thai flag top
                    if (y <= 4) 
                        rgb = 12'hF00; // Red
                    else if (y <= 8) 
                        rgb = 12'hFFF; // White
                    else if (y <= 12) 
                        rgb = 12'h00F; // Blue
                    else if (y <= 16) 
                        rgb = 12'hFFF; // White
                    else if (y <= 20) 
                        rgb = 12'hF00; // Red
                
                    // Thai flag bottom
                    else if (y >= 476) 
                        rgb = 12'hF00; // Red
                    else if (y >= 472) 
                        rgb = 12'hFFF; // White
                    else if (y >= 468) 
                        rgb = 12'h00F; // Blue
                    else if (y >= 464) 
                        rgb = 12'hFFF; // White
                    else if (y >= 460) 
                        rgb = 12'hF00; // Red
                    
                    else rgb = 12'hFFF;  // white background
     end
   
endmodule
