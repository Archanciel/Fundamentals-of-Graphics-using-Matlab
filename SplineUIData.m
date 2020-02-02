classdef SplineUIData < handle
    % inheriting from handle in order for instances to be passed by reference
    properties
        % constants
        % none !
        splinePointLabelStrCellVector;
        splineColorCellVector;
        splineLineHandleCellVector;
        splinePointLabelHandleVector;
        splineScatteredPointHandleVector;
    end
    methods
        function obj = SplineUIData(splinePointLabelStrCellVector,...
                                    splineColorCellVector)
            obj.splinePointLabelStrCellVector = splinePointLabelStrCellVector;
            obj.splineColorCellVector = splineColorCellVector;
        end
    end
end