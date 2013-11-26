%skeleton "lalr1.cc"
%require "3.0"
%debug
%defines
%define api.namespace {GBC}
%define parser_class_name {Disassembler}

%code requires {
	namespace GBC {
		class Driver;
		class Scanner;
	}
}

%lex-param { Scanner &scanner }
%parse-param { Scanner &scanner }

%lex-param { Driver &driver }
%parse-param { Driver &driver }

%code{
	#include <iostream>
	#include <fstream>

	#include "gbc_scanner.hpp"
	#include "gbc_driver.hpp"

	static int yylex(	GBC::Disassembler::semantic_type* yylval,
						GBC::Scanner &scanner,
						GBC::Driver &driver);

	std::string hexify(unsigned int v);
}

%token	 NOP
%token	 LD_BC_nn
%token	 LD_BC_A
%token	 INC_BC
%token	 DEC_BC
%token	 DEC_B
%token	 INC_B
%token	 LD_B_n
%token	 RLC_A
%token	 LD_nn_SP
%token	 ADD_HL_BC
%token	 LD_A_BC
%token	 INC_C
%token	 DEC_C
%token	 LD_C_n
%token	 RRC_A
%token	 STOP
%token	 LD_DE_nn
%token	 LD_DE_A
%token	 INC_DE
%token	 INC_D
%token	 DEC_D
%token	 LD_D_n
%token	 RL_A
%token	 JR_n
%token	 ADD_HL_DE
%token	 LD_A_DE
%token	 DEC_DE
%token	 INC_E
%token	 DEC_E
%token	 LD_E_n
%token	 RR_A
%token	 JR_NZ_n
%token	 LD_HL_nn
%token	 LDI_HL_A
%token	 INC_HL_P
%token	 INC_H
%token	 DEC_H
%token	 LD_H_n
%token	 DAA
%token	 JR_Z_n
%token	 ADD_HL_HL
%token	 LDI_A_HL
%token	 DEC_HL_P
%token	 INC_L
%token	 DEC_L
%token	 LD_L_n
%token	 CPL
%token	 JR_NC_n
%token	 LD_SP_nn
%token	 LDD_HL_A
%token	 INC_SP
%token	 INC_HL
%token	 DEC_HL
%token	 LD_HL_n
%token	 SCF
%token	 JR_C_n
%token	 ADD_HL_SP
%token	 LDD_A_HL
%token	 DEC_SP
%token	 INC_A
%token	 DEC_A
%token	 LD_A_n
%token	 CCF
%token	 LD_B_B
%token	 LD_B_C
%token	 LD_B_D
%token	 LD_B_E
%token	 LD_B_H
%token	 LD_B_L
%token	 LD_B_HL
%token	 LD_B_A
%token	 LD_C_B
%token	 LD_C_C
%token	 LD_C_D
%token	 LD_C_E
%token	 LD_C_H
%token	 LD_C_L
%token	 LD_C_HL
%token	 LD_C_A
%token	 LD_D_B
%token	 LD_D_C
%token	 LD_D_D
%token	 LD_D_E
%token	 LD_D_H
%token	 LD_D_L
%token	 LD_D_HL
%token	 LD_D_A
%token	 LD_E_B
%token	 LD_E_C
%token	 LD_E_D
%token	 LD_E_E
%token	 LD_E_H
%token	 LD_E_L
%token	 LD_E_HL
%token	 LD_E_A
%token	 LD_H_B
%token	 LD_H_C
%token	 LD_H_D
%token	 LD_H_E
%token	 LD_H_H
%token	 LD_H_L
%token	 LD_H_HL
%token	 LD_H_A
%token	 LD_L_B
%token	 LD_L_C
%token	 LD_L_D
%token	 LD_L_E
%token	 LD_L_H
%token	 LD_L_L
%token	 LD_L_HL
%token	 LD_L_A
%token	 LD_HL_B
%token	 LD_HL_C
%token	 LD_HL_D
%token	 LD_HL_E
%token	 LD_HL_H
%token	 LD_HL_L
%token	 HALT
%token	 LD_HL_A
%token	 LD_A_B
%token	 LD_A_C
%token	 LD_A_D
%token	 LD_A_E
%token	 LD_A_H
%token	 LD_A_L
%token	 LD_A_HL
%token	 LD_A_A
%token	 ADD_A_B
%token	 ADD_A_C
%token	 ADD_A_D
%token	 ADD_A_E
%token	 ADD_A_H
%token	 ADD_A_L
%token	 ADD_A_HL
%token	 ADD_A_A
%token	 ADC_A_B
%token	 ADC_A_C
%token	 ADC_A_D
%token	 ADC_A_E
%token	 ADC_A_H
%token	 ADC_A_L
%token	 ADC_A_HL
%token	 ADC_A_A
%token	 SUB_A_B
%token	 SUB_A_C
%token	 SUB_A_D
%token	 SUB_A_E
%token	 SUB_A_H
%token	 SUB_A_L
%token	 SUB_A_HL
%token	 SUB_A_A
%token	 SBC_A_B
%token	 SBC_A_C
%token	 SBC_A_D
%token	 SBC_A_E
%token	 SBC_A_H
%token	 SBC_A_L
%token	 SBC_A_HL
%token	 SBC_A_A
%token	 AND_B
%token	 AND_C
%token	 AND_D
%token	 AND_E
%token	 AND_H
%token	 AND_L
%token	 AND_HL
%token	 AND_A
%token	 XOR_B
%token	 XOR_C
%token	 XOR_D
%token	 XOR_E
%token	 XOR_H
%token	 XOR_L
%token	 XOR_HL
%token	 XOR_A
%token	 OR_B
%token	 OR_C
%token	 OR_D
%token	 OR_E
%token	 OR_H
%token	 OR_L
%token	 OR_HL
%token	 OR_A
%token	 CP_B
%token	 CP_C
%token	 CP_D
%token	 CP_E
%token	 CP_H
%token	 CP_L
%token	 CP_HL
%token	 CP_A
%token	 RET_NZ
%token	 POP_BC
%token	 JP_NZ_nn
%token	 JP_nn
%token	 CALL_NZ_nn
%token	 PUSH_BC
%token	 ADD_A_n
%token	 RST_0
%token	 RET_Z
%token	 RET
%token	 JP_Z_nn
%token	 CALL_Z_nn
%token	 CALL_nn
%token	 ADC_A_n
%token	 RST_8
%token	 RET_NC
%token	 POP_DE
%token	 JP_NC_nn
%token	 BAD_OP
%token	 CALL_NC_nn
%token	 PUSH_DE
%token	 SUB_A_n
%token	 RST_10
%token	 RET_C
%token	 RETI
%token	 JP_C_nn
%token	 CALL_C_nn
%token	 SBC_A_n
%token	 RST_18
%token	 LDH_n_A
%token	 POP_HL
%token	 LDH_C_A
%token	 PUSH_HL
%token	 AND_n
%token	 RST_20
%token	 ADD_SP_d
%token	 JP_HL
%token	 LD_nn_A
%token	 XOR_n
%token	 RST_28
%token	 LDH_A_n
%token	 POP_AF
%token	 DI
%token	 PUSH_AF
%token	 OR_n
%token	 RST_30
%token	 LDHL_SP_d
%token	 LD_SP_HL
%token	 LD_A_nn
%token	 EI
%token	 CP_n
%token	 RST_38
%token	 RLC_B
%token	 RLC_C
%token	 RLC_D
%token	 RLC_E
%token	 RLC_H
%token	 RLC_L
%token	 RLC_HL
%token	 RRC_B
%token	 RRC_C
%token	 RRC_D
%token	 RRC_E
%token	 RRC_H
%token	 RRC_L
%token	 RRC_HL
%token	 RL_B
%token	 RL_C
%token	 RL_D
%token	 RL_E
%token	 RL_H
%token	 RL_L
%token	 RL_HL
%token	 RR_B
%token	 RR_C
%token	 RR_D
%token	 RR_E
%token	 RR_H
%token	 RR_L
%token	 RR_HL
%token	 SLA_B
%token	 SLA_C
%token	 SLA_D
%token	 SLA_E
%token	 SLA_H
%token	 SLA_L
%token	 SLA_HL
%token	 SLA_A
%token	 SRA_B
%token	 SRA_C
%token	 SRA_D
%token	 SRA_E
%token	 SRA_H
%token	 SRA_L
%token	 SRA_HL
%token	 SRA_A
%token	 SWAP_B
%token	 SWAP_C
%token	 SWAP_D
%token	 SWAP_E
%token	 SWAP_H
%token	 SWAP_L
%token	 SWAP_HL
%token	 SWAP_A
%token	 SRL_B
%token	 SRL_C
%token	 SRL_D
%token	 SRL_E
%token	 SRL_H
%token	 SRL_L
%token	 SRL_HL
%token	 SRL_A
%token	 BIT_0_B
%token	 BIT_0_C
%token	 BIT_0_D
%token	 BIT_0_E
%token	 BIT_0_H
%token	 BIT_0_L
%token	 BIT_0_HL
%token	 BIT_0_A
%token	 BIT_1_B
%token	 BIT_1_C
%token	 BIT_1_D
%token	 BIT_1_E
%token	 BIT_1_H
%token	 BIT_1_L
%token	 BIT_1_HL
%token	 BIT_1_A
%token	 BIT_2_B
%token	 BIT_2_C
%token	 BIT_2_D
%token	 BIT_2_E
%token	 BIT_2_H
%token	 BIT_2_L
%token	 BIT_2_HL
%token	 BIT_2_A
%token	 BIT_3_B
%token	 BIT_3_C
%token	 BIT_3_D
%token	 BIT_3_E
%token	 BIT_3_H
%token	 BIT_3_L
%token	 BIT_3_HL
%token	 BIT_3_A
%token	 BIT_4_B
%token	 BIT_4_C
%token	 BIT_4_D
%token	 BIT_4_E
%token	 BIT_4_H
%token	 BIT_4_L
%token	 BIT_4_HL
%token	 BIT_4_A
%token	 BIT_5_B
%token	 BIT_5_C
%token	 BIT_5_D
%token	 BIT_5_E
%token	 BIT_5_H
%token	 BIT_5_L
%token	 BIT_5_HL
%token	 BIT_5_A
%token	 BIT_6_B
%token	 BIT_6_C
%token	 BIT_6_D
%token	 BIT_6_E
%token	 BIT_6_H
%token	 BIT_6_L
%token	 BIT_6_HL
%token	 BIT_6_A
%token	 BIT_7_B
%token	 BIT_7_C
%token	 BIT_7_D
%token	 BIT_7_E
%token	 BIT_7_H
%token	 BIT_7_L
%token	 BIT_7_HL
%token	 BIT_7_A
%token	 RES_0_B
%token	 RES_0_C
%token	 RES_0_D
%token	 RES_0_E
%token	 RES_0_H
%token	 RES_0_L
%token	 RES_0_HL
%token	 RES_0_A
%token	 RES_1_B
%token	 RES_1_C
%token	 RES_1_D
%token	 RES_1_E
%token	 RES_1_H
%token	 RES_1_L
%token	 RES_1_HL
%token	 RES_1_A
%token	 RES_2_B
%token	 RES_2_C
%token	 RES_2_D
%token	 RES_2_E
%token	 RES_2_H
%token	 RES_2_L
%token	 RES_2_HL
%token	 RES_2_A
%token	 RES_3_B
%token	 RES_3_C
%token	 RES_3_D
%token	 RES_3_E
%token	 RES_3_H
%token	 RES_3_L
%token	 RES_3_HL
%token	 RES_3_A
%token	 RES_4_B
%token	 RES_4_C
%token	 RES_4_D
%token	 RES_4_E
%token	 RES_4_H
%token	 RES_4_L
%token	 RES_4_HL
%token	 RES_4_A
%token	 RES_5_B
%token	 RES_5_C
%token	 RES_5_D
%token	 RES_5_E
%token	 RES_5_H
%token	 RES_5_L
%token	 RES_5_HL
%token	 RES_5_A
%token	 RES_6_B
%token	 RES_6_C
%token	 RES_6_D
%token	 RES_6_E
%token	 RES_6_H
%token	 RES_6_L
%token	 RES_6_HL
%token	 RES_6_A
%token	 RES_7_B
%token	 RES_7_C
%token	 RES_7_D
%token	 RES_7_E
%token	 RES_7_H
%token	 RES_7_L
%token	 RES_7_HL
%token	 RES_7_A
%token	 SET_0_B
%token	 SET_0_C
%token	 SET_0_D
%token	 SET_0_E
%token	 SET_0_H
%token	 SET_0_L
%token	 SET_0_HL
%token	 SET_0_A
%token	 SET_1_B
%token	 SET_1_C
%token	 SET_1_D
%token	 SET_1_E
%token	 SET_1_H
%token	 SET_1_L
%token	 SET_1_HL
%token	 SET_1_A
%token	 SET_2_B
%token	 SET_2_C
%token	 SET_2_D
%token	 SET_2_E
%token	 SET_2_H
%token	 SET_2_L
%token	 SET_2_HL
%token	 SET_2_A
%token	 SET_3_B
%token	 SET_3_C
%token	 SET_3_D
%token	 SET_3_E
%token	 SET_3_H
%token	 SET_3_L
%token	 SET_3_HL
%token	 SET_3_A
%token	 SET_4_B
%token	 SET_4_C
%token	 SET_4_D
%token	 SET_4_E
%token	 SET_4_H
%token	 SET_4_L
%token	 SET_4_HL
%token	 SET_4_A
%token	 SET_5_B
%token	 SET_5_C
%token	 SET_5_D
%token	 SET_5_E
%token	 SET_5_H
%token	 SET_5_L
%token	 SET_5_HL
%token	 SET_5_A
%token	 SET_6_B
%token	 SET_6_C
%token	 SET_6_D
%token	 SET_6_E
%token	 SET_6_H
%token	 SET_6_L
%token	 SET_6_HL
%token	 SET_6_A
%token	 SET_7_B
%token	 SET_7_C
%token	 SET_7_D
%token	 SET_7_E
%token	 SET_7_H
%token	 SET_7_L
%token	 SET_7_HL
%token	 SET_7_A


