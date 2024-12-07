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
    input PS2Clk, // USB
    input PS2Data, // USB
    output [7:0] led 
);
    reg en_send;
    reg [7:0] send_data;

    wire [7:0] O;
    wire we;
    wire tx_busy;
    uart uart_instance(clk, 0, send_data, en_send, tx_busy, RsTx, RsRx, O, we); // Instance of uart
    
    // PS2 Keyboard
    wire [7:0] keycode;
    wire flag;
    ps2 uut (
        .clk(clk),
        .ps2_clk(PS2Clk),
        .ps2_data(PS2Data),
        .scancode(keycode),
        .new_code(flag)
    );
    
    // Read data when push-up detected (0xF0)
    reg [7:0] keyboard_data;
    reg push_up = 0;
    always @(posedge clk) begin
        if (flag && keycode == 8'hF0) begin
            push_up = 1;
        end
        else if (push_up && flag) begin
            keyboard_data <= keycode;
            push_up = 0;
        end
    end

    assign led = keyboard_data;
    
    reg [7:0] input_switchs;
    wire [3:0] num3, num2, num1, num0; // left to right
    wire an0, an1, an2, an3;
    assign an = {an3, an2, an1, an0};
    assign num3 = keyboard_data[7:4];
    assign num2 = keyboard_data[3:0];
    assign num1 = send_data[7:4];
    assign num0 = send_data[3:0];
    
    wire sp_btnU;
    singlePulser pulser( .d(sp_btnU),.pushed(btnU),.clk(clk));
    always @(posedge clk) begin
        if (en_send) begin 
            en_send <= 0;
        end else if (sp_btnU) begin
            send_data <= sw;
            en_send <= 1;
        end
    end

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
    quadSevenSeg segment( seg, dp, an0, an1, an2, an3, num0, num1, num2, num3, target_enable );

endmodule