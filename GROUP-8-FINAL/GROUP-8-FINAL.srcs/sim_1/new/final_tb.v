`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.04.2023 21:53:05
// Design Name: 
// Module Name: Final_tb
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


module last_tb;
reg main_clk;
reg alu_clk;
wire [31:0] ins;
   wire [31:0] read_value_1;
   wire [31:0] read_value_2;
   wire [4:0] rsa1;
   wire [4:0] rsa2;
   wire [16:0] opcodea;
   wire [11:0] immediatea;
   wire [4:0] rda;
   wire [31:0] alu_output;
   wire [31:0] dmem_output;
   wire [31:0] tempU;
  

    

    // Register file write controllers
    wire write_enable_regfile;
    wire [31:0] write_value_regfile;
    wire [4:0] write_dest_regfile;
    
    // Pipelined registers at IF-Stage
   wire [2:0] PC;
   wire [4:0] pipe3_if_RDA;
   wire [16:0] pipe4_if_OPCODE;
   wire[4:0] pipe5_if_RS1;
   wire [4:0] pipe6_if_RS2;
   wire [11:0] pipe7_if_IMM;
   
    // Pipelined registers at ID-Stage
    wire [31:0] alu_input_b;
    wire [31:0] pipe1_id_RV1;
    wire [31:0] pipe2_id_RV2;
    wire [31:0] pipe3_id_IMM;
    wire [4:0] pipe4_id_RDA;
    wire [16:0] pipe5_id_OPCODE;
    wire pipe6_id_write_enable_regfile;
    wire pipe7_id_read_en_dmem;
    wire pipe8_id_write_en_dmem;
    
    // Pipeline register at EX-Stage
    wire [31:0] pipe1_ex_ALUOUTPUT;
    wire [31:0] pipe2_ex_RV2;
    wire pipe3_ex_write_enable_regfile;
    wire pipe4_ex_read_en_dmem;
    wire [16:0] pipe4_ex_OPCODE;
    wire [4:0] pipe5_ex_RDA;
    wire pipe6_ex_write_en_dmem;
    
    //Pipeline registers at Mem-Stage
    wire [31:0] pipe1_mem_WRITEVAL;
    wire [31:0] pipe2_mem_WRITEVAL2;
    wire [4:0] pipe3_mem_WRITEDEST;
    wire [4:0] pipe4_mem_RDA;
main dut(main_clk, alu_clk,
          write_enable_regfile,
 write_value_regfile,
      write_dest_regfile,
    
    // Pipelined registers at IF-Stage
 PC,
 pipe3_if_RDA,
 pipe4_if_OPCODE,
 pipe5_if_RS1,
 pipe6_if_RS2,
 pipe7_if_IMM,
   
    // Pipelined registers at ID-Stage
 alu_input_b,
 pipe1_id_RV1,
  pipe2_id_RV2,
 pipe3_id_IMM,
 pipe4_id_RDA,
 pipe5_id_OPCODE,
     pipe6_id_write_enable_regfile,
pipe7_id_read_en_dmem,
 pipe8_id_write_en_dmem,
    
    // Pipeline register at EX-Stage
 pipe1_ex_ALUOUTPUT,
 pipe2_ex_RV2,
 pipe3_ex_write_enable_regfile,
     pipe4_ex_read_en_dmem,
     pipe4_ex_OPCODE,
    pipe5_ex_RDA,
   pipe6_ex_write_en_dmem,
    
    //Pipeline registers at Mem-Stage
     pipe1_mem_WRITEVAL,
    pipe2_mem_WRITEVAL2,
     pipe3_mem_WRITEDEST,
     pipe4_mem_RDA,
    ins,
    read_value_1,
    read_value_2,
   rsa1,
   rsa2,
    opcodea,
    immediatea,
    rda,
    alu_output,
    dmem_output,
    tempU);
initial begin
    main_clk = 1'b1;
    alu_clk = 1'b1;
end
always #50 main_clk = ~main_clk;
always #12.5 alu_clk = ~alu_clk;
endmodule
