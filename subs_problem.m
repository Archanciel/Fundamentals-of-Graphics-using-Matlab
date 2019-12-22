clear
syms s
syms t
y = 6 + 2 * s - 3 * t
z = subs(y, {s,t}, {3,3})
y = subs(y, {s,t}, {2,2})
