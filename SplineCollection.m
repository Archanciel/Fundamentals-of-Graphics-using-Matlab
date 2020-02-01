classdef SplineCollection < handle
    % inheriting from handle in order for instances to be passed by reference
    properties
        % constants
        % none !        

        splineModelCellVector;
        splineStartSlope;
        splineEndSlope;
    end
    methods
        function obj = SplineCollection(splineStartSlope,...
                                        splineEndSlope)
            obj.splineStartSlope = splineStartSlope;
            obj.splineEndSlope = splineEndSlope;
        end
        function addSplineModel(obj, splineModel)
            currentSplineModelNumber = length(obj.splineModelCellVector);
            currentIndex = currentSplineModelNumber + 1;
            obj.splineModelCellVector{currentIndex} = splineModel;
            splineModel.splineModelName = num2str(currentIndex);
        end
        function splineNumber = getSplineNumber(obj)
            splineNumber = length(obj.splineModelCellVector);
        end
        function splineModel = getSplineModel(obj, i)
            splineModel = obj.splineModelCellVector{i};
        end
        function [xAxisMin, xAxisMax] = getXAxisLimits(obj)
            startSplineModel = obj.getSplineModel(1);
            endSplineModel = obj.getSplineModel(length(obj.splineModelCellVector));
            
            xAxisMin = startSplineModel.splineXpointCoordVector(1, 1) - 1; 
            xAxisMax = endSplineModel.splineXpointCoordVector(1, end) + 1;
        end
    end
end
