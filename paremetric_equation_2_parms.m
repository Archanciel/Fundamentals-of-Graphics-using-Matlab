clear
syms s
syms t
y = 6 + 2 * s - 3 * t
ss = linspace(-2,7,4)
tt = linspace(2,-7,4)
y = subs(y, {s,t}, {2,2})
z = subs(y, {s,t}, {3,3})
yy = subs(y, {s, t}, {ss, tt})

close all
figure
points=[ss' tt' yy']; % using the data given in the question 
fill3(points(1,:),points(2,:),points(3,:),'r') 
xlabel('s')
ylabel('t')
zlabel('y')
grid on 
alpha(0.3)


%{
[s t] = meshgrid(-3:1:1)

y = 2.*s + 3.*t + 6
surf(s,t,y);
%}
