function [pars, low, hi] = load_global(data)

age    = data.age;  

%Initial mean values
Pbar   = data.Pbar;
Hbar   = data.Hbar; 

%% PARAMETERS  

A    = 5;           %dimensionless 

Kb   = .1;          %dimensionless
Kpb  = 5;           %dimensionless
Ks   = 5;           %dimensionless

tauH  = 0.5;        %sec

qw   = .04;         %mmHg^(-1)
qpb  = 10*(1-Kb);   %sec
qs   = 10*(1-Kb);   %sec

Ds   = 3;           %sec
taus = 10;          %sec

%% Patient specific parameters

sw  = Pbar;         %mmHg

%Intrinsic HR
HI = 100;           %bpm

%Maximal HR
HM = 208 - .7*age;  %bpm     
Hs = (1/Ks)*(HM/HI - 1); %dimensionless

%% Calculate sigmoid shifts

Pa_ss  = data.Pbar; 
ewa_ss = 1 - sqrt((1 + exp(-qw*(Pa_ss - sw)))/(A + exp(-qw*(Pa_ss - sw)))); 

Tpb_ss = .8;
Ts_ss  = .2; 

%Steady-state sigmoid shifts 
spb = ewa_ss + log(Kpb/Tpb_ss - 1)/qpb;  %sec^(-1)
ss  = ewa_ss - log(Ks/Ts_ss - 1)/qs;     %sec^(-1)

%% At end of expiration and inspiration

Hpb = (1 - Hbar/HI + Hs*Ts_ss)/Tpb_ss;
Hpb = Hpb*Kpb;      %dimensionless

%% Outputs

pars = [A;              
    Ks;                         %Gains
    taus; tauH;                 %Time Constants
    qw; qpb; qs;                %Sigmoid Steepnesses
    sw; spb; ss;                %Sigmoid Shifts
    HI; Hpb; Hs;                %Heart rate gains
    Ds];                        %Delay
    
pars = log(pars);

low     = pars - log(10);
hi      = pars + log(10);
low(14) = log(1); 
hi(14) = log(10); 

end 

