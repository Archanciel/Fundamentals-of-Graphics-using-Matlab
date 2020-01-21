clear all

global uiData; % must be declared as global variable since this is the unique
               % the popupmenu callback function can acess to it ! In other
               % calbacks, uiData is passed as argument to the function.
uiData = UIControlsData();

global splineData; % must be declared as global variable since this is the unique
                   % the popupmenu callback function can acess to it ! In other
                   % calbacks, uiData is passed as argument to the function.
splineData = SplineData();

points_labels{1} = 'P_1';
points_labels{2} = 'P_2';
points_labels{3} = 'P_3';
points_labels{4} = 'P_4';
splineData.splinePointLabelStrVector = points_labels;

clear points_labels

points_labels{1} = 'P_5';
points_labels{2} = 'P_6';
points_labels{3} = 'P_7';
points_labels{4} = 'P_8';
splineData.additionalSplinePointLabelStrVector = points_labels;

spline_colors{1} = 'b';
spline_colors{2} = 'r';
spline_colors{3} = 'm';
splineData.splineColorVector = spline_colors;

clear spline_colors
spline_colors{1} = 'k';
spline_colors{2} = 'r';
spline_colors{3} = 'g';
splineData.additionalSplineColorVector = spline_colors;

% piecewise splines points initial coordinates

p1 = [0 1];
p2 = [2 2];
p3 = [5 0];
p4 = [8 0];

P_1_4 = [p1;p2;p3;p4];

%added piecewise spline points. Must be located here so plot x axis limit
%can account for p8 x value !
p5 = [8 0];
p6 = [9 -1];
p7 = [10 3];
p8 = [11 2];
P_5_8 = [p5;p6;p7;p8];

% initializing the global spline_data variable (for use by ui callback functions)
splineData.splineXpointCoordVector = [P_1_4(:,1)' P_5_8(:,1)']; % curve points x coordinates
splineData.splineYpointCoordVector = [P_1_4(:,2)' P_5_8(:,2)']; % curve points y coordinates
uiData.pointMenuCurrentSelection = 'P1';   % initial value of menu 

yFuncCellArray = computeFirstPiecewiseSpline(splineData);
plotFirstPiecewiseSpline(yFuncCellArray, uiData, splineData);

yFuncCellArray = computeAdditionalPiecewiseSpline(splineData);
plotAdditionalPiecewiseSpline(yFuncCellArray, uiData, splineData);
addUI(uiData, splineData);

function addUI(uiData, splineData)
    % Adds UI controls
    
    SLIDER_POS_X = 150;
    MENU_POS_X = 70;

    [xSliderMin xSliderMax] = getMinMaxX(1, uiData, splineData);
    yMin = -10;
    yMax = 10;

    xSlider = uicontrol('style','slider','units','pixel','position',[SLIDER_POS_X 20 300 20],...
        'sliderstep',[uiData.XY_SLIDER_STEP/(xSliderMax-xSliderMin), uiData.XY_SLIDER_STEP * 5/(xSliderMax-xSliderMin)],'max',xSliderMax,'min',xSliderMin, 'value',splineData.splineXpointCoordVector(1,1));
    addlistener(xSlider,'ContinuousValueChange',@(hObject, event) sliderPlot_x(hObject, event, uiData, splineData));
    uiData.xSliderHandle = xSlider; % required so that menu selection can update the curve point impacted by the x slider 
    uicontrol('style','text',...
        'position',[SLIDER_POS_X - 10 30 10 10],'string', 'X');
    xValueText = uicontrol('Style','text','Position',[SLIDER_POS_X + 302,25,20,15],...
                'String',splineData.splineXpointCoordVector(1,1), 'BackgroundColor', 'w');
    uiData.xSliderTextValueHandle = xValueText; % required so that the x slider can update its displayed value

    % slider controlling y coordinates
    ySlider = uicontrol('style','slider','units','pixel','position',[SLIDER_POS_X 0 300 20],...
        'sliderstep',[uiData.XY_SLIDER_STEP/(yMax-yMin), uiData.XY_SLIDER_STEP * 5/(yMax-yMin)],'max',yMax,'min',yMin, 'value',splineData.splineYpointCoordVector(1,1));
    uiData.ySliderHandle = ySlider; % required so that menu selection can update the curve point impacted by the y slider 
    addlistener(ySlider,'ContinuousValueChange',@(hObject, event) sliderPlot_y(hObject, event, uiData, splineData));
    uicontrol('style','text',...
        'position',[SLIDER_POS_X - 10 10 10 10],'string', 'Y');
    yValueText = uicontrol('Style','text','Position',[SLIDER_POS_X + 302,5,20,15],...
                'String',splineData.splineYpointCoordVector(1,1), 'BackgroundColor', 'w');
    uiData.ySliderTextValueHandle = yValueText; % required so that the y slider can update its displayed value

    % drop down menu to select which point is modified by the sliders
    % since two separate piecewise spines are used, P4 and P5 can not be modified
    % through the UI !
    menu = uicontrol('Style','popupmenu',...
        'position', [MENU_POS_X 20 60 20], 'string', {'P1','P2','P3','P6','P7','P8'});
