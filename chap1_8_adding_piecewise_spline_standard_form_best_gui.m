clear all

p1 = [0 1]
p2 = [2 2]
p3 = [5 0]
p4 = [8 0]
P_1_4 = [p1;p2;p3;p4]
Pn = P_1_4

%added piecewise spline points. Must be located here so plot x axis limit
%can account for p8 x value !
p5 = [8 0]
p6 = [9 -1]
p7 = [10 3]
p8 = [11 2]
P_5_8 = [p5;p6;p7;p8]

C = [Pn(1,1)^3 Pn(1,1)^2 Pn(1,1) 1 0 0 0 0 0 0 0 0;
     Pn(2,1)^3 Pn(2,1)^2 Pn(2,1) 1 0 0 0 0 0 0 0 0;
     0 0 0 0 Pn(2,1)^3 Pn(2,1)^2 Pn(2,1) 1 0 0 0 0;
     0 0 0 0 Pn(3,1)^3 Pn(3,1)^2 Pn(3,1) 1 0 0 0 0;
     0 0 0 0 0 0 0 0 Pn(3,1)^3 Pn(3,1)^2 Pn(3,1) 1;
     0 0 0 0 0 0 0 0 Pn(4,1)^3 Pn(4,1)^2 Pn(4,1) 1;
     -3 * Pn(2,1)^2 -2 * Pn(2,1) -1 0 3 * Pn(2,1)^2 2 * Pn(2,1) 1 0 0 0 0 0;
     0 0 0 0 -3 * Pn(3,1)^2 -2 * Pn(3,1) -1 0 3 * Pn(3,1)^2 2 * Pn(3,1) 1 0;
     -6 * Pn(2,1) -2 0 0 6 * Pn(2,1) 2 0 0 0 0 0 0;
     0 0 0 0 -6 * Pn(3,1) -2 0 0 6 * Pn(3,1) 2 0 0;
     3 * Pn(1,1)^2 2 * Pn(1,1) 1 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 3 * Pn(4,1)^2 2 * Pn(4,1) 1 0]
C_i = inv(C)

Y = [Pn(1,2);
    Pn(2,2);
    Pn(2,2);
    Pn(3,2);
    Pn(3,2);
    Pn(4,2);
    0;
    0;
    0;
    0;
    4;
    -2]

A = C_i * Y

syms x
y_A = A(1,1) * x^3 + A(2,1) * x^2 + A(3,1) * x + A(4,1);
y_B = A(5,1) * x^3 + A(6,1) * x^2 + A(7,1) * x + A(8,1);
y_C = A(9,1) * x^3 + A(10,1) * x^2 + A(11,1) * x + A(12,1);

fprintf("y_A")
vpa(y_A)
fprintf("y_B")
vpa(y_B)
fprintf("y_C")
vpa(y_C)

%plotting
close all
figure

xx_lim = [p1(1,1) - 1 p8(1,1) + 1]
xx_all = linspace(xx_lim(1,1),xx_lim(1,2));

%plotting partial initial piecewise curves

clear yy_A
clear yy_B
clear yy_C

xx_lim_A = [Pn(1,1) - 1 Pn(2,1)]
xx_A = linspace(xx_lim(1,1),xx_lim_A(1,2));
yy_A = subs(y_A, x, xx_A);
hplot = plot(xx_A, yy_A, 'b');

hold on
xx_lim_B = [Pn(2,1) Pn(3,1)]
xx_B = linspace(xx_lim_B(1,1),xx_lim_B(1,2));
yy_B = subs(y_B, x, xx_B);
plot(xx_B, yy_B, 'r');

xx_lim_C = [Pn(3,1) Pn(4,1)]
xx_C = linspace(xx_lim_C(1,1),xx_lim_C(1,2));
yy_C = subs(y_C, x, xx_C);
plot(xx_C, yy_C, 'm');

scatter(Pn(:,1),Pn(:,2),50,'filled')
text(Pn(1,1)+0.1, Pn(1,2)-0.1, 'P_1');
text(Pn(2,1)+0.1, Pn(2,2)-0.1, 'P_2');
text(Pn(3,1)+0.1, Pn(3,2)-0.1, 'P_3');
text(Pn(4,1)+0.1, Pn(4,2)-0.1, 'P_4');

xlabel('x')
ylabel('y')
title(["Piecewise spline + 1" "standard form - " "partial curves"])

set(gca,'ylim',[-5 10],'xlim',[xx_lim(1,1) xx_lim(1,2)],'xtick',xx_lim(1,1):xx_lim(1,2),'ytick',-5:10)
opt.fontname = 'helvetica';
opt.fontsize = 8;

centeraxes(gca,opt);

%adding new 4 points piecewise spline
clear Pn, C, C_i, Y, A
Pn = P_5_8
C = [Pn(1,1)^3 Pn(1,1)^2 Pn(1,1) 1 0 0 0 0 0 0 0 0;
     Pn(2,1)^3 Pn(2,1)^2 Pn(2,1) 1 0 0 0 0 0 0 0 0;
     0 0 0 0 Pn(2,1)^3 Pn(2,1)^2 Pn(2,1) 1 0 0 0 0;
     0 0 0 0 Pn(3,1)^3 Pn(3,1)^2 Pn(3,1) 1 0 0 0 0;
     0 0 0 0 0 0 0 0 Pn(3,1)^3 Pn(3,1)^2 Pn(3,1) 1;
     0 0 0 0 0 0 0 0 Pn(4,1)^3 Pn(4,1)^2 Pn(4,1) 1;
     -3 * Pn(2,1)^2 -2 * Pn(2,1) -1 0 3 * Pn(2,1)^2 2 * Pn(2,1) 1 0 0 0 0 0;
     0 0 0 0 -3 * Pn(3,1)^2 -2 * Pn(3,1) -1 0 3 * Pn(3,1)^2 2 * Pn(3,1) 1 0;
     -6 * Pn(2,1) -2 0 0 6 * Pn(2,1) 2 0 0 0 0 0 0;
     0 0 0 0 -6 * Pn(3,1) -2 0 0 6 * Pn(3,1) 2 0 0;
     3 * Pn(1,1)^2 2 * Pn(1,1) 1 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 3 * Pn(4,1)^2 2 * Pn(4,1) 1 0]
