module ps2_keyboard (
    input        clk,        // System clock
    input        reset_n,    // Active-low asynchronous reset
    input        ps2_clk,    // PS/2 clock line from keyboard
    input        ps2_data,   // PS/2 data line from keyboard
    output reg [7:0] scancode, // Last received 8-bit scancode
    output reg   new_code    // Pulses high for one clk cycle when a new code is received
);

    // Synchronize the asynchronous PS/2 signals to the system clock
    // for stable edge detection.
    reg [2:0] ps2_clk_sync;
    reg [2:0] ps2_data_sync;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            ps2_clk_sync  <= 3'b111;
            ps2_data_sync <= 3'b111;
        end else begin
            ps2_clk_sync  <= {ps2_clk_sync[1:0], ps2_clk};
            ps2_data_sync <= {ps2_data_sync[1:0], ps2_data};
        end
    end

    // Detect falling edge of PS/2 clock
    wire ps2_clk_rising_edge  = (ps2_clk_sync[2:1] == 2'b01);
    wire ps2_clk_falling_edge = (ps2_clk_sync[2:1] == 2'b10);

    // State machine for receiving data bits
    localparam STATE_IDLE     = 4'd0;
    localparam STATE_START    = 4'd1;
    localparam STATE_DATA     = 4'd2;
    localparam STATE_PARITY   = 4'd3;
    localparam STATE_STOP     = 4'd4;
    localparam STATE_DONE     = 4'd5;

    reg [3:0] state;
    reg [7:0] shift_reg;
    reg [3:0] bit_count; // counts bits of data received

    reg parity_bit;
    reg stop_bit;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state      <= STATE_IDLE;
            shift_reg  <= 8'd0;
            bit_count  <= 4'd0;
            parity_bit <= 1'b0;
            stop_bit   <= 1'b0;
            scancode   <= 8'd0;
            new_code   <= 1'b0;
        end else begin
            new_code <= 1'b0; // default

            case (state)
                STATE_IDLE: begin
                    // Wait for start bit (0) on falling edge
                    if (ps2_clk_falling_edge && (ps2_data_sync[2] == 1'b0)) begin
                        state     <= STATE_DATA;
                        bit_count <= 4'd0;
                    end
                end

                STATE_DATA: begin
                    if (ps2_clk_falling_edge) begin
                        // Read data bits LSB first
                        shift_reg <= {ps2_data_sync[2], shift_reg[7:1]};
                        bit_count <= bit_count + 1'b1;

                        if (bit_count == 4'd7) begin
                            // After 8 data bits received, move to parity bit
                            state <= STATE_PARITY;
                        end
                    end
                end

                STATE_PARITY: begin
                    if (ps2_clk_falling_edge) begin
                        parity_bit <= ps2_data_sync[2];
                        // Move to stop bit
                        state <= STATE_STOP;
                    end
                end

                STATE_STOP: begin
                    if (ps2_clk_falling_edge) begin
                        stop_bit <= ps2_data_sync[2];
                        // If stop bit is correct (should be 1), we consider data done
                        state <= STATE_DONE;
                    end
                end

                STATE_DONE: begin
                    // Validate parity and stop bit if needed.
                    // For now, assume it's correct.
                    scancode <= shift_reg;
                    new_code <= 1'b1;
                    // Return to idle and look for next code
                    state <= STATE_IDLE;
                end

                default: state <= STATE_IDLE;
            endcase
        end
    end

endmodule