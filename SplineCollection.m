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
            % Returns the minimum and maximum x value that can be set to a 
            % point. Min x is the x value of the left most point of the
            % first piecewise spline. Max x is the x value of the right 
            % most point of the last piecewise spline. 
            startSplineModel = obj.getSplineModel(1);
            endSplineModel = obj.getSplineModel(length(obj.splineModelCellArray));
            
            xAxisMin = startSplineModel.splineXpointCoordVector(1, 1) - 1; 
            xAxisMax = endSplineModel.splineXpointCoordVector(1, end) + 1;
        end

        function [minX, maxX] = getMinMaxX(obj, pointIndex, coordVariationMinStep)
            % Returns the x value interval within which a specific point
            % can be moved. The idea is that a point can not be moved more
            % left than the x value + min step of its left neighbour or more
            % right than the x value - min step of its right neighbour.
            [xAxisMin, xAxisMax] = obj.getXAxisLimits();
            [pointSplineModel, pointSplineIndex] = obj.getSplineModelContainingPoint(pointIndex);
            pointIndexInSpline = obj.getPointIndexInSplineAtIndex(pointSplineIndex, pointIndex);
            currentPointXValue = pointSplineModel.splineXpointCoordVector(1, pointIndexInSpline);

            if pointIndex == 1
                minX = xAxisMin;
            else 
                if pointIndexInSpline > 1
                    prevPointX = pointSplineModel.splineXpointCoordVector(1, pointIndexInSpline - 1) + coordVariationMinStep;
                else
                    prevPointX = pointSplineModel.splineXpointCoordVector(1, pointIndexInSpline) + coordVariationMinStep;
                end
                minX = min(prevPointX, currentPointXValue);
            end

            maxPointIndex = length(obj.splineModelCellArray) * 4;
            
            if pointIndex == maxPointIndex
                maxX = xAxisMax;
            else
                if pointIndexInSpline < 4
                    nextPointX = pointSplineModel.splineXpointCoordVector(1, pointIndexInSpline + 1) - coordVariationMinStep;
                else
                    nextPointX = pointSplineModel.splineXpointCoordVector(1, pointIndexInSpline) - coordVariationMinStep;
                end
                maxX = max(nextPointX, currentPointXValue);
            end
        end 
        
        function pointXValue = getXValueOfPoint(obj, pointIndex)
            [pointSplineModel, pointSplineIndex] = obj.getSplineModelContainingPoint(pointIndex);
            pointIndexInSpline = obj.getPointIndexInSplineAtIndex(pointSplineIndex, pointIndex);
            pointXValue = pointSplineModel.splineXpointCoordVector(1, pointIndexInSpline);
        end
        
        function [pointSplineModel, pointSplineIndex] = getSplineModelContainingPoint(obj, pointIndex)
            pointSplineIndex = ceil(pointIndex / 4);
            pointSplineModel = obj.splineModelCellArray{pointSplineIndex};
        end
        function pointIndexInSpline = getPointIndexInSplineAtIndex(obj, splineIndex, pointIndex)
            pointIndexInSpline = pointIndex - ((splineIndex - 1) * 4);
        end
    end
end
