clear all
close all

radius=18-1.5; % Radius of the center of the road
center_circle=radius*sqrt(2);
x=zeros(1,154);
y=zeros(1,154);

i=1;
for ang=pi/2+pi/4:-pi/50:-pi/2-pi/4;
    i=i+1;
    x(i)=radius*cos(ang)+(center_circle);
    y(i)=radius*sin(ang);
end

for ang=pi/2-pi/4:pi/50:pi+pi/2+pi/4;
    i=i+1;
    x(i)=radius*cos(ang)-(center_circle);
    y(i)=radius*sin(ang);
end
z=zeros(1,154);
plot3(x,y,z)
grid