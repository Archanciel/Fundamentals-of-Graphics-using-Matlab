clear all

global SCATTER_POINT_SIZE
SCATTER_POINT_SIZE = 15


global global_splines_data;% {1} --> curve points x coordinates
                           % {2} --> curve points y coordinates
                           % {3} --> current menu selection value 
                           % {4} --> x slider reference 
                           % {5} --> y slider reference 
                           % {6} --> x slider text value reference 
                           % {7} --> y slider text value reference 
                           % {8} --> NO LONGER USED !
                           % {9} --> initial piecewise spline points_labels
                           % {10} --> additional piecewise spline points_labels
                           % {11} --> initial piecewise spline colors
                           % {12} --> additional piecewise spline colors
                           % {13} --> first piecewise spline line handles
                           % {14} --> additional piecewise spline line handles
                           % {15} --> initial piecewise spline point label handles
                           % {16} --> additional piecewise spline point label handles

points_labels{1} = 'P_1';
points_labels{2} = 'P_2';
points_labels{3} = 'P_3';
points_labels{4} = 'P_4';
global_splines_data{9} = points_labels

clear points_labels

points_labels{1} = 'P_5';
points_labels{2} = 'P_6';
points_labels{3} = 'P_7';
points_labels{4} = 'P_8';
global_splines_data{10} = points_labels

spline_colors{1} = 'b'
spline_colors{2} = 'r'
spline_colors{3} = 'm'
global_splines_data{11} = spline_colors

clear spline_colors
spline_colors{1} = 'k'
spline_colors{2} = 'r'
spline_colors{3} = 'g'
global_splines_data{12} = spline_colors

% piecewise splines points initial coordinates

p1 = [0 1]
p2 = [2 2]
p3 = [5 0]
p4 = [8 0]

P_1_4 = [p1;p2;p3;p4]

%added piecewise spline points. Must be located here so plot x axis limit
%can account for p8 x value !
p5 = [8 0]
p6 = [9 -1]
p7 = [10 3]
p8 = [11 2]
P_5_8 = [p5;p6;p7;p8]

% initializing the global spline_data variable (for use by ui callback functions)
global_splines_data{1} = [P_1_4(:,1)' P_5_8(:,1)']; % curve points x coordinates
global_splines_data{2} = [P_1_4(:,2)' P_5_8(:,2)']; % curve points y coordinates
global_splines_data{3} = 'P1';   % initial value of menu 

yFuncCellArray = computeFirstPiecewiseSpline()
plotFirstPiecewiseSpline(yFuncCellArray)

yFuncCellArray = computeAdditionalPiecewiseSpline()
plotAdditionalPiecewiseSpline(yFuncCellArray)
addUI()

function addUI()
    global global_splines_data;

    SLIDER_POS_X = 150
    MENU_POS_X = 70

    xMin = global_splines_data{1}(1,1) - 2;
    xMax = global_splines_data{1}(1,8) + 2;
    yMin = -10
    yMax = 10

    xSlider = uicontrol('style','slider','units','pixel','position',[SLIDER_POS_X 20 300 20],...
        'sliderstep',[1/(xMax-xMin), 2/(xMax-xMin)],'max',xMax,'min',xMin, 'value',global_splines_data{1}(1,1));
    hplot = global_splines_data{8};
    addlistener(xSlider,'ContinuousValueChange',@(hObject, event) sliderPlot_x(hObject, event,hplot));
    global_splines_data{4} = xSlider; % required so that menu selection can update the curve point impacted by the x slider 
    uicontrol('style','text',...
        'position',[SLIDER_POS_X - 10 30 10 10],'string', 'X');
    xValueText = uicontrol('Style','text','Position',[SLIDER_POS_X + 302,25,13,15],...
                'String',global_splines_data{1}(1,1), 'BackgroundColor', 'w');
    global_splines_data{6} = xValueText; % required so that the x slider can update its displayed value

    % slider controlling y coordinates
    ySlider = uicontrol('style','slider','units','pixel','position',[SLIDER_POS_X 0 300 20],...
        'sliderstep',[1/(yMax-yMin), 2/(yMax-yMin)],'max',yMax,'min',yMin, 'value',global_splines_data{2}(1,1));
    global_splines_data{5} = ySlider; % required so that menu selection can update the curve point impacted by the y slider 
    addlistener(ySlider,'ContinuousValueChange',@(hObject, event) sliderPlot_y(hObject, event,hplot));
    uicontrol('style','text',...
        'position',[SLIDER_POS_X - 10 10 10 10],'string', 'Y');
    yValueText = uicontrol('Style','text','Position',[SLIDER_POS_X + 302,5,13,15],...
                'String',global_splines_data{2}(1,1), 'BackgroundColor', 'w');
    global_splines_data{7} = yValueText; % required so that the y slider can update its displayed value

    % drop down menu to select which point is modified by the sliders 
    menu = uicontrol('Style','popupmenu',...
        'position', [MENU_POS_X 20 60 20], 'string', {'P1','P2','P3','P4','P5','P6','P7','P8'});
    menu.Callback = @menuSelection;
