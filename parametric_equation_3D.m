close all
figure
u = [-1;2;1]
a = [1;2;3]
plot3([0 u(1)],[0 u(2)],[0 u(3)],'k-')
text(u(1)+0.5, u(2), u(3),'U','Color','k');

hold on
scatter3(a(1),a(2),a(3),50,'r', 'filled')
text(a(1)+0.5, a(2), a(3),'A','Color','r');

% example of a point m:

m = a + 3 * u

plot3([a(1) m(1)],[a(2) m(2)],[a(3) m(3)],'g-')
text(m(1)+0.5, m(2), m(3),'M','Color','g');

lim = [-2 9];
tick = [-2:1:11];
xlabel('X')
ylabel('Y')
zlabel('z');
set(gca,'XLim',lim);
set(gca,'XTick',tick);
set(gca,'YLim',lim);
set(gca,'YTick',tick);
set(gca,'ZLim',lim);
set(gca,'ZTick',tick);
%not working !
%view(2) %?
%view([0,45])
grid