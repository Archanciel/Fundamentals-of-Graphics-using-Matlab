DO_SUBPLOT = 0 %if set to 0, only plots the full curve graph

p1 = [0 1]
p2 = [2 2]
p3 = [5 0]
p4 = [8 0]
Pn = [p1;p2;p3;p4]

%added cubic spline
pa = [8 0]
pb = [9 -1]
pc = [10 3]
pd = [11 2]
PD = [pa;pb;pc;pd]

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
y_a = A(1,1) * x^3 + A(2,1) * x^2 + A(3,1) * x + A(4,1);
y_b = A(5,1) * x^3 + A(6,1) * x^2 + A(7,1) * x + A(8,1);
y_c = A(9,1) * x^3 + A(10,1) * x^2 + A(11,1) * x + A(12,1);

vpa(y_a)
vpa(y_b)
vpa(y_c)

%plotting
close all
figure

%plotting full piecewise curves
if DO_SUBPLOT == 1
    subplot(121)
end
xx_lim = [p1(1,1) - 1 pd(1,1) + 1]
xx_all = linspace(xx_lim(1,1),xx_lim(1,2));
yy_a = subs(y_a, x, xx_all);
plot(xx_all, yy_a, 'b')
hold on
yy_b = subs(y_b, x, xx_all);
plot(xx_all, yy_b, 'r')
yy_c = subs(y_c, x, xx_all);
plot(xx_all, yy_c, 'm')

scatter(Pn(:,1),Pn(:,2),50,'filled')
text(p1(1,1)+0.1, p1(1,2)-0.1, 'P_1');
text(p2(1,1)+0.1, p2(1,2)-0.1, 'P_2');
text(p3(1,1)+0.1, p3(1,2)-0.1, 'P_3');
text(p4(1,1)+0.1, p4(1,2)-0.1, 'P_4');

xlabel('x')
ylabel('y')
title(["Piecewise spline + 1" "standard form -" "full curves"])

set(gca,'ylim',[-5 10],'xlim',[xx_lim(1,1) xx_lim(1,2)],'xtick',xx_lim(1,1):xx_lim(1,2),'ytick',-5:10)
opt.fontname = 'helvetica';
opt.fontsize = 8;

centeraxes(gca,opt);

%plotting partial piecewise curves
if DO_SUBPLOT == 1
    subplot(122)
end

clear yy_a, yy_b, yy_c
%xx_lim = [p1(1,1) - 1 p4(1,1)]
xx_lim = [p1(1,1) - 1 pd(1,1) + 1]

xx_lim_a = [p1(1,1) - 1 p2(1,1)]

xx_a = linspace(xx_lim(1,1),xx_lim_a(1,2));
yy_a = subs(y_a, x, xx_a);
plot(xx_a, yy_a, 'b')
hold on
xx_lim_b = [p2(1,1) p3(1,1)]
xx_b = linspace(xx_lim_b(1,1),xx_lim_b(1,2));
yy_b = subs(y_b, x, xx_b);
plot(xx_b, yy_b, 'r')
xx_lim_c = [p3(1,1) p4(1,1)]
xx_c = linspace(xx_lim_c(1,1),xx_lim_c(1,2));

yy_c = subs(y_c, x, xx_c);
plot(xx_c, yy_c, 'm')

scatter(Pn(:,1),Pn(:,2),50,'filled')
text(p1(1,1)+0.1, p1(1,2)-0.1, 'P_1');
text(p2(1,1)+0.1, p2(1,2)-0.1, 'P_2');
text(p3(1,1)+0.1, p3(1,2)-0.1, 'P_3');
text(p4(1,1)+0.1, p4(1,2)-0.1, 'P_4');

xlabel('x')
ylabel('y')
title(["Piecewise spline + 1" "standard form - " "partial curves"])

set(gca,'ylim',[-5 10],'xlim',[xx_lim(1,1) xx_lim(1,2)],'xtick',xx_lim(1,1):xx_lim(1,2),'ytick',-5:10)
opt.fontname = 'helvetica';
opt.fontsize = 8;