end

function yFuncCellArray = computeFirstPiecewiseSpline()
    % Returns a 3 elements cell array containing piecewise splines
    % y_A, y_B and y_C functions
    global global_splines_data;

    Pn = [global_splines_data{1}(1,1:4)' global_splines_data{2}(1,1:4)'];

    C = [Pn(1,1)^3 Pn(1,1)^2 Pn(1,1) 1 0 0 0 0 0 0 0 0;
         Pn(2,1)^3 Pn(2,1)^2 Pn(2,1) 1 0 0 0 0 0 0 0 0;
         0 0 0 0 Pn(2,1)^3 Pn(2,1)^2 Pn(2,1) 1 0 0 0 0;
         0 0 0 0 Pn(3,1)^3 Pn(3,1)^2 Pn(3,1) 1 0 0 0 0;
         0 0 0 0 0 0 0 0 Pn(3,1)^3 Pn(3,1)^2 Pn(3,1) 1;
         0 0 0 0 0 0 0 0 Pn(4,1)^3 Pn(4,1)^2 Pn(4,1) 1;
         -3 * Pn(2,1)^2 -2 * Pn(2,1) -1 0 3 * Pn(2,1)^2 2 * Pn(2,1) 1 0 0 0 0 0;
         0 0 0 0 -3 * Pn(3,1)^2 -2 * Pn(3,1) -1 0 3 * Pn(3,1)^2 2 * Pn(3,1) 1 0;
         -6 * Pn(2,1) -2 0 0 6 * Pn(2,1) 2 0 0 0 0 0 0;
         0 0 0 0 -6 * Pn(3,1) -2 0 0 6 * Pn(3,1) 2 0 0;
         3 * Pn(1,1)^2 2 * Pn(1,1) 1 0 0 0 0 0 0 0 0 0;
         0 0 0 0 0 0 0 0 3 * Pn(4,1)^2 2 * Pn(4,1) 1 0]
    C_i = inv(C);

    Y = [Pn(1,2);
        Pn(2,2);
        Pn(2,2);
        Pn(3,2);
        Pn(3,2);
        Pn(4,2);
        0;
        0;
        0;
        0;
        4;
        -2];

    A = C_i * Y;

    syms x
    y_A = A(1,1) * x^3 + A(2,1) * x^2 + A(3,1) * x + A(4,1);
    y_B = A(5,1) * x^3 + A(6,1) * x^2 + A(7,1) * x + A(8,1);
    y_C = A(9,1) * x^3 + A(10,1) * x^2 + A(11,1) * x + A(12,1);

    yFuncCellArray{1} = y_A;
    yFuncCellArray{2} = y_B;
    yFuncCellArray{3} = y_C;
    
    fprintf("y_A");
    vpa(y_A);
    fprintf("y_B");
    vpa(y_B);
    fprintf("y_C");
    vpa(y_C);
end

