`timescale 1ns / 1ps

module top(
    input clk,          // 100MHz on Basys 3
    input reset,        // btnC on Basys 3
    output hsync,       // to VGA connector
    output vsync,       // to VGA connector
    output [11:0] rgb,   // to DAC, to VGA connector
    input wire RsRx, //uart // [7:4] for Higher num hex, [3:0] for Lower num
    output wire RsTx, //uart
    output [6:0] seg,
    output dp,
    output [3:0] an
    );
    
    wire [3:0] num3, num2, num1, num0; // left to right
    wire an0, an1, an2, an3;
    assign an = {an3, an2, an1, an0};
    
    // Divide clock
    wire targetClk;
    wire [18:0] tclk;

    assign tclk[0] = clk;
    genvar c;
    generate for(c = 0; c < 18; c = c + 1) begin
        clockDiv fDiv(tclk[c+1], tclk[c]);
    end endgenerate
    
    clockDiv fdivTarget(targetClk, tclk[18]);
    
    // signals
    wire [9:0] w_x, w_y;
    wire w_video_on, w_p_tick;
    reg [11:0] rgb_reg;
    wire [11:0] rgb_next;
    wire [7:0]O;
    
    // VGA Controller
    vga_controller vga(.clk_100MHz(clk), .reset(reset), .hsync(hsync), .vsync(vsync),
                       .video_on(w_video_on), .p_tick(w_p_tick), .x(w_x), .y(w_y));
                       
    // Text Generation Circuit
    ascii_test at(.clk(clk), .video_on(w_video_on), .x(w_x), .y(w_y), .rgb(rgb_next));
    
    uart uart_instance(clk, RsRx, RsTx,O); // Instance of uart
    
    // rgb buffer
    always @(posedge clk)
        if(w_p_tick)
            rgb_reg <= rgb_next;
            
    // output
    assign rgb = rgb_reg;
    
    // 7seg board
    quadSevenSeg q7seg(seg, dp, an0, an1, an2, an3,O, O,O, O, targetClk);
      
endmodule
