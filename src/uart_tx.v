module uart_tx #(
    parameter integer DIVISOR = 10417 // For 50MHz and 115200 baud approx
)(
    input  wire       clk,
    input  wire       rst,
    input  wire [7:0] tx_data,
    input  wire       tx_start,
    output reg        tx_busy,
    output reg        tx_serial_out
);
    localparam IDLE = 0, START = 1, DATA = 2, STOP = 3;

    reg [1:0]  state = IDLE;
    reg [7:0]  data_reg;
    reg [2:0]  bit_index;
    reg [15:0] baud_cnt;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            state         <= IDLE;
            tx_serial_out <= 1'b1;
            tx_busy       <= 1'b0;
            baud_cnt      <= 0;
            bit_index     <= 0;
        end else begin
            case(state)
                IDLE: begin
                    tx_serial_out <= 1'b1; // line idle high
                    if(tx_start) begin
                        data_reg <= tx_data;
                        tx_busy  <= 1'b1;
                        state    <= START;
                        baud_cnt <= 0;
                    end
                end

                START: begin
                    if(baud_cnt < (DIVISOR - 1))
                        baud_cnt <= baud_cnt + 1;
                    else begin
                        baud_cnt      <= 0;
                        tx_serial_out <= 1'b0; // start bit
                        state         <= DATA;
                        bit_index     <= 0;
                    end
                end

                DATA: begin
                    if(baud_cnt < (DIVISOR - 1)) begin
                        baud_cnt <= baud_cnt + 1;
                    end else begin
                        baud_cnt      <= 0;
                        tx_serial_out <= data_reg[bit_index];
                        bit_index     <= bit_index + 1;
                        if(bit_index == 7)
                            state <= STOP;
                    end
                end

                STOP: begin
                    if(baud_cnt < (DIVISOR - 1))
                        baud_cnt <= baud_cnt + 1;
                    else begin
                        baud_cnt      <= 0;
                        tx_serial_out <= 1'b1; // stop bit
                        tx_busy       <= 1'b0;
                        state         <= IDLE;
                    end
                end

            endcase
        end
    end

endmodule
