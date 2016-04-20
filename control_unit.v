// Name: control_unit.v
// Module: CONTROL_UNIT
// Output: 
//         READ:        Register file Read signal
//         WRITE:       Register file Write signal
//         ALU_OP1:     ALU operand 1
//         ALU_OP2:     ALU operand 2
//         ALU_Code:    ALU operation code
//         
// Input:  OpCode:  6-bit OpCode
//         Funct:       6-bit Funct code in MIPS instruction (R-Format)
//     Shamt:       5-bit Shamt (Number of bits to shift for shift instructions)
//     DATA_R1, DATA_R2:    data read from register file
//         CLK:         Clock signal
//         RST:         Reset signal
//
//
// Notes: - Control unit synchronize operations of a processor
//
// Created by Feiling Jia, March 2016 (for CS147-01 Spring 2016)

`include "definition.v"

// NOP is a special instruction that does nothing
`define NOP 63

// processor states
`define STATE_FETCH 0
`define STATE_DECODE 1
`define STATE_EXE 2
`define STATE_IDLE 3

module CONTROL_UNIT(OpCode, Shamt, Funct, DATA_R1, DATA_R2, READ, WRITE,
                    ALU_OP1, ALU_OP2, ALU_Code, CLK, RST); 

// Output signals
output reg READ, WRITE;
output reg [`DATA_INDEX_LIMIT:0]  ALU_OP1, ALU_OP2;
output reg [`ALU_FUNCT_INDEX_LIMIT:0] ALU_Code;


// Input signals
input CLK, RST;
input [`ALU_FUNCT_INDEX_LIMIT:0] OpCode, Funct;
input [4:0] Shamt;
input [`DATA_INDEX_LIMIT:0] DATA_R1, DATA_R2;

// State register
reg [1:0] proc_state;

// Set initial value of proc_state
initial
begin
    proc_state = `STATE_IDLE;
end

always @ (negedge RST or posedge CLK)
begin

    if ((RST === 1'b0)) begin
        proc_state = `STATE_FETCH;
        READ = 1'b0;
        WRITE = 1'b0;
        end else begin
        case (proc_state)

        `STATE_FETCH:
            begin if (OpCode != `NOP) begin 
               proc_state = `STATE_DECODE;
               READ = 1'b1; 
               WRITE = 1'b0;
               #50;  
               // manually insert some delay to allow register read to complete
               end
            end
        
        `STATE_DECODE:
            // Data from register file should be ready. 
            // Determine ALU Code (Funct) and ALU operands
            begin
                // Fill in the code here
                proc_state = `STATE_EXE;
                ALU_Code = Funct;
                ALU_OP1 = DATA_R1;
                case(Funct)
                6'h01:begin
                    ALU_OP2 = Shamt;
                end
                6'h02:begin
                    ALU_OP2 = Shamt;
                end
                default: ALU_OP2 = DATA_R2;
                endcase
                #50;
            end
// manually insert some delay to allow alu operation to complete
             
        `STATE_EXE:
            // Result from ALU is ready and should be written to the register file
            begin
                // Fill in the code here
                proc_state = `STATE_IDLE;
                READ = 1'b0;
                WRITE = 1'b1;
            end
         default: ; // do nothing if proc_state is STATE_IDLE
        endcase
    end
end
endmodule;
