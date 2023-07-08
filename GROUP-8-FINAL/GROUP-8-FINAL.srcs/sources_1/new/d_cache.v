`timescale 1ns / 1ps
module datamem(input clk, input [2:0] add, input [31:0] wd, input w_enable, input r_enable, output reg [31:0] rd);
  reg [31:0] data_memo [7:0];
    initial begin
    data_memo[0] = 45;
    data_memo[1] = -20;
    end
   
  always@(posedge clk)
    begin
    if(w_enable == 1'b1)
    begin
//    data_memo[0] = 45;
//    data_memo[1] = -20;
//    data_memo[2] = 0;
//    data_memo[3] = 0;
//    data_memo[4] = 0;
//    data_memo[5] = 0;
      $display("Entered Data_Memory Block to write the value %d at %d th address",wd,add);
      data_memo[add] = wd;
      rd = 0;
    end
    if(r_enable == 1'b1)
        begin
        rd = data_memo[add];
        end
    end
    endmodule