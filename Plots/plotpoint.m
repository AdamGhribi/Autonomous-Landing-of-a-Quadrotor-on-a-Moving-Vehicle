%% Plot - point
% 
%
%%%%%%%%%%%%%%%%%%%%%
%%
% figure
% plot3(out.pos_des.Data(:,1),out.pos_des.Data(:,2),out.pos_des.Data(:,3),'r--')
% hold on
% xlabel('x')
% ylabel('y')
% zlabel('z')
% plot3(x0(1),x0(2),x0(3),'*')
% curve=animatedline();
% gv = animatedline('Color','b');
% set(gca,'XLim',[-2 50],'YLim',[-3 3],'ZLim',[-1 10])
% view(43,24)
% grid on 
% for i=1:min(length(out.pos.Data(:,3)),length(out.pos_GV.Data(:,1)))
%     addpoints(gv,out.pos_GV.Data(i,1),out.pos_GV.Data(i,2),out.pos_GV.Data(i,3));
%     addpoints(curve,out.pos.Data(i,1),out.pos.Data(i,2),out.pos.Data(i,3));
%     drawnow
% end
%%
figure
plot3(out.pos.Data(:,1),out.pos.Data(:,2),out.pos.Data(:,3),'LineWidth',2)
grid on
hold on
plot3(out.pos_GV.Data(:,1),out.pos_GV.Data(:,2),out.pos_GV.Data(:,3),'LineWidth',2);
set(gca,'XLim',[-0.5 45],'YLim',[-20.5 1],'ZLim',[-1 5])
xlabel('x[m]','Interpreter','latex')
ylabel('y[m]','Interpreter','latex')
zlabel('z[m]','Interpreter','latex')
legend('MAV','GV')
view(-45,45)
title('Landing trajectory')
%% Plots
figure
subplot(3,1,1)
plot(out.pos.Time,out.pos.Data(:,1),'LineWidth',2)
hold on
plot(out.pos_GV.Time,out.pos_GV.Data(:,1),'LineWidth',2)
grid on
legend('$X_{MAV}$','$X_{GV}$','Interpreter','latex','Location','best')
xlabel('Time[s]','Interpreter','latex')
ylabel('$X$[m]','Interpreter','latex')
set(gca,'XLim',[0 20])
subplot(3,1,2)
plot(out.pos.Time,out.pos.Data(:,2),'LineWidth',2)
hold on
plot(out.pos_GV.Time,out.pos_GV.Data(:,2),'LineWidth',2)
grid on
legend('$Y_{MAV}$','$Y_{GV}$','Interpreter','latex','Location','best')
xlabel('Time[s]','Interpreter','latex')
ylabel('$Y$[m]','Interpreter','latex')
set(gca,'XLim',[0 20])

subplot(3,1,3)
plot(out.pos.Time,out.pos.Data(:,3),'LineWidth',2)
hold on
plot(out.pos_GV.Time,out.pos_GV.Data(:,3),'LineWidth',2)
grid on
legend('$Z_{MAV}$','$Z_{GV}$','Interpreter','latex','Location','best')
xlabel('Time[s]','Interpreter','latex')
ylabel('$Z$[m]','Interpreter','latex')
set(gca,'XLim',[0 20])