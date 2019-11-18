function [pars, low, hi] = load_global(data)

age    = data.age;  

%Initial mean values
Pbar   = data.Pbar; 
Hbar   = data.Hbar; 

%% PARAMETERS  

A    = 5;               %dimensionless 
B    = .5;              %sec^(-1)

Kb   = .1;              %dimensionless
Kpb  = 5;               %dimensionless
Ks   = 5;               %dimensionless

taub  = .9;             %sec
taupb = 1.8;            %sec
taus  = 10;             %sec
tauH  = .5; 

qw   = .04;             %mmHg^(-1)
qpb  = 10;              %sec
qs   = 10;              %sec

Ds   = 3;               %sec

%% Patient specific parameters

sw  = Pbar;             %mmHg

%Intrinsic HR
HI = 100;               %bpm

%Maximal HR
HM = 208 - .7*age;      %bpm     
Hs = (1/Ks)*(HM/HI - 1);%dimensionless

%% Calculate sigmoid shifts

Pc_ss  = data.Pbar; 
ewc_ss = 1 - sqrt((1 + exp(-qw*(Pc_ss - sw)))/(A + exp(-qw*(Pc_ss - sw)))); 
ebc_ss = Kb*ewc_ss; 
ec_ss  = ewc_ss - ebc_ss; 

Pa_ss  = data.Pbar - data.Pthbar; 
ewa_ss = 1 - sqrt((1 + exp(-qw*(Pa_ss - sw)))/(A + exp(-qw*(Pa_ss - sw)))); 
eba_ss = Kb*ewa_ss; 
ea_ss  = ewa_ss - eba_ss; 

n_ss   = B*ec_ss + (1 - B)*ea_ss;

Tpb_ss = .8;
Ts_ss  = .2; 

%Steady-state sigmoid shifts 
spb = n_ss + log(Kpb/Tpb_ss - 1)/qpb;  %sec^(-1)
ss  = n_ss -  log(Ks/Ts_ss - 1)/qs;    %sec^(-1)

%% At end of expiration and inspiration

Hpb = (1 - Hbar/HI + Hs*Ts_ss)/Tpb_ss;  %dimensionless

%% Outputs

pars = [A; B;              
    Kb; Kpb; Ks;                           %Gains
    taub; taupb; taus; tauH;     %Time Constants
    qw; qpb; qs;                %Sigmoid Steepnesses
    sw; spb; ss;               %Sigmoid Shifts
    HI; Hpb; Hs;
    Ds];                 %Heart Rate Parameters 
    
pars = log(pars);

low     = pars - log(10);
hi      = pars + log(10);
low(2)  = log(0.01);
hi(2)   = log(1); 
low(19) = log(1); 
hi(19)  = log(10); 

end 

