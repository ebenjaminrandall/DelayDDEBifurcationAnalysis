This directory computes forward model evaluations at the optimal parameter values for the full five-state model. 
To compile the Fortran code, in the command line run the following command on Mac/Linux OS while in this directory: 

gfortran -o driver *.f

This creates the executable driver called by the MATLAB unix command. Once compiled, the MATLAB code will run normally.
The code consists of the following: 

Data:
optHR_control.mat - .mat file containing the data and model predictions with optimized parameter values for the control subject exhibiting sink behavior 
optHR_SF.mat      - .mat file containing the data and model predictions with optimized parameter values for the control subject exhibiting stable focus behavior
optHR_M.mat       - .mat file containing the data and model predictions with optimized parameter values for the postural orthostatic tachycardia syndrome (POTS) patient with M behavior exhibiting stable focus behavior

MATLAB Code: 

Driver_plots.m      - runs the model for all three subjects by calling model_sol.m
model_sol.m         - writes files to .txt in the FortranData folder for the executable ./driver to read in 
load_global.m       - assigned and calculated parameter values based on datat 
initialconditions.m - calculates the initial conditions and constant history value based on baseline systolic blood pressure and heart rate values

Fortran Code: 

driver_baroreflex_fivestate.f - formulates the full five-state model and reads in .txt files from the FortranData folder
spline.f                     - determines a piecewise cubic spline. 
splint.f                     - evaluates the piecewise cubic spline 
All other Fortran code can be found http://www.unige.ch/~hairer/software.html under Delay differential equations. 
