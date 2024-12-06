module ps2_keyboard(
    input wire clk,           // System clock
    input wire ps2_clk,       // PS/2 clock
    input wire ps2_data,      // PS/2 data
    output reg [7:0] keycode, // Output keycode
    output reg key_valid      // Valid key signal
);

    reg [10:0] shift_reg = 0; // 11-bit shift register for PS/2 protocol
    reg [3:0] bit_count = 0;  // Counter for bits received
    reg ps2_clk_prev = 1;     // Previous state of PS/2 clock for edge detection

    always @(posedge clk) begin
        // Detect falling edge of ps2_clk
        if (ps2_clk_prev && ~ps2_clk) begin
            shift_reg <= {ps2_data, shift_reg[10:1]}; // Shift in data bit
            bit_count <= bit_count + 1;              // Increment bit counter

            // Check for complete frame (11 bits)
            if (bit_count == 10) begin
                bit_count <= 0;                  // Reset bit counter
                if (shift_reg[0] == 0 &&        // Start bit must be 0
                    shift_reg[10] == 1) begin   // Stop bit must be 1
                    keycode <= shift_reg[8:1]; // Extract keycode (8 bits)
                    key_valid <= 1;            // Set valid key signal
                end else begin
                    key_valid <= 0;            // Invalid frame
                end
            end
        end else begin
            key_valid <= 0; // Reset valid key signal on no new data
        end
        ps2_clk_prev <= ps2_clk; // Update previous clock state
    end

endmodule