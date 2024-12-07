`timescale 1ns / 1ps

module top(
    input clk,          // 100MHz on Basys 3
    input reset,
    input btnD,        // btnD on Basys 3
    output hsync,       // to VGA connector
    output vsync,       // to VGA connector
    output [11:0] rgb,   // to DAC, to VGA connector
    input wire RsRx, //uart // [7:4] for Higher num hex, [3:0] for Lower num
    output wire RsTx, //uart
    input wire Rx,
    output [6:0] seg,
    output dp,
    output [3:0] an
    );
    
    
    wire [3:0] num3, num2, num1, num0; // left to right
    wire an0, an1, an2, an3;
    assign an = {an3, an2, an1, an0};
    
    // Divide clock
//    wire targetClk;
//    wire [18:0] tclk;

//    assign tclk[0] = clk;
//    genvar c;
//    generate for(c = 0; c < 18; c = c + 1) begin
//        clockDiv fDiv(tclk[c+1], tclk[c]);
//    end endgenerate
    
//    clockDiv fdivTarget(targetClk, tclk[18]);
    reg [17:0] clk_counter = 0;
    reg target_enable = 0;
    
    always @(posedge clk) begin
        if (clk_counter == 18'h3FFFF) begin // Adjust this for your desired frequency
            clk_counter <= 0;
            target_enable <= 1;
        end else begin
            clk_counter <= clk_counter + 1;
            target_enable <= 0;
        end
    end
    
    // signals
    wire [9:0] w_x, w_y;
    wire w_video_on, w_p_tick;
    reg [11:0] rgb_reg;
    wire [11:0] rgb_next;
    wire [7:0] O;
    
    wire we;
    reg [4:0] wx = 5'b11000;
    reg [1:0] wy = 2'b01;
    wire [4:0] rx;
    wire [1:0] ry;
    wire [7:0] rdata;

    reg tx_start;
    reg [7:0] tx_data;
    
    assign rx = w_x[7:3];
    assign ry = w_y[5:4];
    
    // VGA Controller
    vga_controller vga(.clk_100MHz(clk), .reset(reset), .hsync(hsync), .vsync(vsync),
                       .video_on(w_video_on), .p_tick(w_p_tick), .x(w_x), .y(w_y));
                       
    // Text Generation Circuit
    ascii_test at(.clk(clk), .video_on(w_video_on), .x(w_x), .y(w_y), .rgb(rgb_next), .ascii_code(rdata[6:0]));
    
    wire tx_busy;
    uart uart_instance(clk, 0, tx_data, 0, tx_busy, RsTx, RsRx,  O, we); // Instance of uart
    
    wire sharp_we;
    singlePulser( .d(sharp_we) , .pushed(we), .clk(clk));

    wire sharp_reset;
    singlePulser( .d(sharp_reset) , .pushed(btnD), .clk(clk));
    
    wire delay_we;
    delay_one_cycle delay(.clk(clk), .original_signal(sharp_we), .delayed_signal(delay_we));
    
    always @(posedge clk) begin
        if (delay_we) begin
            // Newline: Shift y and move to the first column of next line
            if (O == 8'b00001101 || O == 8'b00001010) begin
                wx = 5'b11000;
                if (wy == 2'b11) begin 
                    wy = 0;
                end else begin
                    wy = wy + 1; 
                end
            end else begin
                // Normal cursor shift: use some simple black magic to make it correctly align
                if (wx == 5'b11111) begin 
                    wx = 0;
                end else if (wx == 5'b10111) begin
                    wx = 5'b11000; 
                    if (wy == 2'b11) begin 
                        wy = 0;
                    end else begin
                        wy = wy + 1; 
                    end
                end else begin
                    wx = wx + 1;                
                end
            end 
        end

        if (sharp_reset) begin
            wx = 5'b11000;
            wy = 2'b01;
        end
    end

    wire [7:0] sa, si;
    DualPortRAM ram(clk, sharp_we, sharp_reset, wy, wx, O, ry, rx, rdata, sa, si);

    // rgb buffer
    always @(posedge clk)
        if(w_p_tick)
            rgb_reg <= rgb_next;
            
    // output
    assign rgb = rgb_reg;
    
    // 7seg board
    quadSevenSeg q7seg(seg, dp, an0, an1, an2, an3,wx[3:0], {0,0, wy[1:0]}, rx[3:0], {0,0, ry[1:0]}, target_enable);
      
endmodule
