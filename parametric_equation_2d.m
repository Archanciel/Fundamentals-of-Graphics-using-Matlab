%{
C = [1 1;6 1]
Ci = inv(C)
y = [2;6]
Ci * y
sprintf('now, with details ...')
%}
C = [1 1;8 1]
Ci = inv(C)
y = [2;9]
A = Ci * y
sprintf('now, with details ...')

n = [1;2]
u = [2.5;1.5]
t = 2
m = n + t * u
C = [n(1) 1;m(1) 1]
y = [n(2);m(2)]
Ci = inv(C)
A = Ci * y

%plotting
close all
figure
scatter(n(1), n(2), 50, 'r', 'filled')
tx = text((n(1) + 0.05), n(2), 'n', 'Color','r');
tx.FontSize = 20;
hold on
plot([0 u(1)], [0 u(2)], 'k-')

plot([n(1) n(1) + u(1)], [n(2) n(2) + u(2)], 'k-')

tx = text((u(1) + 0.05), u(2), 'u', 'Color','k');
tx.FontSize = 20;

syms x
y = A(1) * x + A(2)
xx = linspace(-3,3,7)
yy = subs(y, x, xx)
plot(xx, yy, 'g-')
tt = sprintf('y = ax + b = %s', char(y))
tx = text((xx(1) + 0.05), yy(1), tt, 'Color','g');
tx.FontSize = 20;

xlabel('x');
ylabel('y(x)')
%thicklines(2);

set(gca,'ylim',[-3 3],'xlim',[-4 4],'xtick',-4:4,'ytick',-3:3)
opt.fontname = 'helvetica';
opt.fontsize = 20;

centeraxes(gca,opt);