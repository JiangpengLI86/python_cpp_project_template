#pragma once

#include <vector>
#include <iostream>
#include <memory>
#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
#include <pybind11/pytypes.h>

namespace py = pybind11;

namespace cpp_modules
{

    class TemplateEnv : public std::enable_shared_from_this<TemplateEnv>
    {
    public:
        // Exposed Constructor: create a shared pointer instance of the environment with configuration.
        static std::shared_ptr<TemplateEnv> create(const py::dict &config);

        // Destructor
        ~TemplateEnv();

        // Reset the environment to an initial state.
        std::vector<double> reset();

        // Step through the environment using the provided action.
        py::tuple step(int action);

        // Render the environment (for visualization purposes).
        void render();

        // Close the environment and release any resources.
        void close();

    protected:
        // Private Constructor: truly initialize the environment with configuration.
        TemplateEnv(const py::dict &config);

    private:
        // Private member variables
        std::vector<double> state;
        py::dict configuration;
    };

} // namespace cpp_module
