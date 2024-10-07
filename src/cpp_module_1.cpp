#include "cpp_module_1.hpp"

namespace py = pybind11;

namespace cpp_modules
{
    // Exposed Constructor: create a shared pointer instance of the environment with configuration.
    // Use this method to create an instance of the environment and get a shared pointer to it.
    std::shared_ptr<TemplateEnv> TemplateEnv::create(const py::dict &config)
    {
        return std::shared_ptr<TemplateEnv>(new TemplateEnv(config));
    }

    // Private Constructor: truly initialize the environment with configuration.
    TemplateEnv::TemplateEnv(const py::dict &config) : configuration(config)
    {
        std::cout << "Environment initialized with config." << std::endl;
        for (auto item : configuration)
        {
            std::cout << "Key: " << py::str(item.first) << ", Value: " << py::str(item.second) << std::endl;
        }
    }

    // Destructor: Clean up if necessary.
    TemplateEnv::~TemplateEnv()
    {
        std::cout << "Environment destroyed." << std::endl;
    }

    // Reset the environment to an initial state.
    std::vector<double> TemplateEnv::reset()
    {
        std::cout << "Environment reset." << std::endl;
        return {0.0, 0.0, 0.0}; // Example initial observation.
    }

    // Step through the environment using the provided action.
    py::tuple TemplateEnv::step(int action)
    {
        std::cout << "Action taken: " << action << std::endl;

        // For demonstration, use some dummy values:
        std::vector<double> new_observation = {1.0, 2.0, 3.0};
        double reward = 1.0;
        bool done = false;
        std::string info = "Step completed.";

        return py::make_tuple(new_observation, reward, done, info);
    }

    // Render the environment (for visualization purposes).
    void TemplateEnv::render()
    {
        std::cout << "Rendering environment..." << std::endl;
    }

    // Close the environment and release any resources.
    void TemplateEnv::close()
    {
        std::cout << "Closing environment..." << std::endl;
    }

}
