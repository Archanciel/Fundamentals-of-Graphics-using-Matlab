clear all;
clc;
figure
syms x; % define symbolic variable x
x1 = 3;
y1 = 2;
x2 = 8;
y2 = -4;
X = [x1 x2];
Y = [y1 y2];
C = [1 x1;1 x2];
A = inv(C)*Y';
a = A(1);
b = A(2);
fprintf('Required equation: \n');
y = a + b*x; % defining symbolic function y(x). Here, a and b are defined
             % and x is aymbolic variable
y = vpa(y) % display the y function body y = 5.6 - 1.2 x

%plotting
xx = linspace(x1, x2); % returns a row vector of 100 evenly spaced points 
                       % between x1 and x2.
yy = subs(y, x, xx); % evaluate y by setting x to vector xx
plot(xx, yy, 'b-');
hold on;
size = 50;
color = 'r';
scatter([x1 x2], [y1 y2], size, color);
%scatter(X, Y, 20, 'r', 'filled');
xlabel('x');
ylabel('y');
grid;
axis square;
axis([0 10 -5 3]);
d = 0.5;
text(x1+d, y1, 'P_1'); % placingp P subscript 1 at coordinate [x1 + 0.5, y1]
text(x2+d, y2, 'P_2');
hold off;
