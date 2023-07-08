`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.04.2023 15:54:42
// Design Name: 
// Module Name: alu
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


module main(input clk,input CLK,
// Register file write controllers
     output reg write_enable_regfile,
     output reg [31:0] write_value_regfile,
     output reg [4:0] write_dest_regfile,
    
    // Pipelined registers at IF-Stage
   output reg [2:0] PC,
   output reg [4:0] pipe3_if_RDA,
   output reg [16:0] pipe4_if_OPCODE,
   output reg[4:0] pipe5_if_RS1,
   output reg [4:0] pipe6_if_RS2,
   output reg [11:0] pipe7_if_IMM,
   
    // Pipelined registers at ID-Stage
    output reg [31:0] alu_input_b,
    output reg [31:0] pipe1_id_RV1,
    output reg [31:0] pipe2_id_RV2,
    output reg [31:0] pipe3_id_IMM,
    output reg [4:0] pipe4_id_RDA,
    output reg [16:0] pipe5_id_OPCODE,
    output reg pipe6_id_write_enable_regfile,
    output reg pipe7_id_read_en_dmem,
    output reg pipe8_id_write_en_dmem,
    
    // Pipeline register at EX-Stage
    output reg [31:0] pipe1_ex_ALUOUTPUT,
    output reg [31:0] pipe2_ex_RV2,
    output reg pipe3_ex_write_enable_regfile,
    output reg pipe4_ex_read_en_dmem,
    output reg [16:0] pipe4_ex_OPCODE,
    output reg [4:0] pipe5_ex_RDA,
    output reg pipe6_ex_write_en_dmem,
    
    //Pipeline registers at Mem-Stage
    output reg [31:0] pipe1_mem_WRITEVAL,
    output reg [31:0] pipe2_mem_WRITEVAL2,
    output reg [4:0] pipe3_mem_WRITEDEST,
    output reg [4:0] pipe4_mem_RDA,
   output [31:0] ins,
   output [31:0] read_value_1,
   output [31:0] read_value_2,
   output [4:0] rsa1,
   output [4:0] rsa2,
   output [16:0] opcodea,
   output [11:0] immediatea,
   output [4:0] rda,
   output [31:0] alu_output,
   output [31:0] dmem_output,
   output [31:0] tempU);
  

    

    
    
    
    
    
   
   
    
  
   initial begin
   PC = 0;
   end
   always@(posedge clk)
   begin
       if(PC == 4)
       begin
       PC = PC;
       # 100
       PC = PC;
       end
       if(PC == 6)
       begin
           PC = PC;
       end
       else begin
           PC <= PC +1;
       end
   end
   
   inmem f0(PC, clk, ins);
   decoder_unit f1(ins,opcodea,rsa1,rsa2,rda,immediatea);
   
    always@(posedge clk)
    begin
    pipe3_if_RDA[4:0] <= rda;
    pipe4_if_OPCODE[16:0] <= opcodea;
    pipe5_if_RS1[4:0] <= rsa1;
    pipe6_if_RS2[4:0] <= rsa2;
    pipe7_if_IMM[11:0] <= immediatea;
    end
   
    register f2(pipe5_if_RS1,pipe6_if_RS2,write_dest_regfile,write_enable_regfile,write_value_regfile,clk,read_value_1,read_value_2);
    
    always@(posedge clk)
    begin
        if(pipe7_if_IMM[11] == 1)
        begin
        pipe3_id_IMM[31:0] = {30'b1,pipe7_if_IMM};
        end
        else begin
        pipe3_id_IMM[31:0] = {30'b0,pipe7_if_IMM};
        end
    end
    
   
   
    always@(posedge clk)
    begin
        if(pipe4_if_OPCODE[6:0] == 7'b0110011 || 7'b0010011 || 7'b0100011)
        begin
            pipe1_id_RV1[31:0] = read_value_1;
            pipe2_id_RV2[31:0] <= read_value_2;
        end 
        if(pipe5_if_RS1 == pipe5_ex_RDA[4:0])
        begin
            if(pipe4_ex_read_en_dmem == 1'b0)
            begin
                if(pipe5_if_RS1 == pipe4_id_RDA)
                    begin
                    pipe1_id_RV1[31:0] <= alu_output;
                    $display("forwarded");
                    end
                 else 
                 pipe1_id_RV1[31:0] <= pipe1_ex_ALUOUTPUT;
                 $display("forwarded");
            end
            if(pipe4_ex_read_en_dmem == 1'b1)
            begin
                pipe1_id_RV1[31:0] <= dmem_output;
                $display("forwarded");
            end
        end

        if(pipe6_if_RS2 == pipe5_ex_RDA[4:0])
        begin
            if(pipe4_ex_read_en_dmem == 1'b0)
            begin
                if(pipe6_if_RS2 == pipe4_id_RDA)
                begin
                pipe2_id_RV2[31:0] <= alu_output;
                $display("forwarded");
                end
                else
                pipe2_id_RV2[31:0] <= pipe1_ex_ALUOUTPUT;
                $display("forwarded");                       
            end
            if(pipe4_ex_read_en_dmem == 1'b1)
            begin
            pipe2_id_RV2[31:0] <= dmem_output;
            $display("forwarded");
            end
        end     

        if(pipe4_if_OPCODE[6:0] == 7'b0110011)
        begin
            alu_input_b = pipe2_id_RV2;
        end
        else begin
            alu_input_b = pipe3_id_IMM;
        end
        pipe4_id_RDA[4:0] <= pipe3_if_RDA[4:0];
        pipe5_id_OPCODE[16:0] <= pipe4_if_OPCODE[16:0];    
    end

    always@(posedge clk)
    begin
        if(pipe4_if_OPCODE[6:0] == 7'b0110011)
        begin
            pipe6_id_write_enable_regfile <= 1'b1;
            pipe7_id_read_en_dmem <= 1'b0;
            pipe8_id_write_en_dmem = 1'b0; 
        end
        if(pipe4_if_OPCODE[6:0] == 7'b0010011)
        begin
            
            if(pipe4_if_OPCODE[9:7] == 3'b000) 
            begin
                pipe6_id_write_enable_regfile <= 1'b1;
                pipe7_id_read_en_dmem <= 1'b0;
                pipe8_id_write_en_dmem <= 1'b0; 
            end
            if( pipe4_if_OPCODE[9:7] == 3'b100)
            begin
                pipe6_id_write_enable_regfile <= 1'b1;
                pipe7_id_read_en_dmem <= 1'b1;
                pipe8_id_write_en_dmem <= 1'b0; 
            end
        end
        if(pipe4_if_OPCODE[6:0] == 7'b0100011)
        begin
            pipe6_id_write_enable_regfile <= 1'b0;
            pipe7_id_read_en_dmem <= 1'b0;
            pipe8_id_write_en_dmem <= 1'b1;
             
        end
    end 
        
        
    ALU f3(.A(pipe1_id_RV1),.B(alu_input_b),.rd(pipe4_id_RDA),.clk(CLK),.opcode(pipe5_id_OPCODE),.LH(alu_output));
   
   always@(posedge clk)
        begin
            pipe1_ex_ALUOUTPUT[31:0] <= alu_output;  
            pipe2_ex_RV2 <= pipe2_id_RV2;
            pipe3_ex_write_enable_regfile <=  pipe6_id_write_enable_regfile;
            pipe4_ex_read_en_dmem <= pipe7_id_read_en_dmem;
            pipe6_ex_write_en_dmem <=  pipe8_id_write_en_dmem;
            pipe5_ex_RDA[4:0] <= pipe4_id_RDA;
        end
      
     datamem f11 (.clk(CLK),.add(pipe1_ex_ALUOUTPUT[2:0]),.wd(pipe2_ex_RV2),.w_enable(pipe6_ex_write_en_dmem),.r_enable(pipe4_ex_read_en_dmem),.rd(dmem_output));
     
     always@(posedge clk)
     begin
     pipe1_mem_WRITEVAL[31:0] <= pipe1_ex_ALUOUTPUT;
     pipe2_mem_WRITEVAL2[31:0] <= dmem_output;
     pipe3_mem_WRITEDEST[4:0] <= pipe5_ex_RDA;
     pipe4_mem_RDA[4:0] <= pipe5_ex_RDA;
     if(pipe3_ex_write_enable_regfile == 1'b1 &&  pipe4_ex_read_en_dmem == 1'b1)
        begin
            write_enable_regfile = 1'b1;
            write_value_regfile <= dmem_output;
            write_dest_regfile <= pipe5_ex_RDA;
        end
     else if(pipe3_ex_write_enable_regfile == 1'b1 && pipe4_ex_read_en_dmem == 1'b0)
        begin
        write_enable_regfile = 1'b1;
        write_value_regfile <= pipe1_ex_ALUOUTPUT;
        write_dest_regfile <= pipe5_ex_RDA;
        end
      else begin
        write_enable_regfile = 1'b0;
        write_value_regfile = 0;
        write_dest_regfile = 0;
      end
      end
endmodule

