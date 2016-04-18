// Name: definition.v
// Module:
// Input:
// Output:
//
// Notes: Common definitions


`define DATA_WIDTH 32
`define DATA_INDEX_LIMIT (`DATA_WIDTH -1)
`define ALU_FUNCT_WIDTH 6
`define ALU_FUNCT_INDEX_LIMIT (`ALU_FUNCT_WIDTH -1)
`define NUM_OF_REG 32
`define REG_INDEX_LIMIT (`NUM_OF_REG -1)
`define REG_ADDR_INDEX_LIMIT 4

`timescale 1ns/10ps

`define SYS_CLK_PERIOD 10
`define SYS_CLK_HALF_PERIOD (`SYS_CLK_PERIOD/2)
