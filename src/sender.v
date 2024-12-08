`timescale 1ns / 1ps

module sender (
    input clk,
    input [7:0] sw,
    input btnU,
    input wire RsRx, //uart // [7:4] for Higher num hex, [3:0] for Lower num
    output wire RsTx, //uart
    input PS2Clk, // PS2
    input PS2Data, // PS2
    output [11:0] led,
    
    output reg [7:0] send_data
);
    reg en_send = 0;

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
    
    // Get Data from keyboard
    reg [7:0] keyboard_scancode;
    reg keyboard_ready = 0; 
    reg ignore_next = 0;
    
    always @(posedge clk) begin
        if (keyboard_ready) keyboard_ready <= 0;
    
        if (flag && keycode == 8'hF0) begin // If receive 0xF0 then mark
            ignore_next <= 1;
        end
        else if (ignore_next && flag) begin // Ignore next data when push-up detected (0xF0)
            keyboard_scancode <= keycode;
            ignore_next <= 0;
        end else if (flag) begin
            keyboard_scancode <= keycode;
            keyboard_ready <= 1;
        end
    end

    assign led[7:0] = keyboard_scancode;
    
    // Scancode to ascii
//    wire delay1_keyboard_ready;
//    delay_one_cycle delay(clk, keyboard_ready, delay1_keyboard_ready);
//    wire delay2_keyboard_ready;
//    delay_one_cycle delay2(clk, delay1_keyboard_ready, delay2_keyboard_ready);
    wire sp_pushup;
    singlePulser puls(sp_pushup,push_up,clk);
    wire [7:0] keyboard_ascii;
    wire lang,shift;
    scancode_to_ascii stc(
        .clk(clk),
        .scancode(keyboard_scancode),
        .push_up(ignore_next),
        .push_down(keyboard_ready),
        .ascii(keyboard_ascii),
        .led(led[11:8]),
        .change_lang(lang)
    );
    
    wire sp_btnU;
    singlePulser pulser( .d(sp_btnU),.pushed(btnU),.clk(clk));
    always @(posedge clk) begin
        if (en_send) begin 
            en_send <= 0;
        end else if (sp_btnU) begin
            send_data <= sw;
            en_send <= 1;
        end else if (keyboard_ready) begin
            if (keyboard_ascii != 0) begin
                send_data <= { lang, keyboard_ascii[6:0]};
                en_send <= 1;
            end
        end
    end


endmodule