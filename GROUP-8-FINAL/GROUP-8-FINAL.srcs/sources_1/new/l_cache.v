`timescale 1ns / 1ps

module inmem(input [2:0] PC, input clk, output reg [31:0] instruction);
    reg [31:0] ins_memo [7:0];
    always@(posedge clk)
    begin
    ins_memo[0] = 32'b00000000000000000000111010010011;
    ins_memo[1] = 32'b00000000001_00000_000_11110_0010011;
    ins_memo[2] = 32'b000000000000_11101_100_11100_0010011;
    ins_memo[3] = 32'b000000000000_11110_100_11011_0010011;
    ins_memo[4] = 32'b1000000_11100_11011_000_01010_0110011;
    ins_memo[5] = 32'b00000000_01010_11101_010_00000_0100011;
        instruction = ins_memo[PC];
    end
endmodule
