`timescale 1ns / 1ps

module sender (
    input clk,
    input [7:0] sw,
    input btnU,
    output [6:0] seg,
    output dp,
    output [3:0] an
);

    wire [3:0] num3, num2, num1, num0; // left to right
    wire an0, an1, an2, an3;
    assign an = {an3, an2, an1, an0};
    assign num3 = sw;

    quadSevenSeg seqment( seg, dp, an0, an1, an2, an3, num0, num1, num2, num3,clk );

endmodule