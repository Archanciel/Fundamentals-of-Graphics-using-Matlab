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
            p3 = [5 0];
            p4 = [8 0];
            p5 = [11 0];
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
        
        function testBuildYfunctionMatrixPartFirstLinePoint_1(testCase)
            pointNumber = 5;
            matrixLineCateory = 1;
            pointIndex = 1;
            
            actual_vector = testCase.splineModelNPoints.buildYfunctionMatrixPart(matrixLineCateory, pointIndex, pointNumber);
            exp_vector = [0    0    0    1    0    0    0    0    0    0    0    0    0    0    0    0];
            testCase.verifyEqual(actual_vector,exp_vector);
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_vector')
        end
         
        function testBuildYfunctionMatrixPartFirstLinePoint_2(testCase)
            pointNumber = 5;
            matrixLineCateory = 1;
            pointIndex = 2;
            
            actual_vector = testCase.splineModelNPoints.buildYfunctionMatrixPart(matrixLineCateory, pointIndex, pointNumber);
            exp_vector = [8    4    2    1    0    0    0    0    0    0    0    0    0    0    0    0];
            testCase.verifyEqual(actual_vector,exp_vector);
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_vector')
        end
         
        function testBuildYfunctionMatrixPartSecondLinePoint_2(testCase)
            pointNumber = 5;
            matrixLineCateory = 2;
            pointIndex = 2;
            
            actual_vector = testCase.splineModelNPoints.buildYfunctionMatrixPart(matrixLineCateory, pointIndex, pointNumber);
            exp_vector = [0    0    0    0    8    4    2    1    0    0    0    0    0    0    0    0];
            testCase.verifyEqual(actual_vector,exp_vector);
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_vector')
        end
         
        function testBuildYfunctionMatrixPartFirstLinePoint_3(testCase)
            pointNumber = 5;
            matrixLineCateory = 1;
            pointIndex = 3;
            
            actual_vector = testCase.splineModelNPoints.buildYfunctionMatrixPart(matrixLineCateory, pointIndex, pointNumber);
            exp_vector = [0    0    0    0  125   25    5    1    0    0    0    0    0    0    0    0];
            testCase.verifyEqual(actual_vector,exp_vector);
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_vector')
        end
         
        function testBuildYfunctionMatrixPartSecondLinePoint_3(testCase)
            pointNumber = 5;
            matrixLineCateory = 2;
            pointIndex = 3;
            
            actual_vector = testCase.splineModelNPoints.buildYfunctionMatrixPart(matrixLineCateory, pointIndex, pointNumber);
            exp_vector = [0    0    0    0    0    0    0    0  125   25    5    1    0    0    0    0];
            testCase.verifyEqual(actual_vector,exp_vector);
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_vector')
        end
         
        function testBuildYfunctionMatrixPartFirstLinePoint_4(testCase)
            pointNumber = 5;
            matrixLineCateory = 1;
            pointIndex = 4;
            
            actual_vector = testCase.splineModelNPoints.buildYfunctionMatrixPart(matrixLineCateory, pointIndex, pointNumber);
            exp_vector = [0    0    0    0    0    0    0    0  512   64    8    1    0    0    0    0];
            testCase.verifyEqual(actual_vector,exp_vector);
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_vector')
        end
         
        function testBuildYfunctionMatrixPartSecondLinePoint_4(testCase)
            pointNumber = 5;
            matrixLineCateory = 2;
            pointIndex = 4;
            
            actual_vector = testCase.splineModelNPoints.buildYfunctionMatrixPart(matrixLineCateory, pointIndex, pointNumber);
            exp_vector = [0    0    0    0    0    0    0    0    0    0    0    0  512   64    8    1];
            testCase.verifyEqual(actual_vector,exp_vector);
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_vector')
        end
         
        function testBuildYfunctionMatrixPartLastLinePoint_5(testCase)
            pointNumber = 5;
            matrixLineCateory = 3;
            pointIndex = 5;
            
            actual_vector = testCase.splineModelNPoints.buildYfunctionMatrixPart(matrixLineCateory, pointIndex, pointNumber);
            exp_vector = [0    0    0    0    0    0    0    0    0    0    0    0 1331  121   11    1];
            testCase.verifyEqual(actual_vector,exp_vector);
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_vector')
        end
        
        function testBuildYPrimefunctionMatrixPartFirstLinePoint_1(testCase)
            pointNumber = 5;
            pointIndex = 1;
            
            actual_vector = testCase.splineModelNPoints.buildYPrimefunctionMatrixPart(pointIndex, pointNumber);
            exp_vector = [];
            testCase.verifyEqual(actual_vector,exp_vector);
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_vector')
        end
        
        function testBuildYPrimefunctionMatrixPartFirstLinePoint_5(testCase)
            pointNumber = 5;
            pointIndex = 5;
            
            actual_vector = testCase.splineModelNPoints.buildYPrimefunctionMatrixPart(pointIndex, pointNumber);
            exp_vector = [];
            testCase.verifyEqual(actual_vector,exp_vector);
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_vector')
        end
        
        function testBuildYPrimefunctionMatrixPartFirstLinePoint_2(testCase)
            pointNumber = 5;
            pointIndex = 2;
            
            actual_vector = testCase.splineModelNPoints.buildYPrimefunctionMatrixPart(pointIndex, pointNumber);
            exp_vector = [-12    -4    -1    0   12    4    1    0    0    0    0    0    0    0    0    0];
            testCase.verifyEqual(actual_vector,exp_vector);
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_vector')
        end
        
        function testBuildYPrimefunctionMatrixPartFirstLinePoint_3(testCase)
            pointNumber = 5;
            pointIndex = 3;
            
            actual_vector = testCase.splineModelNPoints.buildYPrimefunctionMatrixPart(pointIndex, pointNumber);
            exp_vector = [0    0    0    0    -75   -10    -1    0   75   10    1    0    0    0    0    0];
            testCase.verifyEqual(actual_vector,exp_vector);
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_vector')
        end
        
        function testBuildYPrimefunctionMatrixPartFirstLinePoint_4(testCase)
            pointNumber = 5;
            pointIndex = 4;
            
            actual_vector = testCase.splineModelNPoints.buildYPrimefunctionMatrixPart(pointIndex, pointNumber);
            exp_vector = [0    0    0    0    0    0    0    0   -192   -16    -1    0  192   16    1    0];
            testCase.verifyEqual(actual_vector,exp_vector);
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_vector')
        end

