`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2021 09:59:35 PM
// Design Name: 
// Module Name: uart
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module uart(
    input clk,
    input RsRx,
    output RsTx,
    output reg [7:0]  data_2 ,
    output reg we,
    input tx_start,        // New input signal to start transmission
    input [7:0] tx_data    // New input signal for data to transmit
    );
    
    reg last_rec;
    wire [7:0] data_out;
    wire sent, received, baud;
    
    baudrate_gen baudrate_gen(clk, baud);
    uart_rx receiver(baud, RsRx, received, data_out);
    uart_tx transmitter(baud, data_in, en, sent, RsTx);
    
    always @(posedge baud) begin
        if (~last_rec & received) begin
            data_2 = data_out;
            we = 1;
        end else begin
            we = 0;
        end

        // Transmission logic
        if (tx_start) begin
            data_in = tx_data;
            en = 1;
        end
    
        last_rec = received;
    end

    
endmodule