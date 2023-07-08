`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.04.2023 16:03:15
// Design Name: 
// Module Name: aluu
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


module addercell(input [31:0] a,input [31:0] b,output reg [31:0] sum, output reg sum1, input clk);
    reg [31:0] g;
    reg [31:0] p;
    reg [32:0] c;
    integer i = 0;
    always@(posedge clk)
    begin
    c[0] = 1'b0;
    for(i = 0 ; i<32; i = i+1)
        begin
          g[i] = a[i] & b[i];
          p[i] = a[i] ^ b[i];
          c[i+1] = (c[i] & p[i]) | g[i];
          sum[i] = p[i] ^c[i];
        end
      c[32] = (c[31] & p[31]) | g[31];
      sum1 = c[32]^c[31];
 end
endmodule

module subcell(input [31:0] a,input [31:0] b,output reg [31:0] sum, output reg sum1, input clk);
    reg [31:0] g;
    reg [31:0] p;
    reg [32:0] c;
    integer i = 0;
    always@(posedge clk)
    begin
    c[0] = 1'b0;
    for(i = 0 ; i<32; i = i+1)
        begin
          g[i] = a[i] & b[i];
          p[i] = a[i] ^ b[i];
          c[i+1] = (c[i] & p[i]) | g[i];
          sum[i] = p[i] ^c[i];
        end
      c[32] = (c[31] & p[31]) | g[31];
      sum1 = c[32]^c[31];
 end
endmodule

module mulcell(input [31:0] a, input [31:0] b,
                output reg [31:0] mula, output reg [31:0] mulb,input clk);
    integer i=0;
    reg [63:0] c;
    reg [63:0] var;
    always@(posedge clk)
    begin
        var[31:0] = a;
        if(a[31]==1)
        begin
            var[63:32] = 32'b11111111111111111111111111111111;
        end
        else
        begin
            var[63:32] = 32'b0;
        end
       
    for(i=0; i<32; i = i+1)
    begin
          if(i==0)
          begin
                if(0 - b[0] == 1)
                begin
                 c = 0 + var;                
                end
                else if(0 - b[0] == -1)
                begin
                    c = 0 + (((~var) + 1)) ;                  
                end
                else
                begin
                 c = 0;  
                end
               
           end
                else
                    if(b[i-1] - b[i] == 1)
                    begin
                    c = c + (2**i)*var;
                    end
                    else if(b[i-1] - b[i] == -1)
                    begin
                    c = c + ((2**i)*((~var) + 1)) ;
                    end
                    else
                    begin
                    c = c;  
                    end
                end
        mula[31:0] = c[31:0];
        mulb[31:0] = c[63:32];
    end  
endmodule


module ALU(input [31:0] A,input [31:0] B, input [4:0] rd, output reg [31:0] UH,output reg [31:0] LH,input clk, input [16:0] opcode,output reg of);
wire [31:0] sum1;
wire [31:0] sum2;
wire [31:0] sub1;
wire [31:0] sub2;
wire [31:0] mul1;
wire [31:0] mul1;
wire [31:0] mul2;
reg [16:0] op;
addercell f1(.a(A),.b(B),.sum(sum1),.sum1(sum2),.clk(clk));
subcell f2(.a(A),.b((~B)+1),.sum(sub1),.sum1(sub2),.clk(clk));
mulcell f3(A,B,mul1,mul2,clk);
wire [4:0] op_fiv;
wire [31:0] op_thirtwo;
wire [1:0] write;
assign write = 2'b01;
assign op_fiv = 5'b0;
assign op_thirtwo = 32'b0;
wire [31:0] tempyy;
always@(posedge clk)
begin
//    $display("Entered at %d with a=%d, b=%d",$time,A,B);
    op = opcode;
    case(op)
    17'b10000000000110011: begin LH = sum1;
                           UH = 0;
                          of = sum2;
                           end
    17'b0000000_100_0010011: begin LH = sum1;
                           UH = 0;
                          of = sum2;
                           end
   
    17'b01000000000110011: begin LH = sub1;
                           UH = 0;
                           of = sub2;
                           end
    17'b00000010000110011: begin LH = mul1;
                           UH = mul2;
                           end
    17'b00000000000010011: begin LH = sum1;
                           UH = 0;
                          of = sum2;
                          end
    17'b01000000100010011: begin LH = sub1;
                           UH = 0;
                           of = sub2;
                           end
    17'b00000010110010011: begin LH = mul1;
                           UH = mul2;
                           end
    17'b00000000100100011: begin LH = sum1;
                           UH = 0;
                           of = sum2;
                           end
    endcase
end
assign tempyy = LH;
endmodule

