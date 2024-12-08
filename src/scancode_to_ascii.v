`timescale 1ns / 1ps

module scancode_to_ascii(
    input clk,
    input [7:0] scancode,
    input push_up,
    input push_down,
    output [7:0] ascii,
    output reg [3:0] led,
    output is_thai
);
    reg is_thai = 0;
    wire shifting;
    reg holding_shift = 0;
    reg caplock = 0;
    
    wire [9:0] scancode_data;
    assign scancode_data = { is_thai, shifting, scancode };
    assign shifting = (holding_shift && !caplock) || (!holding_shift && caplock);
    
    always @(posedge clk) begin
        led = {push_up , push_down , shifting, is_thai};
        
        if (push_down && scancode == 8'h58) begin // press caplock
            caplock <= ~caplock;
        end else if (push_down && (scancode == 8'h12 || scancode == 8'h59)) begin // hold shift left/right
            holding_shift <= 1;
        end else if (push_up && (scancode == 8'h12 || scancode == 8'h59)) begin // release shift left/right
            holding_shift <= 0;
        end else if (push_down && scancode == 8'h0E) begin // press ~
            is_thai <= ~is_thai;
        end
    end
    
    scancode_rom rom (.clk(clk) , .addr(scancode_data) , .data(ascii));

endmodule