function plotFirstPiecewiseSpline(yFuncCellArray)
    global SCATTER_POINT_SIZE
    global global_splines_data;

    Pn = [global_splines_data{1}(1,1:4)' global_splines_data{2}(1,1:4)'];

    syms x
    y_A = yFuncCellArray{1};
    y_B = yFuncCellArray{2};
    y_C = yFuncCellArray{3};

    %plotting
    close all
    figure

    xx_lim = [global_splines_data{1}(1,1) - 1 global_splines_data{1}(1,8) + 1];

    %plotting partial initial piecewise curves
    points_labels = global_splines_data{9}; 
    spline_colors = global_splines_data{11}; 
    
    isAdditionalSpline = 0 % first point label will be shifted to avoid overwritting
                    % last point label of initial piecewise spline
    plottedFirstPiecewiseSplines = plotPartialPiecewiseSpline(Pn, xx_lim, y_A, y_B, y_C, points_labels, spline_colors, isAdditionalSpline);
    global_splines_data{13} = plottedFirstPiecewiseSplines(1:3);
    global_splines_data{15} = plottedFirstPiecewiseSplines(4);
    
    xlabel('x');
    ylabel('y');
    title(["Piecewise spline + 1" "standard form - " "partial curves"]);

    set(gca,'ylim',[-5 10],'xlim',[xx_lim(1,1) xx_lim(1,2)],'xtick',xx_lim(1,1):xx_lim(1,2),'ytick',-5:10)
    opt.fontname = 'helvetica';
    opt.fontsize = 8;

    centeraxes(gca,opt);
end

function plottedPiecewiseSplines = plotPartialPiecewiseSpline(Pn, xx_lim, y_ONE, y_TWO, y_THREE, points_labels, spline_colors, isAdditionalSpline)
    %Returns handles on the plotted piecewise splines
    %so that they can be deleted before redrawing them !
    global SCATTER_POINT_SIZE
    global global_splines_data;
    
    syms x;
    
    xx_lim_ONE = [Pn(1,1) - 1 Pn(2,1)];
    xx_ONE = linspace(xx_lim(1,1),xx_lim_ONE(1,2));
    yy_ONE = subs(y_ONE, x, xx_ONE);
    plottedPiecewiseSplines{1} = plot(xx_ONE, yy_ONE, spline_colors{1});
    
    hold on
    xx_lim_TWO = [Pn(2,1) Pn(3,1)];
    xx_TWO = linspace(xx_lim_TWO(1,1),xx_lim_TWO(1,2));
    yy_TWO = subs(y_TWO, x, xx_TWO);
    plottedPiecewiseSplines{2} = plot(xx_TWO, yy_TWO, spline_colors{2});

    xx_lim_THREE = [Pn(3,1) Pn(4,1)];
    xx_THREE = linspace(xx_lim_THREE(1,1),xx_lim_THREE(1,2));
    yy_THREE = subs(y_THREE, x, xx_THREE);
    plottedPiecewiseSplines{3} = plot(xx_THREE, yy_THREE, spline_colors{3});

    pointLabels = plotPointsAndLabels(Pn, points_labels, isAdditionalSpline)
    plottedPiecewiseSplines{4} = pointLabels
end

function pointLabels = plotPointsAndLabels(Pn, points_labels, isAdditionalSpline)
    % isAdditionalSpline argument == 1 indicaten that the first point label of the
    % additional spline must be shifted in order to avoid overwritting the
    % last point initial sline label
    % isAdditionalSpline argument == 0 indicates that all points and their
    % labels can be deleted before being redrawn
    %
    % Returns pointLabels so they can be deleted before being redrawn
    global SCATTER_POINT_SIZE

    if isAdditionalSpline == 0
        delete(findobj(gca, 'type', 'scatter')); % deleting scattered points    
