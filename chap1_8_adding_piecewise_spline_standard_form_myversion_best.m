clear all
DO_SUBPLOT = 1 %if set to 1, only plots the full curves graph
               %if set to 2, only plots the partial curves graph
               %if set to 3, plots both graphs

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

%plotting full initial piecewise curves
if DO_SUBPLOT == 3 %if set to 1, only plots the full curves graph
                   %if set to 2, only plots the partial curves graph
                   %if set to 3, plots both graphs
    subplot(121)
end

xx_lim = [p1(1,1) - 1 p8(1,1) + 1]
xx_all = linspace(xx_lim(1,1),xx_lim(1,2));

if DO_SUBPLOT ~= 2 %if set to 1, only plots the full curves graph
                   %if set to 2, only plots the partial curves graph
                   %if set to 3, plots both graphs



clear yy_A
clear yy_B
clear yy_C

yy_A = subs(y_A, x, xx_all);
plot(xx_all, yy_A, 'b');
hold on
yy_B = subs(y_B, x, xx_all);
plot(xx_all, yy_B, 'r');
yy_C = subs(y_C, x, xx_all);
plot(xx_all, yy_C, 'm');

scatter(Pn(:,1),Pn(:,2),50,'filled')
text(Pn(1,1)+0.1, Pn(1,2)-0.1, 'P_1');
text(Pn(2,1)+0.1, Pn(2,2)-0.1, 'P_2');
text(Pn(3,1)+0.1, Pn(3,2)-0.1, 'P_3');
text(Pn(4,1)+0.1, Pn(4,2)-0.1, 'P_4');

xlabel('x')
ylabel('y')
title(["Piecewise spline + 1" "standard form -" "full curves"])

set(gca,'ylim',[-5 10],'xlim',[xx_lim(1,1) xx_lim(1,2)],'xtick',xx_lim(1,1):xx_lim(1,2),'ytick',-5:10)
opt.fontname = 'helvetica';
opt.fontsize = 8;

centeraxes(gca,opt);
end

%plotting partial initial piecewise curves
if DO_SUBPLOT == 3
    subplot(122)
end

clear yy_A
clear yy_B
clear yy_C

xx_lim_A = [Pn(1,1) - 1 Pn(2,1)]
xx_A = linspace(xx_lim(1,1),xx_lim_A(1,2));
yy_A = subs(y_A, x, xx_A);
plot(xx_A, yy_A, 'b');

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

%plotting full added piecewise curves
if DO_SUBPLOT == 3
    subplot(121)
end

if DO_SUBPLOT ~= 2 %if set to 1, only plots the full curves graph
                   %if set to 2, only plots the partial curves graph
                   %if set to 3, plots both graphs

clear yy_D
clear yy_E
clear yy_F

yy_D = subs(y_D, x, xx_all);
plot(xx_all, yy_D, 'k');
yy_E = subs(y_E, x, xx_all);
plot(xx_all, yy_E, 'r');
yy_F = subs(y_F, x, xx_all);
plot(xx_all, yy_F, 'g');

scatter(Pn(:,1),Pn(:,2),50,'filled')
text(Pn(1,1)-0.3, Pn(1,2)-0.3, 'P_5');
text(Pn(2,1)+0.1, Pn(2,2)-0.1, 'P_6');
text(Pn(3,1)+0.1, Pn(3,2)-0.1, 'P_7');
text(Pn(4,1)+0.1, Pn(4,2)-0.1, 'P_8');
end

%plotting partial added piecewise curves
if DO_SUBPLOT == 3
    subplot(122)
end

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
