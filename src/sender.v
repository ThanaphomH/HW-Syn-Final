`timescale 1ns / 1ps

module sender (
    input clk,
    input [7:0] sw,
    input btnU,
    output [6:0] seg,
    output dp,
    output [3:0] an,
    input wire RsRx, //uart // [7:4] for Higher num hex, [3:0] for Lower num
    output wire RsTx, //uart
    input PS2Data, // USB
    input PS2Clk // USB
);

    wire [7:0] O;
    wire we;
    uart uart_instance(clk, RsRx, RsTx, O, we); // Instance of uart
    
    // USB
    reg CLK50MHZ=0;
    always @(posedge(clk))begin
        CLK50MHZ<=~CLK50MHZ;
    end
    
    wire [15:0] keycode;
    wire flag;
    PS2Receiver uut (
        .clk(CLK50MHZ),
        .kclk(PS2Clk),
        .kdata(PS2Data),
        .keycode(keycode),
        .oflag(flag)
    );
    
    reg [7:0] input_switchs;
    wire [3:0] num3, num2, num1, num0; // left to right
    wire an0, an1, an2, an3;
    assign an = {an3, an2, an1, an0};
    assign num3 = keycode[15:8];
    assign num2 = keycode[7:0];
    assign num1 = input_switchs;
    assign num0 = input_switchs;
    
    always @(posedge clk) begin
        input_switchs <= sw;
    end

    quadSevenSeg segment( seg, dp, an0, an1, an2, an3, num0, num1, num2, num3,clk );

endmodule