%    menu = uicontrol('Style','popupmenu',...
%        'position', [MENU_POS_X 20 60 20], 'string', {'P1','P2','P3','P4','P5','P6','P7','P8'});
    menu.Callback = @menuSelection;
    addlistener(menu,'ContinuousValueChange',@(hObject, event) sliderPlot_y(hObject, event));
end

function [minX maxX] = getMinMaxX(pointIndex, uiData, splineData)
    [xAxisMin, xAxisMax] = getXAxisLimits(splineData);
    currentX = splineData.splineXpointCoordVector(1, pointIndex);
        
    if pointIndex == 1
        minX = xAxisMin;
    else    
        prevPointX = splineData.splineXpointCoordVector(1, pointIndex - 1) + uiData.XY_SLIDER_STEP;
        minX = min(prevPointX, currentX);
    end
      
    if pointIndex == 8
        maxX = xAxisMax;
    else
        nextPointX = splineData.splineXpointCoordVector(1, pointIndex + 1) - uiData.XY_SLIDER_STEP;
        maxX = max(nextPointX, currentX);
    end
end 

function yFuncCellArray = computeFirstPiecewiseSpline(splineData)
    % Returns a 3 elements cell array containing piecewise splines
    % y_A, y_B and y_C functions
    
    Pn = [splineData.splineXpointCoordVector(1,1:4)' splineData.splineYpointCoordVector(1,1:4)'];

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
         0 0 0 0 0 0 0 0 3 * Pn(4,1)^2 2 * Pn(4,1) 1 0];
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
end

function plotFirstPiecewiseSpline(yFuncCellArray, uiData, splineData)
    Pn = [splineData.splineXpointCoordVector(1,1:4)' splineData.splineYpointCoordVector(1,1:4)'];

    syms x
    y_A = yFuncCellArray{1};
    y_B = yFuncCellArray{2};
    y_C = yFuncCellArray{3};

    %plotting
    close all
    figure

    %plotting partial initial piecewise curves
    
    isAdditionalSpline = 0; % first point label will be shifted to avoid overwritting
                            % last point label of initial piecewise spline
    plottedFirstPiecewiseSplines = plotPartialPiecewiseSpline(uiData,...
                                                              Pn,...
                                                              y_A,...
                                                              y_B,...
                                                              y_C,...
                                                              splineData,...
                                                              isAdditionalSpline);
    splineData.splineLineHandleVector = plottedFirstPiecewiseSplines;
    
    xlabel('x');
    ylabel('y');
    title(["Piecewise spline + 1" "standard form - " "partial curves"]);

    [xAxisMin, xAxisMax] = getXAxisLimits(splineData);
    
    set(gca,'ylim',[-5 10],'xlim',[xAxisMin xAxisMax],'xtick',xAxisMin:xAxisMax,'ytick',-5:10)
    opt.fontname = 'helvetica';
    opt.fontsize = 8;

    centeraxes(gca,opt);
end

function [xAxisMin, xAxisMax] = getXAxisLimits(splineData)
    xAxisMin = splineData.splineXpointCoordVector(1,1) - 1; 
    xAxisMax = splineData.splineXpointCoordVector(1,8) + 1;
