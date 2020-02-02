classdef SplineUIData < handle
    % Inheriting from handle in order for instances to be passed by
    % referenceo
    %
    % Holds UI only data used by the SplineView class to plot the spline
    properties
        % constants
        % none !
        splinePointLabelStrCellArray; % filled by SplineView
        splineColorCellArray;         % obtained from the related SplineModel
        splineLineHandleCellArray;
        splinePointLabelHandleArray;
        splineScatteredPointHandleArray;
    end
    methods
        function obj = SplineUIData()
        end
    end
end