centeraxes(gca,opt);


%adding cubic spline
CD = [p3(1,1)^3 p3(1,1)^2 p3(1,1) 1 0 0 0 0;
      p4(1,1)^3 p4(1,1)^2 p4(1,1) 1 0 0 0 0;
      0 0 0 0 pa(1,1)^3 pa(1,1)^2 pa(1,1) 1;
      0 0 0 0 pb(1,1)^3 pb(1,1)^2 pb(1,1) 1;
      0 0 0 0 pc(1,1)^3 pc(1,1)^2 pc(1,1) 1;
      0 0 0 0 pd(1,1)^3 pd(1,1)^2 pd(1,1) 1;
     -3 * p4(1,1)^2 -2 * p4(1,1) -1 0 3 * pa(1,1)^2 2 * pa(1,1) 1 0;
     -6 * p4(1,1)   -2            0 0 6 * pa(1,1)   2           0 0]

CD_i = inv(CD)

YD = [p3(1,2);
      p4(1,2);
      pa(1,2);
      pb(1,2);
      pc(1,2);
      pd(1,2);
      0;
      0]

AD = CD_i * YD

syms x
yD_c = AD(1,1) * x^3 + AD(2,1) * x^2 + AD(3,1) * x + AD(4,1);
yD_d = AD(5,1) * x^3 + AD(6,1) * x^2 + AD(7,1) * x + AD(8,1);

vpa(yD_c)
vpa(yD_d)

%plotting added piecewise curves
if DO_SUBPLOT == 1
    subplot(121)
end

xx_lim_D = [pa(1,1) pd(1,1) + 1]
xx_D = linspace(xx_lim_D(1,1),xx_lim_D(1,2));
yy_d = subs(yD_d, x, xx_D);
plot(xx_D, yy_d, 'k')

scatter(PD(:,1),PD(:,2),50,'filled')
%text(pa(1,1)+0.1, pa(1,2)-0.1, 'P_a');
text(pb(1,1)+0.1, pb(1,2)-0.1, 'P_b');
text(pc(1,1)+0.1, pc(1,2)-0.1, 'P_c');
text(pd(1,1)+0.1, pd(1,2)-0.1, 'P_d');


%plotting partial piecewise curves
if DO_SUBPLOT == 1
    subplot(122)
end

clear yy_a, yy_b, yy_c

xx_lim = [p1(1,1) - 1 pd(1,1)]
xx_lim_a = [p1(1,1) - 1 p2(1,1)]

xx_a = linspace(xx_lim(1,1),xx_lim_a(1,2));
yy_a = subs(y_a, x, xx_a);
plot(xx_a, yy_a, 'b')
hold on
xx_lim_b = [p2(1,1) p3(1,1)]
xx_b = linspace(xx_lim_b(1,1),xx_lim_b(1,2));
yy_b = subs(y_b, x, xx_b);
plot(xx_b, yy_b, 'r')
xx_lim_c = [p3(1,1) p4(1,1)]
xx_c = linspace(xx_lim_c(1,1),xx_lim_c(1,2));

yy_c = subs(y_c, x, xx_c);
plot(xx_c, yy_c, 'm')

scatter(Pn(:,1),Pn(:,2),50,'filled')
text(p1(1,1)+0.1, p1(1,2)-0.1, 'P_1');
text(p2(1,1)+0.1, p2(1,2)-0.1, 'P_2');
text(p3(1,1)+0.1, p3(1,2)-0.1, 'P_3');
text(p4(1,1)+0.1, p4(1,2)-0.1, 'P_4');

xx_lim_D = [pa(1,1) pd(1,1) + 1]
xx_D = linspace(xx_lim_D(1,1),xx_lim_D(1,2));
yy_d = subs(yD_d, x, xx_D);
plot(xx_d, yy_d, 'k')





