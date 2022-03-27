% -------------------------------------------------------------------
% Main skript 
% by : Adam Ghribi
% -------------------------------------------------------------------
close all
clear all                                   
clc


%% init
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

% Step (1) or Wave (-1) 
StepOrWave = -1; 
% if step give [x y z]_des :
x = 1;
y = 1;
z = 1;
% if wave give Amplitude:
Am = 10;

if (StepOrWave<0)
    l=Am+1;
else
    l=max(x,y)+1;
end
%% Controller 
% Position Controller
Kp_x = 6.9;
Ki_x = 0;%3.16;
Kd_x = 15;%12.49;

Kp_y = 6.9;
Ki_y = 0;%3.16;
Kd_y = 15;%6.02;

Kp_z = 20;%18.7;
Ki_z = 10;
Kd_z = 8;%6.04;

% Attitude Controller
Kq_xy = 4;
Kq_z  = 3;

% Rate Controller
K_omega = 7*diag([3.38 3.44 3.33]);

%% LQR 
[A,B,C,D]=linmod('Model',zeros(12,1),[M*g0 0 0 0]');
% x = [x y z phi theta psi p q r u v w]'
% y = [x y z psi]'

% R = eye(4);
% Q = eye(12);
% M = sqrtm(Q);
% rank(crtb(A,B))=12 
% rank(obsv(A,M))=12
% Gain K 
% K = lqr(A,B,Q,R);
% H = inv((-(C-D*K)*inv((A-B*K))*B+D));
% erreur in z !=0 -> intgerator with xi

Aa=[A zeros(12,4); -C zeros(4,4)];
Ba=[B ; -D];
R = diag([0.01 0.1 0.1 0.1]);
Qa= diag([1 1 1 ones(1,13)]);
Ka=lqr(Aa,Ba,Qa,R);
K1=Ka(:,1:12);
Ki=-Ka(:,13:16);

% [AA,BB,CC,DD]=linmod('SiL');
% sys=ss(AA,BB,CC,DD);
% step(sys,20)
% grid


%%
out=sim('SiL.slx',100);
figure
plot3(out.pos_des.Data(:,1),out.pos_des.Data(:,2),out.pos_des.Data(:,3),'r--')
hold on
plot3(0,0,0,'*')
curve=animatedline();
set(gca,'XLim',[-l l],'YLim',[-l l],'ZLim',[-1 42])
view(43,24)
grid on 
for i=1:length(out.pos.Data(:,3))
    addpoints(curve,out.pos.Data(i,1),out.pos.Data(i,2),out.pos.Data(i,3));
    drawnow
end
%% 3D PLOT
figure
plot3(out.pos.Data(:,1),out.pos.Data(:,2),out.pos.Data(:,3),'--','LineWidth',1,'color','r')
set(gca,'XLim',[-l l],'YLim',[-l l],'ZLim',[-1 42])
view(43,24)
%%%
camproj perspective 
camva(0.5)

hlight = camlight('headlight'); 
lighting gouraud
set(gcf,'Renderer','OpenGL')
%%%

grid on
hold on
plot3(out.pos_des.Data(:,1),out.pos_des.Data(:,2),out.pos_des.Data(:,3),'LineWidth',0.5,'color','b')
xlabel('x')
ylabel('y')
zlabel('z')

load Quad_plotting_model
Quad.X_arm = patch('xdata',Quad.X_armX,'ydata',Quad.X_armY,'zdata',Quad.X_armZ,'facealpha',.9,'facecolor','b');
Quad.Y_arm = patch('xdata',Quad.Y_armX,'ydata',Quad.Y_armY,'zdata',Quad.Y_armZ,'facealpha',.9,'facecolor','b');
Quad.Motor1 = patch('xdata',Quad.Motor1X,'ydata',Quad.Motor1Y,'zdata',Quad.Motor1Z,'facealpha',.3,'facecolor','k');
Quad.Motor2 = patch('xdata',Quad.Motor2X,'ydata',Quad.Motor2Y,'zdata',Quad.Motor2Z,'facealpha',.3,'facecolor','k');
Quad.Motor3 = patch('xdata',Quad.Motor3X,'ydata',Quad.Motor3Y,'zdata',Quad.Motor3Z,'facealpha',.3,'facecolor','k');
Quad.Motor4 = patch('xdata',Quad.Motor4X,'ydata',Quad.Motor4Y,'zdata',Quad.Motor4Z,'facealpha',.3,'facecolor','k');


for S =1:length(out.pos.Data(:,3)) 
    
    Quad.X = out.pos.Data(S,1);
    Quad.Y = -out.pos.Data(S,2);
    Quad.Z = -out.pos.Data(S,3);
    Quad.phi = out.euler.Data(S,2);
    Quad.theta =- out.euler.Data(S,1);
    Quad.psi = -out.euler.Data(S,3);

[Quad.Xtemp,Quad.Ytemp,Quad.Ztemp]=rotateBFtoGF(Quad.X_armX,Quad.X_armY,Quad.X_armZ,Quad.phi,Quad.theta,Quad.psi);
set(Quad.X_arm,'xdata',Quad.Xtemp+Quad.X,'ydata',-(Quad.Ytemp+Quad.Y),'zdata',-(Quad.Ztemp+Quad.Z))

[Quad.Xtemp,Quad.Ytemp,Quad.Ztemp]=rotateBFtoGF(Quad.Y_armX,Quad.Y_armY,Quad.Y_armZ,Quad.phi,Quad.theta,Quad.psi);
set(Quad.Y_arm,'xdata',Quad.Xtemp+Quad.X,'ydata',-(Quad.Ytemp+Quad.Y),'zdata',-(Quad.Ztemp+Quad.Z))

[Quad.Xtemp,Quad.Ytemp,Quad.Ztemp]=rotateBFtoGF(Quad.Motor1X,Quad.Motor1Y,Quad.Motor1Z,Quad.phi,Quad.theta,Quad.psi);
set(Quad.Motor1,'xdata',Quad.Xtemp+Quad.X,'ydata',-(Quad.Ytemp+Quad.Y),'zdata',-(Quad.Ztemp+Quad.Z-2*Quad.t))

[Quad.Xtemp,Quad.Ytemp,Quad.Ztemp]=rotateBFtoGF(Quad.Motor2X,Quad.Motor2Y,Quad.Motor2Z,Quad.phi,Quad.theta,Quad.psi);
set(Quad.Motor2,'xdata',Quad.Xtemp+Quad.X,'ydata',-(Quad.Ytemp+Quad.Y),'zdata',-(Quad.Ztemp+Quad.Z-2*Quad.t))

[Quad.Xtemp,Quad.Ytemp,Quad.Ztemp]=rotateBFtoGF(Quad.Motor3X,Quad.Motor3Y,Quad.Motor3Z,Quad.phi,Quad.theta,Quad.psi);
set(Quad.Motor3,'xdata',Quad.Xtemp+Quad.X,'ydata',-(Quad.Ytemp+Quad.Y),'zdata',-(Quad.Ztemp+Quad.Z-2*Quad.t))

[Quad.Xtemp,Quad.Ytemp,Quad.Ztemp]=rotateBFtoGF(Quad.Motor4X,Quad.Motor4Y,Quad.Motor4Z,Quad.phi,Quad.theta,Quad.psi);
set(Quad.Motor4,'xdata',Quad.Xtemp+Quad.X,'ydata',-(Quad.Ytemp+Quad.Y),'zdata',-(Quad.Ztemp+Quad.Z-2*Quad.t))
       campos('auto')
        camtarget([Quad.X -Quad.Y -Quad.Z])
       camroll(0);
drawnow;
  
end


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






