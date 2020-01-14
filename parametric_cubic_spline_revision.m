m = 0.3
n = 0.8
C = [0 0 0 1;m^3 m^2 m 1;n^3 n^2 n 1;1 1 1 1]
Ci = inv(C)

p0 = [-1 2]
p1 = [3 0]
p2 = [1 -2]
p3 = [2 0]

Points = [p0;p1;p2;p3]

A = Ci * Points
syms t

x_t = A(1,1)*t^3 + A(2,1) * t^2 + A(3,1) * t + A(4,1);
vpa(x_t)
y_t = A(1,2)*t^3 + A(2,2) * t^2 + A(3,2) * t + A(4,2);
vpa(y_t)

%plotting
close all
figure
x_tt = linspace(-3,3)
xx = subs(x_t, t, x_tt)
y_tt = linspace(-3,3)
yy = subs(y_t, t, y_tt)
plot(xx, yy)
hold on
scatter(Points(:,1),Points(:,2),50,'filled')
set(gca,'ylim',[-7 6],'xlim',[-5 5],'xtick',-5:5,'ytick',-7:6)
opt.fontname = 'helvetica';11
opt.fontsize = 8;1111

centeraxes(gca,opt);