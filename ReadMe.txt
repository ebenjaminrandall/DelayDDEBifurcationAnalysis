These files are supplementary to the manuscript "Persisitent instability in a nonhomogeneous delay differential equation system of the Valsalva manuver". 


Each folder contains to the necessary files to successfully run each model and produce figures from the manuscript. 
This code uses the MATLAB unix command, which calls an executable called ./driver. On a Macs/Linux OS, 
establishing this executable can be done with the following command in the command line while in the current directory:  


gfortran -o driver *.f 





This repository contains the following folders:  


FiveStateModel 
- Computes forward model evaluations with optimized parameter values of the five state neurological model in response to the Valsalva maneuver.
- Plots Figures 1 and 11 in the manuscript for the five-state model only 
 
TwoStateModel  
- Computes forward model evaluations with optimized parameter values of the two state neurological model in response to the Valsalva maneuver. 
- Plots Figure 11 in the manuscript for the five-state model only 

BifurcationAnalysis 
- Contains code for Algorithm 1 discussed in the manuscript to analyze the behavior of solutions to the model evaluated over a discretized mesh.
- Plots Figure 9b in the manuscript

