classdef UIControlsData < handle
    % inheriting from handle in order for instances to be passed by reference
    properties
        % constants
        SCATTER_POINT_SIZE = 15;
        XY_SLIDER_STEP = 0.1;
        PLOT_RESOLUTION = 100; % linspace 3rd param
        
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