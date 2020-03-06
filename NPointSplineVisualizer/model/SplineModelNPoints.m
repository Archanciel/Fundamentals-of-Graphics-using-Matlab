classdef SplineModelNPoints < SplineModel
    % inheriting from handle in order for instances to be passed by reference
    properties (Access = public)
        % constants
        % none !        

        C;
    end
    
    properties (Access = private)
        A; % hosts the computed piecewise spline function coefficients.
           % Using a private instance variable failitates unit testing
           % the fillPiecewiseSplineFunctionCellArray() method.
    end
    
    methods (Access = public)
        
        function obj = SplineModelNPoints(splinePointVector,...
                                          splineStartSlope,...
                                          splineEndSlope,...
                                          splineColorCellArray)
            obj@SplineModel(splinePointVector,...
                            splineStartSlope,...
                            splineEndSlope,...
                            splineColorCellArray);                                          
        end
        
        function computePiecewiseSplineFunctions(obj)
            obj.C = obj.buildCMatrix();            
            C_i = inv(obj.C);
            Y = obj.buildYVector();            
            obj.A = C_i * Y;
            obj.fillPiecewiseSplineFunctionCellArray();
        end

        function fillPiecewiseSplineFunctionCellArray(obj) 
            matrixA = obj.A;
            lineNumber = size(matrixA, 1);
            
            syms x;
            j = 1;
            
            for i = 1:4:lineNumber - 3
               yFunction = matrixA(i,1) * x^3 + matrixA(i + 1,1) * x^2 + matrixA(i + 2,1) * x + matrixA(i + 3,1);
%               char(vpa(yFunction, 2))
               obj.yFuncCellArray{j} = yFunction;
               j = j + 1;
            end
        end
        
        function vector = buildYVector(obj) 
            pointNumber = length(obj.splineYpointCoordVector);
            vector = [];
            
            % building vector Y function part
            for i = 1:pointNumber
                if i == 1
                    vector = [obj.splineYpointCoordVector(1)];
                elseif i == pointNumber
                    vector = [vector; obj.splineYpointCoordVector(pointNumber)];
                else
                    vector = [vector; obj.splineYpointCoordVector(i)];
                    vector = [vector; obj.splineYpointCoordVector(i)];
                end
            end

            % building vector Y y prime constraint part
            for i = 2:pointNumber - 1
                vector = [vector; 0];
            end
            
            % building vector Y y second constraint part
            for i = 2:pointNumber - 1
                vector = [vector; 0];
            end
            
            % adding vector Y first slope value
            vector = [vector; obj.splineStartSlope];
            
            % adding vector Y last slope value
            vector = [vector; obj.splineEndSlope];
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
