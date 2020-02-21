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
                obj.splineView.replotSplineXChanged(pointIndex, xRoundedValue);
            elseif pointIndex > 0
                % here, a two overlapping points are modified. This happens
                % when moving points which concatenate two contiguous
                % splines.
                realPointIndex = pointIndex * 1000;
                obj.splineView.replotSplineXChanged(realPointIndex, xRoundedValue);
                obj.splineView.replotSplineXChanged(realPointIndex + 1, xRoundedValue);
            else
                % here, the slope is modified.
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
        
        function handle_Y_CoordChanged(obj, yRoundedValue, pointIndex)
            if pointIndex >= 1
                % here, a single point is modified. A single point is a
                % point which is not overlapped by another point with
                % identical coordinates. 
                obj.splineView.replotSplineYChanged(pointIndex,...
                                                    yRoundedValue);
            elseif pointIndex > 0
                % here, a two overlapping points are modified. This happens
                % when moving points which concatenate two contiguous
                % splines.
                realPointIndex = pointIndex * 1000;
                obj.splineView.replotSplineYChanged(realPointIndex,...
                                                    yRoundedValue);
                obj.splineView.replotSplineYChanged(realPointIndex + 1,...
                                                    yRoundedValue);
            end
        end
    end
end