classdef SplineController < handle
    % inheriting from handle in order for instances to be passed by reference
    properties
        % constants
        % none !
        
        splineModel;
        splineView; % set in SplineAppCreator !
    end
    methods
        function obj = SplineController(splineModel)
            obj.splineModel = splineModel;
        end
    end
end