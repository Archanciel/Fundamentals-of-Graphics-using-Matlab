                           % {1} global spline points x coordinates
                           % {2} global spline points y coordinates
                           % {9} piecewise spline points_labels strings
                           % {10} additional piecewise spline points_labels strings
                           % {11} piecewise spline colors
                           % {12} additional piecewise spline colors
                           % {13} --> piecewise spline line handles
                           % {14} --> additional piecewise spline line handles
                           % {15} --> piecewise spline point label handles
                           % {16} --> additional piecewise spline point label handles
                           % {17} --> piecewise spline scattered point handles
                           % {18} --> additional piecewise spline scattered point handles
classdef SplineData < handle
    % inheriting from handle in order for instances to be passed by reference
    properties
        % constants
        % none !
        
        splineXpointCoordVector; % in case of two piecewise splines, hosts 
                                 % coord of BOTH splines
        splineYpointCoordVector;  % in case of two piecewise splines, hosts 
                                  % coord of BOTH splines
        splinePointLabelStrVector;
        additionalSplinePointLabelStrVector;
        splineColorVector;
        additionalSplineColorVector;
        splineLineHandleVector;
        additionalSplineLineHandleVector;
        splinePointLabelHandleVector;
        additionalSplinePointLabelHandleVector;
        splineScatteredPointHandleVector;
        additionalSplineScatteredHandleVector;
    end
    methods
        function obj = SplineData()
        end
        
        % using property setter (similar to python @property annotaton)
        function obj = set.splineXpointCoordVector(obj, vector)
             obj.splineXpointCoordVector = vector;
        end
        
        function obj = set.splineYpointCoordVector(obj, vector)
             obj.splineYpointCoordVector = vector;
        end
        
        function obj = set.splinePointLabelStrVector(obj, vector)
             obj.splinePointLabelStrVector = vector;
        end
        
        function obj = set.additionalSplinePointLabelStrVector(obj, vector)
             obj.additionalSplinePointLabelStrVector = vector;
        end
        
        function obj = set.splineColorVector(obj, vector)
             obj.splineColorVector = vector;
        end
        
        function obj = set.additionalSplineColorVector(obj, vector)
             obj.additionalSplineColorVector = vector;
        end
        
        function obj = set.splineLineHandleVector(obj, vector)
             obj.splineLineHandleVector = vector;
        end
        
        function obj = set.additionalSplineLineHandleVector(obj, vector)
             obj.additionalSplineLineHandleVector = vector;
        end
        
        function obj = set.splinePointLabelHandleVector(obj, vector)
             obj.splinePointLabelHandleVector = vector;
        end
        
        function obj = set.additionalSplinePointLabelHandleVector(obj, vector)
             obj.additionalSplinePointLabelHandleVector = vector;
        end
        
        function obj = set.splineScatteredPointHandleVector(obj, vector)
             obj.splineScatteredPointHandleVector = vector;
        end
        
        function obj = set.additionalSplineScatteredHandleVector(obj, vector)
             obj.additionalSplineScatteredHandleVector = vector;
        end
    end
end