classdef SplineModel < handle
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
        function obj = SplineModel(splinePointVector,...
                                   splineStartSlope,...
                                   splineEndSlope,...
                                   splineColorCellArray)
            % setting x and y coordinates vector                            
            obj.splineXpointCoordVector = [splinePointVector(:,1)'];
            
            obj.ensureXOoordinatesAreIncreasing();
            
            obj.splineYpointCoordVector = [splinePointVector(:,2)'];
            obj.splineStartSlope = splineStartSlope;
            obj.splineEndSlope = splineEndSlope;
            obj.splineColorCellArray = splineColorCellArray;
            obj.yFuncCellArray = cell(1, obj.getSplinePointNumber() - 1);
        end
        
        function ensureXOoordinatesAreIncreasing(obj)
            try
                validateattributes(obj.splineXpointCoordVector, {'double'},{'increasing'});
            catch
                error('SplineModel:NotAllPointXCoordinatesAreIncreasing','Not all points satisfy the X coordinate increasing value constraint !');       
            end
        end
        
        function pointNumber = getSplinePointNumber(obj)
            pointNumber = length(obj.splineXpointCoordVector);
        end
        
        function splineColorCellArray = getSplineColorCellArray(obj)
            splineColorCellArray = obj.splineColorCellArray; 
        end
      
        function reComputePiecewiseSplineFunctions(obj)
            % This method does notifiy the model listeners that the spline
            % was recomputed. Typically, this means that the listeners
            % will have to replot the spline ...
            obj.computePiecewiseSplineFunctions();
            
            notify(obj,'SplineComputedEvent');
        end
        
        function answer = isLastPoint(obj, pointIndex)
            % Returns 1 if true, 0 else.
            answer = pointIndex == obj.getSplinePointNumber(); 
        end
        
        function computePiecewiseSplineFunctions(obj)
            % Fills a 3 elements instance variable cell array containing the
            % piecewise spline y_A, y_B and y_C functions

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

            obj.yFuncCellArray{1} = y_A;
            obj.yFuncCellArray{2} = y_B;
            obj.yFuncCellArray{3} = y_C;
        end
        
        function addListenerToEvent(obj, listener, eventStr)  
            % Used to add view as listener to model changes. 
            %
            % In view/SplineView/createListenerForEvent (line 753)
            % In model/SplineModel/addListenerToEvent (line 105)
            % In model/SplineCollection/addViewListenerToModels (line 29)
            % In controller/SplineController/addView (line 24)
            % In SplineAppCreator (line 76)
            listener.createListenerForEvent(obj, eventStr);
        end
    end
end