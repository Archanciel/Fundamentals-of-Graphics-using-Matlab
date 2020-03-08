classdef SplineCollection < handle
    % inheriting from handle in order for instances to be passed by reference
    properties
        % constants
        POINT_NUMBER_PER_SPLINE = 4;
        MIN_SLOPE = -10;
        MAX_SLOPE = 10;
        
        % none !        
    end
    
    properties (Access = private)
        splineModelCellArray;
    end
    
    methods
        function addSplineModel(obj, splineModel)
            currentSplineModelNumber = obj.getSplineNumber();
            currentIndex = currentSplineModelNumber + 1;
            obj.splineModelCellArray{currentIndex} = splineModel;
            % splineModel.splineModelName = num2str(currentIndex);
            splineModel.splineModelIndex = currentIndex;
        end

        function addViewListenerToModels(obj, view, eventStr)
            splineNumber = obj.getSplineNumber();
            
            for i = 1:splineNumber
                splineModel = obj.splineModelCellArray{i};
                splineModel.addListenerToEvent(view, eventStr);
            end
        end
        
        function splineNumber = getSplineNumber(obj)
            splineNumber = length(obj.splineModelCellArray);
        end
        
        function totalPointNumber = getTotalPointNumber(obj)
            splineNumber = length(obj.splineModelCellArray);
            totalPointNumber = 0;
            
            for i = 1:splineNumber
                splineModel = obj.splineModelCellArray{i};
                totalPointNumber = totalPointNumber + splineModel.getSplinePointNumber();
            end
        end
        
        function splineModel = getSplineModelForSplineIndex(obj, i)
            splineModel = obj.splineModelCellArray{i};
        end
        
        function splineIndexCellArray = getSplineIndexCellArray(obj)
            splineNumber = obj.getSplineNumber();
            splineIndexCellArray = cell(1,splineNumber);
            
            for i = 1:splineNumber
                splineIndexCellArray{i} = i;
            end
        end
        
        function [xMin, xMax] = getAllPointsXLimits(obj)
            % Returns the minimum and maximum x values considering all
            % the points of the piecewise splines in the SplineCollection
            startSplineModel = obj.getSplineModel(1);
            endSplineModel = obj.getSplineModel(obj.getSplineNumber());
            
            xMin = startSplineModel.splineXpointCoordVector(1, 1) - 1; 
            xMax = endSplineModel.splineXpointCoordVector(1, end) + 1;
        end

        function [minSlope, maxSlope] = getMinMaxSlope(obj)
            minSlope = obj.MIN_SLOPE;
            maxSlope = obj.MAX_SLOPE;
        end
        
        function [minX, maxX] = getMinMaxX(obj, firstPointIndex, secondPointIndex, xAxisMin, xAxisMax, coordVariationMinStep)
            % Returns the x value interval within which a specific point
            % can be moved. The idea is that a point can not be moved more
            % left than the x value + min step of its left neighbour or more
            % right than the x value - min step of its right neighbour.
            %
            % In case secondPointIndex is different from firstPointIndex,
            % we are in the case of asking the x min/max value for two
            % overlapping points, i.e. end point of slope i and begin point
            % of slope i + 1.
            if firstPointIndex == secondPointIndex
                [pointSplineModel, indexOfSplineContainingPoint] = obj.getSplineModelContainingPoint(firstPointIndex);
                pointIndexInSpline = obj.getPointIndexInSplineForGlobalPointIndex(indexOfSplineContainingPoint, firstPointIndex);
                currentPointXValue = pointSplineModel.splineXpointCoordVector(1, pointIndexInSpline);

                if firstPointIndex == 1
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

                if firstPointIndex == maxPointIndex
                    maxX = xAxisMax;
                else
                    if pointIndexInSpline < obj.POINT_NUMBER_PER_SPLINE
                        nextPointX = pointSplineModel.splineXpointCoordVector(1, pointIndexInSpline + 1) - coordVariationMinStep;
                    else
                        nextPointX = pointSplineModel.splineXpointCoordVector(1, pointIndexInSpline) - coordVariationMinStep;
                    end
                    maxX = max(nextPointX, currentPointXValue);
                end
            else
                [firstSplineModel, indexOfSplineContainingFirstPoint] = obj.getSplineModelContainingPoint(firstPointIndex);
                firstPointIndexInFirstSpline = obj.getPointIndexInSplineForGlobalPointIndex(indexOfSplineContainingFirstPoint, firstPointIndex);
                currentPointXValue = firstSplineModel.splineXpointCoordVector(1, firstPointIndexInFirstSpline);
                [secondSplineModel, indexOfSplineContainingSecondPoint] = obj.getSplineModelContainingPoint(secondPointIndex);
                secondPointIndexInSecondSpline = obj.getPointIndexInSplineForGlobalPointIndex(indexOfSplineContainingSecondPoint, secondPointIndex);

                prevPointX = firstSplineModel.splineXpointCoordVector(1, firstPointIndexInFirstSpline - 1) + coordVariationMinStep;
                minX = min(prevPointX, currentPointXValue);
                nextPointX = secondSplineModel.splineXpointCoordVector(1, secondPointIndexInSecondSpline + 1) - coordVariationMinStep;
                maxX = max(nextPointX, currentPointXValue);
            end
        end 
        
        function slopeValue = getSlopeValueAtPoint(obj, pointIndexGlobal)
            % pointIndexGlobal is negative when a slope was choosen in the point
            % menu drop down menu.
            pointIndexGlobal = -pointIndexGlobal;
            pointSplineModel = obj.getSplineModelContainingPoint(pointIndexGlobal);
            
            if pointIndexGlobal == 1
                slopeValue = pointSplineModel.splineStartSlope;
            else
                slopeValue = pointSplineModel.splineEndSlope;
            end
        end
        
        function pointXValue = getXValueOfPoint(obj, pointIndexGlobal)
            % pointIndexGlobal is the dropdown menu selection index. This
            % function first determines in which piecewise spline the
            % point is contained. It then returns the x coord of the
            % point.
            [pointSplineModel, indexOfSplineContainingPoint] = obj.getSplineModelContainingPoint(pointIndexGlobal);
            pointIndexInSpline = obj.getPointIndexInSplineForGlobalPointIndex(indexOfSplineContainingPoint, pointIndexGlobal);
            pointXValue = pointSplineModel.splineXpointCoordVector(1, pointIndexInSpline);
        end
        
        function setXValueOfPoint(obj, pointIndexGlobal, value)
            % pointIndexGlobal is the dropdown menu selection index. This
            % function first determines in which piecewise spline the
            % point is contained. It then sets the x coord of the
            % point to the passed value.
            [pointSplineModel, indexOfSplineContainingPoint] = obj.getSplineModelContainingPoint(pointIndexGlobal);
            pointIndexInSpline = obj.getPointIndexInSplineForGlobalPointIndex(indexOfSplineContainingPoint, pointIndexGlobal);
            pointSplineModel.splineXpointCoordVector(1, pointIndexInSpline) = value;
        end
       
        function answer = isPointLastInHisSpline(obj, pointIndexGlobal)
            % pointIndexGlobal: "global point index: if we have 3 piecewise
            % splines with 4 points in each, pointIndexGlobal = 12 is contained
            % in 3rd SplineModel and is the last point of the spline.
            %
            % The function first determines in which piecewise spline the
            % point is contained. It then ash the SplineModel if is is the 
            % last point.
            %
            % Returns 1 if true, 0 else.
            [pointSplineModel, indexOfSplineContainingPoint] = obj.getSplineModelContainingPoint(pointIndexGlobal);
            pointIndexInSpline = obj.getPointIndexInSplineForGlobalPointIndex(indexOfSplineContainingPoint, pointIndexGlobal);
            answer = pointSplineModel.isLastPoint(pointIndexInSpline);
        end
        
        function isContiguousSplineUpdated = setSlopeValueAtPoint(obj, pointIndexGlobal, value)
            % pointIndexGlobal is negative when a slope was choosen in the point
            % menu drop down menu.
            pointIndexGlobal = -pointIndexGlobal;
            pointSplineModel = obj.getSplineModelContainingPoint(pointIndexGlobal);
            isContiguousSplineUpdated = 0;
            
            if pointIndexGlobal == 1
                pointSplineModel.splineStartSlope = value;
            elseif pointIndexGlobal == obj.getTotalPointNumber()
                pointSplineModel.splineEndSlope = value;
            else
                pointSplineModel.splineEndSlope = value;
                pointSplineModel = obj.getSplineModelContainingPoint(pointIndexGlobal + 1);
                pointSplineModel.splineStartSlope = value;
                isContiguousSplineUpdated = 1;
            end
        end
        
        function pointYValue = getYValueOfPoint(obj, pointIndexGlobal)
            % pointIndexGlobal is the dropdown menu selection index. This
            % function first determines in which piecewise spline the
            % point is contained. It then returns the y coord of the
            % point.
            [pointSplineModel, indexOfSplineContainingPoint] = obj.getSplineModelContainingPoint(pointIndexGlobal);
            pointIndexInSpline = obj.getPointIndexInSplineForGlobalPointIndex(indexOfSplineContainingPoint, pointIndexGlobal);
            pointYValue = pointSplineModel.splineYpointCoordVector(1, pointIndexInSpline);
        end
         
        function setYValueOfPoint(obj, pointIndexGlobal, value)
            % pointIndexGlobal is the dropdown menu selection index. This
            % function first determines in which piecewise spline the
            % point is contained. It then sets the y coord of the
            % point to the passed value.
            [pointSplineModel, indexOfSplineContainingPoint] = obj.getSplineModelContainingPoint(pointIndexGlobal);
            pointIndexInSpline = obj.getPointIndexInSplineForGlobalPointIndex(indexOfSplineContainingPoint, pointIndexGlobal);
            pointSplineModel.splineYpointCoordVector(1, pointIndexInSpline) = value;
        end
       
        function [pointSplineModel, indexOfSplineContainingPoint] = getSplineModelContainingPoint(obj, pointIndexGlobal)
            % pointIndexGlobal: "global point index: if we have 3 piecewise
            % splines with 4 points in each, pointIndexGlobal = 12 is contained
            % in 3rd SplineModel.
            indexOfSplineContainingPoint = obj.getIndexOfSplineContainingPoint(pointIndexGlobal);
            pointSplineModel = obj.splineModelCellArray{indexOfSplineContainingPoint};
        end

    end
    
    methods (Access = private)
       
        function indexOfSplineContainingPoint = getIndexOfSplineContainingPoint(obj, pointIndexGlobal)
            % pointIndexGlobal: "global point index: if we have 3 piecewise
            % splines with 5 points, 4 points and six points respectively,
            % pointIndexGlobal = 6 is contained in 2nd SplineModel.
            splineNumber = obj.getSplineNumber();
            currentSplineEndPointIndex = 0;
            
            for i = 1:splineNumber
                splineModel = obj.splineModelCellArray{i};
                currentSplineEndPointIndex = currentSplineEndPointIndex + splineModel.getSplinePointNumber();

                if pointIndexGlobal <= currentSplineEndPointIndex
                    indexOfSplineContainingPoint = i;
                    break;
                end
            end
        end
        
        function pointIndexInSpline = getPointIndexInSplineForGlobalPointIndex(obj, splineIndex, pointIndexGlobal)
            if splineIndex == 1
                pointIndexInSpline = pointIndexGlobal;
            else
                previousSplinePointNumber = 0;
                
                for i = 1:splineIndex - 1
                    splineModel = obj.splineModelCellArray{i};
                    previousSplinePointNumber = previousSplinePointNumber + splineModel.getSplinePointNumber();
                end
                
                pointIndexInSpline = pointIndexGlobal - previousSplinePointNumber;
            end
        end
    end
end
