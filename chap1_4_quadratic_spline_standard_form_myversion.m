close all
figure
syms x;
y = -1.1 * x ^ 2 + 10.9 * x - 20.8;
vpa(y)
xx = linspace(1, 9);
yy = subs(y, x, xx);
plot(xx, yy, 'r-')
hold on
x1 = 3;
x2 = 6;
x3 = 8;
y1 = 2;
y2 = 5;
y3 = -4;
scatter([x1 x2 x3], [y1 y2 y3])
text(x1+0.1, y1-0.5, 'P_1');
text(x2-0.1, y2+0.5, 'P_2');
text(x3-0.1, y3+0.5, 'P_3');

xlabel('x');
ylabel('y')

set(gca,'ylim',[-10 7],'xlim',[-5 11],'xtick',-5:11,'ytick',-10:7)
opt.fontname = 'helvetica';
opt.fontsize = 8;

centeraxes(gca,opt);
