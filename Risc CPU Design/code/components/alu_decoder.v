
// alu_decoder.v - logic for ALU decoder

module alu_decoder (
    input            opb5,
    input [2:0]      funct3,
    input            funct7b5,
    input [1:0]      ALUOp,
    output reg [3:0] ALUControl
);

always @(*) begin
    case (ALUOp)
        2'b00: ALUControl = 4'b0000;             // ADD (e.g., for lw, sw)
        2'b01: ALUControl = 4'b0001;             // SUB (e.g., for beq, bne)
        default: begin                          // R-type or I-type
            case (funct3)
                3'b000: begin
                    if (funct7b5 & opb5)
                        ALUControl = 4'b0001;    // SUB
                    else
                        ALUControl = 4'b0000;    // ADD or ADDI
                end
                3'b001: ALUControl = 4'b0100;    // SLLI or sll
                3'b010: ALUControl = 4'b0101;    // SLT
                3'b011: ALUControl = 4'b0110;    // SLTU
                3'b100: ALUControl = 4'b0111;    // XOR
                3'b101: begin
                    if (funct7b5)
                        ALUControl = 4'b1001;    // SRAI
                    else
                        ALUControl = 4'b1000;    // SRLI
                end
                3'b110: ALUControl = 4'b0011;    // OR
                3'b111: ALUControl = 4'b0010;    // AND
                default: ALUControl = 4'bxxxx;   // Undefined
            endcase
        end
    endcase
end


endmodule

