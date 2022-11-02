#include "assembler.h"
#include <sstream>
#include <algorithm>
#include <utility>
#include <vector>
#include <string>
#include <set>
#include <iomanip>

const std::vector<std::string> instructions = {
        "NOPO",
        "LD",
        "LDC",
        "AND",
        "ANDC",
        "OR",
        "ORC",
        "XNOR",
        "STO",
        "STOC",
        "IEN",
        "OEN",
        "JMP",
        "RTN",
        "SKZ",
        "NOPF"
};

std::set<std::string> no_address_instructions = {
        "NOPO",
        "RTN",
        "SKZ",
        "NOPF",
};

size_t getInstructionCode(const std::string& instruction) {
    return std::distance(instructions.begin(), std::find(instructions.begin(), instructions.end(), instruction));
}

std::string Assembler::assemble(const std::string &text) {
    Logger::info("Started assembling");
    auto machine_code = Parser{text}.parse().assemble();
    Logger::info("Finished assembling");

    std::ostringstream ss;
    for (auto [instruction, address] : machine_code)
        ss << std::hex << instruction << std::setw(2) << std::setfill('0') << address << std::endl;
    return ss.str();
}

Assembler::Parser::Parser(std::string text) : text{std::move(text)}, ptr{0} {

}

size_t to_int(const std::string &str) {
    size_t num;
    std::istringstream ss{str};
    ss >> num;
    return num;
}

std::map<std::string, Assembler::PinMap> Assembler::Parser::parsePinout() {
    std::map<std::string, PinMap> pinout;
//    std::set<size_t> addresses;
    while (!isEOF()) {
        std::string token = current_token();
        PinMap::Mode mode;
        if (token == "INPUT")
            mode = PinMap::INPUT;
        else if (token == "OUTPUT")
            mode = PinMap::OUTPUT;
        else
            break;
        next_token();
        std::string name = next_token();
        size_t address = to_int(next_token());
        if (pinout.find(name) != pinout.end())
            throw std::runtime_error("Pin redefinition");
        pinout[name] = PinMap{mode, address};
    }
    return pinout;
}

Assembler::Program Assembler::Parser::parse() {
    Assembler::Program program;
    std::string token = next_token();
    if (token.empty())
        Logger::warning("No instructions found");
    else {
        if (token == "PINOUT") {
            program.pinout = parsePinout();
            token = next_token();
        } else
            Logger::info("No pinouts found");
        if (token == "START") {
            program.labels["START"] = 0;
            while (!isEOF()) {
                std::string instruction = next_token();

                auto it = std::find(instructions.begin(), instructions.end(), instruction);
                if (it == instructions.end())
                    program.labels[instruction] = program.instructions.size();
                else {
                    std::string address;
                    if (no_address_instructions.find(instruction) == no_address_instructions.end()) {
                        address = next_token();
                        if (instruction != "JMP" && address != "RR" &&
                            program.pinout.find(address) == program.pinout.end())
                            program.variables.insert(address);
                    }
                    program.instructions.push_back({instruction, address});
                }
            }
        }
    }
    return program;
}

bool Assembler::Parser::isEOF() {
    return ptr == text.size();
}

void Assembler::Parser::skip_whitespace() {
    while (!isEOF()) {
        if (text[ptr] == '#') {
            while (!isEOF() && text[ptr] != '\n')
                ptr++;
        } else if (std::isspace(text[ptr]))
            ptr++;
        else
            break;
    }
}

std::string Assembler::Parser::next_token() {
    skip_whitespace();
    std::string token;
    while (!isEOF() && !std::isspace(text[ptr]))
        token += text[ptr++];
    skip_whitespace();
    return token;
}

std::string Assembler::Parser::current_token() {
    skip_whitespace();
    std::string token;
    int current_ptr = ptr;
    while (!isEOF() && !std::isspace(text[current_ptr]))
        token += text[current_ptr++];
    skip_whitespace();
    return token;
}

std::vector<std::pair<size_t, size_t>> Assembler::Program::assemble() {
    std::vector<std::pair<size_t, size_t>> machine_code;

    std::set<size_t> used_addresses;
    for (auto [_, value] : pinout)
        used_addresses.insert(value.address);
    std::map<std::string, size_t> variable_mapping;
    size_t idx = 0;
    for (const auto& variable : variables) {
        while (used_addresses.find(idx) != used_addresses.end())
            idx++;
        variable_mapping[variable] = idx;
    }

    for (const auto& instructionTuple : instructions) {
        size_t opcode = getInstructionCode(instructionTuple.instruction);
        size_t address;
        if (instructionTuple.instruction == "JMP")
            address = labels[instructionTuple.address];
        else if (pinout.find(instructionTuple.address) != pinout.end())
            address = pinout[instructionTuple.address].address;
        else if (variable_mapping.find(instructionTuple.address) != variable_mapping.end())
            address = variable_mapping[instructionTuple.address];
        else
            address = 255;
        machine_code.emplace_back(opcode, address);
    }
    return machine_code;
}
