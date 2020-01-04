%{
In this version, I am trying to add a new cubic spline to the existing
3 piecewise cubic splines. My solution is not ok since, in order to smooth the 
connection between the last piecewise spline and the new spline, I set the
slope of the lend of the last spline to the slope of the start of the new spline.
I do this because I do not know how to force the starting slope of the new spline
since adding a line to the new cubic spline matrix would cause the matrix to be
no longer square and so to be no longer invertible.
%}

DO_SUBPLOT = 1 %if set to 0, only plots the full curve graph
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

C = [p1(1,1)^3 p1(1,1)^2 p1(1,1) 1 0 0 0 0 0 0 0 0;
     p2(1,1)^3 p2(1,1)^2 p2(1,1) 1 0 0 0 0 0 0 0 0;
     0 0 0 0 p2(1,1)^3 p2(1,1)^2 p2(1,1) 1 0 0 0 0;
     0 0 0 0 p3(1,1)^3 p3(1,1)^2 p3(1,1) 1 0 0 0 0;
     0 0 0 0 0 0 0 0 p3(1,1)^3 p3(1,1)^2 p3(1,1) 1;
     0 0 0 0 0 0 0 0 p4(1,1)^3 p4(1,1)^2 p4(1,1) 1;
     -3 * p2(1,1)^2 -2 * p2(1,1) -1 0 3 * p2(1,1)^2 2 * p2(1,1) 1 0 0 0 0 0;
     0 0 0 0 -3 * p3(1,1)^2 -2 * p3(1,1) -1 0 3 * p3(1,1)^2 2 * p3(1,1) 1 0;
     -6 * p2(1,1) -2 0 0 6 * p2(1,1) 2 0 0 0 0 0 0;
     0 0 0 0 -6 * p3(1,1) -2 0 0 6 * p3(1,1) 2 0 0;
     3 * p1(1,1)^2 2 * p1(1,1) 1 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 3 * p4(1,1)^2 2 * p4(1,1) 1 0]
C_i = inv(C)

%adding a new cubic spline. This code is located here since the slope
%of the new spline must be calculated before computing the piecewise
%splines (see introduction comment)
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
yD_d_prime = diff(yD_d)
end_C_slope = subs(yD_d_prime,x,pa(1))
vpa(end_C_slope)

Y = [p1(1,2);
    p2(1,2);
    p2(1,2);
    p3(1,2);
    p3(1,2);
    p4(1,2);
    0;
    0;
    0;
    0;
    4;
    end_C_slope]

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
xx_lim = [p1(1,1) - 1 pd(1,1) + 1]
%xx_lim = [p1(1,1) - 1 p4(1,1)]
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
if DO_SUBPLOT == 1
    title(["Piecewise spline + 1" "standard form - " "partial curves"])
end

set(gca,'ylim',[-5 10],'xlim',[xx_lim(1,1) xx_lim(1,2)],'xtick',xx_lim(1,1):xx_lim(1,2),'ytick',-5:10)
opt.fontname = 'helvetica';
opt.fontsize = 8;

centeraxes(gca,opt);





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


%plotting added partial piecewise curves
if DO_SUBPLOT == 1
    subplot(122)
end
clear yy_d
xx_lim = [pa(1,1) pd(1,1) + 1]
xx_lim_D = [pa(1,1) pd(1,1) + 1]

xx_d = linspace(xx_lim_D(1,1),xx_lim_D(1,2));
yy_d = subs(yD_d, x, xx_d);
plot(xx_d, yy_d, 'k')
hold on


scatter(PD(:,1),PD(:,2),50,'filled')
%text(pa(1,1)+0.1, pa(1,2)-0.1, 'P_a');
text(pb(1,1)+0.1, pb(1,2)-0.1, 'P_b');
text(pc(1,1)+0.1, pc(1,2)-0.1, 'P_c');
text(pd(1,1)+0.1, pd(1,2)-0.1, 'P_d');
