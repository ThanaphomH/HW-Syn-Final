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
    output reg [DATA_WIDTH-1:0] dout     // Data output for the read port
);

    // Memory declaration: 2D array
    reg [DATA_WIDTH-1:0] mem [0:ROWS-1][0:COLS-1];

    integer i, j;
    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < ROWS; i = i + 1) begin
                for (j = 0; j < COLS; j = j + 1) begin
                    mem[i][j] <= {DATA_WIDTH{1'b0}}; 
                end
            end
        end else if (we && din != 8'h7E) begin
            mem[w_row][w_col] <= din;   // Write data to specified address
        end
    end

    // Read operation
    always @(posedge clk) begin
        dout <= mem[r_row][r_col];      // Read data from specified address
    end

endmodule