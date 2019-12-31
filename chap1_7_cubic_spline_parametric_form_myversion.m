clear all
m = 0.05
n = 0.9
p0 = [-1 2]
pm = [0 0]
pn = [1 -2]
p1 = [2 0]
C = [0 0 0 1;m^3 m^2 m 1;n^3 n^2 n 1;1 1 1 1]
Ci = inv(C)
Pt = [p0;pm;pn;p1]
A = Ci * Pt
syms t
x = A(1,1) * t^3 + A(2,1) * t^2 + A(3,1) * t + A(4,1);
vpa(x)
y = A(1,2) * t^3 + A(2,2) * t^2 + A(3,2) * t + A(4,2);
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
text(Pt(1,1)+0.1, Pt(1,2)-0.1, 'P_0');
text(Pt(2,1)+0.1, Pt(2,2)-0.1, 'P_1');
text(Pt(3,1)+0.1, Pt(3,2)-0.1, 'P_2');
text(Pt(4,1)+0.1, Pt(4,2)-0.1, 'P_3');

xlabel('x(t)')
ylabel('y(t)')

ti = title({"m = " + m + ", n = " + n , " "}); %title with a blank line
ti.FontSize = 15;

set(gca,'ylim',[-7 6],'xlim',[-5 5],'xtick',-5:5,'ytick',-7:6)
opt.fontname = 'helvetica';
opt.fontsize = 8;

centeraxes(gca,opt);