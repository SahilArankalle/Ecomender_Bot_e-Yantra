
// alu.v - ALU module

module alu #(parameter WIDTH = 32) (
    input       [WIDTH-1:0] a, b,       // operands
    input       [3:0] alu_ctrl,         // ALU control
    output reg  [WIDTH-1:0] alu_out,    // ALU output
    output      zero                    // zero flag
);

always @(a, b, alu_ctrl) begin
    case (alu_ctrl)
        4'b0000:  alu_out <= a + b;       // ADD
        4'b0001:  alu_out <= a + ~b + 1;  // SUB
        4'b0010:  alu_out <= a & b;       // AND
        4'b0011:  alu_out <= a | b;       // OR
		  4'b0100:  alu_out <= a << b; //sll or slli
        4'b0101:  alu_out <= ($signed(a) < $signed(b)) ? 1 : 0;		  // slt or slti
		  4'b0110:  alu_out <= (a < b) ? 1 : 0; //sltu or sltui
		  4'b0111:  alu_out <= a ^ b;  //xor or xori
		  4'b1000:  alu_out <= a >> b;  //srl or srli
		  4'b1001:  alu_out <= $signed(a) >>> b[4:0]; //sra or srai
		  
        default: alu_out = 0;
    endcase
end

assign zero = (alu_out == 0) ? 1'b1 : 1'b0;

endmodule