end

function plottedPiecewiseSplines = plotPartialPiecewiseSpline(uiData,...
                                                              Pn,...
                                                              y_ONE,...
                                                              y_TWO,...
                                                              y_THREE,...
                                                              splineData,...
                                                              isAdditionalSpline)
    %Returns handles on the plotted piecewise splines
    %so that they can be deleted before redrawing them !
    syms x;

    if isAdditionalSpline == 0
        points_labels = splineData.splinePointLabelStrVector; 
        spline_colors = splineData.splineColorVector; 
    else
        points_labels = splineData.additionalSplinePointLabelStrVector; 
        spline_colors = splineData.additionalSplineColorVector; 
    end

    if isAdditionalSpline == 0
        xx_ONE = linspace(Pn(1,1) - 1, Pn(2,1));
        yy_ONE = subs(y_ONE, x, xx_ONE);
    else
        xx_ONE = linspace(Pn(1,1), Pn(2,1));
        yy_ONE = subs(y_ONE, x, xx_ONE);
    end
    
    plottedPiecewiseSplines{1} = plot(xx_ONE, yy_ONE, spline_colors{1});
    
    hold on
    xx_lim_TWO = [Pn(2,1) Pn(3,1)];
    xx_TWO = linspace(xx_lim_TWO(1,1),xx_lim_TWO(1,2));
    yy_TWO = subs(y_TWO, x, xx_TWO);
    plottedPiecewiseSplines{2} = plot(xx_TWO, yy_TWO, spline_colors{2});

    if isAdditionalSpline == 0
        xx_THREE = linspace(Pn(3,1), Pn(4,1));
        yy_THREE = subs(y_THREE, x, xx_THREE);
    else
        xx_THREE = linspace(Pn(3,1), Pn(4,1) + 1);
        yy_THREE = subs(y_THREE, x, xx_THREE);
    end
    
    plottedPiecewiseSplines{3} = plot(xx_THREE, yy_THREE, spline_colors{3});

    if isAdditionalSpline == 0
        pointLabelHandlesToDelete = splineData.splinePointLabelHandleVector;
    else
        pointLabelHandlesToDelete = splineData.additionalSplinePointLabelHandleVector;
    end
    
    if isAdditionalSpline == 0
        scatteredPointHandleToDelete = splineData.splineScatteredPointHandleVector;
    else
        scatteredPointHandleToDelete = splineData.additionalSplineScatteredPointHandleVector;
    end

    [newPointLabelHandles, newScatteredPointHandle] = plotPointsAndLabels(uiData,...
                                                                          Pn,... 
                                                                          points_labels,...
                                                                          isAdditionalSpline,...
                                                                          pointLabelHandlesToDelete,...
                                                                          scatteredPointHandleToDelete);
    
    if isAdditionalSpline == 0
        splineData.splinePointLabelHandleVector = newPointLabelHandles;
        splineData.splineScatteredPointHandleVector = newScatteredPointHandle;
    else
        splineData.additionalSplinePointLabelHandleVector = newPointLabelHandles;
        splineData.additionalSplineScatteredPointHandleVector = newScatteredPointHandle;
    end
end

function [newPointLabelHandles, newScatteredPointHandle] = plotPointsAndLabels(uiData,...
                                                                               Pn,...
                                                                               pointsLabelStrings,...
                                                                               isAdditionalSpline,...
                                                                               pointsLabelHandles,...
                                                                               scatteredPointsHandle)
    % isAdditionalSpline argument == 1 indicaten that the first point label of the
    % additional spline must be shifted in order to avoid overwritting the
    % last point initial sline label
    %
    % Returns newPointLabelHandles so they can be deleted before being redrawn
    % and newSscatteredPointHandle which hosts the handle returned by the scatter
    % function

    deleteScatteredPoints(scatteredPointsHandle);
    deletePointLabels(pointsLabelHandles);
    
    newScatteredPointHandle = scatter(Pn(:,1),Pn(:,2),uiData.SCATTER_POINT_SIZE,'k','filled');
    
    if isAdditionalSpline == 1
        % in this case, the point label is written in a shifted position
        % in order to avoid overwrittinf the initial spline last point
        % label since the two points share the same x-y coordinates
        newPointLabelHandles{1} = text(Pn(1,1)-0.3, Pn(1,2)-0.3, pointsLabelStrings{1});
    else
        newPointLabelHandles{1} = text(Pn(1,1)+0.1, Pn(1,2)-0.1, pointsLabelStrings{1});
    end
    
    newPointLabelHandles{2} = text(Pn(2,1)+0.1, Pn(2,2)-0.1, pointsLabelStrings{2});
    newPointLabelHandles{3} = text(Pn(3,1)+0.1, Pn(3,2)-0.1, pointsLabelStrings{3});
    newPointLabelHandles{4} = text(Pn(4,1)+0.1, Pn(4,2)-0.1, pointsLabelStrings{4});
