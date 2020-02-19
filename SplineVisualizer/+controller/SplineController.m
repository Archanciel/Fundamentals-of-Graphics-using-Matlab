classdef SplineController < handle
    % inheriting from handle in order for instances to be passed by reference
    properties
        % constants
        % none !
        
        splineCollection              model.SplineCollection;
        splineView                    view.SplineView; % set in SplineAppCreator !
    end
    methods
        function obj = SplineController(splineCollection)
            obj.splineCollection = splineCollection;
        end
    end
end