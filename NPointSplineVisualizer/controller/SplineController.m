classdef SplineController < handle
    % inheriting from handle in order for instances to be passed by reference
    properties
        % constants
        % none !
        
        splineCollection              SplineCollection;
        splineView                    SplineView; % set in SplineAppCreator !
    end

    methods (Access = public)

        function obj = SplineController(splineCollection)
%            addpath('model');
%            addpath('view');

            obj.splineCollection = splineCollection;
        end

        function addView(obj, view)
            % Ok since only one view exists in the application.
            obj.splineView = view;

            % Adding the view as listener to the SplineModel contained
            % in the SplineCollection so that the view is notified
            % each time the SplineModel is recalculated.
            %
            % In view/SplineView/createListenerForEvent (line 753)
            % In model/SplineModel/addListenerToEvent (line 105)
            % In model/SplineCollection/addViewListenerToModels (line 29)
            % In controller/SplineController/addView (line 24)
            % In SplineAppCreator (line 76)
            obj.splineCollection.addViewListenerToModels(view, 'SplineComputedEvent');

            % Ensures the SplineController is triggered each time the
            % user updates a control in the view. 
            %
            % In view/SplineView/attachControllerToSliderChangeEvent (line 761)
            % In controller/SplineController/addView (line 28)
            % In SplineAppCreator (line 76)
            view.attachControllerToSliderChangeEvent(obj);
        end
        
        function handle_X_CoordChanged(obj, xRoundedValue, pointIndex)
            if pointIndex >= 1
                % here, a single point is modified. A single point is a
                % point which is not overlapped by another point with
                % identical coordinates. 
                obj.splineCollection.setXValueOfPoint(pointIndex, xRoundedValue);
                splineModel = obj.splineCollection.getSplineModelContainingPoint(pointIndex);
                splineModel.reComputePiecewiseSplineFunctions();
            elseif pointIndex > 0
                % here, a two overlapping points are modified. This happens
                % when moving points which concatenate two contiguous
                % splines.
                realPointIndex = pointIndex * 1000;
                obj.splineCollection.setXValueOfPoint(realPointIndex, xRoundedValue);
                splineModel = obj.splineCollection.getSplineModelContainingPoint(realPointIndex);
                splineModel.reComputePiecewiseSplineFunctions();

                obj.splineCollection.setXValueOfPoint(realPointIndex + 1, xRoundedValue);
                splineModel = obj.splineCollection.getSplineModelContainingPoint(realPointIndex + 1);
                splineModel.reComputePiecewiseSplineFunctions();
            else
                % here, the slope is modified.
                isContiguousSplineUpdated = obj.splineCollection.setSlopeValueAtPoint(pointIndex, xRoundedValue);

                % replotting the modified spline
                pointIndex = -pointIndex;
                splineModel = obj.splineCollection.getSplineModelContainingPoint(pointIndex);
                splineModel.reComputePiecewiseSplineFunctions();

                if isContiguousSplineUpdated == 1
                    pointIndex = pointIndex + 1;
                    splineModel = obj.splineCollection.getSplineModelContainingPoint(pointIndex);
                    splineModel.reComputePiecewiseSplineFunctions();
                end
            end
        end
        
        function handle_Y_CoordChanged(obj, yRoundedValue, pointIndex)
            if pointIndex >= 1
                % here, a single point is modified. A single point is a
                % point which is not overlapped by another point with
                % identical coordinates. 
                obj.splineCollection.setYValueOfPoint(pointIndex, yRoundedValue);
                splineModel = obj.splineCollection.getSplineModelContainingPoint(pointIndex);
                splineModel.reComputePiecewiseSplineFunctions();
            elseif pointIndex > 0
                % here, a two overlapping points are modified. This happens
                % when moving points which concatenate two contiguous
                % splines.
                realPointIndex = pointIndex * 1000;
                obj.splineCollection.setYValueOfPoint(realPointIndex, yRoundedValue);
                splineModel = obj.splineCollection.getSplineModelContainingPoint(realPointIndex);
                splineModel.reComputePiecewiseSplineFunctions();

                obj.splineCollection.setYValueOfPoint(realPointIndex + 1, yRoundedValue);
                splineModel = obj.splineCollection.getSplineModelContainingPoint(realPointIndex + 1);
                splineModel.reComputePiecewiseSplineFunctions();
            end
        end
        
    end
    
end