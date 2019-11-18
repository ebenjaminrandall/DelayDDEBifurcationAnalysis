function Init = initialconditions(pars,data)

%% PARAMETERS 

A  = pars(1);

Ks  = pars(2); 

qw  = pars(5); 
qs  = pars(7);

sw  = pars(8); 
ss  = pars(10);

%% INITIAL CONDITIONS

Pa_0  = data.Pdata(1) - data.Pthdata(1); 
ewa_0 = 1 - sqrt((1 + exp(-qw*(Pa_0 - sw)))/(A + exp(-qw*(Pa_0 - sw)))); 

Gs_0  = 1/(1 + exp(qs*(ewa_0 - ss))); 

Ts_0  = Ks*Gs_0; 

%% OUTPUT

Init = [Ts_0; data.Hdata(1)];
