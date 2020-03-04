clear aqll;
DO_SUBPLOT = 2 % if set to 0, only plots the full curve graph
               % if set to 1, plots the full curve graph and the partial curve graph
               % if set to 2, only plots the partial curve graph
ADDITIONAL_X_AXIS_SIZE = 3
LINE_SPACE_NUMBER = 500
END_SPLINE = 2

addpath("./model");
addpath(".."); % required in order to be able to call the centeraxis() function

p1 = [0 1]
p2 = [2 2]
p3 = [5 0]
p4 = [8 0]
p5 = [11 0]
p6 = [15 -3]
Pn = [p1;p2;p3;p4;p5;p6]


spline_colors{1} = 'b';
spline_colors{2} = 'r';
spline_colors{3} = 'm';
spline_colors{4} = 'g';
spline_colors{5} = 'k';

splineModelNPoints = SplineModelNPoints(Pn,...
                                        4,...
                                        -2,...
                                        spline_colors);

splineModelNPoints.computePiecewiseSplineFunctions();

yFuncCellArray = splineModelNPoints.yFuncCellArray;
y_a = yFuncCellArray{1};
y_b = yFuncCellArray{2};
y_c = yFuncCellArray{3};
y_d = yFuncCellArray{4};
y_e = yFuncCellArray{5};

%plotting
close all
figure

%plotting full piecewise curves

if DO_SUBPLOT == 1
    subplot(121);
end

xx_lim = [p1(1,1) - 1 p6(1,1)];
xx_all = linspace(xx_lim(1,1),xx_lim(1,2),LINE_SPACE_NUMBER);
syms x
yy_a = subs(y_a, x, xx_all);

if DO_SUBPLOT ~= 2
    plot(xx_all, yy_a, 'b')

    hold on
end

yy_b = subs(y_b, x, xx_all);
plot(xx_all, yy_b, 'r')
yy_c = subs(y_c, x, xx_all);
plot(xx_all, yy_c, 'm')
yy_d = subs(y_d, x, xx_all);
plot(xx_all, yy_d, 'g')
yy_e = subs(y_d, x, xx_all);
plot(xx_all, yy_e, 'k')

scatter(Pn(:,1),Pn(:,2),50,'filled')
text(p1(1,1)+0.1, p1(1,2)-0.1, 'P_1');
text(p2(1,1)+0.1, p2(1,2)-0.1, 'P_2');
text(p3(1,1)+0.1, p3(1,2)-0.1, 'P_3');
text(p4(1,1)+0.1, p4(1,2)-0.1, 'P_4');
text(p5(1,1)+0.1, p5(1,2)-0.1, 'P_5');
text(p5(1,1)+0.1, p6(1,2)-0.1, 'P_6');

xlabel('x');
ylabel('y');
title(["Piecewise spline" "56 points version" "standard form -" "full curves"]);

set(gca,'ylim',[-5 10],'xlim',[xx_lim(1,1) xx_lim(1,2)],'xtick',xx_lim(1,1):xx_lim(1,2),'ytick',-5:10);
opt.fontname = 'helvetica';
opt.fontsize = 8;

centeraxes(gca,opt);

%plotting partial piecewise curves

if DO_SUBPLOT == 1
    subplot(122)
elseif DO_SUBPLOT ~= 2
    return
end

clear yy_a, yy_b, yy_c, yy_d, yy_e
xx_lim = [p1(1,1) - 1 p6(1,1) + ADDITIONAL_X_AXIS_SIZE];
xx_lim_a = [p1(1,1) - 1 p2(1,1)];

xx_a = linspace(xx_lim(1,1),xx_lim_a(1,2),LINE_SPACE_NUMBER);
yy_a = subs(y_a, x, xx_a);
plot(xx_a, yy_a, 'b')
hold on
xx_lim_b = [p2(1,1) p3(1,1)];
xx_b = linspace(xx_lim_b(1,1),xx_lim_b(1,2),LINE_SPACE_NUMBER);
yy_b = subs(y_b, x, xx_b);
plot(xx_b, yy_b, 'r')
xx_lim_c = [p3(1,1) p4(1,1)];
xx_c = linspace(xx_lim_c(1,1),xx_lim_c(1,2),LINE_SPACE_NUMBER);
yy_c = subs(y_c, x, xx_c);
plot(xx_c, yy_c, 'm')
xx_lim_d = [p4(1,1) p5(1,1)];
xx_d = linspace(xx_lim_d(1,1),xx_lim_d(1,2),LINE_SPACE_NUMBER);
yy_d = subs(y_d, x, xx_d);
plot(xx_d, yy_d, 'g')
xx_lim_e = [p5(1,1) p6(1,1)];
xx_e = linspace(xx_lim_e(1,1),xx_lim_e(1,2),LINE_SPACE_NUMBER);
yy_e = subs(y_e, x, xx_e);
plot(xx_e, yy_e, 'k')

scatter(Pn(:,1),Pn(:,2),50,'filled')
text(p1(1,1)+0.1, p1(1,2)-0.1, 'P_1');
text(p2(1,1)+0.1, p2(1,2)-0.1, 'P_2');
text(p3(1,1)+0.1, p3(1,2)-0.1, 'P_3');
text(p4(1,1)+0.1, p4(1,2)-0.1, 'P_4');
text(p5(1,1)+0.1, p5(1,2)-0.1, 'P_5');
text(p6(1,1)+0.1, p6(1,2)-0.1, 'P_6');

xlabel('x');
ylabel('y');
title(["Piecewise spline" "6 points version" "standard form - " "partial curves"]);

set(gca,'ylim',[-5 10],'xlim',[xx_lim(1,1) xx_lim(1,2)],'xtick',xx_lim(1,1):xx_lim(1,2),'ytick',-5:10);
opt.fontname = 'helvetica';
opt.fontsize = 8;

centeraxes(gca,opt);