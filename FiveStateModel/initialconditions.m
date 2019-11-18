function Init = initialconditions(pars,data)

%% PARAMETERS 

A  = pars(1);
B  = pars(2);

Kb  = pars(3);
Kpb = pars(4);
Ks  = pars(5); 

qw  = pars(10); 
qpb = pars(11);
qs  = pars(12);

sw  = pars(13); 
spb = pars(14); 
ss  = pars(15);

%% INITIAL CONDITIONS

Pc_0  = data.Pdata(1); 
ewc_0 = 1 - sqrt((1 + exp(-qw*(Pc_0 - sw)))/(A + exp(-qw*(Pc_0 - sw)))); 
ebc_0 = Kb*ewc_0; 
ec_0  = ewc_0 - ebc_0; 

Pa_0  = data.Pdata(1) - data.Pthdata(1); 
ewa_0 = 1 - sqrt((1 + exp(-qw*(Pa_0 - sw)))/(A + exp(-qw*(Pa_0 - sw)))); 
eba_0 = Kb*ewa_0; 
ea_0  = ewa_0 - eba_0; 

n_0   = B*ec_0 + (1 - B)*ea_0;

Gpb_0 = 1/(1 + exp(-qpb*(n_0 - spb)));
Gs_0  = 1/(1 + exp(qs*(n_0 - ss))); 

Tpb_0 = Kpb*Gpb_0; 
Ts_0  = Ks*Gs_0; 

%% OUTPUT

Init = [ebc_0; eba_0; Tpb_0; Ts_0; data.Hbar];
