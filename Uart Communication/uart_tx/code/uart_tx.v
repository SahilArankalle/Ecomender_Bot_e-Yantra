// EcoMender Bot : Task 2A - UART Transmitter
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.

This file is used to generate UART Tx data packet to transmit the messages based on the input data.

Recommended Quartus Version : 20.1
The submitted project file must be 20.1 compatible as the evaluation will be done on Quartus Prime Lite 20.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

/*
Module UART Transmitter

Input:  clk_3125 - 3125 KHz clock
        parity_type - even(0)/odd(1) parity type
        tx_start - signal to start the communication.
        data    - 8-bit data line to transmit

Output: tx      - UART Transmission Line
        tx_done - message transmitted flag
*/

// module declaration
module uart_tx(
    input clk_3125,
    input parity_type,tx_start,
    input [7:0] data,
    output reg tx, tx_done
);

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////

parameter IDLE = 3'b000, START_BIT = 3'b001, READ_BITS = 3'b010, PARITY_BIT = 3'b011, STOP_BIT = 3'b100;

// Internal signals
reg [2:0] state;
reg [2:0] bit_index;
reg [3:0] clk_counter;  // Counter for baud rate timing (15 cycles)
reg [7:0] data_reg;     // Shift register for UART packet
reg parity_bit;         // Calculated parity bit

// Initialization
initial begin
    tx = 1;             // Idle line is high
    tx_done = 0;
    state = IDLE;
    clk_counter = 0;
    bit_index = 0;
    data_reg = 8'b0;
    parity_bit = 0;
end

always @(posedge clk_3125) begin
    case (state)
        IDLE: begin
             // Keep line idle
            tx_done <= 0;
            if (tx_start) begin
					tx <= 0;
                data_reg <= data;
                // Calculate parity bit
                parity_bit <= parity_type ? ~(^data) : (^data);
                state <= START_BIT;
            end
        end

        START_BIT: begin
            if (clk_counter <= 11) begin
                tx <= 0; // Transmit start bit
                clk_counter <= clk_counter + 1;
            end else begin
                clk_counter <= 0;
                state <= READ_BITS;
            end
        end

        READ_BITS: begin
            if (clk_counter <= 12) begin
                tx <= data_reg[7]; // Transmit LSB first
                clk_counter <= clk_counter + 1;
            end else begin
                clk_counter <= 0;
                data_reg <= data_reg << 1; // Shift to the next bit
                bit_index <= bit_index + 1;
                if (bit_index == 7) begin
                    bit_index <= 0;
                    state <= PARITY_BIT;
                end
            end
        end

        PARITY_BIT: begin
            if (clk_counter <= 12) begin
                tx <= parity_bit; // Transmit parity bit
                clk_counter <= clk_counter + 1;
            end else begin
                clk_counter <= 0;
                state <= STOP_BIT;
            end
        end

        STOP_BIT: begin
            if (clk_counter <= 12) begin
                tx <= 1; // Transmit stop bit
                clk_counter <= clk_counter + 1;
            end else begin
                clk_counter <= 0;
                tx_done <= 1; // Signal transmission done
                state <= IDLE;
            end
        end
    endcase
end



//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////

endmodule