module ps2 (
    input        clk,        // System clock
    input        ps2_clk,    // PS/2 clock line from keyboard
    input        ps2_data,   // PS/2 data line from keyboard
    output reg [7:0] scancode,  // Last received 8-bit scancode
    output reg   new_code      // Pulses high for one clk cycle when a new code is received
);

    // Synchronize the asynchronous PS/2 signals to the system clock
    reg [2:0] ps2_clk_sync  = 3'b111;
    reg [2:0] ps2_data_sync = 3'b111;

    always @(posedge clk) begin
        ps2_clk_sync  <= {ps2_clk_sync[1:0], ps2_clk};
        ps2_data_sync <= {ps2_data_sync[1:0], ps2_data};
    end

    // Detect falling edge of PS/2 clock
    wire ps2_clk_falling_edge = (ps2_clk_sync[2:1] == 2'b10);

    // State machine for receiving data bits
    localparam STATE_IDLE     = 4'd0;
    localparam STATE_DATA     = 4'd2;
    localparam STATE_PARITY   = 4'd3;
    localparam STATE_STOP     = 4'd4;
    localparam STATE_DONE     = 4'd5;

    // Initialize registers
    reg [3:0] state          = STATE_IDLE;
    reg [7:0] shift_reg      = 8'd0;
    reg [3:0] bit_count      = 4'd0;
    reg parity_bit           = 1'b0;
    reg stop_bit             = 1'b0;

    always @(posedge clk) begin
        new_code <= 1'b0; // default each cycle

        case (state)
            STATE_IDLE: begin
                // Wait for start bit (0) on falling edge
                // The start bit is indicated by ps2_data_sync[2] == 0
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
                // For simplicity, we assume parity and stop bits are correct
                scancode <= shift_reg;
                new_code <= 1'b1;
                // Return to idle and look for next code
                state <= STATE_IDLE;
            end

            default: state <= STATE_IDLE;
        endcase
    end

endmodule
