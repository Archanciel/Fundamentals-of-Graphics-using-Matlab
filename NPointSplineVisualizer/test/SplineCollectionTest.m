classdef SplineCollectionTest < matlab.unittest.TestCase
    % SplineModelNPointsTest tests SplineModelNPoints
 
    properties
    end
    
    methods(TestMethodSetup)
%        function instanciateTestClass(testCase)
%        end
    end

    methods
        function testCase = SplineCollectionTest()
            addpath("../model");
            % comment
        end
    end

    methods (Access = private) % utiliy methods
        function splineCollection = fill3SameSizeSplineCollection(testCase)
            splineCollection = SplineCollection();

            % initial piecewise splines points coordinates

            p1 = [0 1];
            p2 = [2 2];
            p3 = [5 0];
            p4 = [8 0];

            P_1_4 = [p1;p2;p3;p4];

            % initial piecewise spline drawing parms

            spline_colors{1} = 'b';
            spline_colors{2} = 'r';
            spline_colors{3} = 'm';

            splineModel = SplineModel(P_1_4,...
                                      4,...
                                      -2,...
                                      spline_colors);

            splineCollection.addSplineModel(splineModel);

            % additional piecewise splines points coordinates

            p5 = [8 0];
            p6 = [9 -1];
            p7 = [10 3];
            p8 = [11 2];

            P_5_8 = [p5;p6;p7;p8];

            % additional piecewise spline drawing parms

            spline_colors{1} = 'k';
            spline_colors{2} = 'r';
            spline_colors{3} = 'g';

            additionalSplineModel = SplineModel(P_5_8,...
                                                -2,...
                                                0,...
                                                spline_colors);

            splineCollection.addSplineModel(additionalSplineModel);

            % third piecewise splines points coordinates

            p9 = [11 2];
            p10 = [14 -2];
            p11 = [15 4];
            p12 = [16 -2];

            P_9_12 = [p9;p10;p11;p12];

            % third piecewise spline drawing parms

            spline_colors{1} = 'r';
            spline_colors{2} = 'g';
            spline_colors{3} = 'k';

            thirdSplineModel = SplineModel(P_9_12,...
                                           0,...
                                           3,...
                                           spline_colors);

            splineCollection.addSplineModel(thirdSplineModel);
        end
        
        function splineCollection = fill3DifferentSizeSplineCollection(testCase)
            splineCollection = SplineCollection();

            % initial piecewise splines 5 points coordinates

            p1 = [0 1];
            p2 = [2 2];
            p3 = [5 0];
            p35 = [6 -2];
            p4 = [8 0];

            P_1_4 = [p1;p2;p3;p35;p4];

            % initial piecewise spline drawing parms

            spline_colors{1} = 'b';
            spline_colors{2} = 'r';
            spline_colors{3} = 'y';
            spline_colors{4} = 'm';

            splineModel = SplineModelNPoints(P_1_4,...
                                      4,...
                                      -2,...
                                      spline_colors);

            splineCollection.addSplineModel(splineModel);

            % additional piecewise splines 5 points coordinates

            p5 = [8 0];
            p6 = [9 -1];
            p7 = [10 3];
            p75 = [10.5 3];
            p8 = [11 2];

            P_5_8 = [p5;p6;p7;p75;p8];

            % additional piecewise spline drawing parms

            spline_colors{1} = 'k--';
            spline_colors{2} = 'r--';
            spline_colors{3} = 'g--';
            spline_colors{4} = 'y--';

            additionalSplineModel = SplineModelNPoints(P_5_8,...
                                                -2,...
                                                0,...
                                                spline_colors);

            splineCollection.addSplineModel(additionalSplineModel);

            % third piecewise splines 4 points coordinates

            p9 = [11 2];
            p10 = [14 -2];
            p11 = [15 4];
            p12 = [16 -2];

            P_9_12 = [p9;p10;p11;p12];

            % third piecewise spline drawing parms

            spline_colors{1} = 'r-.';
            spline_colors{2} = 'g-.';
            spline_colors{3} = 'k-.';

            thirdSplineModel = SplineModelNPoints(P_9_12,...
                                           0,...
                                           3,...
                                           spline_colors);

            splineCollection.addSplineModel(thirdSplineModel);
        end
        
    end
    
    methods (Test)
        function testFillColorCellArray(testCase)
            lineStyle = '-';
            splineCollection = SplineCollection();
            actual_color_cellArray = splineCollection.fillColorCellArray(7, lineStyle);
            exp_color_cellArray{1} = 'r-';
            exp_color_cellArray{2} = 'y-';
            exp_color_cellArray{3} = 'm-';
            exp_color_cellArray{4} = 'k-';
            exp_color_cellArray{5} = 'g-';
            exp_color_cellArray{6} = 'c-';
            exp_color_cellArray{7} = 'b-';
            testCase.verifyEqual(actual_color_cellArray, exp_color_cellArray);
            
