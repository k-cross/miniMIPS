// Name: alu.v
// Module: alu
// Input: op1[32] - operand 1
//        op2[32] - operand 2
//        funct[6] - function code
// Output: result[32] - output result for the operation
//
// Notes: 32 bit combinatorial ALU
// 
// Support MiniMIPS instruction set
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 02, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//  1.3     Feb 15, 2016	Feiling Jia	feiling.jia@sjsu.edu	adapted for class project
//------------------------------------------------------------------------------------------

`include "definition.v"
module alu(result, op1, op2, funct);
// input list
input [`DATA_INDEX_LIMIT:0] op1; // operand 1
input [`DATA_INDEX_LIMIT:0] op2; // operand 2
input [`ALU_FUNCT_INDEX_LIMIT:0] funct; // function code

// output list
output [`DATA_INDEX_LIMIT:0] result; // result of the operation.

// simulator internal storage - this is not h/w register
reg [`DATA_INDEX_LIMIT:0] result;

// Whenever op1, op2 or funct changes do something
always @ (op1 or op2 or funct)
begin
    case (funct)
        `ALU_FUNCT_WIDTH'h20 : result = op1 + op2; // addition
        `ALU_FUNCT_WIDTH'h22 : result = op1 - op2; // subtraction
        `ALU_FUNCT_WIDTH'h24 : result = op1 * op2; // multiply
        `ALU_FUNCT_WIDTH'h26 : result = op1 / op2; // divide 
        `ALU_FUNCT_WIDTH'h28 : result = op1 << op2; // shift logical left
        `ALU_FUNCT_WIDTH'h30 : result = op1 >> op2; // shift logical right
        `ALU_FUNCT_WIDTH'h32 : result = op1 & op2; // and
        `ALU_FUNCT_WIDTH'h34 : result = op1 | op2; // or
        `ALU_FUNCT_WIDTH'h36 : result = op1 ~| op2; // nor
        `ALU_FUNCT_WIDTH'h38 : result = (op1 < op2)? 1 : 0; // set if <
        
        default: result = `DATA_WIDTH'hxxxxxxxx;
                 
    endcase
end

endmodule
