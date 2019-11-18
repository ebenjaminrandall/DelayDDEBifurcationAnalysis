%bifurmap

clear all

%Load in solution from evalmodelmesh
object = matfile('bifur.mat'); 

Dsvals = object.Dsvals; 
tausvals = object.tausvals; 
tr = object.tr; %Assign color map 
map = [ 0 0 255/255         % blue

Tpoly = object.Tpoly; 

    255/255 153/255 0       % orange
    0 255/255 0             % green
    255/255 0 0             % red
    166/255 166/255 166/255];% gray

%Initialize solution matrix
remap = zeros(length(Dsvals),length(tausvals)); 

%Thresholds
eta_M = .5;     %Upper limit for slope of amplitudes for limit cycle
eta_m = -0.01;  %Lower threshold for slope of amplitudes for limit cycle
mu    = 0.9;    %Threshold for fit of regression line 

filteredpoints = 2; %Assign only every 2nd point in the mesh for space  

%Algorithm 1 in manuscript 
for i = 1:filteredpoints:length(tausvals)
   for j = 1:filteredpoints:length(Dsvals)
        Ts = object.keep(i,j,:); 
        
        %Assign individual T signal
        T = zeros(1,length(Ts)); 
        for ii = 1:length(Ts)
            T(ii) = Ts(1,1,ii); 
        end 

        %Find gradient of T
        gradT = gradient(T); 

        %Find oscillations only after reset time 
        gradT_tr2end = gradT(tr:end); 
        Tpoly_tr2end = Tpoly(tr:end);

        %Find where gradient crosses x-axis 
        z = []; 
        for ii = 1:length(gradT_tr2end)-1
            signs = gradT_tr2end(ii)*gradT_tr2end(ii+1); 
            if signs < 0 
                z = [z ii];
            end 
        end 

        %Only take points if distance between them is >= .1 sec
        x = find(abs(diff(Tpoly_tr2end(z))) >= 0.1); 

        %Find points in original signal 
        TT = T(tr+z(x)); 

        %Only keep points if difference between them is >= 0.01 sec
        x = find(abs(diff(TT)) >= 0.01); 

        %Find consecutive amplitudes of signal 
        y    = find(diff(TT(x)) > 0); 
        amps = TTxdiff(y);
        
        %Assign colors
        if isempty(amps) 
            remap(j,i) = -1; %Sink
        elseif length(amps) == 1
            remap(j,i) = -3; %Spiral in 
        else
            p = polyfit([1:length(amps)],amps,1); 
            y_amps = polyval(p,1:length(amps)); 
            yresid = amps - y_amps; 
            ssresid = sum(yresid.^2); 
            sstotal = (length(amps) - 1)*var(amps); 
            rsq = 1 - ssresid/sstotal; 
            if p(1) <= eta_M && p(1) >= eta_m
                %Ensure regression line fits well and there are more than 3
                %oscillations (otherwise it spirals in)
                if rsq > mu && length(amps) > 3 
                    remap(j,i) = -4; %Limit cycle
                else 
                    remap(j,i) = -3; %Spiral in
                end 
            elseif p(1) > eta_M
                remap(j,i) = -5; %Spiral out
            else
                remap(j,i) = -3; %Spiral in
            end 
        end 
        disp([i j])
   end 
end 


%Plot figure at filtered points
for i = 1:round(length(remap)/filteredpoints)
    x = find(remap(filteredpoints*(i-1)+1,:) ~=0);
    r(i,:) = remap(filteredpoints*(i-1)+1,x);
end

[X,Y] = meshgrid(tausvals(1:filteredpoints:end),Dsvals(1:filteredpoints:end));

figure(1)
clf
hold on
h = surf(X,Y,r); 
plot(0.1:0.01:10, (1/exp(1))*[0.1:0.01:10], 'r', 'linewidth', 3)
colormap(map)
xlim([0.1 10])
ylim([0.1 10])
view(2)
grid off
set(gca,'FontSize',16)
set(h,'EdgeColor','none')
xlabel('$\tau_s$','interpreter','latex')
ylabel('$D_s$','interpreter','latex')

