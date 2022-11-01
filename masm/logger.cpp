#include "logger.h"
#include <iostream>

bool Logger::is_verbose;

void Logger::log(Logger::LogLevel logLevel, const std::string &message) {
    if (is_verbose || logLevel == LogLevel::ERROR) {
        std::cout << "[";
        if (logLevel == LogLevel::INFO)
            std::cout << "INFO";
        else if (logLevel == LogLevel::WARNING)
            std::cout << "WARNING";
        else if (logLevel == LogLevel::ERROR)
            std::cout << "ERROR";
        std::cout << "]: " << message << std::endl;
    }
}

void Logger::info(const std::string &message) {
    log(LogLevel::INFO, message);
}

void Logger::warning(const std::string &message) {
    log(LogLevel::WARNING, message);
}

void Logger::error(const std::string &message) {
    log(LogLevel::ERROR, message);
}

void Logger::setVerbose(bool verbose) {
    is_verbose = verbose;
}

bool Logger::isVerbose() {
    return is_verbose;
}
