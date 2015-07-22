This file contains instructions for obtaining, compiling, and using the microbial community design algorithm.  This algorithm takes in a set of species with associated metabolic reactions, a set of substrate metabolites, and a set of product metabolites.  The algorithm then finds a minimal community that has the metabolic capacity for converting the specified substrates into the desired products.

## DOWNLOAD:

The source code for the community design algorithm can be obtained by cloning the git repository:

`git clone git@github.com:engal/community_design.git`

or downloading the compressed repository via the command line:

`wget https://github.com/engal/community_design/archive/master.tar.gz
tar -zxf community_design-master.tar.gz`

or downloading the zip file directly from the webpage:

https://github.com/engal/community_design

Pre-built binaries for Cbc, the ILP solver we recommend, can be downloaded from

http://www.coin-or.org/download/binary/Cbc

*******************************************************************
COMPILATION:
*******************************************************************

In the home directory of this project (where this README is located), compile the code by typing:

  make

To test the code, you can type

  make test

*******************************************************************
USE:
*******************************************************************

After compilation, you will have an executable called "design_community" in the bin directory.  design_community functions as a wrapper for three other executables: "write_design_problem.o", "cbc", and "get_solution_species.py".  design_community takes three arguments: a file representing the species->reaction mapping, a comma-delimited list of substrates, and a comma-delimited list of products, as shown below:

  ./design_community species->reactions substrates products

The output is then a list of species in the minimal solution community found by the algorithm printed to stdout.

The design process can also be performed step-by-step using the mentioned executables in case the user wants to examine intermediate files in the process.  You would start this step-by-step approach by running write_design_problem, which takes in the same arguments as design_community and prints the associated problem in its ILP formulation:

  ./write_design_problem.o species->reactions substrates products > ilp_formulation.txt

This output contains the definition of all variables and constraints in the ILP problem, which is then taken by the cbc executable and solved using a branch-and-cut search algorithm:

  ./cbc -import ilp_formulation.txt -branchAnd -solution design_solution.txt

The solution file either reports an infeasible integer solution, or identifies all non-zero variables in the feasible solution.  For the design algorithm, the non-zero variables will be the species for the solution community as well as the reactions used to get from the given substrates to the desired products.  To extract just the species for the solution community, you can use the get_solution_species.py executable:

  ./get_solution_species.py design_solution.txt > solution_species.txt