%%

opcode
	: NOP
		{ std::cout << "NOP" << std::endl; return 0; }
	| LD_BC_nn argument
		{ std::cout << "LD BC, " << hexify($2) << std::endl; return 0; }
	| LD_BC_A
		{ std::cout << "LD_BC_A" << std::endl; return 0; }
	| INC_BC
		{ std::cout << "INC_BC" << std::endl; return 0; }
	| INC_B
		{ std::cout << "INC_B" << std::endl; return 0; }
	| DEC_B
		{ std::cout << "DEC_B" << std::endl; return 0; }
	| LD_B_n
		{ std::cout << "LD_B_n" << std::endl; return 0; }
	| RLC_A
		{ std::cout << "RLC_A" << std::endl; return 0; }
	| LD_nn_SP argument
		{ std::cout << "LD " << hexify($2) << ", SP" << std::endl; return 0; }
	| ADD_HL_BC
		{ std::cout << "ADD_HL_BC" << std::endl; return 0; }
	| LD_A_BC
		{ std::cout << "LD_A_BC" << std::endl; return 0; }
	| DEC_BC
		{ std::cout << "DEC_BC" << std::endl; return 0; }
	| INC_C
		{ std::cout << "INC_C" << std::endl; return 0; }
	| DEC_C
		{ std::cout << "DEC_C" << std::endl; return 0; }
	| LD_C_n
		{ std::cout << "LD_C_n" << std::endl; return 0; }
	| RRC_A
		{ std::cout << "RRC_A" << std::endl; return 0; }
	| STOP
		{ std::cout << "STOP" << std::endl; return 0; }
	| LD_DE_nn
		{ std::cout << "LD_DE_nn" << std::endl; return 0; }
	| LD_DE_A
		{ std::cout << "LD_DE_A" << std::endl; return 0; }
	| INC_DE
		{ std::cout << "INC_DE" << std::endl; return 0; }
	| INC_D
		{ std::cout << "INC_D" << std::endl; return 0; }
	| DEC_D
		{ std::cout << "DEC_D" << std::endl; return 0; }
	| LD_D_n
		{ std::cout << "LD_D_n" << std::endl; return 0; }
	| RL_A
		{ std::cout << "RL_A" << std::endl; return 0; }
	| JR_n
		{ std::cout << "JR_n" << std::endl; return 0; }
	| ADD_HL_DE
		{ std::cout << "ADD_HL_DE" << std::endl; return 0; }
	| LD_A_DE
		{ std::cout << "LD_A_DE" << std::endl; return 0; }
	| DEC_DE
		{ std::cout << "DEC_DE" << std::endl; return 0; }
	| INC_E
		{ std::cout << "INC_E" << std::endl; return 0; }
	| DEC_E
		{ std::cout << "DEC_E" << std::endl; return 0; }
	| LD_E_n
		{ std::cout << "LD_E_n" << std::endl; return 0; }
	| RR_A
		{ std::cout << "RR_A" << std::endl; return 0; }
	| JR_NZ_n
		{ std::cout << "JR_NZ_n" << std::endl; return 0; }
	| LD_HL_nn
		{ std::cout << "LD_HL_nn" << std::endl; return 0; }
	| LDI_HL_A
		{ std::cout << "LDI_HL_A" << std::endl; return 0; }
	| INC_HL_P
		{ std::cout << "INC_HL_P" << std::endl; return 0; }
	| INC_H
		{ std::cout << "INC_H" << std::endl; return 0; }
	| DEC_H
		{ std::cout << "DEC_H" << std::endl; return 0; }
	| LD_H_n
		{ std::cout << "LD_H_n" << std::endl; return 0; }
	| DAA
		{ std::cout << "DAA" << std::endl; return 0; }
	| JR_Z_n
		{ std::cout << "JR_Z_n" << std::endl; return 0; }
	| ADD_HL_HL
		{ std::cout << "ADD_HL_HL" << std::endl; return 0; }
	| LDI_A_HL
		{ std::cout << "LDI_A_HL" << std::endl; return 0; }
	| DEC_HL_P
		{ std::cout << "DEC_HL_P" << std::endl; return 0; }
	| INC_L
		{ std::cout << "INC_L" << std::endl; return 0; }
	| DEC_L
		{ std::cout << "DEC_L" << std::endl; return 0; }
	| LD_L_n
		{ std::cout << "LD_L_n" << std::endl; return 0; }
	| CPL
		{ std::cout << "CPL" << std::endl; return 0; }
	| JR_NC_n
		{ std::cout << "JR_NC_n" << std::endl; return 0; }
	| LD_SP_nn
		{ std::cout << "LD_SP_nn" << std::endl; return 0; }
	| LDD_HL_A
		{ std::cout << "LDD_HL_A" << std::endl; return 0; }
	| INC_SP
		{ std::cout << "INC_SP" << std::endl; return 0; }
	| INC_HL
		{ std::cout << "INC_HL" << std::endl; return 0; }
	| DEC_HL
		{ std::cout << "DEC_HL" << std::endl; return 0; }
	| LD_HL_n
		{ std::cout << "LD_HL_n" << std::endl; return 0; }
	| SCF
		{ std::cout << "SCF" << std::endl; return 0; }
	| JR_C_n
		{ std::cout << "JR_C_n" << std::endl; return 0; }
	| ADD_HL_SP
		{ std::cout << "ADD_HL_SP" << std::endl; return 0; }
	| LDD_A_HL
		{ std::cout << "LDD_A_HL" << std::endl; return 0; }
	| DEC_SP
		{ std::cout << "DEC_SP" << std::endl; return 0; }
	| INC_A
		{ std::cout << "INC_A" << std::endl; return 0; }
	| DEC_A
		{ std::cout << "DEC_A" << std::endl; return 0; }
	| LD_A_n
		{ std::cout << "LD_A_n" << std::endl; return 0; }
	| CCF
		{ std::cout << "CCF" << std::endl; return 0; }
	| LD_B_B
		{ std::cout << "LD_B_B" << std::endl; return 0; }
	| LD_B_C
		{ std::cout << "LD_B_C" << std::endl; return 0; }
	| LD_B_D
		{ std::cout << "LD_B_D" << std::endl; return 0; }
	| LD_B_E
		{ std::cout << "LD_B_E" << std::endl; return 0; }
	| LD_B_H
		{ std::cout << "LD_B_H" << std::endl; return 0; }
	| LD_B_L
		{ std::cout << "LD_B_L" << std::endl; return 0; }
	| LD_B_HL
		{ std::cout << "LD_B_HL" << std::endl; return 0; }
	| LD_B_A
		{ std::cout << "LD_B_A" << std::endl; return 0; }
	| LD_C_B
		{ std::cout << "LD_C_B" << std::endl; return 0; }
	| LD_C_C
		{ std::cout << "LD_C_C" << std::endl; return 0; }
	| LD_C_D
		{ std::cout << "LD_C_D" << std::endl; return 0; }
	| LD_C_E
		{ std::cout << "LD_C_E" << std::endl; return 0; }
	| LD_C_H
		{ std::cout << "LD_C_H" << std::endl; return 0; }
	| LD_C_L
		{ std::cout << "LD_C_L" << std::endl; return 0; }
	| LD_C_HL
		{ std::cout << "LD_C_HL" << std::endl; return 0; }
	| LD_C_A
		{ std::cout << "LD_C_A" << std::endl; return 0; }
	| LD_D_B
		{ std::cout << "LD_D_B" << std::endl; return 0; }
	| LD_D_C
		{ std::cout << "LD_D_C" << std::endl; return 0; }
	| LD_D_D
		{ std::cout << "LD_D_D" << std::endl; return 0; }
	| LD_D_E
		{ std::cout << "LD_D_E" << std::endl; return 0; }
	| LD_D_H
		{ std::cout << "LD_D_H" << std::endl; return 0; }
	| LD_D_L
		{ std::cout << "LD_D_L" << std::endl; return 0; }
	| LD_D_HL
		{ std::cout << "LD_D_HL" << std::endl; return 0; }
	| LD_D_A
		{ std::cout << "LD_D_A" << std::endl; return 0; }
	| LD_E_B
		{ std::cout << "LD_E_B" << std::endl; return 0; }
	| LD_E_C
		{ std::cout << "LD_E_C" << std::endl; return 0; }
	| LD_E_D
		{ std::cout << "LD_E_D" << std::endl; return 0; }
	| LD_E_E
		{ std::cout << "LD_E_E" << std::endl; return 0; }
	| LD_E_H
		{ std::cout << "LD_E_H" << std::endl; return 0; }
	| LD_E_L
		{ std::cout << "LD_E_L" << std::endl; return 0; }
	| LD_E_HL
		{ std::cout << "LD_E_HL" << std::endl; return 0; }
	| LD_E_A
		{ std::cout << "LD_E_A" << std::endl; return 0; }
	| LD_H_B
		{ std::cout << "LD_H_B" << std::endl; return 0; }
	| LD_H_C
		{ std::cout << "LD_H_C" << std::endl; return 0; }
	| LD_H_D
		{ std::cout << "LD_H_D" << std::endl; return 0; }
	| LD_H_E
		{ std::cout << "LD_H_E" << std::endl; return 0; }
	| LD_H_H
		{ std::cout << "LD_H_H" << std::endl; return 0; }
	| LD_H_L
		{ std::cout << "LD_H_L" << std::endl; return 0; }
	| LD_H_HL
		{ std::cout << "LD_H_HL" << std::endl; return 0; }
	| LD_H_A
		{ std::cout << "LD_H_A" << std::endl; return 0; }
	| LD_L_B
		{ std::cout << "LD_L_B" << std::endl; return 0; }
	| LD_L_C
		{ std::cout << "LD_L_C" << std::endl; return 0; }
	| LD_L_D
		{ std::cout << "LD_L_D" << std::endl; return 0; }
	| LD_L_E
		{ std::cout << "LD_L_E" << std::endl; return 0; }
	| LD_L_H
		{ std::cout << "LD_L_H" << std::endl; return 0; }
	| LD_L_L
		{ std::cout << "LD_L_L" << std::endl; return 0; }
	| LD_L_HL
		{ std::cout << "LD_L_HL" << std::endl; return 0; }
	| LD_L_A
		{ std::cout << "LD_L_A" << std::endl; return 0; }
	| LD_HL_B
		{ std::cout << "LD_HL_B" << std::endl; return 0; }
	| LD_HL_C
		{ std::cout << "LD_HL_C" << std::endl; return 0; }
	| LD_HL_D
		{ std::cout << "LD_HL_D" << std::endl; return 0; }
	| LD_HL_E
		{ std::cout << "LD_HL_E" << std::endl; return 0; }
	| LD_HL_H
		{ std::cout << "LD_HL_H" << std::endl; return 0; }
	| LD_HL_L
		{ std::cout << "LD_HL_L" << std::endl; return 0; }
	| HALT
		{ std::cout << "HALT" << std::endl; return 0; }
	| LD_HL_A
		{ std::cout << "LD_HL_A" << std::endl; return 0; }
	| LD_A_B
		{ std::cout << "LD_A_B" << std::endl; return 0; }
	| LD_A_C
		{ std::cout << "LD_A_C" << std::endl; return 0; }
	| LD_A_D
		{ std::cout << "LD_A_D" << std::endl; return 0; }
	| LD_A_E
		{ std::cout << "LD_A_E" << std::endl; return 0; }
	| LD_A_H
		{ std::cout << "LD_A_H" << std::endl; return 0; }
	| LD_A_L
		{ std::cout << "LD_A_L" << std::endl; return 0; }
	| LD_A_HL
		{ std::cout << "LD_A_HL" << std::endl; return 0; }
	| LD_A_A
		{ std::cout << "LD_A_A" << std::endl; return 0; }
	| ADD_A_B
		{ std::cout << "ADD_A_B" << std::endl; return 0; }
	| ADD_A_C
		{ std::cout << "ADD_A_C" << std::endl; return 0; }
	| ADD_A_D
		{ std::cout << "ADD_A_D" << std::endl; return 0; }
	| ADD_A_E
		{ std::cout << "ADD_A_E" << std::endl; return 0; }
	| ADD_A_H
		{ std::cout << "ADD_A_H" << std::endl; return 0; }
	| ADD_A_L
		{ std::cout << "ADD_A_L" << std::endl; return 0; }
	| ADD_A_HL
		{ std::cout << "ADD_A_HL" << std::endl; return 0; }
	| ADD_A_A
		{ std::cout << "ADD_A_A" << std::endl; return 0; }
	| ADC_A_B
		{ std::cout << "ADC_A_B" << std::endl; return 0; }
	| ADC_A_C
		{ std::cout << "ADC_A_C" << std::endl; return 0; }
	| ADC_A_D
		{ std::cout << "ADC_A_D" << std::endl; return 0; }
	| ADC_A_E
		{ std::cout << "ADC_A_E" << std::endl; return 0; }
	| ADC_A_H
		{ std::cout << "ADC_A_H" << std::endl; return 0; }
	| ADC_A_L
		{ std::cout << "ADC_A_L" << std::endl; return 0; }
	| ADC_A_HL
		{ std::cout << "ADC_A_HL" << std::endl; return 0; }
	| ADC_A_A
		{ std::cout << "ADC_A_A" << std::endl; return 0; }
	| SUB_A_B
		{ std::cout << "SUB_A_B" << std::endl; return 0; }
	| SUB_A_C
		{ std::cout << "SUB_A_C" << std::endl; return 0; }
	| SUB_A_D
		{ std::cout << "SUB_A_D" << std::endl; return 0; }
	| SUB_A_E
		{ std::cout << "SUB_A_E" << std::endl; return 0; }
	| SUB_A_H
		{ std::cout << "SUB_A_H" << std::endl; return 0; }
	| SUB_A_L
		{ std::cout << "SUB_A_L" << std::endl; return 0; }
	| SUB_A_HL
		{ std::cout << "SUB_A_HL" << std::endl; return 0; }
	| SUB_A_A
		{ std::cout << "SUB_A_A" << std::endl; return 0; }
	| SBC_A_B
		{ std::cout << "SBC_A_B" << std::endl; return 0; }
	| SBC_A_C
		{ std::cout << "SBC_A_C" << std::endl; return 0; }
	| SBC_A_D
		{ std::cout << "SBC_A_D" << std::endl; return 0; }
	| SBC_A_E
		{ std::cout << "SBC_A_E" << std::endl; return 0; }
	| SBC_A_H
		{ std::cout << "SBC_A_H" << std::endl; return 0; }
	| SBC_A_L
		{ std::cout << "SBC_A_L" << std::endl; return 0; }
	| SBC_A_HL
		{ std::cout << "SBC_A_HL" << std::endl; return 0; }
	| SBC_A_A
		{ std::cout << "SBC_A_A" << std::endl; return 0; }
	| AND_B
		{ std::cout << "AND_B" << std::endl; return 0; }
	| AND_C
		{ std::cout << "AND_C" << std::endl; return 0; }
	| AND_D
		{ std::cout << "AND_D" << std::endl; return 0; }
	| AND_E
		{ std::cout << "AND_E" << std::endl; return 0; }
	| AND_H
		{ std::cout << "AND_H" << std::endl; return 0; }
	| AND_L
		{ std::cout << "AND_L" << std::endl; return 0; }
	| AND_HL
		{ std::cout << "AND_HL" << std::endl; return 0; }
	| AND_A
		{ std::cout << "AND_A" << std::endl; return 0; }
	| XOR_B
		{ std::cout << "XOR_B" << std::endl; return 0; }
	| XOR_C
		{ std::cout << "XOR_C" << std::endl; return 0; }
	| XOR_D
		{ std::cout << "XOR_D" << std::endl; return 0; }
	| XOR_E
		{ std::cout << "XOR_E" << std::endl; return 0; }
	| XOR_H
		{ std::cout << "XOR_H" << std::endl; return 0; }
	| XOR_L
		{ std::cout << "XOR_L" << std::endl; return 0; }
	| XOR_HL
		{ std::cout << "XOR_HL" << std::endl; return 0; }
	| XOR_A
		{ std::cout << "XOR_A" << std::endl; return 0; }
	| OR_B
		{ std::cout << "OR_B" << std::endl; return 0; }
	| OR_C
		{ std::cout << "OR_C" << std::endl; return 0; }
	| OR_D
		{ std::cout << "OR_D" << std::endl; return 0; }
	| OR_E
		{ std::cout << "OR_E" << std::endl; return 0; }
	| OR_H
		{ std::cout << "OR_H" << std::endl; return 0; }
	| OR_L
		{ std::cout << "OR_L" << std::endl; return 0; }
	| OR_HL
		{ std::cout << "OR_HL" << std::endl; return 0; }
	| OR_A
		{ std::cout << "OR_A" << std::endl; return 0; }
	| CP_B
		{ std::cout << "CP_B" << std::endl; return 0; }
	| CP_C
		{ std::cout << "CP_C" << std::endl; return 0; }
	| CP_D
		{ std::cout << "CP_D" << std::endl; return 0; }
	| CP_E
		{ std::cout << "CP_E" << std::endl; return 0; }
	| CP_H
		{ std::cout << "CP_H" << std::endl; return 0; }
	| CP_L
		{ std::cout << "CP_L" << std::endl; return 0; }
	| CP_HL
		{ std::cout << "CP_HL" << std::endl; return 0; }
	| CP_A
		{ std::cout << "CP_A" << std::endl; return 0; }
	| RET_NZ
		{ std::cout << "RET_NZ" << std::endl; return 0; }
	| POP_BC
		{ std::cout << "POP_BC" << std::endl; return 0; }
	| JP_NZ_nn
		{ std::cout << "JP_NZ_nn" << std::endl; return 0; }
	| JP_nn
		{ std::cout << "JP_nn" << std::endl; return 0; }
	| CALL_NZ_nn
		{ std::cout << "CALL_NZ_nn" << std::endl; return 0; }
	| PUSH_BC
		{ std::cout << "PUSH_BC" << std::endl; return 0; }
	| ADD_A_n
		{ std::cout << "ADD_A_n" << std::endl; return 0; }
	| RST_0
		{ std::cout << "RST_0" << std::endl; return 0; }
	| RET_Z
		{ std::cout << "RET_Z" << std::endl; return 0; }
	| RET
		{ std::cout << "RET" << std::endl; return 0; }
	| JP_Z_nn
		{ std::cout << "JP_Z_nn" << std::endl; return 0; }
	| CALL_Z_nn
		{ std::cout << "CALL_Z_nn" << std::endl; return 0; }
	| CALL_nn
		{ std::cout << "CALL_nn" << std::endl; return 0; }
	| ADC_A_n
		{ std::cout << "ADC_A_n" << std::endl; return 0; }
	| RST_8
		{ std::cout << "RST_8" << std::endl; return 0; }
	| RET_NC
		{ std::cout << "RET_NC" << std::endl; return 0; }
	| POP_DE
		{ std::cout << "POP_DE" << std::endl; return 0; }
	| JP_NC_nn
		{ std::cout << "JP_NC_nn" << std::endl; return 0; }
	| BAD_OP
		{ std::cout << "BAD_OP" << std::endl; return 0; }
	| CALL_NC_nn
		{ std::cout << "CALL_NC_nn" << std::endl; return 0; }
	| PUSH_DE
		{ std::cout << "PUSH_DE" << std::endl; return 0; }
	| SUB_A_n
		{ std::cout << "SUB_A_n" << std::endl; return 0; }
	| RST_10
		{ std::cout << "RST_10" << std::endl; return 0; }
	| RET_C
		{ std::cout << "RET_C" << std::endl; return 0; }
	| RETI
		{ std::cout << "RETI" << std::endl; return 0; }
	| JP_C_nn
		{ std::cout << "JP_C_nn" << std::endl; return 0; }
	| CALL_C_nn
		{ std::cout << "CALL_C_nn" << std::endl; return 0; }
	| SBC_A_n
		{ std::cout << "SBC_A_n" << std::endl; return 0; }
	| RST_18
		{ std::cout << "RST_18" << std::endl; return 0; }
	| LDH_n_A
		{ std::cout << "LDH_n_A" << std::endl; return 0; }
	| POP_HL
		{ std::cout << "POP_HL" << std::endl; return 0; }
	| LDH_C_A
		{ std::cout << "LDH_C_A" << std::endl; return 0; }
	| PUSH_HL
		{ std::cout << "PUSH_HL" << std::endl; return 0; }
	| AND_n
		{ std::cout << "AND_n" << std::endl; return 0; }
	| RST_20
		{ std::cout << "RST_20" << std::endl; return 0; }
	| ADD_SP_d
		{ std::cout << "ADD_SP_d" << std::endl; return 0; }
	| JP_HL
		{ std::cout << "JP_HL" << std::endl; return 0; }
	| LD_nn_A
		{ std::cout << "LD_nn_A" << std::endl; return 0; }
	| XOR_n
		{ std::cout << "XOR_n" << std::endl; return 0; }
	| RST_28
		{ std::cout << "RST_28" << std::endl; return 0; }
	| LDH_A_n
		{ std::cout << "LDH_A_n" << std::endl; return 0; }
	| POP_AF
		{ std::cout << "POP_AF" << std::endl; return 0; }
	| DI
		{ std::cout << "DI" << std::endl; return 0; }
	| PUSH_AF
		{ std::cout << "PUSH_AF" << std::endl; return 0; }
	| OR_n
		{ std::cout << "OR_n" << std::endl; return 0; }
	| RST_30
		{ std::cout << "RST_30" << std::endl; return 0; }
	| LDHL_SP_d
		{ std::cout << "LDHL_SP_d" << std::endl; return 0; }
	| LD_SP_HL
		{ std::cout << "LD_SP_HL" << std::endl; return 0; }
	| LD_A_nn
		{ std::cout << "LD_A_nn" << std::endl; return 0; }
	| EI
		{ std::cout << "EI" << std::endl; return 0; }
	| CP_n
		{ std::cout << "CP_n" << std::endl; return 0; }
	| RST_38
		{ std::cout << "RST_38" << std::endl; return 0; }
	| RLC_B
		{ std::cout << "RLC_B" << std::endl; return 0; }
	| RLC_C
		{ std::cout << "RLC_C" << std::endl; return 0; }
	| RLC_D
		{ std::cout << "RLC_D" << std::endl; return 0; }
	| RLC_E
		{ std::cout << "RLC_E" << std::endl; return 0; }
	| RLC_H
		{ std::cout << "RLC_H" << std::endl; return 0; }
	| RLC_L
		{ std::cout << "RLC_L" << std::endl; return 0; }
	| RLC_HL
		{ std::cout << "RLC_HL" << std::endl; return 0; }
	| RRC_B
		{ std::cout << "RRC_B" << std::endl; return 0; }
	| RRC_C
		{ std::cout << "RRC_C" << std::endl; return 0; }
	| RRC_D
		{ std::cout << "RRC_D" << std::endl; return 0; }
	| RRC_E
		{ std::cout << "RRC_E" << std::endl; return 0; }
	| RRC_H
		{ std::cout << "RRC_H" << std::endl; return 0; }
	| RRC_L
		{ std::cout << "RRC_L" << std::endl; return 0; }
	| RRC_HL
		{ std::cout << "RRC_HL" << std::endl; return 0; }
	| RL_B
		{ std::cout << "RL_B" << std::endl; return 0; }
	| RL_C
		{ std::cout << "RL_C" << std::endl; return 0; }
	| RL_D
		{ std::cout << "RL_D" << std::endl; return 0; }
	| RL_E
		{ std::cout << "RL_E" << std::endl; return 0; }
	| RL_H
		{ std::cout << "RL_H" << std::endl; return 0; }
	| RL_L
		{ std::cout << "RL_L" << std::endl; return 0; }
	| RL_HL
		{ std::cout << "RL_HL" << std::endl; return 0; }
	| RR_B
		{ std::cout << "RR_B" << std::endl; return 0; }
	| RR_C
		{ std::cout << "RR_C" << std::endl; return 0; }
	| RR_D
		{ std::cout << "RR_D" << std::endl; return 0; }
	| RR_E
		{ std::cout << "RR_E" << std::endl; return 0; }
	| RR_H
		{ std::cout << "RR_H" << std::endl; return 0; }
	| RR_L
		{ std::cout << "RR_L" << std::endl; return 0; }
	| RR_HL
		{ std::cout << "RR_HL" << std::endl; return 0; }
	| SLA_B
		{ std::cout << "SLA_B" << std::endl; return 0; }
	| SLA_C
		{ std::cout << "SLA_C" << std::endl; return 0; }
	| SLA_D
		{ std::cout << "SLA_D" << std::endl; return 0; }
	| SLA_E
		{ std::cout << "SLA_E" << std::endl; return 0; }
	| SLA_H
		{ std::cout << "SLA_H" << std::endl; return 0; }
	| SLA_L
		{ std::cout << "SLA_L" << std::endl; return 0; }
	| SLA_HL
		{ std::cout << "SLA_HL" << std::endl; return 0; }
	| SLA_A
		{ std::cout << "SLA_A" << std::endl; return 0; }
	| SRA_B
		{ std::cout << "SRA_B" << std::endl; return 0; }
	| SRA_C
		{ std::cout << "SRA_C" << std::endl; return 0; }
	| SRA_D
		{ std::cout << "SRA_D" << std::endl; return 0; }
	| SRA_E
		{ std::cout << "SRA_E" << std::endl; return 0; }
	| SRA_H
		{ std::cout << "SRA_H" << std::endl; return 0; }
	| SRA_L
		{ std::cout << "SRA_L" << std::endl; return 0; }
	| SRA_HL
		{ std::cout << "SRA_HL" << std::endl; return 0; }
	| SRA_A
		{ std::cout << "SRA_A" << std::endl; return 0; }
	| SWAP_B
		{ std::cout << "SWAP_B" << std::endl; return 0; }
	| SWAP_C
		{ std::cout << "SWAP_C" << std::endl; return 0; }
	| SWAP_D
		{ std::cout << "SWAP_D" << std::endl; return 0; }
	| SWAP_E
		{ std::cout << "SWAP_E" << std::endl; return 0; }
	| SWAP_H
		{ std::cout << "SWAP_H" << std::endl; return 0; }
	| SWAP_L
		{ std::cout << "SWAP_L" << std::endl; return 0; }
	| SWAP_HL
		{ std::cout << "SWAP_HL" << std::endl; return 0; }
	| SWAP_A
		{ std::cout << "SWAP_A" << std::endl; return 0; }
	| SRL_B
		{ std::cout << "SRL_B" << std::endl; return 0; }
	| SRL_C
		{ std::cout << "SRL_C" << std::endl; return 0; }
	| SRL_D
		{ std::cout << "SRL_D" << std::endl; return 0; }
	| SRL_E
		{ std::cout << "SRL_E" << std::endl; return 0; }
	| SRL_H
		{ std::cout << "SRL_H" << std::endl; return 0; }
	| SRL_L
		{ std::cout << "SRL_L" << std::endl; return 0; }
	| SRL_HL
		{ std::cout << "SRL_HL" << std::endl; return 0; }
	| SRL_A
		{ std::cout << "SRL_A" << std::endl; return 0; }
	| BIT_0_B
		{ std::cout << "BIT_0_B" << std::endl; return 0; }
	| BIT_0_C
		{ std::cout << "BIT_0_C" << std::endl; return 0; }
	| BIT_0_D
		{ std::cout << "BIT_0_D" << std::endl; return 0; }
	| BIT_0_E
		{ std::cout << "BIT_0_E" << std::endl; return 0; }
	| BIT_0_H
		{ std::cout << "BIT_0_H" << std::endl; return 0; }
	| BIT_0_L
		{ std::cout << "BIT_0_L" << std::endl; return 0; }
	| BIT_0_HL
		{ std::cout << "BIT_0_HL" << std::endl; return 0; }
	| BIT_0_A
		{ std::cout << "BIT_0_A" << std::endl; return 0; }
	| BIT_1_B
		{ std::cout << "BIT_1_B" << std::endl; return 0; }
	| BIT_1_C
		{ std::cout << "BIT_1_C" << std::endl; return 0; }
	| BIT_1_D
		{ std::cout << "BIT_1_D" << std::endl; return 0; }
	| BIT_1_E
		{ std::cout << "BIT_1_E" << std::endl; return 0; }
	| BIT_1_H
		{ std::cout << "BIT_1_H" << std::endl; return 0; }
	| BIT_1_L
		{ std::cout << "BIT_1_L" << std::endl; return 0; }
	| BIT_1_HL
		{ std::cout << "BIT_1_HL" << std::endl; return 0; }
	| BIT_1_A
		{ std::cout << "BIT_1_A" << std::endl; return 0; }
	| BIT_2_B
		{ std::cout << "BIT_2_B" << std::endl; return 0; }
	| BIT_2_C
		{ std::cout << "BIT_2_C" << std::endl; return 0; }
	| BIT_2_D
		{ std::cout << "BIT_2_D" << std::endl; return 0; }
	| BIT_2_E
		{ std::cout << "BIT_2_E" << std::endl; return 0; }
	| BIT_2_H
		{ std::cout << "BIT_2_H" << std::endl; return 0; }
	| BIT_2_L
		{ std::cout << "BIT_2_L" << std::endl; return 0; }
	| BIT_2_HL
		{ std::cout << "BIT_2_HL" << std::endl; return 0; }
	| BIT_2_A
		{ std::cout << "BIT_2_A" << std::endl; return 0; }
	| BIT_3_B
		{ std::cout << "BIT_3_B" << std::endl; return 0; }
	| BIT_3_C
		{ std::cout << "BIT_3_C" << std::endl; return 0; }
	| BIT_3_D
		{ std::cout << "BIT_3_D" << std::endl; return 0; }
	| BIT_3_E
		{ std::cout << "BIT_3_E" << std::endl; return 0; }
	| BIT_3_H
		{ std::cout << "BIT_3_H" << std::endl; return 0; }
	| BIT_3_L
		{ std::cout << "BIT_3_L" << std::endl; return 0; }
	| BIT_3_HL
		{ std::cout << "BIT_3_HL" << std::endl; return 0; }
	| BIT_3_A
		{ std::cout << "BIT_3_A" << std::endl; return 0; }
	| BIT_4_B
		{ std::cout << "BIT_4_B" << std::endl; return 0; }
	| BIT_4_C
		{ std::cout << "BIT_4_C" << std::endl; return 0; }
	| BIT_4_D
		{ std::cout << "BIT_4_D" << std::endl; return 0; }
	| BIT_4_E
		{ std::cout << "BIT_4_E" << std::endl; return 0; }
	| BIT_4_H
		{ std::cout << "BIT_4_H" << std::endl; return 0; }
	| BIT_4_L
		{ std::cout << "BIT_4_L" << std::endl; return 0; }
	| BIT_4_HL
		{ std::cout << "BIT_4_HL" << std::endl; return 0; }
	| BIT_4_A
		{ std::cout << "BIT_4_A" << std::endl; return 0; }
	| BIT_5_B
		{ std::cout << "BIT_5_B" << std::endl; return 0; }
	| BIT_5_C
		{ std::cout << "BIT_5_C" << std::endl; return 0; }
	| BIT_5_D
		{ std::cout << "BIT_5_D" << std::endl; return 0; }
	| BIT_5_E
		{ std::cout << "BIT_5_E" << std::endl; return 0; }
	| BIT_5_H
		{ std::cout << "BIT_5_H" << std::endl; return 0; }
	| BIT_5_L
		{ std::cout << "BIT_5_L" << std::endl; return 0; }
	| BIT_5_HL
		{ std::cout << "BIT_5_HL" << std::endl; return 0; }
	| BIT_5_A
		{ std::cout << "BIT_5_A" << std::endl; return 0; }
	| BIT_6_B
		{ std::cout << "BIT_6_B" << std::endl; return 0; }
	| BIT_6_C
		{ std::cout << "BIT_6_C" << std::endl; return 0; }
	| BIT_6_D
		{ std::cout << "BIT_6_D" << std::endl; return 0; }
	| BIT_6_E
		{ std::cout << "BIT_6_E" << std::endl; return 0; }
	| BIT_6_H
		{ std::cout << "BIT_6_H" << std::endl; return 0; }
	| BIT_6_L
		{ std::cout << "BIT_6_L" << std::endl; return 0; }
	| BIT_6_HL
		{ std::cout << "BIT_6_HL" << std::endl; return 0; }
	| BIT_6_A
		{ std::cout << "BIT_6_A" << std::endl; return 0; }
	| BIT_7_B
		{ std::cout << "BIT_7_B" << std::endl; return 0; }
	| BIT_7_C
		{ std::cout << "BIT_7_C" << std::endl; return 0; }
	| BIT_7_D
		{ std::cout << "BIT_7_D" << std::endl; return 0; }
	| BIT_7_E
		{ std::cout << "BIT_7_E" << std::endl; return 0; }
	| BIT_7_H
		{ std::cout << "BIT_7_H" << std::endl; return 0; }
	| BIT_7_L
		{ std::cout << "BIT_7_L" << std::endl; return 0; }
	| BIT_7_HL
		{ std::cout << "BIT_7_HL" << std::endl; return 0; }
	| BIT_7_A
		{ std::cout << "BIT_7_A" << std::endl; return 0; }
	| RES_0_B
		{ std::cout << "RES_0_B" << std::endl; return 0; }
	| RES_0_C
		{ std::cout << "RES_0_C" << std::endl; return 0; }
	| RES_0_D
		{ std::cout << "RES_0_D" << std::endl; return 0; }
	| RES_0_E
		{ std::cout << "RES_0_E" << std::endl; return 0; }
	| RES_0_H
		{ std::cout << "RES_0_H" << std::endl; return 0; }
	| RES_0_L
		{ std::cout << "RES_0_L" << std::endl; return 0; }
	| RES_0_HL
		{ std::cout << "RES_0_HL" << std::endl; return 0; }
	| RES_0_A
		{ std::cout << "RES_0_A" << std::endl; return 0; }
	| RES_1_B
		{ std::cout << "RES_1_B" << std::endl; return 0; }
	| RES_1_C
		{ std::cout << "RES_1_C" << std::endl; return 0; }
	| RES_1_D
		{ std::cout << "RES_1_D" << std::endl; return 0; }
	| RES_1_E
		{ std::cout << "RES_1_E" << std::endl; return 0; }
	| RES_1_H
		{ std::cout << "RES_1_H" << std::endl; return 0; }
	| RES_1_L
		{ std::cout << "RES_1_L" << std::endl; return 0; }
	| RES_1_HL
		{ std::cout << "RES_1_HL" << std::endl; return 0; }
	| RES_1_A
		{ std::cout << "RES_1_A" << std::endl; return 0; }
	| RES_2_B
		{ std::cout << "RES_2_B" << std::endl; return 0; }
	| RES_2_C
		{ std::cout << "RES_2_C" << std::endl; return 0; }
	| RES_2_D
		{ std::cout << "RES_2_D" << std::endl; return 0; }
	| RES_2_E
		{ std::cout << "RES_2_E" << std::endl; return 0; }
	| RES_2_H
		{ std::cout << "RES_2_H" << std::endl; return 0; }
	| RES_2_L
		{ std::cout << "RES_2_L" << std::endl; return 0; }
	| RES_2_HL
		{ std::cout << "RES_2_HL" << std::endl; return 0; }
	| RES_2_A
		{ std::cout << "RES_2_A" << std::endl; return 0; }
	| RES_3_B
		{ std::cout << "RES_3_B" << std::endl; return 0; }
	| RES_3_C
		{ std::cout << "RES_3_C" << std::endl; return 0; }
	| RES_3_D
		{ std::cout << "RES_3_D" << std::endl; return 0; }
	| RES_3_E
		{ std::cout << "RES_3_E" << std::endl; return 0; }
	| RES_3_H
		{ std::cout << "RES_3_H" << std::endl; return 0; }
	| RES_3_L
		{ std::cout << "RES_3_L" << std::endl; return 0; }
	| RES_3_HL
		{ std::cout << "RES_3_HL" << std::endl; return 0; }
	| RES_3_A
		{ std::cout << "RES_3_A" << std::endl; return 0; }
	| RES_4_B
		{ std::cout << "RES_4_B" << std::endl; return 0; }
	| RES_4_C
		{ std::cout << "RES_4_C" << std::endl; return 0; }
	| RES_4_D
		{ std::cout << "RES_4_D" << std::endl; return 0; }
	| RES_4_E
		{ std::cout << "RES_4_E" << std::endl; return 0; }
	| RES_4_H
		{ std::cout << "RES_4_H" << std::endl; return 0; }
	| RES_4_L
		{ std::cout << "RES_4_L" << std::endl; return 0; }
	| RES_4_HL
		{ std::cout << "RES_4_HL" << std::endl; return 0; }
	| RES_4_A
		{ std::cout << "RES_4_A" << std::endl; return 0; }
	| RES_5_B
		{ std::cout << "RES_5_B" << std::endl; return 0; }
	| RES_5_C
		{ std::cout << "RES_5_C" << std::endl; return 0; }
	| RES_5_D
		{ std::cout << "RES_5_D" << std::endl; return 0; }
	| RES_5_E
		{ std::cout << "RES_5_E" << std::endl; return 0; }
	| RES_5_H
		{ std::cout << "RES_5_H" << std::endl; return 0; }
	| RES_5_L
		{ std::cout << "RES_5_L" << std::endl; return 0; }
	| RES_5_HL
		{ std::cout << "RES_5_HL" << std::endl; return 0; }
	| RES_5_A
		{ std::cout << "RES_5_A" << std::endl; return 0; }
	| RES_6_B
		{ std::cout << "RES_6_B" << std::endl; return 0; }
	| RES_6_C
		{ std::cout << "RES_6_C" << std::endl; return 0; }
	| RES_6_D
		{ std::cout << "RES_6_D" << std::endl; return 0; }
	| RES_6_E
		{ std::cout << "RES_6_E" << std::endl; return 0; }
	| RES_6_H
		{ std::cout << "RES_6_H" << std::endl; return 0; }
	| RES_6_L
		{ std::cout << "RES_6_L" << std::endl; return 0; }
	| RES_6_HL
		{ std::cout << "RES_6_HL" << std::endl; return 0; }
	| RES_6_A
		{ std::cout << "RES_6_A" << std::endl; return 0; }
	| RES_7_B
		{ std::cout << "RES_7_B" << std::endl; return 0; }
	| RES_7_C
		{ std::cout << "RES_7_C" << std::endl; return 0; }
	| RES_7_D
		{ std::cout << "RES_7_D" << std::endl; return 0; }
	| RES_7_E
		{ std::cout << "RES_7_E" << std::endl; return 0; }
	| RES_7_H
		{ std::cout << "RES_7_H" << std::endl; return 0; }
	| RES_7_L
		{ std::cout << "RES_7_L" << std::endl; return 0; }
	| RES_7_HL
		{ std::cout << "RES_7_HL" << std::endl; return 0; }
	| RES_7_A
		{ std::cout << "RES_7_A" << std::endl; return 0; }
	| SET_0_B
		{ std::cout << "SET_0_B" << std::endl; return 0; }
	| SET_0_C
		{ std::cout << "SET_0_C" << std::endl; return 0; }
	| SET_0_D
		{ std::cout << "SET_0_D" << std::endl; return 0; }
	| SET_0_E
		{ std::cout << "SET_0_E" << std::endl; return 0; }
	| SET_0_H
		{ std::cout << "SET_0_H" << std::endl; return 0; }
	| SET_0_L
		{ std::cout << "SET_0_L" << std::endl; return 0; }
	| SET_0_HL
		{ std::cout << "SET_0_HL" << std::endl; return 0; }
	| SET_0_A
		{ std::cout << "SET_0_A" << std::endl; return 0; }
	| SET_1_B
		{ std::cout << "SET_1_B" << std::endl; return 0; }
	| SET_1_C
		{ std::cout << "SET_1_C" << std::endl; return 0; }
	| SET_1_D
		{ std::cout << "SET_1_D" << std::endl; return 0; }
	| SET_1_E
		{ std::cout << "SET_1_E" << std::endl; return 0; }
	| SET_1_H
		{ std::cout << "SET_1_H" << std::endl; return 0; }
	| SET_1_L
		{ std::cout << "SET_1_L" << std::endl; return 0; }
	| SET_1_HL
		{ std::cout << "SET_1_HL" << std::endl; return 0; }
	| SET_1_A
		{ std::cout << "SET_1_A" << std::endl; return 0; }
	| SET_2_B
		{ std::cout << "SET_2_B" << std::endl; return 0; }
	| SET_2_C
		{ std::cout << "SET_2_C" << std::endl; return 0; }
	| SET_2_D
		{ std::cout << "SET_2_D" << std::endl; return 0; }
	| SET_2_E
		{ std::cout << "SET_2_E" << std::endl; return 0; }
	| SET_2_H
		{ std::cout << "SET_2_H" << std::endl; return 0; }
	| SET_2_L
		{ std::cout << "SET_2_L" << std::endl; return 0; }
	| SET_2_HL
		{ std::cout << "SET_2_HL" << std::endl; return 0; }
	| SET_2_A
		{ std::cout << "SET_2_A" << std::endl; return 0; }
	| SET_3_B
		{ std::cout << "SET_3_B" << std::endl; return 0; }
	| SET_3_C
		{ std::cout << "SET_3_C" << std::endl; return 0; }
	| SET_3_D
		{ std::cout << "SET_3_D" << std::endl; return 0; }
	| SET_3_E
		{ std::cout << "SET_3_E" << std::endl; return 0; }
	| SET_3_H
		{ std::cout << "SET_3_H" << std::endl; return 0; }
	| SET_3_L
		{ std::cout << "SET_3_L" << std::endl; return 0; }
	| SET_3_HL
		{ std::cout << "SET_3_HL" << std::endl; return 0; }
	| SET_3_A
		{ std::cout << "SET_3_A" << std::endl; return 0; }
	| SET_4_B
		{ std::cout << "SET_4_B" << std::endl; return 0; }
	| SET_4_C
		{ std::cout << "SET_4_C" << std::endl; return 0; }
	| SET_4_D
		{ std::cout << "SET_4_D" << std::endl; return 0; }
	| SET_4_E
		{ std::cout << "SET_4_E" << std::endl; return 0; }
	| SET_4_H
		{ std::cout << "SET_4_H" << std::endl; return 0; }
	| SET_4_L
		{ std::cout << "SET_4_L" << std::endl; return 0; }
	| SET_4_HL
		{ std::cout << "SET_4_HL" << std::endl; return 0; }
	| SET_4_A
		{ std::cout << "SET_4_A" << std::endl; return 0; }
	| SET_5_B
		{ std::cout << "SET_5_B" << std::endl; return 0; }
	| SET_5_C
		{ std::cout << "SET_5_C" << std::endl; return 0; }
	| SET_5_D
		{ std::cout << "SET_5_D" << std::endl; return 0; }
	| SET_5_E
		{ std::cout << "SET_5_E" << std::endl; return 0; }
	| SET_5_H
		{ std::cout << "SET_5_H" << std::endl; return 0; }
	| SET_5_L
		{ std::cout << "SET_5_L" << std::endl; return 0; }
	| SET_5_HL
		{ std::cout << "SET_5_HL" << std::endl; return 0; }
	| SET_5_A
		{ std::cout << "SET_5_A" << std::endl; return 0; }
	| SET_6_B
		{ std::cout << "SET_6_B" << std::endl; return 0; }
	| SET_6_C
		{ std::cout << "SET_6_C" << std::endl; return 0; }
	| SET_6_D
		{ std::cout << "SET_6_D" << std::endl; return 0; }
	| SET_6_E
		{ std::cout << "SET_6_E" << std::endl; return 0; }
	| SET_6_H
		{ std::cout << "SET_6_H" << std::endl; return 0; }
	| SET_6_L
		{ std::cout << "SET_6_L" << std::endl; return 0; }
	| SET_6_HL
		{ std::cout << "SET_6_HL" << std::endl; return 0; }
	| SET_6_A
		{ std::cout << "SET_6_A" << std::endl; return 0; }
	| SET_7_B
		{ std::cout << "SET_7_B" << std::endl; return 0; }
	| SET_7_C
		{ std::cout << "SET_7_C" << std::endl; return 0; }
	| SET_7_D
		{ std::cout << "SET_7_D" << std::endl; return 0; }
	| SET_7_E
		{ std::cout << "SET_7_E" << std::endl; return 0; }
	| SET_7_H
		{ std::cout << "SET_7_H" << std::endl; return 0; }
	| SET_7_L
		{ std::cout << "SET_7_L" << std::endl; return 0; }
	| SET_7_HL
		{ std::cout << "SET_7_HL" << std::endl; return 0; }
	| SET_7_A
		{ std::cout << "SET_7_A" << std::endl; return 0; }
	;

