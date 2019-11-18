This directory computes the bifurcation analysis from Algorithm 1 in the manuscript for the reduced two-state model. 
To compile the Fortran code, in the command line run the following command on Mac/Linux OS while in this directory: 

gfortran -o driver *.f

This creates the executable driver called by the MATLAB unix command. Once compiled, the MATLAB code will run normally.
The code consists of the following: 

Data:
nomHR.mat - .mat file containing the data and parameter values for the control subject exhibiting sink behavior 
bifur.mat - .mat file containing solutions from the discretized mesh in evalmodelmesh.m

MATLAB Code: 

evalmodelmesh.m     - computes model evaluations over the specified discretized mesh by calling model_sol.m; produces bifur.mat
bifurmap.m	    - follows the protocol from Algorithm 1 to assign colors to the solution behaviors from bifur.mat; produces Figure 9b
model_sol.m         - writes files to .txt in the FortranData folder for the executable ./driver to read in 
initialconditions.m - calculates the initial conditions and constant history value based on baseline systolic blood pressure and heart rate values

Fortran Code: 

driver_baroreflex_fivestate.f - formulates the full five-state model and reads in .txt files from the FortranData folder
spline.f                     - determines a piecewise cubic spline. 
splint.f                     - evaluates the piecewise cubic spline 
All other Fortran code can be found http://www.unige.ch/~hairer/software.html under Delay differential equations. 
