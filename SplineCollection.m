classdef SplineCollection < handle
    % inheriting from handle in order for instances to be passed by reference
    properties
        % constants
        % none !        

        splineModelCellArray;
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
            currentSplineModelNumber = length(obj.splineModelCellArray);
            currentIndex = currentSplineModelNumber + 1;
            obj.splineModelCellArray{currentIndex} = splineModel;
            splineModel.splineModelName = num2str(currentIndex);
        end
        function splineNumber = getSplineNumber(obj)
            splineNumber = length(obj.splineModelCellArray);
        end
        function splineModel = getSplineModel(obj, i)
            splineModel = obj.splineModelCellArray{i};
        end
        function splineNamesCellArray = getSplineNamesCellArray(obj)
            splineNumber = obj.getSplineNumber();
            splineNamesCellArray = cell(1,splineNumber);
            
            for i = 1:splineNumber
                splineModel = obj.splineModelCellArray{i};
                splineNamesCellArray{i} = splineModel.splineModelName ;
            end
        end
        function [xAxisMin, xAxisMax] = getXAxisLimits(obj)
            startSplineModel = obj.getSplineModel(1);
            endSplineModel = obj.getSplineModel(length(obj.splineModelCellArray));
            
            xAxisMin = startSplineModel.splineXpointCoordVector(1, 1) - 1; 
            xAxisMax = endSplineModel.splineXpointCoordVector(1, end) + 1;
        end
    end
end
