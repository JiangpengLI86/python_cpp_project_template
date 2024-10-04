# Define some variables
set(PROJECT_NAME "template")
set(CPP_STANDARD 11)
set(CPP_MODULE_NAME "cpp_modules")
set(CPP_MODULE_OUTPUT_DIR "lib")

# Set the minimum required version of CMake for a project
cmake_minimum_required(VERSION 3.5)

# Set the project name
project(${PROJECT_NAME})

# Set the C++ standard
set(CMAKE_CXX_STANDARD ${CPP_STANDARD})

# Set the default build type
# Override it by passing -DCMAKE_BUILD_TYPE=<type> to cmake
# where <type> is one of: Debug, Release, RelWithDebInfo, MinSizeRel
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release")
endif()

# Set the optimization level >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    # For GCC/Clang, set optimization and debugging flags
    if(CMAKE_BUILD_TYPE STREQUAL "Release")
        set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O3")
    elseif(CMAKE_BUILD_TYPE STREQUAL "Debug")
        set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Og")
    elseif(CMAKE_BUILD_TYPE STREQUAL "MinSizeRel")
        set(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL} -Os")
    endif()
elseif(CMAKE_CXX_COMPILER_ID MATCHES "MSVC")
    # For MSVC, use equivalent flags for optimizations and debugging
    if(CMAKE_BUILD_TYPE STREQUAL "Release")
        set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /O2") # MSVC's high optimization level
    elseif(CMAKE_BUILD_TYPE STREQUAL "Debug")
        set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /Od /Zi") # Disable optimizations, enable debug info
    elseif(CMAKE_BUILD_TYPE STREQUAL "MinSizeRel")
        set(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL} /O1") # Optimize for size
    endif()
endif()

# Set the optimization level <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

# Add all cpp files in the src directory >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
file(GLOB_RECURSE SOURCES "src/*.cpp")

# Add all cpp files in the src directory <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

# boost library >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
find_package(Boost REQUIRED COMPONENTS system filesystem thread program_options)

# boost library <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

# pybind11 library >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
target_compile_options(${CPP_MODULE_NAME} PRIVATE -fvisibility=hidden) # Hide symbols from the shared library. Only works for GCC/Clang.
add_subdirectory(pybind11)
pybind11_add_module(${CPP_MODULE_NAME} ${SOURCES})

# pybind11 library >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# spglog library >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
find_package(spdlog REQUIRED)
add_compile_definitions(SPDLOG_ACTIVE_LEVEL=SPDLOG_LEVEL_TRACE)

# spglog library <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

# Include directories >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Tell the compiler where to find the header files
# Note that if a child library's `CMakeLists.txt` file already includes the directories using `target_include_directories` with `PUBLIC` or `INTERFACE`, then the parent project does not need to include the directories again.
target_include_directories(${CPP_MODULE_NAME}
    PRIVATE
    "include"
    ${Boost_INCLUDE_DIRS}
)

# Include directories <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

# Link libraries >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Tell the linker where to find the libraries
# Note that even if a parent project's `CMakeLists.txt` file use `add_subdirectory` to include the child library, the parent project still needs to use `target_link_libraries` to link that library.
target_link_libraries(${CPP_MODULE_NAME}
    PRIVATE
    ${Boost_LIBRARIES}
    spdlog::spdlog_header_only
)

# Link libraries <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

# Set the output directory >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Set the output directory for the shared library
set_target_properties(${CPP_MODULE_NAME} PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/${CPP_MODULE_OUTPUT_DIR}"
    ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/${CPP_MODULE_OUTPUT_DIR}"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/${CPP_MODULE_OUTPUT_DIR}"
)

# Set the output directory <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

# # Add executable >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# # Tell CMake to create the executable.
# # All source file directly linked to the executable must be listed here
# add_executable(${PROJECT_NAME} ${SOURCES})
#
# # Add executable <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

# # Add library >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# # Tell CMake to create the shared library.
# # All source file directly linked to the shared library must be listed here
# add_library(${PROJECT_NAME} SHARED ${SOURCES})
#
# # Add library <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

# # Link directories >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# # Tell the linker where to find the directories containing the libraries
# # Note: If a parent project's `CMakeLists.txt` file use `add_subdirectory` to include the child library, indicating the child library is compiled together with the parent project, then the parent project does not need to use `target_link_directories` to link that library again.
# target_link_directories(${PROJECT_NAME}
# PRIVATE
# "lib"
# )
# # Link directories <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
