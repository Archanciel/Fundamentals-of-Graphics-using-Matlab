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
        Pn;
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
    
    methods (Access = public)
        
        function obj = SplineModelNPoints(splinePointVector,...
                                          splineStartSlope,...
                                          splineEndSlope,...
                                          splineColorCellArray)
            % setting x and y coordinates vector                            
            obj.splineXpointCoordVector = [splinePointVector(:,1)'];
            obj.splineYpointCoordVector = [splinePointVector(:,2)'];
            obj.Pn = [obj.splineXpointCoordVector(1,:)' obj.splineYpointCoordVector(1,:)'];            
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

            Pn = obj.Pn;
            
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

        function matrix = buildCMatrix(obj) 
            pointNumber = length(obj.splineXpointCoordVector);
            matrix = [];
            
            % building y function part
            for i = 1:pointNumber
                if i == 1
                    matrix = [obj.buildYFunctionMatrixPart(1, i, pointNumber)];
                elseif i == pointNumber
                    matrix = [matrix; obj.buildYFunctionMatrixPart(3, i, pointNumber)];
                else
                    matrix = [matrix; obj.buildYFunctionMatrixPart(1, i, pointNumber)];                    
                    matrix = [matrix; obj.buildYFunctionMatrixPart(2, i, pointNumber)];                    
                end
            end

            % building y prime constraint part
            for i = 2:pointNumber - 1
                matrix = [matrix; obj.buildYPrimeFunctionMatrixPart(i, pointNumber)];
            end
            
            % building y second constraint part
            for i = 2:pointNumber - 1
                matrix = [matrix; obj.buildYSecondFunctionMatrixPart(i, pointNumber)];
            end
            
            % building first slope constraint part
            matrix = [matrix; obj.buildYPrimeSlopeConstraintfunctionMatrixPart(1, pointNumber)];
            
            % building last slope constraint part
            matrix = [matrix; obj.buildYPrimeSlopeConstraintfunctionMatrixPart(pointNumber, pointNumber)];
            
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', matrix.')
        end

        function vector = buildYFunctionMatrixPart(obj, matrixLineCategory, pointIndex, pointNumber) 
            % matrixLineCategory: values 1, 2 or 3. Indicates if first matrix line, 
            % second matrix line or last matrix line of y function group.
            x = obj.splineXpointCoordVector(pointIndex);
            
            if matrixLineCategory == 1
                if pointIndex == 1
                    startZerosVector = zeros(1, (pointIndex - 1) * 4);
                    endZerosVector = zeros(1, (pointNumber - pointIndex - 1) * 4);
                else
                    startZerosVector = zeros(1, (pointIndex - 2) * 4);
                    endZerosVector = zeros(1, (pointNumber - pointIndex) * 4);
                end
                    
                vector = [startZerosVector x^3 x^2 x 1 endZerosVector]; 
            elseif matrixLineCategory == 2
                startZerosVector = zeros(1, (pointIndex - 1) * 4);
                endZerosVector = zeros(1, (pointNumber - pointIndex - 1) * 4);            
                vector = [startZerosVector x^3 x^2 x 1 endZerosVector]; 
            else % last matrix line
                startZerosVector = zeros(1, (pointIndex - 2) * 4);
                endZerosVector = zeros(1, (pointNumber - pointIndex) * 4);            
                vector = [startZerosVector x^3 x^2 x 1 endZerosVector]; 
            end
        end
        
        function vector = buildYPrimeFunctionMatrixPart(obj, pointIndex, pointNumber)             
            if pointIndex == 1 || pointIndex == pointNumber
                % first or last point have no y' constraint
                error('buildYPrimeFunctionMatrixPart:NoYprimeConstraintForThisPoint','Calling this method for first or last point is incorrect since those points have no y prime constraint !')
            else
                x = obj.splineXpointCoordVector(pointIndex);
                startZerosVector = zeros(1, (pointIndex - 2) * 4);
                endZerosVector = zeros(1, (pointNumber - pointIndex - 1) * 4);
                vector = [startZerosVector (-3 * x^2) (-2 * x) -1 0 (3 * x^2) (2 * x) 1 0 endZerosVector]; 
            end
        end
        
        function vector = buildYSecondFunctionMatrixPart(obj, pointIndex, pointNumber)             
            if pointIndex == 1 || pointIndex == pointNumber
                % first or last point have no ý'' constraint
                error('buildYSecondFunctionMatrixPart:NoYsecondConstraintForThisPoint','Calling this method for first or last point is incorrect since those points have no y second constraint !')
            else
                x = obj.splineXpointCoordVector(pointIndex);
                startZerosVector = zeros(1, (pointIndex - 2) * 4);
                endZerosVector = zeros(1, (pointNumber - pointIndex - 1) * 4);
                vector = [startZerosVector (-6 * x) -2 0 0 (6 * x) 2 0 0 endZerosVector]; 
            end
        end
        
        function vector = buildYPrimeSlopeConstraintfunctionMatrixPart(obj, pointIndex, pointNumber)             
            x = obj.splineXpointCoordVector(pointIndex);
            
            if pointIndex == 1
                startZerosVector = [];
                endZerosVector = zeros(1, (pointNumber - 2) * 4);
                vector = [startZerosVector (3 * x^2) (2 * x) 1 0 endZerosVector]; 
            elseif pointIndex == pointNumber
                startZerosVector = zeros(1, (pointIndex - 2) * 4);
                endZerosVector = [];
                vector = [startZerosVector (3 * x^2) (2 * x) 1 0 endZerosVector]; 
            else
                % only first or last point have a y' slope constraint
                error('buildYPrimeSlopeConstraintfunctionMatrixPart:NoBeginOrEndSlopeConstraintForThisPoint','Calling this method for an intermediate point is incorrect since those points have no slope constraint !')
            end
        end
        
    end % public methods
    
    methods (Access = private)
        
        
    end % private methods        
end