end

function yFuncCellArray = computeAdditionalPiecewiseSpline(splineData)
    % Returns a 3 elements cell array containing piecewise splines
    % y_D, y_E and y_F functions
    
    %adding new 4 points piecewise spline

    Pn = [splineData.splineXpointCoordVector(1,5:8)' splineData.splineYpointCoordVector(1,5:8)'];

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
         0 0 0 0 0 0 0 0 3 * Pn(4,1)^2 2 * Pn(4,1) 1 0];
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
end

function plotAdditionalPiecewiseSpline(yFuncCellArray, uiData, splineData)
    %adding new 4 points piecewise spline

    Pn = [splineData.splineXpointCoordVector(1,5:8)' splineData.splineYpointCoordVector(1,5:8)'];

    syms x;
    y_D = yFuncCellArray{1};
    y_E = yFuncCellArray{2};
    y_F = yFuncCellArray{3};

    %plotting partial added piecewise curves
    
    isAdditionalSpline = 1;% first point label will be shifted to avoid overwritting
                           % last point label of initial piecewise spline
    plottedAdditionalPiecewiseSplines = plotPartialPiecewiseSpline(uiData,...
                                                                   Pn,...
                                                                   y_D,...
                                                                   y_E,...
                                                                   y_F,...
                                                                   splineData,...
                                                                   isAdditionalSpline);
    splineData.additionalSplineLineHandleVector = plottedAdditionalPiecewiseSplines;
end


% ui callback functions

function sliderPlot_x(hObject, event, uiData, splineData)
    n = get(hObject,'Value');
    
    switch uiData.pointMenuCurrentSelection
        case 'P1'
            splineData.splineXpointCoordVector(1,1) = n;
        case 'P2'
            splineData.splineXpointCoordVector(1,2) = n;
        case 'P3'
            splineData.splineXpointCoordVector(1,3) = n;
        case 'P4'
            splineData.splineXpointCoordVector(1,4) = n;
        case 'P5'
            splineData.splineXpointCoordVector(1,5) = n;
        case 'P6'
            splineData.splineXpointCoordVector(1,6) = n;
        case 'P7'
            splineData.splineXpointCoordVector(1,7) = n;
        case 'P8'
            splineData.splineXpointCoordVector(1,8) = n;
      otherwise
            error('Invalid selection %s', uiData.pointMenuCurrentSelection);
    end
    
    xSliderValueTextUI = uiData.xSliderTextValueHandle;
    xSliderValueTextUI.String = n;

    yFuncCellArray_A_B_C = computeFirstPiecewiseSpline(splineData);
    Pn = [splineData.splineXpointCoordVector(1,1:4)' splineData.splineYpointCoordVector(1,1:4)'];

    syms x
    y_A = yFuncCellArray_A_B_C{1};
    y_B = yFuncCellArray_A_B_C{2};
    y_C = yFuncCellArray_A_B_C{3};
    
    deletePartialPiecewiseSpline(splineData.splineLineHandleVector);
    isAdditionalSpline = 0; % first point label will be shifted to avoid overwritting
                            % last point label of initial piecewise spline
    plottedFirstPiecewiseSplines = plotPartialPiecewiseSpline(uiData,...
                                                              Pn,...
                                                              y_A,...
                                                              y_B,...
                                                              y_C,...
                                                              splineData,...
                                                              isAdditionalSpline);
    splineData.splineLineHandleVector = plottedFirstPiecewiseSplines;
    yFuncCellArray_D_E_F = computeAdditionalPiecewiseSpline(splineData);
    Pn_first = Pn;
    Pn = [splineData.splineXpointCoordVector(1,5:8)' splineData.splineYpointCoordVector(1,5:8)'];

    syms x;
    y_D = yFuncCellArray_D_E_F{1};
    y_E = yFuncCellArray_D_E_F{2};
    y_F = yFuncCellArray_D_E_F{3};
    
    deletePartialPiecewiseSpline(splineData.additionalSplineLineHandleVector);

    isAdditionalSpline = 1;% first point label will be shifted to avoid overwritting
                           % last point label of initial piecewise spline
    plottedFirstPiecewiseSplines = plotPartialPiecewiseSpline(uiData,...
                                                              Pn,...
                                                              y_D,...
                                                              y_E,...
                                                              y_F,...
                                                              splineData,...
                                                              isAdditionalSpline);
    splineData.additionalSplineLineHandleVector = plottedFirstPiecewiseSplines;