%            celldisp(actual_color_cellArray);
        end

        function testGetMinMaxX_3SameSizeSplineCollection_P1(testCase)
            splineCollection = testCase.fill3SameSizeSplineCollection;
            
            firstPointIndex = 1;
            secondPointIndex = 1;
            xAxisMin = -1;
            xAxisMax = 17;
            coordVariationMinStep = 0.1;
            [actual_minX, actual_maxX] = splineCollection.getMinMaxX(firstPointIndex, secondPointIndex, xAxisMin, xAxisMax, coordVariationMinStep);
            exp_minX = -1;
            exp_maxX = 1.9;
            testCase.verifyEqual(actual_minX, exp_minX);
            testCase.verifyEqual(actual_maxX, exp_maxX);
        end
        
        function testGetMinMaxX_3SameSizeSplineCollection_P2(testCase)
            splineCollection = testCase.fill3SameSizeSplineCollection;
            
            firstPointIndex = 2;
            secondPointIndex = 2;
            xAxisMin = -1;
            xAxisMax = 17;
            coordVariationMinStep = 0.1;
            [actual_minX, actual_maxX] = splineCollection.getMinMaxX(firstPointIndex, secondPointIndex, xAxisMin, xAxisMax, coordVariationMinStep);
            exp_minX = 0.1;
            exp_maxX = 4.9;
            testCase.verifyEqual(actual_minX, exp_minX);
            testCase.verifyEqual(actual_maxX, exp_maxX);
        end
        
        function testGetMinMaxX_3SameSizeSplineCollection_P4(testCase)
            splineCollection = testCase.fill3SameSizeSplineCollection;
            
            firstPointIndex = 4;
            secondPointIndex = 5;
            xAxisMin = -1;
            xAxisMax = 17;
            coordVariationMinStep = 0.1;
            [actual_minX, actual_maxX] = splineCollection.getMinMaxX(firstPointIndex, secondPointIndex, xAxisMin, xAxisMax, coordVariationMinStep);
            exp_minX = 5.1;
            exp_maxX = 8.9;
            testCase.verifyEqual(actual_minX, exp_minX);
            testCase.verifyEqual(actual_maxX, exp_maxX);
        end
        
        function testGetMinMaxX_3SameSizeSplineCollection_P6(testCase)
            splineCollection = testCase.fill3SameSizeSplineCollection;
            
            firstPointIndex = 6;
            secondPointIndex = 6;
            xAxisMin = -1;
            xAxisMax = 17;
            coordVariationMinStep = 0.1;
            [actual_minX, actual_maxX] = splineCollection.getMinMaxX(firstPointIndex, secondPointIndex, xAxisMin, xAxisMax, coordVariationMinStep);
            exp_minX = 8.1;
            exp_maxX = 9.9;
            testCase.verifyEqual(actual_minX, exp_minX);
            testCase.verifyEqual(actual_maxX, exp_maxX);
        end
        
        function testGetMinMaxX_3SameSizeSplineCollection_P8(testCase)
            splineCollection = testCase.fill3SameSizeSplineCollection;
            
            firstPointIndex = 8;
            secondPointIndex = 9;
            xAxisMin = -1;
            xAxisMax = 17;
            coordVariationMinStep = 0.1;
            [actual_minX, actual_maxX] = splineCollection.getMinMaxX(firstPointIndex, secondPointIndex, xAxisMin, xAxisMax, coordVariationMinStep);
            exp_minX = 10.1;
            exp_maxX = 13.9;
            testCase.verifyEqual(actual_minX, exp_minX);
            testCase.verifyEqual(actual_maxX, exp_maxX);
        end
        
        function testGetMinMaxX_3SameSizeSplineCollection_P12(testCase)
            splineCollection = testCase.fill3SameSizeSplineCollection;
            
            firstPointIndex = 12;
            secondPointIndex = 12;
            xAxisMin = -1;
            xAxisMax = 17;
            coordVariationMinStep = 0.1;
            [actual_minX, actual_maxX] = splineCollection.getMinMaxX(firstPointIndex, secondPointIndex, xAxisMin, xAxisMax, coordVariationMinStep);
            exp_minX = 15.1;
            exp_maxX = 17;
            testCase.verifyEqual(actual_minX, exp_minX);
            testCase.verifyEqual(actual_maxX, exp_maxX);
        end
        
        function testGetMinMaxX_3DifferentSizeSplineCollection_P1(testCase)
            splineCollection = testCase.fill3DifferentSizeSplineCollection;
            
            firstPointIndex = 1;
            secondPointIndex = 1;
            xAxisMin = -1;
            xAxisMax = 17;
            coordVariationMinStep = 0.1;
            [actual_minX, actual_maxX] = splineCollection.getMinMaxX(firstPointIndex, secondPointIndex, xAxisMin, xAxisMax, coordVariationMinStep);
            exp_minX = -1;
            exp_maxX = 1.9;
            testCase.verifyEqual(actual_minX, exp_minX);
            testCase.verifyEqual(actual_maxX, exp_maxX);
        end
        
        function testGetMinMaxX_3DifferentSizeSplineCollection_P2(testCase)
            splineCollection = testCase.fill3DifferentSizeSplineCollection;
            
            firstPointIndex = 2;
            secondPointIndex = 2;
            xAxisMin = -1;
            xAxisMax = 17;
            coordVariationMinStep = 0.1;
            [actual_minX, actual_maxX] = splineCollection.getMinMaxX(firstPointIndex, secondPointIndex, xAxisMin, xAxisMax, coordVariationMinStep);
            exp_minX = 0.1;
            exp_maxX = 4.9;
            testCase.verifyEqual(actual_minX, exp_minX);
            testCase.verifyEqual(actual_maxX, exp_maxX);
        end
        
        function testGetMinMaxX_3DifferentSizeSplineCollection_P4(testCase)
            splineCollection = testCase.fill3DifferentSizeSplineCollection;
            
            firstPointIndex = 4;
            secondPointIndex = 4;
            xAxisMin = -1;
            xAxisMax = 17;
            coordVariationMinStep = 0.1;
            [actual_minX, actual_maxX] = splineCollection.getMinMaxX(firstPointIndex, secondPointIndex, xAxisMin, xAxisMax, coordVariationMinStep);
            exp_minX = 5.1;
            exp_maxX = 7.9;
            testCase.verifyEqual(actual_minX, exp_minX);
            testCase.verifyEqual(actual_maxX, exp_maxX);
        end
        
        function testGetMinMaxX_3DifferentSizeSplineCollection_P14(testCase)
            splineCollection = testCase.fill3DifferentSizeSplineCollection;
            
            firstPointIndex = 14;
            secondPointIndex = 14;
            xAxisMin = -1;
            xAxisMax = 17;
            coordVariationMinStep = 0.1;
            [actual_minX, actual_maxX] = splineCollection.getMinMaxX(firstPointIndex, secondPointIndex, xAxisMin, xAxisMax, coordVariationMinStep);
            exp_minX = 15.1;
            exp_maxX = 17;
            testCase.verifyEqual(actual_minX, exp_minX);
            testCase.verifyEqual(actual_maxX, exp_maxX);
        end
        
        function testGetMinMaxX_3DifferentSizeSplineCollection_P5(testCase)
            splineCollection = testCase.fill3DifferentSizeSplineCollection;
            
            firstPointIndex = 5;
            secondPointIndex = 6;
            xAxisMin = -1;
            xAxisMax = 17;
            coordVariationMinStep = 0.1;
            [actual_minX, actual_maxX] = splineCollection.getMinMaxX(firstPointIndex, secondPointIndex, xAxisMin, xAxisMax, coordVariationMinStep);
            exp_minX = 6.1;
            exp_maxX = 8.9;
            testCase.verifyEqual(actual_minX, exp_minX);
            testCase.verifyEqual(actual_maxX, exp_maxX);
        end
        
        function testGetMinMaxX_3DifferentSizeSplineCollection_P8(testCase)
            splineCollection = testCase.fill3DifferentSizeSplineCollection;
            
            firstPointIndex = 8;
            secondPointIndex = 8;
            xAxisMin = -1;
            xAxisMax = 17;
            coordVariationMinStep = 0.1;
            [actual_minX, actual_maxX] = splineCollection.getMinMaxX(firstPointIndex, secondPointIndex, xAxisMin, xAxisMax, coordVariationMinStep);
            exp_minX = 9.1;
            exp_maxX = 10.4;
            testCase.verifyEqual(actual_minX, exp_minX);
            testCase.verifyEqual(actual_maxX, exp_maxX);
        end
        
        function testGetMinMaxX_3DifferentSizeSplineCollection_P10(testCase)
            splineCollection = testCase.fill3DifferentSizeSplineCollection;
            
            firstPointIndex = 10;
            secondPointIndex = 11;
            xAxisMin = -1;
            xAxisMax = 17;
            coordVariationMinStep = 0.1;
            [actual_minX, actual_maxX] = splineCollection.getMinMaxX(firstPointIndex, secondPointIndex, xAxisMin, xAxisMax, coordVariationMinStep);
            exp_minX = 10.6;
            exp_maxX = 13.9;
            testCase.verifyEqual(actual_minX, exp_minX);
            testCase.verifyEqual(actual_maxX, exp_maxX);
        end
        
        function testGetMinMaxX_3DifferentSizeSplineCollection_P12(testCase)
            splineCollection = testCase.fill3DifferentSizeSplineCollection;
            
            firstPointIndex = 12;
            secondPointIndex = 12;
            xAxisMin = -1;
            xAxisMax = 17;
            coordVariationMinStep = 0.1;
            [actual_minX, actual_maxX] = splineCollection.getMinMaxX(firstPointIndex, secondPointIndex, xAxisMin, xAxisMax, coordVariationMinStep);
            exp_minX = 11.1;
            exp_maxX = 14.9;
            testCase.verifyEqual(actual_minX, exp_minX);
            testCase.verifyEqual(actual_maxX, exp_maxX);
        end
        
    end
    
end 
