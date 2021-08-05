t=0:0.01:20;
x0=2;
alpha=0:0.01:2*pi;
x0=1;
x=x0+0.3*cos(alpha);
x01=7;
x1=x01-0.3*cos(alpha);
y0=1;
y=y0+cos(alpha);

h=6; % высота вертикальной направляющей
a=2; % параметры ползуна
l=4; % длина стержня
 
 
% Косметика окна
figure % принудительное создание окна
xlim([-1 10])
ylim([-2 10])
xlim manual
ylim manual
axis equal
hold on

% Вертикальные направляющие
plot([3 3], [0 h]);
plot([5 5], [0 h]);

% Ползун
SliderX=[3 3 5 5 3];
SliderY=[2 4 4 2 2];
Slider=plot(SliderX,SliderY+y(1));

% Стержень
xA=4;     %Координата x точки A
yA=h-1-y;     %Координата y точки A
xB=xA-l*sin(alpha);     %Координата x точки B
yB=yA-l*cos(alpha);     %Координата y точки B
PointA=plot(xA,yA(1),'o'); %условный схематичный центр
PointB=plot(xB(1),yB(1),'o','markersize',10,'markerFaceColor',[0 1 0]); %шарик
AB=plot([xA xB(1)],[yA(1)+2 yB(1)]);  %стержень

% Левая пружина
xO1=0;
yO1=6;
PointO1=plot(xO1,yO1,'o'); % левое крепление левой пружины
xC1 = x+0.5; 
yC1 = h-1-y+2;
PointC1=plot(xC1, yC1, 'o'); % первый верхний зубчик пружины
xC2 = xC1+0.25;
yC2 = yC1-2;
PointC2=plot(xC2, yC2, 'o'); % первый нижний зубчик пружины
xC3 = xC1+0.5;
yC3 = yC1;
PointC3=plot(xC3, yC3, 'o'); % второй верхний зубчик пружины  
xC4 = xC1+0.75;
yC4 = yC1-2;
PointC4=plot(xC4, yC4, 'o'); % второй нижний зубчик пружины  
xC5 = xC1+1;
yC5 = yC1;
PointC5=plot(xC5, yC5, 'o'); % третий верхний зубчик пружины
O1C1 = plot([xO1 xC1(1)],[yO1 yC1(1)]);
C1C2 = plot([xC1(1) xC2(1)],[yC1(1) yC2(1)]);
C2C3 = plot([xC2(1) xC3(1)],[yC2(1) yC3(1)]);
C3C4 = plot([xC3(1) xC4(1)],[yC3(1) yC4(1)]);
C4C5 = plot([xC4(1) xC5(1)],[yC4(1) yC5(1)]);
C5A = plot([xC5(1) xA(1)],[yC5(1) yA(1)]);

% Правая пружина
xO2=8;
yO2=6;
PointO2=plot(xO2,yO2,'o'); % правое крепление правой пружины
xD1 = x1-0.1; 
yD1 = h-1-y+2;
PointD1=plot(xC1, yC1, 'o'); % первый верхний зубчик пружины
xD2 = xD1-0.25; 
yD2 = yD1-2;
PointD2=plot(xD2, yD2, 'o'); % первый нижний зубчик пружины
xD3 = xD1-0.5; 
yD3 = yD1;
PointD3=plot(xD3, yD3, 'o'); % второй верхний зубчик пружины
xD4 = xD1-0.75; 
yD4 = yD1-2;
PointD4=plot(xD4, yD4, 'o'); % второй нижний зубчик пружины
xD5 = xD1-1; 
yD5 = yD1;
PointD5=plot(xD5, yD5, 'o'); % третий верхний зубчик пружины
O2D1 = plot([xO2 xD1(1)],[yO2 yD1(1)]);
D1D2 = plot([xD1(1) xD2(1)],[yD1(1) yD2(1)]);
D2D3 = plot([xD2(1) xD3(1)],[yD2(1) yD3(1)]);
D3D4 = plot([xD3(1) xD4(1)],[yD3(1) yD4(1)]);
D4D5 = plot([xD4(1) xD5(1)],[yD4(1) yD5(1)]);
D5A = plot([xD5(1) xA(1)],[yD5(1) yA(1)]);


