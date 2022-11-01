#ifndef MASM_LOGGER_H
#define MASM_LOGGER_H

#include <string>

class Logger {
public:
    enum LogLevel {
        INFO,
        WARNING,
        ERROR
    };

    static void log(LogLevel logLevel, const std::string &message);

    static void info(const std::string &message);

    static void warning(const std::string &message);

    static void error(const std::string &message);

    static void setVerbose(bool verbose);

    static bool isVerbose();

private:
    static bool is_verbose;
};

#endif //MASM_LOGGER_H
