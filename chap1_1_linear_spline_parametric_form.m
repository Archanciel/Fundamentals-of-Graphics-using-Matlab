clear all;
clc;
syms t;
x1 = 3;
y1 = 2;
x2 = 8;
y2 = -4;
X = [x1 x2]
Y = [y1 y2]
G = [X;Y]
C = [1 0;1 1];
A = inv(C)*G';
ax = A(1,1);
ay = A(1,2);
bx = A(2,1);
by = A(2,2);
fprintf('Required equations: \n');
x = ax + bx*t;
x = vpa(x) 
y = ay + by*t;
y = vpa(y) 

%plotting
tt = linspace(0,1);
xx = subs(x, t, tt);
yy = subs(y, t, tt);
subplot(131), plot(tt, xx);
grid;
axis square;
xlabel('t');
ylabel('x');
title('t - x');
subplot(132), plot(tt, yy);
grid;
axis square;
xlabel('t');
ylabel('y');
title('t - y');
subplot(133), plot(xx, yy, 'b-', X, Y, 'bo');
grid;
axis square;
hold on;
scatter(X, Y, 20, 'r', 'filled');
xlabel('x');
ylabel('y');
title('x - y');
text(x1+1, y1-0.5, 'P_0');
text(x2-1, y2+0.5, 'P_1');
hold off;
