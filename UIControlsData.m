                           % {1} --> curve points x coordinates
                           % {2} --> curve points y coordinates
                           % {3} current menu selection value 
                           % {4} x slider reference 
                           % {5} y slider reference 
                           % {6} x slider text value reference 
                           % {7} y slider text value reference 
                           % {8} --> NO LONGER USED !
                           % {9} --> initial piecewise spline points_labels strings
                           % {10} --> additional piecewise spline points_labels strings
                           % {11} --> initial piecewise spline colors
                           % {12} --> additional piecewise spline colors
                           % {13} --> initial piecewise spline line handles
                           % {14} --> additional piecewise spline line handles
                           % {15} --> initial piecewise spline point label handles
                           % {16} --> additional piecewise spline point label handles
                           % {17} --> initial piecewise spline scattered point handles
                           % {18} --> additional piecewise spline scattered point handles
classdef UIControlsData < handle
    % inheriting from handle in order for instances to be passed by reference
    properties
        % constants
        SCATTER_POINT_SIZE = 15;
        XY_SLIDER_STEP = 0.1;
        
        pointMenuCurrentSelection;
        xSliderHandle;
        ySliderHandle;
        xSliderTextValueHandle;
        ySliderTextValueHandle;
    end
    methods
        function obj = UIControlsData()
            obj.pointMenuCurrentSelection = 'P1';
        end
        
        % using property setter (similar to python @property annotaton)
        function obj = set.pointMenuCurrentSelection(obj, value)
             obj.pointMenuCurrentSelection = value;
        end
        
        function obj = set.xSliderHandle(obj, value)
             obj.xSliderHandle = value;
        end
        
        function obj = set.ySliderHandle(obj, value)
             obj.ySliderHandle = value;
        end
        
        function obj = set.xSliderTextValueHandle(obj, value)
             obj.xSliderTextValueHandle = value;
        end
        
        function obj = set.ySliderTextValueHandle(obj, value)
             obj.ySliderTextValueHandle = value;
        end
    end
end