%        delete(findobj(gca, 'type', 'text')); % deleting point labels
        deletePointLabels(points_labels)
    end
    
    scatter(Pn(:,1),Pn(:,2),SCATTER_POINT_SIZE,'k','filled');
    
    if isAdditionalSpline == 1
        pointLabels{1} = text(Pn(1,1)-0.3, Pn(1,2)-0.3, points_labels{1});
    else
        pointLabels{1} = text(Pn(1,1)+0.1, Pn(1,2)-0.1, points_labels{1});
    end
    
    pointLabels{2} = text(Pn(2,1)+0.1, Pn(2,2)-0.1, points_labels{2});
    pointLabels{3} = text(Pn(3,1)+0.1, Pn(3,2)-0.1, points_labels{3});
    pointLabels{4} = text(Pn(4,1)+0.1, Pn(4,2)-0.1, points_labels{4});
end

function yFuncCellArray = computeAdditionalPiecewiseSpline()
    % Returns a 3 elements cell array containing piecewise splines
    % y_D, y_E and y_F functions
    
    %adding new 4 points piecewise spline
    global global_splines_data;

    Pn = [global_splines_data{1}(1,5:8)' global_splines_data{2}(1,5:8)'];

    C = [Pn(1,1)^3 Pn(1,1)^2 Pn(1,1) 1 0 0 0 0 0 0 0 0;
         Pn(2,1)^3 Pn(2,1)^2 Pn(2,1) 1 0 0 0 0 0 0 0 0;
         0 0 0 0 Pn(2,1)^3 Pn(2,1)^2 Pn(2,1) 1 0 0 0 0;
         0 0 0 0 Pn(3,1)^3 Pn(3,1)^2 Pn(3,1) 1 0 0 0 0;
         0 0 0 0 0 0 0 0 Pn(3,1)^3 Pn(3,1)^2 Pn(3,1) 1;
         0 0 0 0 0 0 0 0 Pn(4,1)^3 Pn(4,1)^2 Pn(4,1) 1;
         -3 * Pn(2,1)^2 -2 * Pn(2,1) -1 0 3 * Pn(2,1)^2 2 * Pn(2,1) 1 0 0 0 0 0;
         0 0 0 0 -3 * Pn(3,1)^2 -2 * Pn(3,1) -1 0 3 * Pn(3,1)^2 2 * Pn(3,1) 1 0;
         -6 * Pn(2,1) -2 0 0 6 * Pn(2,1) 2 0 0 0 0 0 0;
         0 0 0 0 -6 * Pn(3,1) -2 0 0 6 * Pn(3,1) 2 0 0;
         3 * Pn(1,1)^2 2 * Pn(1,1) 1 0 0 0 0 0 0 0 0 0;
         0 0 0 0 0 0 0 0 3 * Pn(4,1)^2 2 * Pn(4,1) 1 0]
    C_i = inv(C);

    Y = [Pn(1,2);
        Pn(2,2);
        Pn(2,2);
        Pn(3,2);
        Pn(3,2);
        Pn(4,2);
        0;
        0;
        0;
        0;
        -2;
        0];

    A = C_i * Y;

    syms x
    y_D = A(1,1) * x^3 + A(2,1) * x^2 + A(3,1) * x + A(4,1);
    y_E = A(5,1) * x^3 + A(6,1) * x^2 + A(7,1) * x + A(8,1);
    y_F = A(9,1) * x^3 + A(10,1) * x^2 + A(11,1) * x + A(12,1);

    yFuncCellArray{1} = y_D;
    yFuncCellArray{2} = y_E;
    yFuncCellArray{3} = y_F;

    fprintf("y_D")
    vpa(y_D)
    fprintf("y_E")
    vpa(y_E)
    fprintf("y_F")
    vpa(y_F)
end

