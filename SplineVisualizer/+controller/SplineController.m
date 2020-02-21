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
        
        function handle_X_CoordChanged(obj, xRoundedValue, pointIndex)
            if pointIndex >= 1
                obj.splineView.replotSplineXChanged(pointIndex, xRoundedValue);
            elseif pointIndex > 0
                realPointIndex = pointIndex * 1000;
                obj.splineView.replotSplineXChanged(realPointIndex, xRoundedValue);
                obj.splineView.replotSplineXChanged(realPointIndex + 1, xRoundedValue);
            else
                % here the slope is modified
                isContiguousSplineUpdated = obj.splineCollection.setSlopeValueAtPoint(pointIndex, xRoundedValue);

                % replotting the modified spline
                pointIndex = -pointIndex;
                obj.splineView.deletePlottedPiecewiseSpline(pointIndex);            
                maxSplineIndex = obj.splineCollection.getSplineNumber();
                obj.splineView.plotSpline(obj.splineCollection.getSplineIndexOfSplineContainingPoint(pointIndex),...
                               maxSplineIndex);
                           
                if isContiguousSplineUpdated == 1
                    pointIndex = pointIndex + 1;
                    obj.splineView.deletePlottedPiecewiseSpline(pointIndex);            
                    maxSplineIndex = obj.splineCollection.getSplineNumber();
                    obj.splineView.plotSpline(obj.splineCollection.getSplineIndexOfSplineContainingPoint(pointIndex),...
                                   maxSplineIndex);
                end
            end
        end
    end
end