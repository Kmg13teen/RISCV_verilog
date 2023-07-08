# Group_8 CO report
### Team Leader : Likith A.
### Team members: Kshitij Ghodake and Sabareesh
This is the readme file for the completed RISC-V pipelining of the CO lab. The required modules are contained in the design sources in this same folder.
The modules used for this project/lab are 
- main module
- decoder
- ALU
- register_file
- D cache
- L cache

Functioning of each module has been explained in their respective sections.

## The 'main' module
The main module is always instantiated, it instantiates the required modules. It takes input as two clocks, 'clk' and 'CLK'. 'clk' is the main clock for all the modules except ALU and D cache, which takes in 'CLK' as their clock. 'CLK' is at least 2 times as fast as 'clk' because the adder/subtractor modules of the ALU have to be triggered by a clock (CLK) again.
_Main module is 'main.v'_

## decoder_file
The decoder takes in the 32-bit instruction and gives the relevant outputs for source registers, immediates, based on the type of the instruction. 
_Decoder module is decoder.v_
## ALU module
The ALU module takes in two inputs from the pipeline registers, and does the required operation according to the provided opcode, the output value is then stored in the following pipeline register
_ALU module is alu.v_

## Register file
The register file is used to read and write the values which are accessed during the execution of the instructions.
_Register file module is register_file.v_

## D cache
The D cache module can write or read values from the data memory.
_D cache file is d_cache.v_

## L cache
The instructions to be executed are saved in the L cache and are fetched every clock cycle
_L cache file is l_cache.v_

## Testbench
The testbench just provides the clock cycles with their appropriate time periods.
_The testbench for this project is final_tb.v_