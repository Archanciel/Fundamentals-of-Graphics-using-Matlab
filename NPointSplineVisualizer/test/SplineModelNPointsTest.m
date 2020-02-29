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
    end
    
end 
