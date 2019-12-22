syms t
y = 6 + 2 * t

xx = linspace(-5, 5, 11)
yy = subs(y, t, xx)

close all
figure
plot(xx, yy, 'k-')

xlabel('t');
ylabel('y(t)')

set(gca,'ylim',[-6 17],'xlim',[-6 17],'xtick',-6:17,'ytick',-6:17)
opt.fontname = 'helvetica';
opt.fontsize = 12;

centeraxes(gca,opt);