%анимация
for i=1:length(t)
  anmSY=SliderY+y(i); 
  set(Slider,'Ydata',anmSY);     %анимация ползуна
  anmPntAy = yA+y(i);
  set(PointA,'Ydata',anmPntAy);
  anmABy1 = yA(i)+2*y(i)-2;
  anmABy2 = yB(i)+2*y(i)-2;
  set(PointB,'Xdata',xB(i)+2*x(i)-2,'Ydata',anmABy2);
  set(AB,'Xdata',[xA xB(i)+2*x(i)-2],'Ydata',[anmABy1 anmABy2]);     %анимация стержня
   
  %левая пружина 
  %переменные
  anmPntC1x = xC1(i)-2*x(i)+1.05; % первый верхний 
  anmPntC1y = yC1(i)+2*y(i)-1.15;
  anmPntC2x = xC2(i)-2*x(i)+1.35; % первый нижний 
  anmPntC2y = 0.5*yC2(i)+2*y(i)-1.15;   
  anmPntC3x = xC3(i)-2*x(i)+1.2; % второй верхний 
  anmPntC3y = yC3(i)+2*y(i)-1.15;  
  anmPntC4x = xC4(i)-2*x(i)+1.35; % второй нижний
  anmPntC4y = 0.5*yC4(i)+2*y(i)-1.15;  
  anmPntC5x = xC5(i)-2*x(i)+1.35; % третий верхний 
  anmPntC5y = yC5(i)+2*y(i)-1.15;  
  %движение точек
  set(PointC1,'Xdata',anmPntC1x,'Ydata',anmPntC1y);
  set(PointC2,'Xdata',anmPntC2x,'Ydata',anmPntC2y);
  set(PointC3,'Xdata',anmPntC3x,'Ydata',anmPntC3y);
  set(PointC4,'Xdata',anmPntC4x,'Ydata',anmPntC4y);
  set(PointC5,'Xdata',anmPntC5x,'Ydata',anmPntC5y);
  %движение витков пружины
  set(O1C1,'Xdata',[xO1 anmPntC1x],'Ydata',[yO1 anmPntC1y]);
  set(C1C2,'Xdata',[anmPntC1x anmPntC2x],'Ydata',[anmPntC1y anmPntC2y]);
  set(C2C3,'Xdata',[anmPntC2x anmPntC3x],'Ydata',[anmPntC2y anmPntC3y]);
  set(C3C4,'Xdata',[anmPntC3x anmPntC4x],'Ydata',[anmPntC3y anmPntC4y]);
  set(C4C5,'Xdata',[anmPntC4x anmPntC5x],'Ydata',[anmPntC4y anmPntC5y]);
  set(C5A,'Xdata',[anmPntC5x xA-1],'Ydata',[anmPntC5y anmPntAy]);
  
  %правая пружина
  anmPntD1x = xD1(i)+2*x(i)-1.5; % первый верхний 
  anmPntD1y = yD1(i)+2*y(i)-1.15;
  anmPntD2x = xD2(i)+2*x(i)-1.5; % первый нижний 
  anmPntD2y = 0.5*yD2(i)+2*y(i)-1.15;   
  anmPntD3x = xD3(i)+2*x(i)-1.5; % второй верхний 
  anmPntD3y = yD3(i)+2*y(i)-1.15;   
  anmPntD4x = xD4(i)+2*x(i)-1.5; % второй нижний 
  anmPntD4y = 0.5*yD4(i)+2*y(i)-1.15;   
  anmPntD5x = xD5(i)+2*x(i)-1.5; % третий верхний 
  anmPntD5y = yD5(i)+2*y(i)-1.15;   
  %движение точек
  set(PointD1,'Xdata',anmPntD1x,'Ydata',anmPntD1y);
  set(PointD2,'Xdata',anmPntD2x,'Ydata',anmPntD2y);
  set(PointD3,'Xdata',anmPntD3x,'Ydata',anmPntD3y);
  set(PointD4,'Xdata',anmPntD4x,'Ydata',anmPntD4y);
  set(PointD5,'Xdata',anmPntD5x,'Ydata',anmPntD5y);
  %движение витков пружины
  set(O2D1,'Xdata',[xO2 anmPntD1x],'Ydata',[yO2 anmPntD1y]);
  set(D1D2,'Xdata',[anmPntD1x anmPntD2x],'Ydata',[anmPntD1y anmPntD2y]);
  set(D2D3,'Xdata',[anmPntD2x anmPntD3x],'Ydata',[anmPntD2y anmPntD3y]);
  set(D3D4,'Xdata',[anmPntD3x anmPntD4x],'Ydata',[anmPntD3y anmPntD4y]);
  set(D4D5,'Xdata',[anmPntD4x anmPntD5x],'Ydata',[anmPntD4y anmPntD5y]);
  set(D5A,'Xdata',[anmPntD5x xA+1],'Ydata',[anmPntD5y anmPntAy]);
  
  pause(0.01);
end