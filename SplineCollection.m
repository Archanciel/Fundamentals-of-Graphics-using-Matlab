classdef SplineCollection < handle
    % inheriting from handle in order for instances to be passed by reference
    properties
        % constants
        POINT_NUMBER_PER_SPLINE = 4;
        MIN_SLOPE = -10;
        MAX_SLOPE = 10;
        
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
            currentSplineModelNumber = obj.getSplineNumber();
            currentIndex = currentSplineModelNumber + 1;
            obj.splineModelCellArray{currentIndex} = splineModel;
            splineModel.splineModelName = num2str(currentIndex);
        end
        
        function splineNumber = getSplineNumber(obj)
            splineNumber = length(obj.splineModelCellArray);
        end
        
        function splineNumber = getTotalPointNumber(obj)
            splineNumber = length(obj.splineModelCellArray) * obj.POINT_NUMBER_PER_SPLINE;
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
            endSplineModel = obj.getSplineModel(obj.getSplineNumber());
            
            xAxisMin = startSplineModel.splineXpointCoordVector(1, 1) - 1; 
            xAxisMax = endSplineModel.splineXpointCoordVector(1, end) + 1;
        end

        function [minSlope, maxSlope] = getMinMaxSlope(obj)
            minSlope = obj.MIN_SLOPE;
            maxSlope = obj.MAX_SLOPE;
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

            maxPointIndex = obj.getSplineNumber() * obj.POINT_NUMBER_PER_SPLINE;
            
            if pointIndex == maxPointIndex
                maxX = xAxisMax;
            else
                if pointIndexInSpline < obj.POINT_NUMBER_PER_SPLINE
                    nextPointX = pointSplineModel.splineXpointCoordVector(1, pointIndexInSpline + 1) - coordVariationMinStep;
                else
                    nextPointX = pointSplineModel.splineXpointCoordVector(1, pointIndexInSpline) - coordVariationMinStep;
                end
                maxX = max(nextPointX, currentPointXValue);
            end
        end 
        
        function slopeValue = getSlopeValueAtPoint(obj, pointIndex)
            % pointIndex is negative when a slope was choosen in the point
            % menu drop down menu.
            slopeIndex = -pointIndex;
            [pointSplineModel, pointSplineIndex] = obj.getSplineModelContainingPoint(slopeIndex);
            
            if slopeIndex == 1
                slopeValue = pointSplineModel.splineStartSlope;
            else
                slopeValue = pointSplineModel.splineEndSlope;
            end
        end
        
        function pointXValue = getXValueOfPoint(obj, pointIndex)
            % pointIndex is the dropdown menu selection index. This
            % function first determines in which piecewise spline the
            % point is contained. It then returns the x coord of the
            % point.
            [pointSplineModel, pointSplineIndex] = obj.getSplineModelContainingPoint(pointIndex);
            pointIndexInSpline = obj.getPointIndexInSplineAtIndex(pointSplineIndex, pointIndex);
            pointXValue = pointSplineModel.splineXpointCoordVector(1, pointIndexInSpline);
        end
        
        function setXValueOfPoint(obj, pointIndex, value)
            % pointIndex is the dropdown menu selection index. This
            % function first determines in which piecewise spline the
            % point is contained. It then sets the x coord of the
            % point to the passed value.
            [pointSplineModel, pointSplineIndex] = obj.getSplineModelContainingPoint(pointIndex);
            pointIndexInSpline = obj.getPointIndexInSplineAtIndex(pointSplineIndex, pointIndex);
            pointSplineModel.splineXpointCoordVector(1, pointIndexInSpline) = value;
        end
        
        function isContiguousSplineUpdated = setSlopeValueAtPoint(obj, pointIndex, value)
            % pointIndex is negative when a slope was choosen in the point
            % menu drop down menu.
            slopeIndex = -pointIndex;
            [pointSplineModel, pointSplineIndex] = obj.getSplineModelContainingPoint(slopeIndex);
            isContiguousSplineUpdated = 0;
            
            if slopeIndex == 1
                pointSplineModel.splineStartSlope = value;
            elseif slopeIndex == obj.getTotalPointNumber()
                pointSplineModel.splineEndSlope = value;
            else
                pointSplineModel.splineEndSlope = value;
                [pointSplineModel, pointSplineIndex] = obj.getSplineModelContainingPoint(slopeIndex + 1);
                pointSplineModel.splineStartSlope = value;
                isContiguousSplineUpdated = 1;
            end
        end
        
        function pointYValue = getYValueOfPoint(obj, pointIndex)
            % pointIndex is the dropdown menu selection index. This
            % function first determines in which piecewise spline the
            % point is contained. It then returns the y coord of the
            % point.
            [pointSplineModel, pointSplineIndex] = obj.getSplineModelContainingPoint(pointIndex);
            pointIndexInSpline = obj.getPointIndexInSplineAtIndex(pointSplineIndex, pointIndex);
            pointYValue = pointSplineModel.splineYpointCoordVector(1, pointIndexInSpline);
        end
         
        function setYValueOfPoint(obj, pointIndex, value)
            % pointIndex is the dropdown menu selection index. This
            % function first determines in which piecewise spline the
            % point is contained. It then sets the y coord of the
            % point to the passed value.
            [pointSplineModel, pointSplineIndex] = obj.getSplineModelContainingPoint(pointIndex);
            pointIndexInSpline = obj.getPointIndexInSplineAtIndex(pointSplineIndex, pointIndex);
            pointSplineModel.splineYpointCoordVector(1, pointIndexInSpline) = value;
        end
       
        function [pointSplineModel, pointSplineIndex] = getSplineModelContainingPoint(obj, pointIndex)
            pointSplineIndex = obj.getSplineIndexOfSplineContainingPoint(pointIndex);
            pointSplineModel = obj.splineModelCellArray{pointSplineIndex};
        end
       
        function pointSplineIndex = getSplineIndexOfSplineContainingPoint(obj, pointIndex)
            pointSplineIndex = ceil(pointIndex / obj.POINT_NUMBER_PER_SPLINE);
        end
        
        function pointIndexInSpline = getPointIndexInSplineAtIndex(obj, splineIndex, pointIndex)
            pointIndexInSpline = pointIndex - ((splineIndex - 1) * obj.POINT_NUMBER_PER_SPLINE);
        end
    end
end
