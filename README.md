This file contains instructions for obtaining, compiling, and using the microbial community design algorithm.  This algorithm takes in a set of species with associated metabolic reactions, a set of substrate metabolites, and a set of product metabolites.  The algorithm then finds a minimal community that has the metabolic capacity for converting the specified substrates into the desired products.

### DOWNLOAD:

The source code for the community design algorithm can be obtained by cloning the git repository:

`git clone git@github.com:engal/community_design.git`

or downloading the compressed repository via the command line:

```
wget https://github.com/engal/community_design/archive/master.tar.gz
tar -zxf community_design-master.tar.gz
```

or downloading the zip file directly from the webpage:

https://github.com/engal/community_design

##### Downloading the CBC ILP solver

Pre-built binaries for CBC, the ILP solver we recommend, can be downloaded from [here](http://ampl.com/products/solvers/open-source/#cbc).

### COMPILATION:

In the home directory of this project (where this README.md is located), first perform the necessary setup by typing:

`./setup`

If you hav downloaded or compiled the CBC binary, then you can specify the binary's location during setup:

`./setup -c /path/to/cbc`

Once you have finished the setup, you can compile by typing:

`make`

To test the code after compilation, you can then type

`make test`

### USE:

After compilation, you will have an executable called `design_community` in the bin directory.  `design_community` functions as a wrapper for three other executables: `write_design_problem`, `cbc` (if you have downloaded it), and `get_solution_species`.  `design_community` takes one argument: a file representing the entire problem definition, including the list of available substrates, and substrates that the community must be able to convert to other metabolites, the desired products, and the mapping of which species can catalyze which reactions:

`./design_community problem_definition_file`

The output is then a list of species in the minimal solution community found by the algorithm printed to stdout.

##### Advanced Usage

There are a few advanced options available when using `design_community`.

###### Simple Graph Interpretation

Depending on the application, you may desire to use a less strict interpretation of the metabolic network.  For instance, you may want to ensure a set of metabolic reactions can convert your available substrates to your desired products, but you don't care whether there may be cofactors or additional metabolites required to perform this conversion.  The `-s` flag causes the algorithm to treat the metabolic network of the provided species as a simple graph, where each multi-substrate->multi-product reaction from the original network is split into single-substrate->sigle-product reactions.  For example, if there was a reaction

`A + B -> C + D`

the new simple reactions would be

```
A -> C
A -> D
B -> C
B -> D
```

and so calling `design_community` using this simple graph interpretation would look like this:

`./design_community -s problem_definition_file`

###### Forced Substrate Usage

Normally, the algorithm treats substrates as a pool of available resources, not caring about which particular available substrates are used to create the desired products.  However, there may be cases where you want to ensure that the designed community can make use of a specific substrate or set of substrates.  To achieve this, you can include a section the problem definition file with the section header "FORCED_SUBSTRATES" and a list of the associated substrates.

###### Manual Community Design Process

The design process can also be performed step-by-step using the mentioned executables in case the user wants to examine intermediate files in the process.  You would start this step-by-step approach by running `write_design_problem`, which takes in the same arguments as `design_community` (including the additional arguments) and prints the associated problem in its ILP formulation:

`./write_design_problem problem_definition_file > ilp_formulation.txt`

This output contains the definition of all variables and constraints in the ILP problem, which is then used as input for an ILP solver.  In our case, we used the CBC ILP solver, which uses a branch-and-cut search algorithm:

`./cbc -import ilp_formulation.txt -branchAnd -solution design_solution.txt`

The solution file either reports an infeasible integer solution, or identifies all non-zero variables in the feasible solution.  For the design algorithm, the non-zero variables will be the species for the solution community as well as the reactions used to get from the given substrates to the desired products.  To extract just the species for the solution community, you can use the `get_solution_species` executable:

`./get_solution_species.py design_solution.txt > solution_species.txt`