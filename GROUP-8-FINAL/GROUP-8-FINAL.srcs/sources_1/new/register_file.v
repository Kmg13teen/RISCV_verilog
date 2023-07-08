`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.04.2023 15:54:58
// Design Name: 
// Module Name: register_file
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module register(
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input enable,
    input [31:0] write_value,
    input clk,
    output [31:0] read_value_1,
    output [31:0] read_value_2
    );
    reg [31:0] register_file [31:0];
    integer i;
 
    always @(posedge clk)
    begin
    register_file[0] = 32'b0;
    case(enable)
        1'b1:
        begin
             register_file[rd] = write_value;
             $display("Entered Register File to write the value %d at destination register %d at time = %d",write_value,rd,$time);
        end        
    endcase
       
    end
    
assign read_value_1 = register_file[rs1];
assign read_value_2 = register_file[rs2];
endmodule
