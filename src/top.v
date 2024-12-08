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
    output [6:0] seg,
    output dp,
    output [3:0] an,
    
    input [7:0] sw,
    input btnU,
    input PS2Clk, // PS2
    input PS2Data, // PS2
    output [11:0] led 
);

    reg dummy_tx;
    wire [7:0] receive_data;
    receiver rec (
        .clk(clk),          // 100MHz on Basys 3
        .reset(reset),
        .btnD(btnD),        // btnD on Basys 3
        .hsync(hsync),       // to VGA connector
        .vsync(vsync),       // to VGA connector
        .rgb(rgb),   // to DAC, to VGA connector
        .RsRx(RsRx), //uart // [7:4] for Higher num hex, [3:0] for Lower num
        .RsTx(dummy_tx), //uart
        .receive_data(receive_data)
    );
    
    reg dummy_rx;
    wire [7:0] send_data;
    sender send (
        .clk(clk),
        .sw(sw),
        .btnU(btnU),
        .RsRx(dummy_rx), //uart // [7:4] for Higher num hex, [3:0] for Lower num
        .RsTx(RsTx), //uart
        .PS2Clk(PS2Clk), // PS2
        .PS2Data(PS2Data), // PS2
        .led(led),
        .send_data(send_data)
    );
    
    wire [3:0] num3, num2, num1, num0; // left to right
    wire an0, an1, an2, an3;
    assign an = {an3, an2, an1, an0};
        
    // Divide clock
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
    
    quadSevenSeg q7seg(seg, dp, an0, an1, an2, an3,receive_data[3:0] ,receive_data[7:4] , send_data[3:0], send_data[7:4], target_enable);

endmodule