%ooooo        
        
        function testBuildYSecondfunctionMatrixPartFirstLinePoint_1(testCase)
            pointNumber = 5;
            pointIndex = 1;
            
            actual_vector = testCase.splineModelNPoints.buildYSecondfunctionMatrixPart(pointIndex, pointNumber);
            exp_vector = [];
            testCase.verifyEqual(actual_vector,exp_vector);
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_vector')
        end
        
        function testBuildYSecondfunctionMatrixPartFirstLinePoint_5(testCase)
            pointNumber = 5;
            pointIndex = 5;
            
            actual_vector = testCase.splineModelNPoints.buildYSecondfunctionMatrixPart(pointIndex, pointNumber);
            exp_vector = [];
            testCase.verifyEqual(actual_vector,exp_vector);
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_vector')
        end
        
        function testBuildYPrimefunctionMatrixPartSecondLinePoint_2(testCase)
            pointNumber = 5;
            pointIndex = 2;
            
            actual_vector = testCase.splineModelNPoints.buildYSecondfunctionMatrixPart(pointIndex, pointNumber);
            exp_vector = [-12    -2     0    0   12    2    0    0    0    0    0    0    0    0    0    0];
            testCase.verifyEqual(actual_vector,exp_vector);
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_vector')
        end
        
        function testBuildYSecondfunctionMatrixPartFirstLinePoint_3(testCase)
            pointNumber = 5;
            pointIndex = 3;
            
            actual_vector = testCase.splineModelNPoints.buildYSecondfunctionMatrixPart(pointIndex, pointNumber);
            exp_vector = [0    0    0    0    -30    -2     0    0   30    2    0    0    0    0    0    0];
            testCase.verifyEqual(actual_vector,exp_vector);
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_vector')
        end
        
        function testBuildYPrimefunctionMatrixPartSecondLinePoint_4(testCase)
            pointNumber = 5;
            pointIndex = 4;
            
            actual_vector = testCase.splineModelNPoints.buildYSecondfunctionMatrixPart(pointIndex, pointNumber);
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
            
            actual_vector = testCase.splineModelNPoints.buildYPrimeSlopeConstraintfunctionMatrixPart(pointIndex, pointNumber);
            exp_vector = [];
            testCase.verifyEqual(actual_vector,exp_vector);
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_vector')
        end
        
        function testBuildYPrimeSlopeConstraintFuncMatrixPartFirstLinePoint_3(testCase)
            pointNumber = 5;
            pointIndex = 3;
            
            actual_vector = testCase.splineModelNPoints.buildYPrimeSlopeConstraintfunctionMatrixPart(pointIndex, pointNumber);
            exp_vector = [];
            testCase.verifyEqual(actual_vector,exp_vector);
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_vector')
        end
        
        function testBuildYPrimeSlopeConstraintFuncMatrixPartFirstLinePoint_4(testCase)
            pointNumber = 5;
            pointIndex = 4;
            
            actual_vector = testCase.splineModelNPoints.buildYPrimeSlopeConstraintfunctionMatrixPart(pointIndex, pointNumber);
            exp_vector = [];
            testCase.verifyEqual(actual_vector,exp_vector);
%            fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', actual_vector')
        end
        
    end
    
end 
