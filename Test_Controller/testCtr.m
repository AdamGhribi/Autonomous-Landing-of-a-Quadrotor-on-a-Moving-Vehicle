%% LQR - Quad-Controller
[A,B,C,D]=linmod('Model',[x0';zeros(9,1)],[M*g0 0 0 0]');
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
R = diag([0.1 0.1 0.1 0.1]);
Qa= diag([1 1 1 0.1*ones(1,3) 0.0001*ones(1,3) 0.1*ones(1,3) 1500 1500 1500 1500]);
Ka=lqr(Aa,Ba,Qa,R);
K1=Ka(:,1:12);
Ki=-Ka(:,13:16);


[AA,BB,CC,DD]=linmod('ModelCL');
sys=ss(AA,BB,CC,DD);


%%
figure
subplot(4,1,1)
step(sys(1,1),5)
grid on
hold on
xlabel('Time','Interpreter','latex')
ylabel('$x$[m]','Interpreter','latex')
%legend('X','$X_{des}$','Interpreter','latex','Fontsize',16,'Location','best')
title('Step response in x','Interpreter','latex')

subplot(4,1,2)
step(sys(2,2),5)
grid on
hold on
xlabel('Time','Interpreter','latex')
ylabel('$y$[m]','Interpreter','latex')
title('Step response in y','Interpreter','latex')

subplot(4,1,3)
step(sys(3,3),5)
grid on
hold on
xlabel('Time','Interpreter','latex')
ylabel('$z$[m]','Interpreter','latex')
title('Step response in z','Interpreter','latex')

subplot(4,1,4)
step(sys(4,4),5)
grid on
hold on
xlabel('Time','Interpreter','latex')
ylabel('$\psi$ [Deg]','Interpreter','latex')
title('Step response in $\psi$','Interpreter','latex')