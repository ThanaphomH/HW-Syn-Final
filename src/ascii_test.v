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
    input wire [6:0] ascii_code
    );
    
    // small index 10*10 with small 16*8
    // signal declarations
    wire [10:0] rom_addr;           // 11-bit text ROM address
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
    
    // rgb rainbow
    wire letter_color;
    rainbow_rom rainbow(.clk(clk), .addr(x[7:3]), .data(letter_color)); 
    
    
    // rgb multiplexing circuit
    always @*
        if(~video_on)
            rgb = 12'h000;      // blank
        else
            if(ascii_bit_on)
                rgb = letter_color;  // blue letters
            else
                if (448 <= y && y <= 440) 
                    rgb = 12'hF00;
                else if (464 <= y && y <= 456)
                    rgb = 12'h00F;
                else if (480 <= y && y <= 472)
                    rgb = 12'hF00;
                else rgb = 12'hFFF;  // white background
   
endmodule
