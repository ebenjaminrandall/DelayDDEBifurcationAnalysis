%evalmodelmesh

clear all

tic 

%Load in data and nominal parameter values
load nomHR.mat 

%Tells unix to echo output from command line in the command window in
%Matlab
echoon = 0; 
data.gpars.echoon = echoon; 

%Discretized mesh for tau_s and D_s
tausvals = .1:1e-1:10;
Dsvals = .1:1e-1:10;

pars = load_global(data);

keep = zeros(length(tausvals),length(Dsvals),length(HR)); 
for ii = 1:length(tausvals)
    pars(3) = log(tausvals(ii));
    for jj = 1:length(Dsvals)
        pars(end) = log(Dsvals(jj)); 
        
        [HR,~,~,Outputs] = model_sol(pars,data);
        
        time = Outputs(:,1); 
        Ts   = Outputs(:,2);
        
        keep(ii,jj,:) = Ts; 
    end
end

elapsed_time = toc 
save bifur.mat
