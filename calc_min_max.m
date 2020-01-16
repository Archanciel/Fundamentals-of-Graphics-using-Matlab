global global_splines_data;% {1} --> curve points x coordinates
                           % {2} --> curve points y coordinates
                           % {3} --> current menu selection value 
                           % {4} --> x slider reference 
                           % {5} --> y slider reference 
                           % {6} --> x slider text value reference 
                           % {7} --> y slider text value reference 
                           % {8} --> NO LONGER USED !
                           % {9} --> initial piecewise spline points_labels strings
                           % {10} --> additional piecewise spline points_labels strings
                           % {11} --> initial piecewise spline colors
                           % {12} --> additional piecewise spline colors
                           % {13} --> first piecewise spline line handles
                           % {14} --> additional piecewise spline line handles
                           % {15} --> initial piecewise spline point label handles
                           % {16} --> additional piecewise spline point label handles

% piecewise splines points initial coordinates

p1 = [0 1];
p2 = [2 2];
p3 = [5 0];
p4 = [8 0];

P_1_4 = [p1;p2;p3;p4]

%added piecewise spline points. Must be located here so plot x axis limit
%can account for p8 x value !
p5 = [8 0];
p6 = [12 -1];
p7 = [12 3];
p8 = [12 5];
P_5_8 = [p5;p6;p7;p8]

% initializing the global spline_data variable (for use by ui callback functions)
global_splines_data{1} = [P_1_4(:,1)' P_5_8(:,1)']; % curve points x coordinates
global_splines_data{2} = [P_1_4(:,2)' P_5_8(:,2)']; % curve points y coordinates

global MIN_X
global MAX_X
global MIN_Y
global MAX_Y

MIN_X = -1;
MAX_X = 18;
MIN_Y = -10;
MAX_Y = 10;
global_splines_data{1}

%{
for i = 1:8
    i
    mm = getMinMaxX(i)
end
%}
i = 4
[minX maxX] = getMinMaxX(i)
i = 5
[minX maxX] = getMinMaxX(i)
i = 7
[minX maxX] = getMinMaxX(i)

function [minX maxX] = getMinMaxX(pointIndex)
    global MIN_X
    global MAX_X
    global global_splines_data; 
    
    currentX = global_splines_data{1}(1, pointIndex);
        
    if pointIndex == 1
        minX = MIN_X;
    else    
        prevPointX = global_splines_data{1}(1, pointIndex - 1) + 1;
        minX = min(prevPointX, currentX);
    end
      
    if pointIndex == 8
        maxX = MAX_X;
    else
        nextPointX = global_splines_data{1}(1, pointIndex + 1) - 1;
        maxX = max(nextPointX, currentX);
    end
end    