function plotAdditionalPiecewiseSpline(yFuncCellArray)
    %adding new 4 points piecewise spline
    global SCATTER_POINT_SIZE;
    global global_splines_data;

    Pn = [global_splines_data{1}(1,5:8)' global_splines_data{2}(1,5:8)'];

    syms x
    y_D = yFuncCellArray{1};
    y_E = yFuncCellArray{2};
    y_F = yFuncCellArray{3};

    %plotting partial added piecewise curves

    points_labels = global_splines_data{10}; 
    spline_colors = global_splines_data{12}; 

    xx_lim_D = [Pn(1,1) Pn(2,1)];
    
    isAdditionalSpline = 1 % first point label will be shifted to avoid overwritting
                    % last point label of initial piecewise spline
    plottedAdditionalPiecewiseSplines = plotPartialPiecewiseSpline(Pn, xx_lim_D, y_D, y_E, y_F, points_labels, spline_colors, isAdditionalSpline);
    global_splines_data{14} = plottedAdditionalPiecewiseSplines(1:3);
    global_splines_data{16} = plottedAdditionalPiecewiseSplines(4);
end


% ui callback functions

function sliderPlot_x(hObject,event,hplot)
    global global_splines_data;
    global SCATTER_POINT_SIZE;
    
    n = get(hObject,'Value');
    
    switch global_splines_data{3}
        case 'P1'
            global_splines_data{1}(1,1) = n;
        case 'P2'
            global_splines_data{1}(1,2) = n;
        case 'P3'
            global_splines_data{1}(1,3) = n;
        case 'P4'
            global_splines_data{1}(1,4) = n;
        case 'P5'
            global_splines_data{1}(1,5) = n;
        case 'P6'
            global_splines_data{1}(1,6) = n;
        case 'P7'
            global_splines_data{1}(1,7) = n;
        case 'P8'
            global_splines_data{1}(1,8) = n;
      otherwise
            error('Invalid selection %s', global_splines_data{3})
    end
    
    xSliderValueTextUI = global_splines_data{6};
    xSliderValueTextUI.String = n;

    yFuncCellArray_A_B_C = computeFirstPiecewiseSpline();
    Pn = [global_splines_data{1}(1,1:4)' global_splines_data{2}(1,1:4)'];

    syms x
    y_A = yFuncCellArray_A_B_C{1};
    y_B = yFuncCellArray_A_B_C{2};
    y_C = yFuncCellArray_A_B_C{3};

    xx_lim = [global_splines_data{1}(1,1) - 1 global_splines_data{1}(1,8) + 1];
    points_labels = global_splines_data{9} 
    spline_colors = global_splines_data{11} 
    
    deletePartialPiecewiseSpline(global_splines_data{13});
    isAdditionalSpline = 0 % first point label will be shifted to avoid overwritting
                    % last point label of initial piecewise spline
    plottedFirstPiecewiseSplines = plotPartialPiecewiseSpline(Pn, xx_lim, y_A, y_B, y_C, points_labels, spline_colors, isAdditionalSpline)
    global_splines_data{13} = plottedFirstPiecewiseSplines(1:3);
    global_splines_data{15} = plottedFirstPiecewiseSplines(4);
    yFuncCellArray_D_E_F = computeAdditionalPiecewiseSpline()
    Pn_first = Pn
    Pn = [global_splines_data{1}(1,5:8)' global_splines_data{2}(1,5:8)'];

    syms x
    y_D = yFuncCellArray_D_E_F{1};
    y_E = yFuncCellArray_D_E_F{2};
    y_F = yFuncCellArray_D_E_F{3};
    points_labels = global_splines_data{10} 
    spline_colors = global_splines_data{12} 

    xx_lim_D = [Pn(1,1) Pn(2,1)]
    
    deletePartialPiecewiseSpline(global_splines_data{14});

    isAdditionalSpline = 1 % first point label will be shifted to avoid overwritting
                    % last point label of initial piecewise spline
    plottedFirstPiecewiseSplines = plotPartialPiecewiseSpline(Pn, xx_lim_D, y_D, y_E, y_F, points_labels, spline_colors, isAdditionalSpline)
    global_splines_data{14} = plottedFirstPiecewiseSplines(1:3);
    global_splines_data{16} = plottedFirstPiecewiseSplines(4);
end

function deletePartialPiecewiseSpline(plottedPiecewiseSplinesCell)
    elementNb = size(plottedPiecewiseSplinesCell, 2)
    
    for i = 1:elementNb
        delete(plottedPiecewiseSplinesCell{i})
    end
