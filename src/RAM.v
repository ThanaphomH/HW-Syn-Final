module DualPortRAM #(
    parameter DATA_WIDTH = 8,          // Width of each data element
    parameter ROWS = 4,                // Number of rows
    parameter COLS = 32                 // Number of columns
) (
    input wire clk,                      // Clock signal
    input wire we,                       // Write enable for the write port
    input wire reset,                    // Synchronous reset signal
    input wire [$clog2(ROWS)-1:0] w_row, // Row address for the write port
    input wire [$clog2(COLS)-1:0] w_col, // Column address for the write port
    input wire [DATA_WIDTH-1:0] din,     // Data input for the write port
    input wire [$clog2(ROWS)-1:0] r_row, // Row address for the read port
    input wire [$clog2(COLS)-1:0] r_col, // Column address for the read port
    output reg [DATA_WIDTH-1:0] dout,     // Data output for the read port
    output reg [DATA_WIDTH-1:0] tdout1,   // Data output for the read port
    output reg [DATA_WIDTH-1:0] tdout2
);

    // Memory declaration: 2D array
    reg [DATA_WIDTH-1:0] mem [0:ROWS-1][0:COLS-1];
    reg resetting;

    reg [$clog2(ROWS)-1:0] reset_row;
    reg [$clog2(COLS)-1:0] reset_col;

    always @(posedge clk) begin
        // Reset all memory slot at once will result in black monitor, 
        // attempt to reset one memory cell per clock instead
        if(resetting) begin
            mem[reset_row][reset_col] <= 8'b00000000;

            // move reset cursor to cover all memory slot
            if (reset_row == ROWS-1 && reset_col == COLS-1) begin
                resetting = 0;
            end else if (reset_col == 2'b11) begin
                reset_col = 0;
                reset_row = reset_row + 1;
            end else begin
                reset_col = reset_col + 1;
            end
        end else if (reset) begin
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