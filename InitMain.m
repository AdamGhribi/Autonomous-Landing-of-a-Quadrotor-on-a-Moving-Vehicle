% -------------------------------------------------------------------
% Main skript 
% by : Adam Ghribi
% -------------------------------------------------------------------

close all
clear all                                   
clc

%% init
init 
%% Sim
out=sim('SiL.slx',inf);
%% 2D Plot
plotpoint

%% 3D PLOT
plotquad

%% Plots

figure
subplot(3,1,1)
plot(out.pos.Time,out.pos.Data(:,1))
grid on
hold on
plot(out.pos_des.Time,out.pos_des.Data(:,1))
xlabel('Time[s]','Interpreter','latex','Fontsize',16)
ylabel('$X$[m]','Interpreter','latex','Fontsize',16)
legend('X','$X_{des}$','Interpreter','latex','Fontsize',16,'Location','best')

subplot(3,1,2)
plot(out.pos.Time,out.pos.Data(:,2))
grid on
hold on
plot(out.pos_des.Time,out.pos_des.Data(:,2))
xlabel('Time[s]','Interpreter','latex','Fontsize',16)
ylabel('$Y$[m]','Interpreter','latex','Fontsize',16)
legend('Y','$Y_{des}$','Interpreter','latex','Fontsize',16,'Location','best')

subplot(3,1,3)
plot(out.pos.Time,out.pos.Data(:,3))
grid on
hold on
plot(out.pos_des.Time,out.pos_des.Data(:,3))
xlabel('Time[s]','Interpreter','latex','Fontsize',16)
ylabel('$Z$[m]','Interpreter','latex','Fontsize',16)
legend('Z','$Z_{des}$','Interpreter','latex','Fontsize',16,'Location','best')


