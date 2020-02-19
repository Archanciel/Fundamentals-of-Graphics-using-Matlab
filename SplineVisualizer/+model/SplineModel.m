classdef SplineModel < handle
    % inheriting from handle in order for instances to be passed by reference
    properties (Access = public)
        % constants
        % none !        

        splineModelName; % set by SplineCollection when adding the 
                         % SplineModel to it. Equal to the SplineModel
                         % string index.
        splineXpointCoordVector;
        splineYpointCoordVector;
        splineStartSlope;
        splineEndSlope;
    end
    
    properties (Access = private)
        splineColorCellArray; % will be transfered to the related 
                              % SplineUIData. Located in SplineModel since
                              % spline colors are specified in 
                              % SplineAppCreator where the splines are
                              % defined.
    end
    
    methods
        function obj = SplineModel(splinePointVector,...
                                   splineStartSlope,...
                                   splineEndSlope,...
                                   splineColorCellArray)
            % setting x and y coordinates vector                            
            obj.splineXpointCoordVector = [splinePointVector(:,1)'];
            obj.splineYpointCoordVector = [splinePointVector(:,2)'];
            obj.splineStartSlope = splineStartSlope;
            obj.splineEndSlope = splineEndSlope;
            obj.splineColorCellArray = splineColorCellArray;
        end
        
        function pointNumber = getSplinePointNumber(obj)
            pointNumber = length(obj.splineXpointCoordVector);
        end
        
        function splineColorCellArray = getSplineColorCellArray(obj)
            splineColorCellArray = obj.splineColorCellArray; 
        end
        
        function yFuncCellArray = computePiecewiseSplineFunctions(obj)
            % Returns a 3 elements cell array containing the piecewise spline
            % y_A, y_B and y_C functions

            Pn = [obj.splineXpointCoordVector(1,:)' obj.splineYpointCoordVector(1,:)'];

            C = [Pn(1,1)^3 Pn(1,1)^2 Pn(1,1) 1 0 0 0 0 0 0 0 0;
                 Pn(2,1)^3 Pn(2,1)^2 Pn(2,1) 1 0 0 0 0 0 0 0 0;
                 0 0 0 0 Pn(2,1)^3 Pn(2,1)^2 Pn(2,1) 1 0 0 0 0;
                 0 0 0 0 Pn(3,1)^3 Pn(3,1)^2 Pn(3,1) 1 0 0 0 0;
                 0 0 0 0 0 0 0 0 Pn(3,1)^3 Pn(3,1)^2 Pn(3,1) 1;
                 0 0 0 0 0 0 0 0 Pn(4,1)^3 Pn(4,1)^2 Pn(4,1) 1;
                 -3 * Pn(2,1)^2 -2 * Pn(2,1) -1 0 3 * Pn(2,1)^2 2 * Pn(2,1) 1 0 0 0 0 0;
                 0 0 0 0 -3 * Pn(3,1)^2 -2 * Pn(3,1) -1 0 3 * Pn(3,1)^2 2 * Pn(3,1) 1 0;
                 -6 * Pn(2,1) -2 0 0 6 * Pn(2,1) 2 0 0 0 0 0 0;
                 0 0 0 0 -6 * Pn(3,1) -2 0 0 6 * Pn(3,1) 2 0 0;
                 3 * Pn(1,1)^2 2 * Pn(1,1) 1 0 0 0 0 0 0 0 0 0;
                 0 0 0 0 0 0 0 0 3 * Pn(4,1)^2 2 * Pn(4,1) 1 0];
            C_i = inv(C);

            Y = [Pn(1,2);
                Pn(2,2);
                Pn(2,2);
                Pn(3,2);
                Pn(3,2);
                Pn(4,2);
                0;
                0;
                0;
                0;
                obj.splineStartSlope;
                obj.splineEndSlope];

            A = C_i * Y;

            syms x
            y_A = A(1,1) * x^3 + A(2,1) * x^2 + A(3,1) * x + A(4,1);
            y_B = A(5,1) * x^3 + A(6,1) * x^2 + A(7,1) * x + A(8,1);
            y_C = A(9,1) * x^3 + A(10,1) * x^2 + A(11,1) * x + A(12,1);

            yFuncCellArray{1} = y_A;
            yFuncCellArray{2} = y_B;
            yFuncCellArray{3} = y_C;
        end
    end
end