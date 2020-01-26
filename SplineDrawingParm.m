classdef SplineDrawingParm < handle
    % inheriting from handle in order for instances to be passed by reference
    properties
        % constants
        % none !
        splinePointLabelStrCellVector;
        splineColorCellVector;
        splineLineHandleVector;
        splinePointLabelHandleVector;
        splineScatteredPointHandleVector;
    end
    methods
        function obj = SplineDrawingParm(splinePointLabelStrCellVector,...
                                         splineColorCellVector)
            obj.splinePointLabelStrCellVector = splinePointLabelStrCellVector;
            obj.splineColorCellVector = splineColorCellVector;
        end
    end
end