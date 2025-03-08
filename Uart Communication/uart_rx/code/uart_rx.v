// EcoMender Bot : Task 2A - UART Receiver
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.

This file is used to receive UART Rx data packet from receiver line and then update the rx_msg and rx_complete data lines.

Recommended Quartus Version : 20.1
The submitted project file must be 20.1 compatible as the evaluation will be done on Quartus Prime Lite 20.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

/*
Module UART Receiver

Baudrate: 230400 

Input:  clk_3125 - 3125 KHz clock
        rx      - UART Receiver

Output: rx_msg - received input message of 8-bit width
        rx_parity - received parity bit
        rx_complete - successful uart packet processed signal
*/

// module declaration
module uart_rx(
    input clk_3125,
    input rx,
    output reg [7:0] rx_msg,
    output reg rx_parity,
    output reg rx_complete
    );

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////



localparam clk_per_bits = 14, IDLE_BIT = 3'b000, START_BIT = 3'b001, READ_BITS = 3'b010, PARTIY_BIT = 3'b011, COMP_BIT = 3'b100;

reg [2:0] state;      
reg [4:0] clk_counter;      
reg [2:0] data_index;
reg [7:0] data_reg;
reg parity_bit = 0;
reg calculate_parity;

initial begin
    rx_msg = 0;
    rx_parity = 0;
    rx_complete = 0;
    state = IDLE_BIT;
    clk_counter = 0;
    data_index = 0;
	 //calculate_parity=0;
end


always@(posedge clk_3125)
begin
    case(state)
        IDLE_BIT:begin
                rx_complete <= 0;
                if(rx == 0) begin
                    state <= START_BIT;
                end
                else begin
                    state <= IDLE_BIT;
                end
        end
		  
        START_BIT:begin
                if(clk_counter == 6)    begin
                    if(rx == 0)     begin
                        state <= READ_BITS;
                        clk_counter <= 0;
                    end
                    else    begin
                        state <= IDLE_BIT;
                        clk_counter <= 0;
                    end
                end
                else    begin
                    clk_counter <= clk_counter + 1;
                    
                end
        end
		  
        READ_BITS:begin
                    if(clk_counter == 13)   begin
                        clk_counter <= 0;
                        data_reg[7:1] <= data_reg[6:0];
								data_reg[0] <= rx;

                        if(data_index == 7)     begin
                            data_index <= 0;
                            state <= PARTIY_BIT;
                        end
                        else    begin
                            data_index <= data_index + 1;
                            
                        end
                        
                    end
                    else    begin
                        clk_counter <= clk_counter + 1;
                    end
        end
        PARTIY_BIT: begin
                    if(clk_counter == 13) begin
                        clk_counter <= 0;
                        parity_bit <= rx;
								
							calculate_parity = data_reg[0]^data_reg[1]^data_reg[2]^data_reg[3]^data_reg[4]^data_reg[5]^data_reg[6]^data_reg[7];


                     if( calculate_parity == rx) begin
							state <= COMP_BIT;
                    end
                    else begin
                        data_reg <= 8'h3F;
                        state <= COMP_BIT;
                    end
                    end
                    else begin
                        clk_counter <= clk_counter + 1;
                    end
        end
        COMP_BIT:begin
            if(clk_counter == 20)   begin
                clk_counter <= 1;
                rx_msg <= data_reg;
                state <= IDLE_BIT;
                rx_complete <= 1;
                rx_parity <= parity_bit;
            end
            else       clk_counter <= clk_counter + 1;
            
        end
    endcase
end




//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////


endmodule