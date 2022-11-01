#include <iostream>
#include <fstream>
#include <string>
#include <argparse/argparse.hpp>
#include "assembler.h"

std::string read_file(const std::string& path) {
    std::ifstream file(path);
    std::string str((std::istreambuf_iterator<char>(file)),
                    std::istreambuf_iterator<char>());
    file.close();
    return str;
}

void write_to_file(const std::string& path, const std::string& data) {
    std::ofstream file(path);
    file << data;
    file.close();
}

int main(int argc, char *argv[]) {
    argparse::ArgumentParser program("Motorolla MC14500B assembler");

    program.add_argument("input_file")
            .required()
            .help("Input files");
    program.add_argument("-o", "--output")
            .required()
            .help("specify the output file");

    program.add_argument("--verbose")
            .help("show info and warnings")
            .default_value(false)
            .implicit_value(true);

    try {
        program.parse_args(argc, argv);
    }
    catch (const std::runtime_error& err) {
        std::cerr << err.what() << std::endl;
        std::cerr << program;
        return 1;
    }

    Logger::setVerbose(program["--verbose"] == true);

    try {
        write_to_file(
                program.get<std::string>("--output"),
                Assembler{}.assemble(read_file(program.get<std::string>("input_file"))));
    } catch (const std::runtime_error& error) {
        Logger::error(error.what());
        return 1;
    }

    return 0;
}
