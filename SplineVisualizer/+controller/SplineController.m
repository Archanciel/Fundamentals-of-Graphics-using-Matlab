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
                % here, a single point is modified. A single point is a
                % point which is not overlapped by another point with
                % identical coordinates. 
                obj.splineCollection.setXValueOfPoint(pointIndex, xRoundedValue);
                obj.splineView.replotSpline(pointIndex);
            elseif pointIndex > 0
                % here, a two overlapping points are modified. This happens
                % when moving points which concatenate two contiguous
                % splines.
                realPointIndex = pointIndex * 1000;
                obj.splineCollection.setXValueOfPoint(realPointIndex, xRoundedValue);
                obj.splineView.replotSpline(realPointIndex);

                obj.splineCollection.setXValueOfPoint(realPointIndex + 1, xRoundedValue);
                obj.splineView.replotSpline(realPointIndex + 1);
            else
                % here, the slope is modified.
                isContiguousSplineUpdated = obj.splineCollection.setSlopeValueAtPoint(pointIndex, xRoundedValue);

                % replotting the modified spline
                pointIndex = -pointIndex;
                obj.splineView.replotSpline(pointIndex);

                if isContiguousSplineUpdated == 1
                    pointIndex = pointIndex + 1;
                    obj.splineView.replotSpline(pointIndex);
                end
            end
        end
        
        function handle_Y_CoordChanged(obj, yRoundedValue, pointIndex)
            if pointIndex >= 1
                % here, a single point is modified. A single point is a
                % point which is not overlapped by another point with
                % identical coordinates. 
                obj.splineCollection.setYValueOfPoint(pointIndex, yRoundedValue);
                obj.splineView.replotSpline(pointIndex);
            elseif pointIndex > 0
                % here, a two overlapping points are modified. This happens
                % when moving points which concatenate two contiguous
                % splines.
                realPointIndex = pointIndex * 1000;
                obj.splineCollection.setYValueOfPoint(realPointIndex, yRoundedValue);
                obj.splineView.replotSpline(realPointIndex);

                obj.splineCollection.setYValueOfPoint(realPointIndex + 1, yRoundedValue);
                obj.splineView.replotSpline(realPointIndex + 1);
            end
        end
    end
end