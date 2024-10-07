import sys
sys.path.append("lib")  # C++ extension module path

import cpp_modules

def main():
    # Configuration for the environment
    config = {"learning_rate": 0.01, "max_steps": 1000}

    # Create an instance of the environment
    env = cpp_modules.TemplateEnv(config)

    # Reset the environment to start a new episode
    initial_observation = env.reset()
    print("Initial Observation:", initial_observation)

    # Take an action in the environment
    action = 1  # Example action, could be any integer representing an action
    observation, reward, done, info = env.step(action)
    print("Observation after action:", observation)
    print("Reward:", reward)
    print("Done:", done)
    print("Info:", info)

    # Render the environment (optional, depending on visualization)
    env.render()

    # Close the environment to release resources
    env.close()

if __name__ == "__main__":
    main()
