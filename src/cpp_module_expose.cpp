#include <pybind11/pybind11.h>

#include "cpp_module_1.hpp"

namespace py = pybind11;

/*
 * This file is used to expose all the classes and functions, related to rhcr, from C++ to Python.
 * To avoid multiple definitions problem, this kind of centralized file exposure is needed.
 */

PYBIND11_MODULE(cpp_modules, m)
{
    py::class_<cpp_modules::TemplateEnv, std::shared_ptr<cpp_modules::TemplateEnv>>(m, "TemplateEnv")
        // Use the exposed constructor to create an instance of the environment rather than the private constructor.
        .def(py::init(&cpp_modules::TemplateEnv::create), py::arg("config"), "Create an instance of the environment and get the share pointer of it.")
        .def("reset", &cpp_modules::TemplateEnv::reset, "Reset the environment to an initial state.")
        .def("step", &cpp_modules::TemplateEnv::step, py::arg("action"), "Step through the environment using the provided action.")
        .def("render", &cpp_modules::TemplateEnv::render, "Return the data for rendering in python.")
        .def("close", &cpp_modules::TemplateEnv::close, "Close the environment and release any resources.");
}
