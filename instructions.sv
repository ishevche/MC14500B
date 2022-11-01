package instructions;
	typedef enum logic [3:0] {
		NOPO,  // 0x0
		LD,  // 0x1
		LDC,  // 0x2
		AND,  // 0x3
		ANDC,  // 0x4
		OR,  // 0x5
		ORC,  // 0x6
		XNOR,  // 0x7
		STO,  // 0x8
		STOC,  // 0x9
		IEN,  // 0xA
		OEN,  // 0xB
		JMP,  // 0xC
		RTN,  // 0xD
		SKZ,  // 0xE
		NOPF  // 0xF
	} instruction_t;
endpackage