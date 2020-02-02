classdef SplineUIData < handle
    % inheriting from handle in order for instances to be passed by reference
    properties
        % constants
        % none !
        splinePointLabelStrCellArray;
        splineColorCellArray;
        splineLineHandleCellArray;
        splinePointLabelHandleArray;
        splineScatteredPointHandleArray;
    end
    methods
        function obj = SplineUIData()
        end
    end
end