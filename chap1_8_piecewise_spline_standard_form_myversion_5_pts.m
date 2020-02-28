clear aqll;
DO_SUBPLOT = 2 % if set to 0, only plots the full curve graph
               % if set to 1, plots the full curve graph and the partial curve graph
               % if set to 2, only plots the partial curve graph
ADDITIONAL_X_AXIS_SIZE = 3
LINE_SPACE_NUMBER = 500
END_SPLINE = 2

p1 = [0 1]
p2 = [2 2]
p3 = [5 0]
p4 = [8 0]
p5 = [11 0]
Pn = [p1;p2;p3;p4;p5]
C = [p1(1,1)^3 p1(1,1)^2 p1(1,1) 1 0 0 0 0 0 0 0 0 0 0 0 0;
     p2(1,1)^3 p2(1,1)^2 p2(1,1) 1 0 0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 p2(1,1)^3 p2(1,1)^2 p2(1,1) 1 0 0 0 0 0 0 0 0;
     0 0 0 0 p3(1,1)^3 p3(1,1)^2 p3(1,1) 1 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 p3(1,1)^3 p3(1,1)^2 p3(1,1) 1 0 0 0 0;
     0 0 0 0 0 0 0 0 p4(1,1)^3 p4(1,1)^2 p4(1,1) 1 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 p4(1,1)^3 p4(1,1)^2 p4(1,1) 1;
     0 0 0 0 0 0 0 0 0 0 0 0 p5(1,1)^3 p5(1,1)^2 p5(1,1) 1;
     -3 * p2(1,1)^2 -2 * p2(1,1) -1 0 3 * p2(1,1)^2 2 * p2(1,1) 1 0 0 0 0 0 0 0 0 0;
     0 0 0 0 -3 * p3(1,1)^2 -2 * p3(1,1) -1 0 3 * p3(1,1)^2 2 * p3(1,1) 1 0 0 0 0 0;
     0 0 0 0 0 0 0 0 -3 * p4(1,1)^2 -2 * p4(1,1) -1 0 3 * p4(1,1)^2 2 * p4(1,1) 1 0;
     -6 * p2(1,1) -2 0 0 6 * p2(1,1) 2 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 -6 * p3(1,1) -2 0 0 6 * p3(1,1) 2 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 -6 * p4(1,1) -2 0 0 6 * p4(1,1) 2 0 0;
     3 * p1(1,1)^2 2 * p1(1,1) 1 0 0 0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 3 * p5(1,1)^2 2 * p5(1,1) 1 0];
fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', C.')
C_i = inv(C)

Y = [p1(1,2);
    p2(1,2);
    p2(1,2);
    p3(1,2);
    p3(1,2);
    p4(1,2);
    p4(1,2);
    p5(1,2);
    0;
    0;
    0;
    0;
    0;
    0;
    4;
    END_SPLINE]

A = C_i * Y

syms x
y_a = A(1,1) * x^3 + A(2,1) * x^2 + A(3,1) * x + A(4,1);
y_b = A(5,1) * x^3 + A(6,1) * x^2 + A(7,1) * x + A(8,1);
y_c = A(9,1) * x^3 + A(10,1) * x^2 + A(11,1) * x + A(12,1);
y_d = A(13,1) * x^3 + A(14,1) * x^2 + A(15,1) * x + A(16,1);

vpa(y_a)
vpa(y_b)
vpa(y_c)
vpa(y_d)

%plotting
close all
figure

%plotting full piecewise curves

if DO_SUBPLOT == 1
    subplot(121);
end

xx_lim = [p1(1,1) - 1 p5(1,1)]
xx_all = linspace(xx_lim(1,1),xx_lim(1,2),LINE_SPACE_NUMBER);
yy_a = subs(y_a, x, xx_all);

if DO_SUBPLOT ~= 2
    plot(xx_all, yy_a, 'b')

    hold on
end

yy_b = subs(y_b, x, xx_all);
plot(xx_all, yy_b, 'r')
yy_c = subs(y_c, x, xx_all);
plot(xx_all, yy_c, 'm')
yy_d = subs(y_d, x, xx_all);
plot(xx_all, yy_d, 'g')

scatter(Pn(:,1),Pn(:,2),50,'filled')
text(p1(1,1)+0.1, p1(1,2)-0.1, 'P_1');
text(p2(1,1)+0.1, p2(1,2)-0.1, 'P_2');
text(p3(1,1)+0.1, p3(1,2)-0.1, 'P_3');
text(p4(1,1)+0.1, p4(1,2)-0.1, 'P_4');
text(p5(1,1)+0.1, p5(1,2)-0.1, 'P_5');

xlabel('x')
ylabel('y')
title(["Piecewise spline" "5 points version" "standard form -" "full curves"])

set(gca,'ylim',[-5 10],'xlim',[xx_lim(1,1) xx_lim(1,2)],'xtick',xx_lim(1,1):xx_lim(1,2),'ytick',-5:10)
opt.fontname = 'helvetica';
opt.fontsize = 8;

centeraxes(gca,opt);

%plotting partial piecewise curves

if DO_SUBPLOT == 1
    subplot(122)
elseif DO_SUBPLOT ~= 2
    return
end

clear yy_a, yy_b, yy_c, yy_d
xx_lim = [p1(1,1) - 1 p5(1,1) + ADDITIONAL_X_AXIS_SIZE]
xx_lim_a = [p1(1,1) - 1 p2(1,1)]

xx_a = linspace(xx_lim(1,1),xx_lim_a(1,2),LINE_SPACE_NUMBER);
yy_a = subs(y_a, x, xx_a);
plot(xx_a, yy_a, 'b')
hold on
xx_lim_b = [p2(1,1) p3(1,1)]
xx_b = linspace(xx_lim_b(1,1),xx_lim_b(1,2),LINE_SPACE_NUMBER);
yy_b = subs(y_b, x, xx_b);
plot(xx_b, yy_b, 'r')
xx_lim_c = [p3(1,1) p4(1,1)]
xx_c = linspace(xx_lim_c(1,1),xx_lim_c(1,2),LINE_SPACE_NUMBER);
yy_c = subs(y_c, x, xx_c);
plot(xx_c, yy_c, 'm')
xx_lim_d = [p4(1,1) p5(1,1)]
xx_d = linspace(xx_lim_d(1,1),xx_lim_d(1,2),LINE_SPACE_NUMBER);
yy_d = subs(y_d, x, xx_d);
plot(xx_d, yy_d, 'g')

scatter(Pn(:,1),Pn(:,2),50,'filled')
text(p1(1,1)+0.1, p1(1,2)-0.1, 'P_1');
text(p2(1,1)+0.1, p2(1,2)-0.1, 'P_2');
text(p3(1,1)+0.1, p3(1,2)-0.1, 'P_3');
text(p4(1,1)+0.1, p4(1,2)-0.1, 'P_4');
text(p5(1,1)+0.1, p5(1,2)-0.1, 'P_5');

xlabel('x')
ylabel('y')
title(["Piecewise spline" "5 points version" "standard form - " "partial curves"])

set(gca,'ylim',[-5 10],'xlim',[xx_lim(1,1) xx_lim(1,2)],'xtick',xx_lim(1,1):xx_lim(1,2),'ytick',-5:10)
opt.fontname = 'helvetica';
opt.fontsize = 8;

centeraxes(gca,opt);