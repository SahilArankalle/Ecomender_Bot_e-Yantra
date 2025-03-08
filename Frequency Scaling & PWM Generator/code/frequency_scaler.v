// EcoMender Bot : Task 1A : Frequency Scaling
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.
This file is used to design a module which will scale down the 50MHz Clock Frequency to 1MHz.

Recommended Quartus Version : 20.1
The submitted project file must be 20.1 compatible as the evaluation will be done on Quartus Prime Lite 20.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

//Frequency Scaling
//Inputs : clk_50MHz
//Output : clk_1MHz


module frequency_scaler (
    input clk_50MHz,
    output reg clk_1MHz
);

initial begin
    clk_1MHz = 1;
end

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE //////////////////
reg [4:0] counter = 0;

always @ (posedge clk_50MHz)
begin
if (counter == 5'b11001)
begin
clk_1MHz = ~clk_1MHz;

counter = 0;
end
counter = counter + 5'b1;
end 

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE //////////////////

endmodule
