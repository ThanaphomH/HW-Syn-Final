module uart_rx #(
    parameter integer DIVISOR = 10417
)(
    input  wire       clk,
    input  wire       rst,
    input  wire       rx_serial_in,
    output reg [7:0]  rx_data,
    output reg        rx_ready
);
    localparam IDLE = 0, START = 1, DATA = 2, STOP = 3;

    reg [1:0]   state = IDLE;
    reg [7:0]   data_reg;
    reg [2:0]   bit_index;
    reg [15:0]  baud_cnt;
    reg         sample_point;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            state      <= IDLE;
            rx_data    <= 0;
            rx_ready   <= 0;
            data_reg   <= 0;
            bit_index  <= 0;
            baud_cnt   <= 0;
        end else begin
            rx_ready <= 0; // default

            case(state)
                IDLE: begin
                    if(rx_serial_in == 1'b0) begin
                        // Detect start bit
                        state     <= START;
                        baud_cnt  <= 0;
                    end
                end

                START: begin
                    if(baud_cnt == (DIVISOR/2)) begin
                        // Sample in the middle of start bit
                        if(rx_serial_in == 1'b0) begin
                            // Valid start bit
                            baud_cnt  <= 0;
                            bit_index <= 0;
                            data_reg  <= 0;
                            state     <= DATA;
                        end else begin
                            // False start
                            state <= IDLE;
                        end
                    end else begin
                        baud_cnt <= baud_cnt + 1;
                    end
                end

                DATA: begin
                    if(baud_cnt == DIVISOR-1) begin
                        baud_cnt <= 0;
                        data_reg[bit_index] <= rx_serial_in;
                        bit_index <= bit_index + 1;
                        if(bit_index == 7)
                            state <= STOP;
                    end else begin
                        baud_cnt <= baud_cnt + 1;
                    end
                end

                STOP: begin
                    if(baud_cnt == DIVISOR-1) begin
                        baud_cnt <= 0;
                        // Check stop bit
                        if(rx_serial_in == 1'b1) begin
                            rx_data  <= data_reg;
                            rx_ready <= 1'b1;
                        end
                        state <= IDLE;
                    end else begin
                        baud_cnt <= baud_cnt + 1;
                    end
                end

            endcase
        end
    end

endmodule