#!/bin/bash

# Setup the coding environment

export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export RESET='\033[0m'

# Stop the script if any command fails: set -e

# Check whether the parent folder is a git repository >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Navigate to the directory containing this script (docker folder)
cd "$(dirname "$0")"
cd ..

# Check if the parent folder is a git repository, if not, initialize a new git repository.
if [ -d ".git" ]; then
    echo -e "${GREEN}Parent folder is already a git repository.${RESET}"
else
    echo -e "${GREEN}Parent folder is not a git repository. Initializing a new git repository.${RESET}"
    git init .
fi
# Check whether the parent folder is a git repository <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

# Checking whether all the submodules are initialized >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Check if the .gitmodules file exists, if it does, initialize all the submodules.
if [ -f ".gitmodules" ]; then
    echo -e "${YELLOW}Initializing submodules.${RESET}"
    git submodule update --init --recursive

    # If the update command fails, exit the script.
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to initialize submodules.${RESET}"
        exit 1
    else
        echo -e "${GREEN}All submodules are initialized.${RESET}"
    fi
else
    echo -e "${YELLOW}No submodules found.${RESET}"
fi
# Checking whether all the submodules are initialized <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

# Use the following commands to add a new submodule to the repository. >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# git submodule add -b <branch> <repository> <path>
# git submodule update --init --recursive
# git add .gitmodules <path>

# For instance, to add pybind11 as a submodule at external/pybind11, use the following commands:
# git submodule add -b stable https://github.com/pybind/pybind11.git external/pybind11
# git submodule update --init --recursive
# git add .gitmodules external/pybind11
# Use the above commands to add a new submodule to the repository. <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