end

function deletePartialPiecewiseSpline(plottedPiecewiseSplinesCell)
    elementNb = size(plottedPiecewiseSplinesCell, 2);
    
    for i = 1:elementNb
        delete(plottedPiecewiseSplinesCell{i});
    end
end

function deletePointLabels(pointLabelHandels)
    elementNb = size(pointLabelHandels, 2);
    
    for i = 1:elementNb
        delete(pointLabelHandels{i});
    end
end

function deleteScatteredPoints(scatteredPointsHandle)
    % scatteredPointsHandle hosts the handle returned by the scatter
    % function
    elementNb = size(scatteredPointsHandle, 2);
    
    if elementNb > 0
        delete(scatteredPointsHandle);
    end
end

function sliderPlot_y(hObject,event, uiData, splineData)
    n = get(hObject,'Value');
    
    switch uiData.pointMenuCurrentSelection
        case 'P1'
            splineData.splineYpointCoordVector(1,1) = n;
        case 'P2'
            splineData.splineYpointCoordVector(1,2) = n;
        case 'P3'
            splineData.splineYpointCoordVector(1,3) = n;
        case 'P4'
            splineData.splineYpointCoordVector(1,4) = n;
        case 'P5'
            splineData.splineYpointCoordVector(1,5) = n;
        case 'P6'
            splineData.splineYpointCoordVector(1,6) = n;
        case 'P7'
            splineData.splineYpointCoordVector(1,7) = n;
        case 'P8'
            splineData.splineYpointCoordVector(1,8) = n;
      otherwise
            error('Invalid selection %s', uiData.pointMenuCurrentSelection)
    end
    
    ySliderValueTextUI = uiData.ySliderTextValueHandle;
    ySliderValueTextUI.String = n;

    yFuncCellArray_A_B_C = computeFirstPiecewiseSpline(splineData);
    Pn = [splineData.splineXpointCoordVector(1,1:4)' splineData.splineYpointCoordVector(1,1:4)'];

    syms x
    y_A = yFuncCellArray_A_B_C{1};
    y_B = yFuncCellArray_A_B_C{2};
    y_C = yFuncCellArray_A_B_C{3};
    
    deletePartialPiecewiseSpline(splineData.splineLineHandleVector);
    isAdditionalSpline = 0; % first point label will be shifted to avoid overwritting
                            % last point label of initial piecewise spline
    plottedFirstPiecewiseSplines = plotPartialPiecewiseSpline(uiData,...
                                                              Pn,...
                                                              y_A,...
                                                              y_B,...
                                                              y_C,...
                                                              splineData,...
                                                              isAdditionalSpline);
    splineData.splineLineHandleVector = plottedFirstPiecewiseSplines;
    yFuncCellArray_D_E_F = computeAdditionalPiecewiseSpline(splineData);
    Pn_first = Pn;
    Pn = [splineData.splineXpointCoordVector(1,5:8)' splineData.splineYpointCoordVector(1,5:8)'];

    syms x;
    y_D = yFuncCellArray_D_E_F{1};
    y_E = yFuncCellArray_D_E_F{2};
    y_F = yFuncCellArray_D_E_F{3};
    
    deletePartialPiecewiseSpline(splineData.additionalSplineLineHandleVector);

    isAdditionalSpline = 1;% first point label will be shifted to avoid overwritting
                           % last point label of initial piecewise spline
    plottedFirstPiecewiseSplines = plotPartialPiecewiseSpline(uiData,...
                                                              Pn,...
                                                              y_D,...
                                                              y_E,...
                                                              y_F,...
                                                              splineData,...
                                                              isAdditionalSpline);
    splineData.additionalSplineLineHandleVector = plottedFirstPiecewiseSplines;