C_i = inv(C)

Y = [Pn(1,2);
    Pn(2,2);
    Pn(2,2);
    Pn(3,2);
    Pn(3,2);
    Pn(4,2);
    0;
    0;
    0;
    0;
    -2;
    0]

A = C_i * Y

syms x
y_D = A(1,1) * x^3 + A(2,1) * x^2 + A(3,1) * x + A(4,1);
y_E = A(5,1) * x^3 + A(6,1) * x^2 + A(7,1) * x + A(8,1);
y_F = A(9,1) * x^3 + A(10,1) * x^2 + A(11,1) * x + A(12,1);

fprintf("y_D")
vpa(y_D)
fprintf("y_E")
vpa(y_E)
fprintf("y_F")
vpa(y_F)

%plotting partial added piecewise curves

clear yy_D
clear yy_E
clear yy_F

xx_lim_D = [Pn(1,1) Pn(2,1)]
xx_D = linspace(xx_lim_D(1,1),xx_lim_D(1,2));
yy_D = subs(y_D, x, xx_D);
plot(xx_D, yy_D, 'k');

hold on
xx_lim_E = [Pn(2,1) Pn(3,1)]
xx_E = linspace(xx_lim_E(1,1),xx_lim_E(1,2));
yy_E = subs(y_E, x, xx_E);
plot(xx_E, yy_E, 'r');

xx_lim_F = [Pn(3,1) Pn(4,1) + 1]
xx_F = linspace(xx_lim_F(1,1),xx_lim_F(1,2));
yy_F = subs(y_F, x, xx_F);
plot(xx_F, yy_F, 'g');

scatter(Pn(:,1),Pn(:,2),50,'filled')
text(Pn(1,1)-0.3, Pn(1,2)-0.3, 'P_5');
text(Pn(2,1)+0.1, Pn(2,2)-0.1, 'P_6');
text(Pn(3,1)+0.1, Pn(3,2)-0.1, 'P_7');
text(Pn(4,1)+0.1, Pn(4,2)-0.1, 'P_8');

SLIDER_POS_X = 150
MENU_POS_X = 70

xMin = -10
xMax = 10
yMin = -10
yMax = 10

global line

line{1} = [-8 5] % 2 points x coordinates
line{2} = [-4 7] % 2 points y coordinates
line{3} = 'p1'   % initial value of menu 
    
xSlider = uicontrol('style','slider','units','pixel','position',[SLIDER_POS_X 20 300 20],...
    'sliderstep',[1/(xMax-xMin), 2/(xMax-xMin)],'max',xMax,'min',xMin, 'value',line{1}(1,1));
addlistener(xSlider,'ContinuousValueChange',@(hObject, event) sliderPlot_x(hObject, event,hplot));
line{4} = xSlider % required so that menu selection can update slider values
uicontrol('style','text',...
    'position',[SLIDER_POS_X - 10 30 10 10],'string', 'X');

% slider controlling y coordinates
ySlider = uicontrol('style','slider','units','pixel','position',[SLIDER_POS_X 0 300 20],...
    'sliderstep',[1/(xMax-xMin), 2/(xMax-xMin)],'max',xMax,'min',xMin, 'value',line{2}(1,1));
line{5} = ySlider
addlistener(ySlider,'ContinuousValueChange',@(hObject, event) sliderPlot_y(hObject, event,hplot));
uicontrol('style','text',...
    'position',[SLIDER_POS_X - 10 10 10 10],'string', 'Y');

% drop down menu to select which point is modified by the sliders 
menu = uicontrol('Style','popupmenu',...
    'position', [MENU_POS_X 20 60 20], 'string', {'p1','p2'});
menu.Callback = @menuSelection;

% callback functions

function sliderPlot_x(hObject,event,hplot)
    global line
    n = get(hObject,'Value')
    
    if line{3} == 'p1'
        line{1}(1,1) = n
    else
        line{1}(1,2) = n
    end
    
    set(hplot,'xdata',line{1});
    drawnow;
end

function sliderPlot_y(hObject,event,hplot)
    global line
    n = get(hObject,'Value')
    
    if line{3} == 'p1'
        line{2}(1,1) = n
    else
        line{2}(1,2) = n
    end
    
    set(hplot,'ydata',line{2});
    drawnow;
end

function menuSelection(hObject,event)
    global line
    
    val = get(hObject,'Value');
    str = get(hObject,'String');
    line{3} = str{val};
    xSlider = line{4};
    ySlider = line{5};

    if line{3} == 'p1'
        xSlider.Value = line{1}(1,1);
        ySlider.Value = line{2}(1,1);
    else
        xSlider.Value = line{1}(1,2);
        ySlider.Value = line{2}(1,2);
    end
end
