close all
figure
clear all;
clc;
syms t;
x1 = 3;
y1 = 2;
x2 = 8;
y2 = -4;
p0 = [x1 y1]
p1 = [x2 y2]
X = [x1 x2]
Y = [y1 y2]
G = [X;Y]
G = [p0;p1]
C = [0 1;1 1]
A = inv(C)*G
ax = A(1,1)
bx = A(2,1)
ay = A(1,2)
by = A(2,2)
fprintf('Required equations: \n');
x = ax * t + bx;
x = vpa(x) 
y = ay * t + by;
y = vpa(y) 

%plotting
tLim = [-2 2]
tt = linspace(tLim(1),tLim(2));
xx = subs(x, t, tt);
yy = subs(y, t, tt);

subplot(1, 3, 1)
plot(tt, xx)
xlabel('t');
ylabel('x(t)')

set(gca,'ylim',[-1 5],'xlim',[tLim(1) tLim(2)],'xtick',tLim(1):tLim(2),'ytick',-1:5)
opt.fontname = 'helvetica';
opt.fontsize = 12;
centeraxes(gca,opt);
title('x function of t');

subplot(1, 3, 2)
plot(tt, yy)
xlabel('t');
ylabel('y(t)')

set(gca,'ylim',[-1 5],'xlim',[tLim(1) tLim(2)],'xtick',tLim(1):tLim(2),'ytick',-1:5)
opt.fontname = 'helvetica';
opt.fontsize = 12;
centeraxes(gca,opt);
title('y function of t');

subplot(1, 3, 3)
hold on;
scatter(X, Y, 20, 'r', 'filled');
text(x1+1, y1-0.5, 'P_0');
text(x2-1, y2+0.5, 'P_1');

plot(xx, yy)
xlabel('x(t)');
ylabel('y(t)');

set(gca,'ylim',[-6 8],'xlim',[-2 9],'xtick',-2:9,'ytick',-6:8)
opt.fontname = 'helvetica';
opt.fontsize = 12;
centeraxes(gca,opt);
title('y(t) x(t)');

hold off;
