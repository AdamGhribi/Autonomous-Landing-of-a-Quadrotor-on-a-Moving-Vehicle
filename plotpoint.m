%% Plot - point
figure
plot3(out.pos_des.Data(:,1),out.pos_des.Data(:,2),out.pos_des.Data(:,3),'r--')
hold on
plot3(x0(1),x0(2),x0(3),'*')
curve=animatedline();
gv = animatedline('Color','b');
set(gca,'XLim',[-2 50],'YLim',[-3 3],'ZLim',[-1 10])
view(43,24)
grid on 
for i=1:min(length(out.pos.Data(:,3)),length(out.pos_GV.Data(:,1)))
    addpoints(curve,out.pos.Data(i,1),out.pos.Data(i,2),out.pos.Data(i,3));
    addpoints(gv,out.pos_GV.Data(i,1),out.pos_GV.Data(i,2),out.pos_GV.Data(i,3));
    drawnow
end