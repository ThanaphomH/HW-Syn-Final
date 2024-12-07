module uart #(
    parameter CLK_FREQ = 100000000,
    parameter BAUD_RATE = 9600
)(
    input  wire        clk,
    input  wire        rst,
    // Transmit interface
    input  wire [7:0]  tx_data,
    input  wire        tx_start,
    output wire        tx_busy,
    output wire        tx_serial_out,
    // Receive interface
    input  wire        rx_serial_in,
    output wire [7:0]  rx_data,
    output wire        rx_ready
);

    // Calculate divisor for baud rate from clock frequency
    localparam integer DIVISOR = CLK_FREQ / BAUD_RATE;

    // Instantiate transmitter
    uart_tx #(
        .DIVISOR(DIVISOR)
    ) tx_inst (
        .clk(clk),
        .rst(rst),
        .tx_data(tx_data),
        .tx_start(tx_start),
        .tx_busy(tx_busy),
        .tx_serial_out(tx_serial_out)
    );

    // Instantiate receiver
    uart_rx #(
        .DIVISOR(DIVISOR)
    ) rx_inst (
        .clk(clk),
        .rst(rst),
        .rx_serial_in(rx_serial_in),
        .rx_data(rx_data),
        .rx_ready(rx_ready)
    );

endmodule