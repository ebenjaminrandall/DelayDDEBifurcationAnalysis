%Driver - make plots 

printon = 0; %To print figures, set printon = 1.

%% Plot control subject - sink 

load optHR_control.mat 

[HRopt,~,~,Outputs] = model_sol(pars_LM,data); 

time = Outputs(:,1); 
Ts_LM = Outputs(:,5); 

%Heart Rate 
hfig = figure(20); 
clf
plot(Tdata,Hdata,'b','linewidth',1)
hold on
plot(time,HRopt,'k','linewidth',1)
set(gca,'FontSize',20)
ylim([50 150])
ytick = 50:50:150;
set(gca,'YTick',ytick);
xtick = 0:20:120;
set(gca,'XTick',xtick);
ylabel('H (bpm)')
xlabel('Time (sec)')
xlim(Tlims1)

%Efferent Activity
hfig1 = figure(21);
clf
h2 = plot(time,Ts_LM,'k','linewidth',1);
set(gca,'FontSize',20)
xlim(Tlims1)
ylabel('Sympathetic')
xlabel('Time (sec)')
ylim([-.6 1.5])
xtick = 0:20:120;
set(gca,'XTick',xtick);
ytick = -.6:.2:1.5; 
set(gca,'YTick',ytick);

%Pressures
hfig2 = figure(22);
clf
h1 = plot(Tdata,Pdata,'b','linewidth',.5); 
hold on 
h2 = plot(Tnew1,SPnew1,'b','linewidth',1);
hold on 
%xlabel('Time (sec)')
%ylabel('BP (mmHg)')
xlim(Tlims1)
set(gca,'FontSize',20)
xtick = 0:20:120;
set(gca,'XTick',xtick);
ylim([40 220])
ytick = 50:50:220;
set(gca,'YTick',ytick);

if printon == 1
    print(hfig,'-depsc2',strcat('control_sink_HR.eps'))
    print(hfig1,'-depsc2',strcat('control_sink_Ts.eps'))
    print(hfig2,'-depsc2',strcat('control_sink_BP.eps'))
end

%Diplays taus and Ds values
disp([exp(pars_LM([8 19]))])

%% Plot control subject - stable focus 

clear all 

load optHR_SF.mat 

[HRopt,~,~,Outputs] = model_sol(pars_LM,data); 

time = Outputs(:,1); 
Ts_LM = Outputs(:,5); 

%Heart Rate
hfig = figure(26); 
clf
plot(Tdata,Hdata,'b','linewidth',1)
hold on
plot(time,HRopt,'k','linewidth',1)
set(gca,'FontSize',20)
ylim([50 150])
ytick = 50:50:150;
set(gca,'YTick',ytick);
xtick = 0:20:120;
set(gca,'XTick',xtick);
ylabel('H (bpm)')
xlabel('Time (sec)')
xlim(Tlims1)

%Efferent Activity
hfig1 = figure(27);
clf
h2 = plot(time,Ts_LM,'k','linewidth',1);
set(gca,'FontSize',20)
xlim(Tlims1)
ylabel('Sympathetic')
xlabel('Time (sec)')
ylim([-.6 1.5])
xtick = 0:20:120;
set(gca,'XTick',xtick);
ytick = -.6:.2:1.5; 
set(gca,'YTick',ytick);

%Pressures
hfig2 = figure(28);
clf
h1 = plot(Tdata,Pdata,'b','linewidth',.5); 
hold on 
h2 = plot(Tnew1,SPnew1,'b','linewidth',1);
hold on 
xlabel('Time (sec)')
ylabel('BP (mmHg)')
xlim(Tlims1)
set(gca,'FontSize',20)
xtick = 0:20:120;
set(gca,'XTick',xtick);
ylim([40 220])
ytick = 50:50:220;
set(gca,'YTick',ytick);

if printon == 1
    print(hfig,'-depsc2',strcat('control_SF_HR.eps'))
    print(hfig1,'-depsc2',strcat('control_SF_Ts.eps'))
    print(hfig2,'-depsc2',strcat('control_SF_BP.eps'))
end 

%Diplays taus and Ds values
disp([exp(pars_LM([8 19]))])


%% Plot POTS - stable focus 

clear all

load optHR_M.mat 

[HRopt,~,~,Outputs] = model_sol(pars_LM,data); 

time = Outputs(:,1); 
Ts_LM = Outputs(:,5); 

%Heart Rate
hfig = figure(23); 
clf
plot(Tdata,Hdata,'b','linewidth',1)
hold on
plot(time,HRopt,'k','linewidth',1)
set(gca,'FontSize',20)
ylim([50 150])
ytick = 50:50:150;
set(gca,'YTick',ytick);
xtick = 0:20:120;
set(gca,'XTick',xtick);
ylabel('H (bpm)')
xlabel('Time (sec)')
xlim([0 120])

%Efferent Activity
hfig1 = figure(24);
clf
h2 = plot(time,Ts_LM,'k','linewidth',1);
set(gca,'FontSize',20)
xlim([0 120])
ylabel('Sympathetic')
xlabel('Time (sec)')
ylim([-.6 1.5])
xtick = 0:20:120;
set(gca,'XTick',xtick);
ytick = -.6:.2:1.5; 
set(gca,'YTick',ytick);

%Pressures
hfig2 = figure(25);
clf
h1 = plot(Tdata,Pdata,'b','linewidth',.5); 
hold on 
h2 = plot(Tnew1,SPnew1,'b','linewidth',1);
hold on 
xlabel('Time (sec)')
ylabel('BP (mmHg)')
xlim([0 120])
set(gca,'FontSize',20)
xtick = 0:20:120;
set(gca,'XTick',xtick);
ylim([40 220])
ytick = 50:50:220;
set(gca,'YTick',ytick);

if printon == 1
    print(hfig,'-depsc2',strcat('M_SF_HR.eps'))
    print(hfig1,'-depsc2',strcat('M_SF_Ts.eps'))
    print(hfig2,'-depsc2',strcat('M_SF_BP.eps'))
end 

%Diplays taus and Ds values
disp([exp(pars_LM([8 19]))])
