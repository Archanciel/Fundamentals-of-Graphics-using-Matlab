classdef SplineModelNPoints < handle
    % inheriting from handle in order for instances to be passed by reference
    properties (Access = public)
        % constants
        % none !        

        splineModelIndex; % set by SplineCollection when adding the 
                          % SplineModel to it. Is used as unique identifier
                          % for the spline model.
        splineXpointCoordVector;
        splineYpointCoordVector;
        splineStartSlope;
        splineEndSlope;
        yFuncCellArray; % hosts the 3 y = ax^3 + bx`2 + cx + d functions
                        % calculated by computePiecewiseSplineFunctions().
        C;
    end
    
    properties (Access = private)
        splineColorCellArray; % will be transfered to the related 
                              % SplineUIData. Located in SplineModel since
                              % spline colors are specified in 
                              % SplineAppCreator where the splines are
                              % defined.
    end

    events
        SplineComputedEvent;
    end
    
    methods
        function obj = SplineModelNPoints(splinePointVector,...
                                          splineStartSlope,...
                                          splineEndSlope,...
                                          splineColorCellArray)
            % setting x and y coordinates vector                            
            obj.splineXpointCoordVector = [splinePointVector(:,1)'];
            obj.splineYpointCoordVector = [splinePointVector(:,2)'];
            obj.splineStartSlope = splineStartSlope;
            obj.splineEndSlope = splineEndSlope;
            obj.splineColorCellArray = splineColorCellArray;
            obj.yFuncCellArray = cell(1, 3);
        end
        
        function pointNumber = getSplinePointNumber(obj)
            pointNumber = length(obj.splineXpointCoordVector);
        end
        
        function splineColorCellArray = getSplineColorCellArray(obj)
            splineColorCellArray = obj.splineColorCellArray; 
        end
      
        function yFuncCellArray = reComputePiecewiseSplineFunctions(obj)
            % This method does notifiy the model listeners that the spline
            % was recomputed. Typically, this means that the listeners
            % will have to replot the spline ...
            yFuncCellArray = obj.computePiecewiseSplineFunctions();
            
            notify(obj,'SplineComputedEvent');
        end
        
        function yFuncCellArray = computePiecewiseSplineFunctions(obj)
            % Returns a 3 elements cell array containing the piecewise spline
            % y_A, y_B, y_C and y_D functions

            Pn = [obj.splineXpointCoordVector(1,:)' obj.splineYpointCoordVector(1,:)'];

            obj.C = [Pn(1,1)^3 Pn(1,1)^2 Pn(1,1) 1 0 0 0 0 0 0 0 0 0 0 0 0;
                     Pn(2,1)^3 Pn(2,1)^2 Pn(2,1) 1 0 0 0 0 0 0 0 0 0 0 0 0;
                     0 0 0 0 Pn(2,1)^3 Pn(2,1)^2 Pn(2,1) 1 0 0 0 0 0 0 0 0;
                     0 0 0 0 Pn(3,1)^3 Pn(3,1)^2 Pn(3,1) 1 0 0 0 0 0 0 0 0;
                     0 0 0 0 0 0 0 0 Pn(3,1)^3 Pn(3,1)^2 Pn(3,1) 1 0 0 0 0;
                     0 0 0 0 0 0 0 0 Pn(4,1)^3 Pn(4,1)^2 Pn(4,1) 1 0 0 0 0;
                     0 0 0 0 0 0 0 0 0 0 0 0 Pn(4,1)^3 Pn(4,1)^2 Pn(4,1) 1;
                     0 0 0 0 0 0 0 0 0 0 0 0 Pn(5,1)^3 Pn(5,1)^2 Pn(5,1) 1;
                     -3 * Pn(2,1)^2 -2 * Pn(2,1) -1 0 3 * Pn(2,1)^2 2 * Pn(2,1) 1 0 0 0 0 0 0 0 0 0;
                     0 0 0 0 -3 * Pn(3,1)^2 -2 * Pn(3,1) -1 0 3 * Pn(3,1)^2 2 * Pn(3,1) 1 0 0 0 0 0;
                     0 0 0 0 0 0 0 0 -3 * Pn(4,1)^2 -2 * Pn(4,1) -1 0 3 * Pn(4,1)^2 2 * Pn(4,1) 1 0;
                     -6 * Pn(2,1) -2 0 0 6 * Pn(2,1) 2 0 0 0 0 0 0 0 0 0 0;
                     0 0 0 0 -6 * Pn(3,1) -2 0 0 6 * Pn(3,1) 2 0 0 0 0 0 0;
                     0 0 0 0 0 0 0 0 -6 * Pn(4,1) -2 0 0 6 * Pn(4,1) 2 0 0;
                     3 * Pn(1,1)^2 2 * Pn(1,1) 1 0 0 0 0 0 0 0 0 0 0 0 0 0;
                     0 0 0 0 0 0 0 0 0 0 0 0 3 * Pn(5,1)^2 2 * Pn(5,1) 1 0];
             
            C_i = inv(obj.C);

            Y = [Pn(1,2);
                Pn(2,2);
                Pn(2,2);
                Pn(3,2);
                Pn(3,2);
                Pn(4,2);
                Pn(4,2);
                Pn(5,2);
                0;
                0;
                0;
                0;
                0;
                0;
                obj.splineStartSlope;
                obj.splineEndSlope];

            A = C_i * Y;

            syms x
            y_a = A(1,1) * x^3 + A(2,1) * x^2 + A(3,1) * x + A(4,1);
            y_b = A(5,1) * x^3 + A(6,1) * x^2 + A(7,1) * x + A(8,1);
            y_c = A(9,1) * x^3 + A(10,1) * x^2 + A(11,1) * x + A(12,1);
            y_d = A(13,1) * x^3 + A(14,1) * x^2 + A(15,1) * x + A(16,1);

            obj.yFuncCellArray{1} = y_a;
            obj.yFuncCellArray{2} = y_b;
            obj.yFuncCellArray{3} = y_c;
            obj.yFuncCellArray{4} = y_d;
            
            yFuncCellArray{1} = y_a;
            yFuncCellArray{2} = y_b;
            yFuncCellArray{3} = y_c;
            yFuncCellArray{4} = y_d;
        end
        
    end
    
end