argument
	:	NOP
		{ $$ = 0x00; }
	|	LD_BC_nn
		{ $$ = 0x01; }
	|	LD_BC_A
		{ $$ = 0x02; }
	|	INC_BC
	|	INC_B
	|	DEC_B
	|	LD_B_n
	|	RLC_A
	|	LD_nn_SP
	|	ADD_HL_BC
	|	LD_A_BC
	|	DEC_BC
	|	INC_C
	|	DEC_C
	|	LD_C_n
	|	RRC_A
	|	STOP
	|	LD_DE_nn
	|	LD_DE_A
	|	INC_DE
	|	INC_D
	|	DEC_D
	|	LD_D_n
	|	RL_A
	|	JR_n
	|	ADD_HL_DE
	|	LD_A_DE
	|	DEC_DE
	|	INC_E
	|	DEC_E
	|	LD_E_n
	|	RR_A
	|	JR_NZ_n
	|	LD_HL_nn
	|	LDI_HL_A
	|	INC_HL_P
	|	INC_H
	|	DEC_H
	|	LD_H_n
	|	DAA
	|	JR_Z_n
	|	ADD_HL_HL
	|	LDI_A_HL
	|	DEC_HL_P
	|	INC_L
	|	DEC_L
	|	LD_L_n
	|	CPL
	|	JR_NC_n
	|	LD_SP_nn
	|	LDD_HL_A
	|	INC_SP
	|	INC_HL
	|	DEC_HL
	|	LD_HL_n
	|	SCF
	|	JR_C_n
	|	ADD_HL_SP
	|	LDD_A_HL
	|	DEC_SP
	|	INC_A
	|	DEC_A
	|	LD_A_n
	|	CCF
	|	LD_B_B
	|	LD_B_C
	|	LD_B_D
	|	LD_B_E
	|	LD_B_H
	|	LD_B_L
	|	LD_B_HL
	|	LD_B_A
	|	LD_C_B
	|	LD_C_C
	|	LD_C_D
	|	LD_C_E
	|	LD_C_H
	|	LD_C_L
	|	LD_C_HL
	|	LD_C_A
	|	LD_D_B
	|	LD_D_C
	|	LD_D_D
	|	LD_D_E
	|	LD_D_H
	|	LD_D_L
	|	LD_D_HL
	|	LD_D_A
	|	LD_E_B
	|	LD_E_C
	|	LD_E_D
	|	LD_E_E
	|	LD_E_H
	|	LD_E_L
	|	LD_E_HL
	|	LD_E_A
	|	LD_H_B
	|	LD_H_C
	|	LD_H_D
	|	LD_H_E
	|	LD_H_H
	|	LD_H_L
	|	LD_H_HL
	|	LD_H_A
	|	LD_L_B
	|	LD_L_C
	|	LD_L_D
	|	LD_L_E
	|	LD_L_H
	|	LD_L_L
	|	LD_L_HL
	|	LD_L_A
	|	LD_HL_B
	|	LD_HL_C
	|	LD_HL_D
	|	LD_HL_E
	|	LD_HL_H
	|	LD_HL_L
	|	HALT
	|	LD_HL_A
	|	LD_A_B
	|	LD_A_C
	|	LD_A_D
	|	LD_A_E
	|	LD_A_H
	|	LD_A_L
	|	LD_A_HL
	|	LD_A_A
	|	ADD_A_B
	|	ADD_A_C
	|	ADD_A_D
	|	ADD_A_E
	|	ADD_A_H
	|	ADD_A_L
	|	ADD_A_HL
	|	ADD_A_A
	|	ADC_A_B
	|	ADC_A_C
	|	ADC_A_D
	|	ADC_A_E
	|	ADC_A_H
	|	ADC_A_L
	|	ADC_A_HL
	|	ADC_A_A
	|	SUB_A_B
	|	SUB_A_C
	|	SUB_A_D
	|	SUB_A_E
	|	SUB_A_H
	|	SUB_A_L
	|	SUB_A_HL
	|	SUB_A_A
	|	SBC_A_B
	|	SBC_A_C
	|	SBC_A_D
	|	SBC_A_E
	|	SBC_A_H
	|	SBC_A_L
	|	SBC_A_HL
	|	SBC_A_A
	|	AND_B
	|	AND_C
	|	AND_D
	|	AND_E
	|	AND_H
	|	AND_L
	|	AND_HL
	|	AND_A
	|	XOR_B
	|	XOR_C
	|	XOR_D
	|	XOR_E
	|	XOR_H
	|	XOR_L
	|	XOR_HL
	|	XOR_A
	|	OR_B
	|	OR_C
	|	OR_D
	|	OR_E
	|	OR_H
	|	OR_L
	|	OR_HL
	|	OR_A
	|	CP_B
	|	CP_C
	|	CP_D
	|	CP_E
	|	CP_H
	|	CP_L
	|	CP_HL
	|	CP_A
	|	RET_NZ
	|	POP_BC
	|	JP_NZ_nn
	|	JP_nn
	|	CALL_NZ_nn
	|	PUSH_BC
	|	ADD_A_n
	|	RST_0
	|	RET_Z
	|	RET
	|	JP_Z_nn
	|	CALL_Z_nn
	|	CALL_nn
	|	ADC_A_n
	|	RST_8
	|	RET_NC
	|	POP_DE
	|	JP_NC_nn
	|	BAD_OP
	|	CALL_NC_nn
	|	PUSH_DE
	|	SUB_A_n
	|	RST_10
	|	RET_C
	|	RETI
	|	JP_C_nn
	|	CALL_C_nn
	|	SBC_A_n
	|	RST_18
	|	LDH_n_A
	|	POP_HL
	|	LDH_C_A
	|	PUSH_HL
	|	AND_n
	|	RST_20
	|	ADD_SP_d
	|	JP_HL
	|	LD_nn_A
	|	XOR_n
	|	RST_28
	|	LDH_A_n
	|	POP_AF
	|	DI
	|	PUSH_AF
	|	OR_n
	|	RST_30
	|	LDHL_SP_d
	|	LD_SP_HL
	|	LD_A_nn
	|	EI
	|	CP_n
	|	RST_38
	|	RLC_B
	|	RLC_C
	|	RLC_D
	|	RLC_E
	|	RLC_H
	|	RLC_L
	|	RLC_HL
	|	RRC_B
	|	RRC_C
	|	RRC_D
	|	RRC_E
	|	RRC_H
	|	RRC_L
	|	RRC_HL
	|	RL_B
	|	RL_C
	|	RL_D
	|	RL_E
	|	RL_H
	|	RL_L
	|	RL_HL
	|	RR_B
	|	RR_C
	|	RR_D
	|	RR_E
	|	RR_H
	|	RR_L
	|	RR_HL
	|	SLA_B
	|	SLA_C
	|	SLA_D
	|	SLA_E
	|	SLA_H
	|	SLA_L
	|	SLA_HL
	|	SLA_A
	|	SRA_B
	|	SRA_C
	|	SRA_D
	|	SRA_E
	|	SRA_H
	|	SRA_L
	|	SRA_HL
	|	SRA_A
	|	SWAP_B
	|	SWAP_C
	|	SWAP_D
	|	SWAP_E
	|	SWAP_H
	|	SWAP_L
	|	SWAP_HL
	|	SWAP_A
	|	SRL_B
	|	SRL_C
	|	SRL_D
	|	SRL_E
	|	SRL_H
	|	SRL_L
	|	SRL_HL
	|	SRL_A
	|	BIT_0_B
	|	BIT_0_C
	|	BIT_0_D
	|	BIT_0_E
	|	BIT_0_H
	|	BIT_0_L
	|	BIT_0_HL
	|	BIT_0_A
	|	BIT_1_B
	|	BIT_1_C
	|	BIT_1_D
	|	BIT_1_E
	|	BIT_1_H
	|	BIT_1_L
	|	BIT_1_HL
	|	BIT_1_A
	|	BIT_2_B
	|	BIT_2_C
	|	BIT_2_D
	|	BIT_2_E
	|	BIT_2_H
	|	BIT_2_L
	|	BIT_2_HL
	|	BIT_2_A
	|	BIT_3_B
	|	BIT_3_C
	|	BIT_3_D
	|	BIT_3_E
	|	BIT_3_H
	|	BIT_3_L
	|	BIT_3_HL
	|	BIT_3_A
	|	BIT_4_B
	|	BIT_4_C
	|	BIT_4_D
	|	BIT_4_E
	|	BIT_4_H
	|	BIT_4_L
	|	BIT_4_HL
	|	BIT_4_A
	|	BIT_5_B
	|	BIT_5_C
	|	BIT_5_D
	|	BIT_5_E
	|	BIT_5_H
	|	BIT_5_L
	|	BIT_5_HL
	|	BIT_5_A
	|	BIT_6_B
	|	BIT_6_C
	|	BIT_6_D
	|	BIT_6_E
	|	BIT_6_H
	|	BIT_6_L
	|	BIT_6_HL
	|	BIT_6_A
	|	BIT_7_B
	|	BIT_7_C
	|	BIT_7_D
	|	BIT_7_E
	|	BIT_7_H
	|	BIT_7_L
	|	BIT_7_HL
	|	BIT_7_A
	|	RES_0_B
	|	RES_0_C
	|	RES_0_D
	|	RES_0_E
	|	RES_0_H
	|	RES_0_L
	|	RES_0_HL
	|	RES_0_A
	|	RES_1_B
	|	RES_1_C
	|	RES_1_D
	|	RES_1_E
	|	RES_1_H
	|	RES_1_L
	|	RES_1_HL
	|	RES_1_A
	|	RES_2_B
	|	RES_2_C
	|	RES_2_D
	|	RES_2_E
	|	RES_2_H
	|	RES_2_L
	|	RES_2_HL
	|	RES_2_A
	|	RES_3_B
	|	RES_3_C
	|	RES_3_D
	|	RES_3_E
	|	RES_3_H
	|	RES_3_L
	|	RES_3_HL
	|	RES_3_A
	|	RES_4_B
	|	RES_4_C
	|	RES_4_D
	|	RES_4_E
	|	RES_4_H
	|	RES_4_L
	|	RES_4_HL
	|	RES_4_A
	|	RES_5_B
	|	RES_5_C
	|	RES_5_D
	|	RES_5_E
	|	RES_5_H
	|	RES_5_L
	|	RES_5_HL
	|	RES_5_A
	|	RES_6_B
	|	RES_6_C
	|	RES_6_D
	|	RES_6_E
	|	RES_6_H
	|	RES_6_L
	|	RES_6_HL
	|	RES_6_A
	|	RES_7_B
	|	RES_7_C
	|	RES_7_D
	|	RES_7_E
	|	RES_7_H
	|	RES_7_L
	|	RES_7_HL
	|	RES_7_A
	|	SET_0_B
	|	SET_0_C
	|	SET_0_D
	|	SET_0_E
	|	SET_0_H
	|	SET_0_L
	|	SET_0_HL
	|	SET_0_A
	|	SET_1_B
	|	SET_1_C
	|	SET_1_D
	|	SET_1_E
	|	SET_1_H
	|	SET_1_L
	|	SET_1_HL
	|	SET_1_A
	|	SET_2_B
	|	SET_2_C
	|	SET_2_D
	|	SET_2_E
	|	SET_2_H
	|	SET_2_L
	|	SET_2_HL
	|	SET_2_A
	|	SET_3_B
	|	SET_3_C
	|	SET_3_D
	|	SET_3_E
	|	SET_3_H
	|	SET_3_L
	|	SET_3_HL
	|	SET_3_A
	|	SET_4_B
	|	SET_4_C
	|	SET_4_D
	|	SET_4_E
	|	SET_4_H
	|	SET_4_L
	|	SET_4_HL
	|	SET_4_A
	|	SET_5_B
	|	SET_5_C
	|	SET_5_D
	|	SET_5_E
	|	SET_5_H
	|	SET_5_L
	|	SET_5_HL
	|	SET_5_A
	|	SET_6_B
	|	SET_6_C
	|	SET_6_D
	|	SET_6_E
	|	SET_6_H
	|	SET_6_L
	|	SET_6_HL
	|	SET_6_A
	|	SET_7_B
	|	SET_7_C
	|	SET_7_D
	|	SET_7_E
	|	SET_7_H
	|	SET_7_L
	|	SET_7_HL
	|	SET_7_A
	;

%%

void 
GBC::Disassembler::error( const std::string &err_message )
{
   std::cerr << "Error parsing token " << scanner.YYText() << ": " << err_message << "\n"; 
}
 
static int 
yylex( GBC::Disassembler::semantic_type *yylval,
       GBC::Scanner  &scanner,
       GBC::Driver   &driver )
{
   return scanner.yylex(yylval);
}

#include <iomanip>
#include <sstream>

std::string hexify(unsigned int v)
{
	std::stringstream ss;
	ss 	<< "0x"
		<< std::setfill('0') << std::setw(2)
		<< std::hex << v;
	return ss.str();
}