k = 0.8
p0 = [-4 2]
pk = [2 -2]
p1 = [4 4]
C = [0 0 1;k^2 k 1;1 1 1]
Ci = inv(C)
Pt = [p0;pk;p1]
A = Ci * Pt
syms t
x = A(1,1) * t^2 + A(2,1) * t + A(3,1);
vpa(x)
y = A(1,2) * t^2 + A(2,2) * t + A(3,2);
vpa(y)

%plotting
close all
figure
tt = linspace(-0.5,1.5);
xx = subs(x, t, tt);
yy = subs(y, t, tt);
plot(xx, yy, 'b')
hold on
scatter(Pt(:,1),Pt(:,2),50,'filled')
text(p0(1,1)+0.1, p0(1,2)-0.1, 'P_0');
text(pk(1,1)+0.1, pk(1,2)-0.1, 'P_k');
text(p1(1,1)+0.1, p1(1,2)-0.1, 'P_1');

xlabel('x(t)')
ylabel('y(t)')
titleStr = sprintf('k = %0.2f', k);
%title([titleStr])
%title(['k = ', num2str(k)])
title("k = " + k)

set(gca,'ylim',[-6 5],'xlim',[-5 5],'xtick',-5:5,'ytick',-6:5)
opt.fontname = 'helvetica';
opt.fontsize = 8;

centeraxes(gca,opt);