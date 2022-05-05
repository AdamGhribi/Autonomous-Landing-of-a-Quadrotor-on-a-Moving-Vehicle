% -------------------------------------------------------------------
% Main skript 
% by : Adam Ghribi
% -------------------------------------------------------------------

close all
clear all                                   
clc

addpath('C:\Users\Adam\OneDrive\Desktop\M.Sc_LRT\4.sem\session2\Stage\sim\Scenarios')
addpath('C:\Users\Adam\OneDrive\Desktop\M.Sc_LRT\4.sem\session2\Stage\sim\Plots')
addpath('C:\Users\Adam\OneDrive\Desktop\M.Sc_LRT\4.sem\session2\Stage\sim\Test_Controller')
addpath('C:\Users\Adam\OneDrive\Desktop\M.Sc_LRT\4.sem\session2\Stage\sim\Test_Guidance')

%% init Quad
wait = 5;
x0= [0 0 0];
kt = 6.7e-6; % Thrust coefficient [-]
kd = 3.12e-7; % Drag torque constant [-]
CD = diag([0.16 0.32 1.1e-6]); % Drag coefficient 3x3 (Cdx Cdy Cdz) [-]
Ib = diag([0.035 0.046 0.0977]); % Quadrotor moment of inertia 3x3 [kg.m2]
Ir = 0.044; % rotor moment of inertia [kg.m2]
M  = 1.5 ; % total mass of quadrotor [kg]
L  = 0.215 ; % length of arm
g0 = 9.81; % gravity [m/s2]
% u = All*w^2 : 
All=[kt kt kt kt; 0 0 -L*kt L*kt; L*kt -L*kt 0 0; kd  kd  -kd  -kd];

%% LQR - Quad-Controller
[A,B,C,D]=linmod('Model',[x0';zeros(9,1)],[M*g0 0 0 0]');

Aa=[A zeros(12,4); -C zeros(4,4)];
Ba=[B ; -D];
R = diag([0.1 0.1 0.1 0.1]);
Qa= diag([1 1 1 0.1*ones(1,3) 0.0001*ones(1,3) 0.1*ones(1,3) 1500 1500 1500 1500]);
Ka=lqr(Aa,Ba,Qa,R);
K1=Ka(:,1:12);
Ki=-Ka(:,13:16);

%% create MPC controller object with sample time
% plant
dt=0.01;
A_mpc=blkdiag([1 dt 0;0 1 dt;0 0 1],[1 dt 0;0 1 dt;0 0 1],[1 dt 0;0 1 dt;0 0 1]);
B_mpc=zeros(9,3);
B_mpc(3,1)=dt;
B_mpc(6,2)=dt;
B_mpc(9,3)=dt;
D_mpc=zeros(9,3);
C_mpc=[1 zeros(1,8);0 0 0 1 zeros(1,5); zeros(1,6) 1 0 0;
        0 1 zeros(1,7); zeros(1,4) 1 zeros(1,4); zeros(1,7)  1 0;
         0 0 1 zeros(1,6); zeros(1,5) 1 zeros(1,3); zeros(1,8) 1];
%mpc
load('mpc1_plant.mat')
mpc1 = mpc(mpc1_plant_C, 0.01);
%specify prediction horizon
mpc1.PredictionHorizon = 10;
%specify control horizon
mpc1.ControlHorizon = 2;
%specify nominal values for inputs and outputs
mpc1.Model.Nominal.U = [0;0;0];
mpc1.Model.Nominal.Y = [0;0;5;0;0;0;0;0;0];
%specify constraints for OV
mpc1.OV(3).Min = 0;
%specify weights
mpc1.Weights.MV = [0 0 0];
mpc1.Weights.MVRate = [0.05 0.05 0.05];
mpc1.Weights.OV = [10 10 10 2 2 2 0.1 0.1 0.1];
mpc1.Weights.ECR = 100000;
%specify simulation options
options = mpcsimopt();
options.RefLookAhead = 'off';
options.MDLookAhead = 'off';
options.Constraints = 'on';
options.OpenLoop = 'off';
%% Sim
out=sim('SiL.slx',inf);

%% 3D animated PLOT
plotquad
