#ifndef MASM_ASSEMBLER_H
#define MASM_ASSEMBLER_H

#include <stdexcept>
#include <vector>
#include <set>
#include <map>
#include "logger.h"

class Assembler {
public:
    std::string assemble(const std::string &text);
private:
    struct InstructionTuple {
        std::string instruction;
        std::string address;
    };

    struct PinMap {
        enum Mode {
            INPUT,
            OUTPUT
        } mode;
        size_t address;
    };

    struct Program {
        std::map<std::string, PinMap> pinout;
        std::vector<InstructionTuple> instructions;
        std::map<std::string, size_t> labels;
        std::set<std::string> variables;

        std::vector<std::pair<size_t, size_t>> assemble();
    };

    class Parser {
    public:
        explicit Parser(std::string text);
        Program parse();
        std::map<std::string, PinMap> parsePinout();
    private:
        std::string text;
        int ptr{};

        bool isEOF();

        std::string next_token();
        std::string current_token();
        void skip_whitespace();
    };
};

#endif //MASM_ASSEMBLER_H
