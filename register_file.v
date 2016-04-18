// Name: register_file.v
// Module: REGISTER_FILE_32x32
// Input:  DATA_W : Data to be written at address ADDR_W
//         ADDR_W : Address of the memory location to be written
//         ADDR_R1 : Address of the memory location to be read for DATA_R1
//         ADDR_R2 : Address of the memory location to be read for DATA_R2
//         READ    : Read signal
//         WRITE   : Write signal
//         CLK     : Clock signal
//         RST     : Reset signal
// Output: DATA_R1 : Data at ADDR_R1 address
//         DATA_R2 : Data at ADDR_R1 address
//
// Notes: - 32 bit word accessible dual read register file having 32 regsisters.
//        - Reset is done at -ve edge of the RST signal
//        - Rest of the operation is done at the +ve edge of the CLK signal
//        - Read operation is done if READ=1 and WRITE=0
//        - Write operation is done if WRITE=1 and READ=0
//        - X is the value at DATA_R* if both READ and WRITE are 0 or 1
//
//	Created by Feiling Jia, for CS147-01 Spring 2016


`include "definition.v"
module REGISTER_FILE_32x32(DATA_R1, DATA_R2, ADDR_R1, ADDR_R2, 
                            DATA_W, ADDR_W, READ, WRITE, CLK, RST);

// input list
input READ, WRITE, CLK, RST;
input [`DATA_INDEX_LIMIT:0] DATA_W;
input [`REG_ADDR_INDEX_LIMIT:0] ADDR_R1, ADDR_R2, ADDR_W;

// Add 32x32 storage for registers
reg [31:0] reg_file_32x32 [0:31];
reg [31:0] reg_ret1;
reg [31:0] reg_ret2;
integer i; // index for reset operation

// output list
output [`DATA_INDEX_LIMIT:0] DATA_R1;
output [`DATA_INDEX_LIMIT:0] DATA_R2;

assign DATA_R1 = ((READ===1'b1)&&(WRITE===1'b0))?reg_ret1:{32{1'bz}};
assign DATA_R2 = ((READ===1'b1)&&(WRITE===1'b0))?reg_ret2:{32{1'bz}};


always @ (negedge RST or posedge CLK)
begin
    // initialize register file for testing purpose
    if (RST === 1'b0)
    begin
        for (i = 0; i <= 32; i = i + 1)
            reg_file_32x32[i] = i;
    end
    else
    begin
        
//Add Code for the register file model, as in Home Assignment #2

    end
end
endmodule
