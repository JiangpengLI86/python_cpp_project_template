#!/bin/bash

# Set the workspace folder to the project's root directory
WORKSPACE_FOLDER=$(dirname "$(readlink -f "$0")")/..

# Get the number of available CPUs and set it to 1.5 times the actual core count (rounded for better I/O handling)
# bc is a command-line calculator
# awk is a text processing tool
NUM_CPUS=$(echo "$(nproc) * 1.5" | bc | awk '{print int($1+0.5)}')

# Define color codes for better readability
RED="\e[31m"
YELLOW="\e[33m"
BLUE="\e[34m"
GREEN="\e[32m"
RESET="\e[0m"

# Function to print error messages in a human-readable format
function print_error() {
    echo -e "${RED}ERROR:${RESET} $1"
}

# Function to print warning messages in a human-readable format
function print_warning() {
    echo -e "${YELLOW}WARNING:${RESET} $1"
}

# Step 1: CMake Configure
function cmake_configure() {
    echo -e "${BLUE}Running cmake configure...${RESET}"
    cmake -S "$WORKSPACE_FOLDER" -B "$WORKSPACE_FOLDER/build" -DCMAKE_BUILD_TYPE=Debug
    if [ $? -ne 0 ]; then
        print_error "CMake configuration failed. Exiting..."
        exit 1
    fi
}

# Step 2: Make Build
function make_build() {
    echo -e "${BLUE}Running make build...${RESET}"

    # [ 2> ] redirects the standard error stream to a process substitution
    # [ >(...) ] is a process substitution in Bash which takes the output and sends it to a given command or set of commands
    # [ while read line; do ... then ] reads the output line by line
    # [ if [[ "$line" == *error* ]]; then ... ] checks if the line contains the word "error" (case-sensitive)
    # [ if [ $? -ne 0 ]; then ... ] checks if the return code of the last command is not equal to 0
    make -C "$WORKSPACE_FOLDER/build" -j $NUM_CPUS 2> >(while read line; do
        if [[ "$line" == *error* ]]; then
            print_error "$line"
        elif [[ "$line" == *warning* ]]; then
            print_warning "$line"
        else
            echo "$line"
        fi
    done)
    if [ $? -ne 0 ]; then
        print_error "Make build failed. Exiting..."
        exit 1
    fi
}

# Run tasks in sequence
cmake_configure
make_build

# Success message
echo -e "${GREEN}Build completed successfully.${RESET}"
