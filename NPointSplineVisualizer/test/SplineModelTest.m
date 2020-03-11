classdef SplineModelTest < matlab.unittest.TestCase
    % SplineModelNPointsTest tests SplineModelNPoints
 
    properties;
    end
    
    methods(TestMethodSetup)
%        function instanciateTestClass(testCase)
%        end
    end

    methods
        function testCase = SplineModelTest()
            % comment
        end
    end
    
    methods (Test)
        function testInstanciateSplineModel_valid(testCase)
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

            actual_splineModel = SplineModel(Pn,...
                                                             4,...
                                                             -2,...
                                                             spline_colors);
        end
        
        function testInstanciateSplineModel_invavid(testCase)
            p1 = [0 1];
            p2 = [2 2];
            p3 = [5 4];
            p4 = [4 0];
            p5 = [11 1];
            Pn = [p1;p2;p3;p4;p5];


            spline_colors{1} = 'b';
            spline_colors{2} = 'r';
            spline_colors{3} = 'm';
            spline_colors{4} = 'g';

            testCase.assertError(@()SplineModel(Pn,4,2,spline_colors), 'SplineModel:NotAllPointXCoordinatesAreIncreasing');
        end
                
    end
    
end 
