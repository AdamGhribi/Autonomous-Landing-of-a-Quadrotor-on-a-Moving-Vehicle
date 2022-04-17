%% 3D Plot 
% by : WILLIAM SELBY
% https://www.wilselby.com/research/arducopter/modeling/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
plot3(out.pos.Data(:,1),out.pos.Data(:,2),out.pos.Data(:,3),'--','LineWidth',1,'color','r')
set(gca,'XLim',[-2 55],'YLim',[-20 20],'ZLim',[0 20])
view(43,24)
%%%
%camproj perspctive 
camva(2.5)

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
        camtarget([0 0 0])%[Quad.X -Quad.Y -Quad.Z])
       camroll(0);
drawnow;
  
end