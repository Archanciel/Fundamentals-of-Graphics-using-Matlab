classdef SplineModelNPointsTest < matlab.unittest.TestCase
    % SplineModelNPointsTest tests SplineModelNPoints
 
    properties
        splineModelNPoints;
    end
    
    methods(TestMethodSetup)
%        function instanciateTestClass(testCase)
%        end
    end

    methods
        function testCase = SplineModelNPointsTest()
            % comment
            addpath("../model");
            p1 = [0 1];
            p2 = [2 2];
            p3 = [5 4];
            p4 = [8 0];
            p5 = [11 1];
            Pn = [p1;p2;p3;p4;p5];


            spline_colors{1} = 'b';
            spline_colors{2} = 'r';
            spline_colors{3} = 'm';
            spline_colors{4} = 'g';

            testCase.splineModelNPoints = SplineModelNPoints(Pn,...
                                                             4,...
                                                             -2,...
                                                             spline_colors);
        end
    end
    
    methods (Test)
        function testFillPiecewiseSplineFunctionCellArray(testCase)
            testCase.splineModelNPoints.computePiecewiseSplineFunctions();
            actualPiecewiseSplineFunctionCellArray = testCase.splineModelNPoints.yFuncCellArray;
            funcNumber = length(actualPiecewiseSplineFunctionCellArray);
            actualPiecewiseSplineFunctionStringCellArray = cell(funcNumber);

            for i = 1:funcNumber
                func = actualPiecewiseSplineFunctionCellArray(i);
                actualPiecewiseSplineFunctionStringCellArray{i} = char(vpa(func, 2));
            end
            
            expPiecewiseSplineFunctionStringCellArray = cell(funcNumber);
            expPiecewiseSplineFunctionStringCellArray{1} = '4.0*x - 3.1*x^2 + 0.68*x^3 + 1.0';
            expPiecewiseSplineFunctionStringCellArray{2} = '2.3*x^2 - 6.9*x - 0.22*x^3 + 8.2';
            expPiecewiseSplineFunctionStringCellArray{3} = '27.0*x - 4.6*x^2 + 0.24*x^3 - 49.0';
            expPiecewiseSplineFunctionStringCellArray{4} = '8.6*x^2 - 78.0*x - 0.31*x^3 + 230.0';

            testCase.verifyEqual(actualPiecewiseSplineFunctionStringCellArray, expPiecewiseSplineFunctionStringCellArray);
        end
        
        function testBuildYVector(testCase)
            actual_Y_vector = testCase.splineModelNPoints.buildYVector();
            exp_Y_vector = [1;
                            2;
                            2;
                            4;
                            4;
                            0;
                            0;
                            1;
                            0;
                            0;
                            0;
                            0;
                            0;
                            0;
                            4;
                           -2];

            testCase.verifyEqual(actual_Y_vector,exp_Y_vector);
             
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_C_matrix.')
        end
        
        function testCMatrixConstruction(testCase)
            testCase.splineModelNPoints.computePiecewiseSplineFunctions();
            actual_C_matrix = testCase.splineModelNPoints.C;
            exp_C_matrix = [0    0    0    1    0    0    0    0    0    0    0    0    0    0    0    0;
                            8    4    2    1    0    0    0    0    0    0    0    0    0    0    0    0;
                            0    0    0    0    8    4    2    1    0    0    0    0    0    0    0    0;
                            0    0    0    0  125   25    5    1    0    0    0    0    0    0    0    0;
                            0    0    0    0    0    0    0    0  125   25    5    1    0    0    0    0;
                            0    0    0    0    0    0    0    0  512   64    8    1    0    0    0    0;
                            0    0    0    0    0    0    0    0    0    0    0    0  512   64    8    1;
                            0    0    0    0    0    0    0    0    0    0    0    0 1331  121   11    1;
                          -12   -4   -1    0   12    4    1    0    0    0    0    0    0    0    0    0;
                            0    0    0    0  -75  -10   -1    0   75   10    1    0    0    0    0    0;
                            0    0    0    0    0    0    0    0 -192  -16   -1    0  192   16    1    0;
                          -12   -2    0    0   12    2    0    0    0    0    0    0    0    0    0    0;
                            0    0    0    0  -30   -2    0    0   30    2    0    0    0    0    0    0;
                            0    0    0    0    0    0    0    0  -48   -2    0    0   48    2    0    0;
                            0    0    1    0    0    0    0    0    0    0    0    0    0    0    0    0;
                            0    0    0    0    0    0    0    0    0    0    0    0  363   22    1    0];

            testCase.verifyEqual(actual_C_matrix,exp_C_matrix);
             
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_C_matrix.')
        end
        
        function testBuildYFunctionMatrixPartFirstLinePoint_1(testCase)
            pointNumber = 5;
            matrixLineCateory = 1;
            pointIndex = 1;
            
            actual_vector = testCase.splineModelNPoints.buildYFunctionMatrixPart(matrixLineCateory, pointIndex, pointNumber);
            exp_vector = [0    0    0    1    0    0    0    0    0    0    0    0    0    0    0    0];
            testCase.verifyEqual(actual_vector,exp_vector);
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_vector')
        end
         
        function testBuildYFunctionMatrixPartFirstLinePoint_2(testCase)
            pointNumber = 5;
            matrixLineCateory = 1;
            pointIndex = 2;
            
            actual_vector = testCase.splineModelNPoints.buildYFunctionMatrixPart(matrixLineCateory, pointIndex, pointNumber);
            exp_vector = [8    4    2    1    0    0    0    0    0    0    0    0    0    0    0    0];
            testCase.verifyEqual(actual_vector,exp_vector);
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_vector')
        end
         
        function testBuildYFunctionMatrixPartSecondLinePoint_2(testCase)
            pointNumber = 5;
            matrixLineCateory = 2;
            pointIndex = 2;
            
            actual_vector = testCase.splineModelNPoints.buildYFunctionMatrixPart(matrixLineCateory, pointIndex, pointNumber);
            exp_vector = [0    0    0    0    8    4    2    1    0    0    0    0    0    0    0    0];
            testCase.verifyEqual(actual_vector,exp_vector);
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_vector')
        end
         
        function testBuildYFunctionMatrixPartFirstLinePoint_3(testCase)
            pointNumber = 5;
            matrixLineCateory = 1;
            pointIndex = 3;
            
            actual_vector = testCase.splineModelNPoints.buildYFunctionMatrixPart(matrixLineCateory, pointIndex, pointNumber);
            exp_vector = [0    0    0    0  125   25    5    1    0    0    0    0    0    0    0    0];
            testCase.verifyEqual(actual_vector,exp_vector);
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_vector')
        end
         
        function testBuildYFunctionMatrixPartSecondLinePoint_3(testCase)
            pointNumber = 5;
            matrixLineCateory = 2;
            pointIndex = 3;
            
            actual_vector = testCase.splineModelNPoints.buildYFunctionMatrixPart(matrixLineCateory, pointIndex, pointNumber);
            exp_vector = [0    0    0    0    0    0    0    0  125   25    5    1    0    0    0    0];
            testCase.verifyEqual(actual_vector,exp_vector);
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_vector')
        end
         
        function testBuildYFunctionMatrixPartFirstLinePoint_4(testCase)
            pointNumber = 5;
            matrixLineCateory = 1;
            pointIndex = 4;
            
            actual_vector = testCase.splineModelNPoints.buildYFunctionMatrixPart(matrixLineCateory, pointIndex, pointNumber);
            exp_vector = [0    0    0    0    0    0    0    0  512   64    8    1    0    0    0    0];
            testCase.verifyEqual(actual_vector,exp_vector);
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_vector')
        end
         
        function testBuildYFunctionMatrixPartSecondLinePoint_4(testCase)
            pointNumber = 5;
            matrixLineCateory = 2;
            pointIndex = 4;
            
            actual_vector = testCase.splineModelNPoints.buildYFunctionMatrixPart(matrixLineCateory, pointIndex, pointNumber);
            exp_vector = [0    0    0    0    0    0    0    0    0    0    0    0  512   64    8    1];
            testCase.verifyEqual(actual_vector,exp_vector);
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_vector')
        end
         
        function testBuildYFunctionMatrixPartLastLinePoint_5(testCase)
            pointNumber = 5;
            matrixLineCateory = 3;
            pointIndex = 5;
            
            actual_vector = testCase.splineModelNPoints.buildYFunctionMatrixPart(matrixLineCateory, pointIndex, pointNumber);
            exp_vector = [0    0    0    0    0    0    0    0    0    0    0    0 1331  121   11    1];
            testCase.verifyEqual(actual_vector,exp_vector);
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_vector')
        end
        
        function testBuildYPrimeFunctionMatrixPartFirstLinePoint_1(testCase)
            pointNumber = 5;
            pointIndex = 1;
            
            testCase.assertError(@()testCase.splineModelNPoints.buildYPrimeFunctionMatrixPart(pointIndex, pointNumber), 'buildYPrimeFunctionMatrixPart:NoYprimeConstraintForThisPoint');
        end
        
        function testBuildYPrimeFunctionMatrixPartFirstLinePoint_5(testCase)
            pointNumber = 5;
            pointIndex = 5;
            
            testCase.assertError(@()testCase.splineModelNPoints.buildYPrimeFunctionMatrixPart(pointIndex, pointNumber), 'buildYPrimeFunctionMatrixPart:NoYprimeConstraintForThisPoint');
        end
        
        function testBuildYPrimeFunctionMatrixPartFirstLinePoint_2(testCase)
            pointNumber = 5;
            pointIndex = 2;
            
            actual_vector = testCase.splineModelNPoints.buildYPrimeFunctionMatrixPart(pointIndex, pointNumber);
            exp_vector = [-12    -4    -1    0   12    4    1    0    0    0    0    0    0    0    0    0];
            testCase.verifyEqual(actual_vector,exp_vector);
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_vector')
        end
        
        function testBuildYPrimeFunctionMatrixPartFirstLinePoint_3(testCase)
            pointNumber = 5;
            pointIndex = 3;
            
            actual_vector = testCase.splineModelNPoints.buildYPrimeFunctionMatrixPart(pointIndex, pointNumber);
            exp_vector = [0    0    0    0    -75   -10    -1    0   75   10    1    0    0    0    0    0];
            testCase.verifyEqual(actual_vector,exp_vector);
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_vector')
        end
        
        function testBuildYPrimeFunctionMatrixPartFirstLinePoint_4(testCase)
            pointNumber = 5;
            pointIndex = 4;
            
            actual_vector = testCase.splineModelNPoints.buildYPrimeFunctionMatrixPart(pointIndex, pointNumber);
            exp_vector = [0    0    0    0    0    0    0    0   -192   -16    -1    0  192   16    1    0];
            testCase.verifyEqual(actual_vector,exp_vector);
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_vector')
        end       
        
        function testBuildYSecondFunctionMatrixPartFirstLinePoint_1(testCase)
            pointNumber = 5;
            pointIndex = 1;
            
            testCase.assertError(@()testCase.splineModelNPoints.buildYSecondFunctionMatrixPart(pointIndex, pointNumber), 'buildYSecondFunctionMatrixPart:NoYsecondConstraintForThisPoint');
        end
        
        function testBuildYSecondFunctionMatrixPartFirstLinePoint_5(testCase)
            pointNumber = 5;
            pointIndex = 5;
            
            testCase.assertError(@()testCase.splineModelNPoints.buildYSecondFunctionMatrixPart(pointIndex, pointNumber), 'buildYSecondFunctionMatrixPart:NoYsecondConstraintForThisPoint');
        end
        
        function testBuildYPrimeFunctionMatrixPartSecondLinePoint_2(testCase)
            pointNumber = 5;
            pointIndex = 2;
            
            actual_vector = testCase.splineModelNPoints.buildYSecondFunctionMatrixPart(pointIndex, pointNumber);
            exp_vector = [-12    -2     0    0   12    2    0    0    0    0    0    0    0    0    0    0];
            testCase.verifyEqual(actual_vector,exp_vector);
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_vector')
        end
        
        function testBuildYSecondFunctionMatrixPartFirstLinePoint_3(testCase)
            pointNumber = 5;
            pointIndex = 3;
            
            actual_vector = testCase.splineModelNPoints.buildYSecondFunctionMatrixPart(pointIndex, pointNumber);
            exp_vector = [0    0    0    0    -30    -2     0    0   30    2    0    0    0    0    0    0];
            testCase.verifyEqual(actual_vector,exp_vector);
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_vector')
        end
        
        function testBuildYPrimeFunctionMatrixPartSecondLinePoint_4(testCase)
            pointNumber = 5;
            pointIndex = 4;
            
            actual_vector = testCase.splineModelNPoints.buildYSecondFunctionMatrixPart(pointIndex, pointNumber);
            exp_vector = [0    0    0    0    0    0    0    0    -48    -2     0    0   48    2    0    0];
            testCase.verifyEqual(actual_vector,exp_vector);
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_vector')
        end
        
        function testBuildYPrimeSlopeConstraintFuncMatrixPartFirstLinePoint_1(testCase)
            pointNumber = 5;
            pointIndex = 1;
            
            actual_vector = testCase.splineModelNPoints.buildYPrimeSlopeConstraintfunctionMatrixPart(pointIndex, pointNumber);
            exp_vector = [0    0    1     0    0    0    0    0    0    0    0    0    0    0    0    0];
            testCase.verifyEqual(actual_vector,exp_vector);
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_vector')
        end
        
        function testBuildYPrimeSlopeConstraintFuncMatrixPartFirstLinePoint_5(testCase)
            pointNumber = 5;
            pointIndex = 5;
            
            actual_vector = testCase.splineModelNPoints.buildYPrimeSlopeConstraintfunctionMatrixPart(pointIndex, pointNumber);
            exp_vector = [0    0    0     0    0    0    0    0    0    0    0    0  363   22    1    0];
            testCase.verifyEqual(actual_vector,exp_vector);
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_vector')
        end
        
        function testBuildYPrimeSlopeConstraintFuncMatrixPartFirstLinePoint_2(testCase)
            pointNumber = 5;
            pointIndex = 2;
            testCase.assertError(@()testCase.splineModelNPoints.buildYPrimeSlopeConstraintfunctionMatrixPart(pointIndex, pointNumber), 'buildYPrimeSlopeConstraintfunctionMatrixPart:NoBeginOrEndSlopeConstraintForThisPoint');
        end
        
        function testBuildYPrimeSlopeConstraintFuncMatrixPartFirstLinePoint_3(testCase)
            pointNumber = 5;
            pointIndex = 3;
            
            testCase.assertError(@()testCase.splineModelNPoints.buildYPrimeSlopeConstraintfunctionMatrixPart(pointIndex, pointNumber), 'buildYPrimeSlopeConstraintfunctionMatrixPart:NoBeginOrEndSlopeConstraintForThisPoint');
        end
        
        function testBuildYPrimeSlopeConstraintFuncMatrixPartFirstLinePoint_4(testCase)
            pointNumber = 5;
            pointIndex = 4;
            
            testCase.assertError(@()testCase.splineModelNPoints.buildYPrimeSlopeConstraintfunctionMatrixPart(pointIndex, pointNumber), 'buildYPrimeSlopeConstraintfunctionMatrixPart:NoBeginOrEndSlopeConstraintForThisPoint');
        end
        
        function testBuildCMatrix(testCase)
            actual_C_matrix = testCase.splineModelNPoints.buildCMatrix();
            exp_C_matrix = [0    0    0    1    0    0    0    0    0    0    0    0    0    0    0    0;
                            8    4    2    1    0    0    0    0    0    0    0    0    0    0    0    0;
                            0    0    0    0    8    4    2    1    0    0    0    0    0    0    0    0;
                            0    0    0    0  125   25    5    1    0    0    0    0    0    0    0    0;
                            0    0    0    0    0    0    0    0  125   25    5    1    0    0    0    0;
                            0    0    0    0    0    0    0    0  512   64    8    1    0    0    0    0;
                            0    0    0    0    0    0    0    0    0    0    0    0  512   64    8    1;
                            0    0    0    0    0    0    0    0    0    0    0    0 1331  121   11    1;
                          -12   -4   -1    0   12    4    1    0    0    0    0    0    0    0    0    0;
                            0    0    0    0  -75  -10   -1    0   75   10    1    0    0    0    0    0;
                            0    0    0    0    0    0    0    0 -192  -16   -1    0  192   16    1    0;
                          -12   -2    0    0   12    2    0    0    0    0    0    0    0    0    0    0;
                            0    0    0    0  -30   -2    0    0   30    2    0    0    0    0    0    0;
                            0    0    0    0    0    0    0    0  -48   -2    0    0   48    2    0    0;
                            0    0    1    0    0    0    0    0    0    0    0    0    0    0    0    0;
                            0    0    0    0    0    0    0    0    0    0    0    0  363   22    1    0];

            testCase.verifyEqual(actual_C_matrix,exp_C_matrix);
             
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_C_matrix.')
        end
        
    end
    
end 
