module DualPortRAM (
    input wire clk,                      // Clock signal
    input wire we,                       // Write enable for the write port
    input wire reset,                    // Synchronous reset signal
    input wire [4:0] w_row, // Row address for the write port
    input wire [1:0] w_col, // Column address for the write port
    input wire [7:0] din,     // Data input for the write port
    input wire [4:0] r_row, // Row address for the read port
    input wire [1:0] r_col, // Column address for the read port
    output reg [7:0] dout,     // Data output for the read port
    output reg [7:0] tdout1,   // Data output for the read port
    output reg [7:0] tdout2
);

    // Memory declaration: 2D array
    reg [7:0] mem [0:3][0:31];
    reg resetting;

    reg [4:0] reset_row;
    reg [1:0] reset_col,

    // Write operation
    always @(posedge clk) begin
        // Reset all memory slot at once will result in black monitor, 
        // attempt to reset one memory cell per clock instead
        if(resetting) begin
            mem[reset_row][reset_col] <= 8b'00000000;

            // move reset cursor to cover all memory slot
            if (reset_row == 5'b11111 && reset_col == 2b'11) begin
                resetting = 0;
            end else if (reset_col == 2b'11) begin
                reset_col = 0;
                reset_row = reset_row + 1;
            end else begin
                reset_col = reset_col + 1;
            end
        end if (reset) begin
            reset_row = 0;
            reset_col = 0;
            resetting = 1;
        end else if (we && din != 8'b00001101 && din != 8'b00001010) begin
            mem[w_row][w_col] <= din;   // Write data to specified address
        end
    end

    // Read operation
    always @(posedge clk) begin
        dout <= mem[r_row][r_col];      // Read data from specified address
        tdout1 <= mem[0][0];      // Read data from specified address
        tdout2 <= mem[0][1];      // Read data from specified address
    end

endmodule