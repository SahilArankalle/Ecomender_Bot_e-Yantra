// EcoMender Bot : Task 1B : Color Detection using State Machines
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.
This file is used to design a module which will detect colors red, green, and blue using state machine and frequency detection.

Recommended Quartus Version : 20.1
The submitted project file must be 20.1 compatible as the evaluation will be done on Quartus Prime Lite 20.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

//Color Detection
//Inputs : clk_1MHz, cs_out
//Output : filter, color

// Module Declaration
module t1b_cd_fd (
    input  clk_1MHz, cs_out,
    output reg [1:0] filter, color
);

// red   -> color = 1;
// green -> color = 2;
// blue  -> color = 3;

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE //////////////////

initial begin // editing this initial block is allowed
    filter = 2; color = 0;
end

parameter green = 2'b11, 
			 red = 2'b00, 
			 blue = 2'b01, 
			 clear = 2'b10;  

reg [8:0] counter;         // Timing counter to manage 500 ns and 1 ns timing 
reg [15:0] freq_counter;    // Frequency counter for cs_out
reg [15:0] freq_red, freq_green, freq_blue;  // Registers to store frequencies for each color

reg prev_filter;
reg cs_out_prev;            

initial begin
    filter = 2;         // Start with green filter
    color = 0;
    counter = 0;
    freq_counter = 0;
    freq_red = 0;
    freq_green = 0;
    freq_blue = 0;
end

always @(posedge clk_1MHz) begin
    counter = counter + 1;

    case (filter)
        green: begin
            if (counter == 500) begin
                filter = red;
                counter = 0;
            end
        end
        red: begin
            if (counter == 500) begin
                filter = blue;
                counter = 0;
            end
        end
        blue: begin
            if (counter == 500) begin
                filter = clear;
                counter = 0;
					  if (freq_red > freq_green && freq_red > freq_blue) begin
							color = 3;  // Red
					  end 
					  else if (freq_green > freq_red && freq_green > freq_blue) begin
							color = 2;  // Green
					  end 
					  else if (freq_blue > freq_red && freq_blue > freq_green) begin
							color = 1;  // Blue
					  end 
					  else begin
							color = 0;  // Undefined
					  end
					 
            end
        end
        clear: begin
            if (counter == 1) begin
                filter = green;
                counter = 0;
            end
        end
        default: begin
            filter = green;
        end
    endcase
	 prev_filter = filter;
end

always @(*) begin
    if (cs_out || cs_out_prev) begin
        freq_counter = freq_counter + 1;  
    end
    cs_out_prev = cs_out;
	 
		
    if (filter == clear) begin
		  freq_counter =0;
    end
	 
	 

end

always @(*) begin
    if (filter == green && counter <= 500) begin
        freq_green = freq_counter;
    end
	 
    if (filter == red && counter <= 500) begin
        freq_red = freq_counter;
    end
	 
    if (filter == blue && counter <= 500) begin
        freq_blue = freq_counter;
    end
    
    if (filter == clear) begin
		  //freq_counter =0;
        freq_red = 0;
        freq_green = 0;
        freq_blue = 0;
    end
  
end


//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE //////////////////

endmodule
