`timescale 1ns / 1ps
module decoder_unit(
    input [31:0] instruction,
    output reg [16:0] opcode,
    output reg [4:0] rs1,
    output reg [4:0] rs2,
    output reg [4:0] rd,
    output reg [11:0] immediate
);

always @ (instruction)
begin
    case (instruction[6:0])
        7'b0110011:
        begin
        rs2 <= instruction[24:20];
        rs1 <= instruction[19:15];
        immediate <= 12'b0;
        opcode = {instruction[31:25],instruction[14:12],instruction[6:0]};
        rd <= instruction[11:7];
        end
   
    7'b0010011:
        begin
        immediate <= instruction[31:20];
        rs2 <= 5'b0;
        rs1 <= instruction[19:15];
        rd <= instruction[11:7];
        opcode = {7'b0,instruction[14:12],instruction[6:0]};
        end
       
   7'b0100011:
       begin
       immediate <= {instruction[31:25], instruction[11:7]};
       rs2 <= instruction[24:20];
       rs1 <= instruction[19:15];
       rd <= 5'b0;
       opcode <= {instruction[14:12],instruction[6:0]};    
       end
       
     7'b0000011:
        begin
        immediate <= instruction[31:20];
         rs2 <= 5'b0;
         rs1 <= instruction[19:15];
         rd <= instruction[11:7];
         opcode <= {instruction[14:12],instruction[6:0]};
        end
   
    endcase
end
endmodule