end

function updateSliderXProperties(slider, sliderTextValue, pointIndex, uiData, splineData)
    [xSliderMin xSliderMax] = getMinMaxX(pointIndex, uiData, splineData);
    slider.Max = xSliderMax;
    slider.Min = xSliderMin;
    slider.SliderStep = [uiData.XY_SLIDER_STEP/(xSliderMax-xSliderMin), uiData.XY_SLIDER_STEP * 5/(xSliderMax-xSliderMin)];
    xValue = splineData.splineXpointCoordVector(1,pointIndex);
    slider.Value = xValue;
    sliderTextValue.String = xValue;
end

function menuSelection(hObject, event)
    global uiData;
    global splineData
    
    val = get(hObject,'Value');
    str = get(hObject,'String');
    
    % saving menu selection into uiData so the two slider
    % callback functions can operate on the right point
    uiData.pointMenuCurrentSelection = str{val};
    
    % get slider and slider text references
    xSlider = uiData.xSliderHandle;
    xSliderTextValue = uiData.xSliderTextValueHandle;
    ySlider = uiData.ySliderHandle;
    ySliderTextValue = uiData.ySliderTextValueHandle;

    switch uiData.pointMenuCurrentSelection
        case 'P1'
            updateSliderXProperties(xSlider, xSliderTextValue, 1, uiData, splineData)
            
            yValue = splineData.splineYpointCoordVector(1,1);
            ySlider.Value = yValue;
            ySliderTextValue.String = yValue;
        case 'P2'
            updateSliderXProperties(xSlider, xSliderTextValue, 2, uiData, splineData)
            
            yValue = splineData.splineYpointCoordVector(1,2);
            ySlider.Value = yValue;
            ySliderTextValue.String = yValue;
        case 'P3'
            updateSliderXProperties(xSlider, xSliderTextValue, 3, uiData, splineData)
            
            yValue = splineData.splineYpointCoordVector(1,3);
            ySlider.Value = yValue;
            ySliderTextValue.String = yValue;
        case 'P4'
            updateSliderXProperties(xSlider, xSliderTextValue, 4, uiData, splineData)
            
            yValue = splineData.splineYpointCoordVector(1,4);
            ySlider.Value = yValue;
            ySliderTextValue.String = yValue;
        case 'P5'
            updateSliderXProperties(xSlider, xSliderTextValue, 5, uiData, splineData)
            
            yValue = splineData.splineYpointCoordVector(1,5);
            ySlider.Value = yValue;
            ySliderTextValue.String = yValue;
        case 'P6'
            updateSliderXProperties(xSlider, xSliderTextValue, 6, uiData, splineData)
            
            yValue = splineData.splineYpointCoordVector(1,6);
            ySlider.Value = yValue;
            ySliderTextValue.String = yValue;
        case 'P7'
            updateSliderXProperties(xSlider, xSliderTextValue, 7, uiData, splineData)
            
            yValue = splineData.splineYpointCoordVector(1,7);
            ySlider.Value = yValue;
            ySliderTextValue.String = yValue;
        case 'P8'
            updateSliderXProperties(xSlider, xSliderTextValue, 8, uiData, splineData)
            
            yValue = splineData.splineYpointCoordVector(1,8);
            ySlider.Value = yValue;
            ySliderTextValue.String = yValue;
      otherwise
            error('Invalid selection %s', uiData.pointMenuCurrentSelection);
    end
end
