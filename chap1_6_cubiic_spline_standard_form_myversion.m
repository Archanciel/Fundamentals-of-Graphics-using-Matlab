p1 = [-1 2]
p2 = [0 0]
p3 = [1 -2]
p4 = [2 0]
Pn = [p1;p2;p3;p4]
C = [p1(1,1)^3 p1(1,1)^2 p1(1,1) 1;
     p2(1,1)^3 p2(1,1)^2 p2(1,1) 1;
     p3(1,1)^3 p3(1,1)^2 p3(1,1) 1;
     p4(1,1)^3 p4(1,1)^2 p4(1,1) 1]
Ci = inv(C)
Y = [p1(1,2);p2(1,2);p3(1,2);p4(1,2)]
A = Ci * Y
syms x
y = A(1,1) * x^3 + A(2,1) * x^2 + A(3,1) * x + A(4,1);
vpa(y)

%plotting
close all
figure
xx = linspace(-3,3);
yy = subs(y, x, xx);
plot(xx, yy, 'b')
hold on
scatter(Pn(:,1),Pn(:,2),50,'filled')
text(p1(1,1)+0.1, p1(1,2)-0.1, 'P_1');
text(p2(1,1)+0.1, p2(1,2)-0.1, 'P_2');
text(p3(1,1)+0.1, p3(1,2)-0.1, 'P_3');
text(p4(1,1)+0.1, p4(1,2)-0.1, 'P_4');
%return
xlabel('x')
ylabel('y')
title("Cubic spline")

set(gca,'ylim',[-4 8],'xlim',[-3 4],'xtick',-3:4,'ytick',-4:8)
opt.fontname = 'helvetica';
opt.fontsize = 8;

centeraxes(gca,opt);