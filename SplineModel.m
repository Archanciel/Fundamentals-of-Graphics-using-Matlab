classdef SplineModel < handle
    % inheriting from handle in order for instances to be passed by reference
    properties
        % constants
        % none !
        

        splineXpointCoordVector;
        splineYpointCoordVector;
    end
    methods
        function obj = SplineModel(splinePointVector)
            % setting X and Y coordinates vector                            
            obj.splineXpointCoordVector = [splinePointVector(:,1)'];
            obj.splineYpointCoordVector = [splinePointVector(:,2)'];
        end
    end
end