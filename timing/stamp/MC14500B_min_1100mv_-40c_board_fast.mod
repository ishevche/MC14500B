/*
 Copyright (C) 2022  Intel Corporation. All rights reserved.
 Your use of Intel Corporation's design tools, logic functions 
 and other software and tools, and any partner logic 
 functions, and any output files from any of the foregoing 
 (including device programming or simulation files), and any 
 associated documentation or information are expressly subject 
 to the terms and conditions of the Intel Program License 
 Subscription Agreement, the Intel Quartus Prime License Agreement,
 the Intel FPGA IP License Agreement, or other applicable license
 agreement, including, without limitation, that your use is for
 the sole purpose of programming logic devices manufactured by
 Intel and sold by Intel or its authorized distributors.  Please
 refer to the applicable agreement for further details, at
 https://fpgasoftware.intel.com/eula.
*/
MODEL
/*MODEL HEADER*/
/*
 This file contains Fast Corner delays for the design using part 5CSEBA6U23I7
 with speed grade M, core voltage 1.1V, and temperature -40 Celsius

*/
MODEL_VERSION "1.0";
DESIGN "MC14500B";
DATE "12/29/2022 00:53:34";
PROGRAM "Quartus Prime";



INPUT clk;
INPUT program_write;
INPUT reset;
INPUT program_cmd[1];
INPUT program_cmd[0];
INPUT program_cmd[3];
INPUT program_cmd[7];
INPUT program_cmd[4];
INPUT program_cmd[5];
INPUT program_cmd[8];
INPUT program_cmd[11];
INPUT program_cmd[6];
INPUT program_cmd[10];
INPUT program_cmd[9];
INPUT input_pins[1];
INPUT input_pins[0];
INPUT input_pins[2];
INPUT input_pins[3];
INPUT input_pins[4];
INPUT program_cmd[2];
OUTPUT output_pins[0];
OUTPUT output_pins[1];
OUTPUT output_pins[2];
OUTPUT output_pins[3];
OUTPUT output_pins[4];

/*Arc definitions start here*/
pos_input_pins[0]__clk__setup:		SETUP (POSEDGE) input_pins[0] clk ;
pos_input_pins[1]__clk__setup:		SETUP (POSEDGE) input_pins[1] clk ;
pos_input_pins[2]__clk__setup:		SETUP (POSEDGE) input_pins[2] clk ;
pos_input_pins[3]__clk__setup:		SETUP (POSEDGE) input_pins[3] clk ;
pos_input_pins[4]__clk__setup:		SETUP (POSEDGE) input_pins[4] clk ;
pos_reset__clk__setup:		SETUP (POSEDGE) reset clk ;
pos_input_pins[0]__clk__hold:		HOLD (POSEDGE) input_pins[0] clk ;
pos_input_pins[1]__clk__hold:		HOLD (POSEDGE) input_pins[1] clk ;
pos_input_pins[2]__clk__hold:		HOLD (POSEDGE) input_pins[2] clk ;
pos_input_pins[3]__clk__hold:		HOLD (POSEDGE) input_pins[3] clk ;
pos_input_pins[4]__clk__hold:		HOLD (POSEDGE) input_pins[4] clk ;
pos_reset__clk__hold:		HOLD (POSEDGE) reset clk ;
pos_clk__output_pins[0]__delay:		DELAY (POSEDGE) clk output_pins[0] ;
pos_clk__output_pins[1]__delay:		DELAY (POSEDGE) clk output_pins[1] ;
pos_clk__output_pins[2]__delay:		DELAY (POSEDGE) clk output_pins[2] ;
pos_clk__output_pins[3]__delay:		DELAY (POSEDGE) clk output_pins[3] ;
pos_clk__output_pins[4]__delay:		DELAY (POSEDGE) clk output_pins[4] ;

ENDMODEL
