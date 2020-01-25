classdef SplineController < handle
    % inheriting from handle in order for instances to be passed by reference
    properties
        % constants
        % none !
        
        splineModel;
    end
    methods
        function obj = SplineController(splineModel)
            obl.splineModel = splineModel;
        end
    end
end