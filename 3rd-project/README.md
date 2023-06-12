# 3rd Practical Project

> The report of this practical project is available [here](ia_3rd_project.pdf).

## Prolog

The Prolog part of this project focuses on assembly planning. The main Prolog file for the assembly planning application is `main.pl`. It makes use of the `domain.pl` file, which defines the domain-specific predicates and facts. The project also includes different planners implemented in Prolog:

* `planner_goal_regression.pl`: Prolog file implementing the goal regression planner.
* `planner/bestfirst/`: Directory containing files related to the best-first search variant of the goal regression planner.
* `planner/pop/`: Directory containing files related to the partial order planning.

To run the Prolog application, you can use the following query:
   
```prolog
?- assemble_product.
```

Please note that the assemble_product predicate is the entry point to the assembly planning process. Additionally, to ensure sufficient stack space for the execution, the stack_limit Prolog flag has been set to a large value.

## Python - Handwritten Digit Classification

This code provides functionality for training and testing a neural network to classify handwritten digits. The neural network is trained using the MNIST dataset and can be tested with either CSV test data or image test data.

The code consists of the following files:

1. `train_and_test.py`: The main script that handles training and testing of the neural network.
2. `neuralnetwork.py`: Contains the implementation of the `NeuralNetwork` class.
3. `data_loader.py`: Contains functions for loading the training and test data.

To run the code, follow these steps:

1. Make sure you have Python installed on your system.
2. Clone the repository or download the code files.
3. Install the required dependencies by running `pip install <dependency>` for each of the following dependencies:
   - `numpy`
   - `scipy`
   - `matplotlib`
   - `imageio`
4. Ensure that you have the necessary data files:
   - MNIST training data: `mnist_dataset/mnist_train.csv`
   - CSV test data: `mnist_dataset/mnist_test.csv`
   - Image test data: `my_own_images/2828_my_own_?.png`
5. Open a terminal or command prompt and navigate to the directory containing the code files.
6. Run the following command:

   ```
   python train_and_test.py
   ```

7. The program will prompt you to enter the test type. Enter `1` to test with CSV test data or `2` to test with image test data.
8. The program will display the performance of the neural network.

Note: Replace `python` with `python3` if you're using Python 3.x.

Ensure that you have the necessary permissions to read and write files in the specified directories.