end

function deletePointLabels(pointLabels)
    elementNb = size(pointLabels, 2)
    
    for i = 1:elementNb
        delete(pointLabels{i})
    end
end

function sliderPlot_y(hObject,event,hplot)
    global global_splines_data;
    n = get(hObject,'Value');
    
    switch global_splines_data{3}
        case 'P1'
            global_splines_data{2}(1,1) = n;
        case 'P2'
            global_splines_data{2}(1,2) = n;
        case 'P3'
            global_splines_data{2}(1,3) = n;
        case 'P4'
            global_splines_data{2}(1,4) = n;
        case 'P5'
            global_splines_data{2}(1,5) = n;
        case 'P6'
            global_splines_data{2}(1,6) = n;
        case 'P7'
            global_splines_data{2}(1,7) = n;
        case 'P8'
            global_splines_data{2}(1,8) = n;
      otherwise
            error('Invalid selection %s', global_splines_data{3})
    end
    
    ySliderValueTextUI = global_splines_data{7};
    ySliderValueTextUI.String = n;
%    set(hplot,'ydata',global_splines_data{2});
%    drawnow;
end

function menuSelection(hObject,event)
    global global_splines_data;
    
    val = get(hObject,'Value');
    str = get(hObject,'String');
    
    % saving menu selection into global_splines_data so the two slider
    % callback functions can operate on the right point
    global_splines_data{3} = str{val};
    
    % get slider and slider text references
    xSlider = global_splines_data{4};
    xSliderTextValue = global_splines_data{6};
    ySlider = global_splines_data{5};
    ySliderTextValue = global_splines_data{7};

    switch global_splines_data{3}
        case 'P1'
            xValue = global_splines_data{1}(1,1);
            xSlider.Value = xValue;
            xSliderTextValue.String = xValue;
            
            yValue = global_splines_data{2}(1,1);
            ySlider.Value = yValue;
            ySliderTextValue.String = yValue;
        case 'P2'
            xValue = global_splines_data{1}(1,2);
            xSlider.Value = xValue;
            xSliderTextValue.String = xValue;
            
            yValue = global_splines_data{2}(1,2);
            ySlider.Value = yValue;
            ySliderTextValue.String = yValue;
        case 'P3'
            xValue = global_splines_data{1}(1,3);
            xSlider.Value = xValue;
            xSliderTextValue.String = xValue;
            
            yValue = global_splines_data{2}(1,3);
            ySlider.Value = yValue;
            ySliderTextValue.String = yValue;
        case 'P4'
            xValue = global_splines_data{1}(1,4);
            xSlider.Value = xValue;
            xSliderTextValue.String = xValue;
            
            yValue = global_splines_data{2}(1,4);
            ySlider.Value = yValue;
            ySliderTextValue.String = yValue;
        case 'P5'
            xValue = global_splines_data{1}(1,5);
            xSlider.Value = xValue;
            xSliderTextValue.String = xValue;
            
            yValue = global_splines_data{2}(1,5);
            ySlider.Value = yValue;
            ySliderTextValue.String = yValue;
        case 'P6'
            xValue = global_splines_data{1}(1,6);
            xSlider.Value = xValue;
            xSliderTextValue.String = xValue;
            
            yValue = global_splines_data{2}(1,6);
            ySlider.Value = yValue;
            ySliderTextValue.String = yValue;
        case 'P7'
            xValue = global_splines_data{1}(1,7);
            xSlider.Value = xValue;
            xSliderTextValue.String = xValue;
            
            yValue = global_splines_data{2}(1,7);
            ySlider.Value = yValue;
            ySliderTextValue.String = yValue;
        case 'P8'
            xValue = global_splines_data{1}(1,8);
            xSlider.Value = xValue;
            xSliderTextValue.String = xValue;
            
            yValue = global_splines_data{2}(1,8);
            ySlider.Value = yValue;
            ySliderTextValue.String = yValue;
      otherwise
            error('Invalid selection %s', global_splines_data{3})
    end
end
