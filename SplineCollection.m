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
        function splinePointLabelStrCellVector = getAllSplinePointLabelStr(obj)
            splineNumber = length(obj.splineModelCellVector)
            
            % preallocating cell array
            splinePointLabelStrCellVector{1,splineNumber} = {}
            
            for i = 1:splineNumber
                currentSpline = obj.splineModelCellVector{i};
                currentSplinePointLabelStrCellVector = currentSpline.splinePointLabelStrCellVector;
                splinePointLabelStrCellVector{i} = currentSplinePointLabelStrCellVector
            end
            
            splinePointLabelStrCellVector = horzcat(splinePointLabelStrCellVector{:})
        end
        function splinePointSelectionMenuValueStrCellVector = getAllSplinePointSelectionMenuValueStr(obj)
            splineNumber = length(obj.splineModelCellVector)
            
            % preallocating cell array
            splinePointSelectionMenuValueStrCellVector{1,splineNumber} = {}
            pIndex = 0
            
            for i = 1:splineNumber
                currentSpline = obj.splineModelCellVector{i};
                for j = 1:length(currentSpline.splineXpointCoordVector)
                    pIndex = pIndex + 1
                    splinePointSelectionMenuValueStrCellVector{pIndex} = strcat('P', num2str(pIndex));
                end
            end
        end
    end
end
