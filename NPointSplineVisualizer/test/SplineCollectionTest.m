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
        function testCreateAndStoreSplineModel_randomX(testCase)
            splineCollection = SplineCollection();
            splineModelIndex = 1;
            startX = 0;
            endX = 6;
            splinePointNumber = 5;
            lineStyle = '--';
            isRandomX = 1;
            splinePartNumber = splinePointNumber - 1;
            
            exp_splinePartColorOellArray = {};
            exp_splinePartColorOellArray{1} = 'r--';
            exp_splinePartColorOellArray{2} = 'y--';
            exp_splinePartColorOellArray{3} = 'm--';
            exp_splinePartColorOellArray{4} = 'k--';
            
            endX = splineCollection.createAndStoreSplineModel(splineModelIndex, startX, splinePointNumber, lineStyle, isRandomX);
            splineModel = splineCollection.getSplineModelForSplineIndex(1);
            
            testCase.verifyEqual(splineModel.getSplinePointNumber(), splinePointNumber);
            testCase.verifyEqual(splineModel.getSplineColorCellArray(), exp_splinePartColorOellArray);
            testCase.verifyEqual(splineModel.splineXpointCoordVector(1), startX);
            testCase.verifyEqual(splineModel.splineXpointCoordVector(splinePointNumber), endX);
            testCase.verifyEqual(splineModel.splineStartSlope, 0);
            testCase.verifyEqual(splineModel.splineEndSlope, 0);
        end
        
        function testCreateRandomXArray(testCase)
            splineCollection = SplineCollection();
            
            startX = 0;
            endX = 3;
            pointNumber = 5;
            
            [actual_xArray] = splineCollection.createRandomXArray(startX, endX, pointNumber);
            
            % actual_xArray
            exp_xArray = unique(actual_xArray);
            testCase.verifyEqual(exp_xArray, actual_xArray);
            testCase.verifyEqual(actual_xArray(1), startX);
            testCase.verifyEqual(actual_xArray(pointNumber), endX);
        end
        
        function testCreateFilledSplineCollection_3_splines_4_pts_randomX(testCase)
            exp_splineNumber = 3;
            exp_totalPointNumber = 12;

            splinePointNumbersArray = [4];
            isRandomX = 1;
            splineCollection = SplineCollection();
            splineCollection.createFilledSplineCollection(exp_splineNumber,...
                                                          splinePointNumbersArray,...
                                                          isRandomX);
            actual_splineNumber = splineCollection.getSplineNumber();
            actual_totalPointNumber = splineCollection.getTotalPointNumber();
            actual_piecewiseSpline_1 = splineCollection.getSplineModelForSplineIndex(1);
            actual_piecewiseSpline_2 = splineCollection.getSplineModelForSplineIndex(2);
            actual_piecewiseSpline_3 = splineCollection.getSplineModelForSplineIndex(3);

            testCase.verifyEqual(actual_splineNumber, exp_splineNumber);
            testCase.verifyEqual(actual_totalPointNumber, exp_totalPointNumber);
            testCase.verifyEqual(actual_piecewiseSpline_1.splineXpointCoordVector(1), 0);
            testCase.verifyEqual(actual_piecewiseSpline_1.splineXpointCoordVector(4), actual_piecewiseSpline_2.splineXpointCoordVector(1));
            testCase.verifyEqual(actual_piecewiseSpline_2.splineXpointCoordVector(4), actual_piecewiseSpline_3.splineXpointCoordVector(1));
            
            actual_piecewiseSpline_1.getSplineColorCellArray()
            actual_piecewiseSpline_2.getSplineColorCellArray()
            actual_piecewiseSpline_3.getSplineColorCellArray()
        end
        
        function testCreateFilledSplineCollection_3_splines_4_pts_x_reg_spaced(testCase)
            exp_splineNumber = 3;
            exp_totalPointNumber = 12;
            exp_splineXpointCoordVector_1 = [0 1 2 3];
            exp_splineXpointCoordVector_2 = [3 4 5 6];
            exp_splineXpointCoordVector_3 = [6 7 8 9];

            splinePointNumbersArray = [4];
            isRandomX = 0;
            splineCollection = SplineCollection();
            splineCollection.createFilledSplineCollection(exp_splineNumber,...
                                                          splinePointNumbersArray,...
                                                          isRandomX);
            actual_splineNumber = splineCollection.getSplineNumber();
            actual_totalPointNumber = splineCollection.getTotalPointNumber();
            actual_piecewiseSpline_1 = splineCollection.getSplineModelForSplineIndex(1);
            actual_piecewiseSpline_2 = splineCollection.getSplineModelForSplineIndex(2);
            actual_piecewiseSpline_3 = splineCollection.getSplineModelForSplineIndex(3);

            testCase.verifyEqual(actual_splineNumber, exp_splineNumber);
            testCase.verifyEqual(actual_totalPointNumber, exp_totalPointNumber);
            
            testCase.verifyEqual(actual_piecewiseSpline_1.splineXpointCoordVector, exp_splineXpointCoordVector_1);
            testCase.verifyEqual(actual_piecewiseSpline_2.splineXpointCoordVector, exp_splineXpointCoordVector_2);
            testCase.verifyEqual(actual_piecewiseSpline_3.splineXpointCoordVector, exp_splineXpointCoordVector_3);
            
            actual_piecewiseSpline_1.getSplineColorCellArray()
            actual_piecewiseSpline_2.getSplineColorCellArray()
            actual_piecewiseSpline_3.getSplineColorCellArray()
        end
        
        function testCreateFilledSplineCollection_3_splines_3_pts_x_reg_spaced(testCase)
            exp_splineNumber = 3;

            splinePointNumbersArray = [3];
            isRandomX = 0;
            splineCollection = SplineCollection();
            testCase.assertError(@()splineCollection.createFilledSplineCollection(exp_splineNumber, splinePointNumbersArray, isRandomX), 'createFilledSplineCollection:MinimumFourPointsNumberViolated');
        end
                
        function testCreateFilledSplineCollection_3_splines_3_pts_randomX(testCase)
            exp_splineNumber = 3;

            splinePointNumbersArray = [3];
            isRandomX = 1;
            splineCollection = SplineCollection();
            testCase.assertError(@()splineCollection.createFilledSplineCollection(exp_splineNumber, splinePointNumbersArray, isRandomX), 'createFilledSplineCollection:MinimumFourPointsNumberViolated');
        end
                
        function testCreateFilledSplineCollection_2_splines_4_3_pts_x_reg_spaced(testCase)
            exp_splineNumber = 2;

            splinePointNumbersArray = [4 3];
            isRandomX = 0;
            splineCollection = SplineCollection();
            testCase.assertError(@()splineCollection.createFilledSplineCollection(exp_splineNumber, splinePointNumbersArray, isRandomX), 'createFilledSplineCollection:MinimumFourPointsNumberViolated');
        end
                
        function testCreateFilledSplineCollection_2_splines_4_and_3_pts_randomX(testCase)
            exp_splineNumber = 2;

            splinePointNumbersArray = [4 3];
            isRandomX = 1;
            splineCollection = SplineCollection();
            testCase.assertError(@()splineCollection.createFilledSplineCollection(exp_splineNumber, splinePointNumbersArray, isRandomX), 'createFilledSplineCollection:MinimumFourPointsNumberViolated');
        end
                
        function testCreateFilledSplineCollection_5_splines_6_pts_x_reg_spaced(testCase)
            exp_splineNumber = 5;
            exp_totalPointNumber = 30;
            exp_splineXpointCoordVector_1 = [0 1 2 3 4 5];
            exp_splineXpointCoordVector_2 = [5 6 7 8 9 10];
            exp_splineXpointCoordVector_3 = [10 11 12 13 14 15];
            exp_splineXpointCoordVector_4 = [15 16 17 18 19 20];
            exp_splineXpointCoordVector_5 = [20 21 22 23 24 25];

            splinePointNumbersArray = [6];
            isRandomX = 0;
            splineCollection = SplineCollection();
            splineCollection.createFilledSplineCollection(exp_splineNumber,...
                                                          splinePointNumbersArray,...
                                                          isRandomX);
            actual_splineNumber = splineCollection.getSplineNumber();
            actual_totalPointNumber = splineCollection.getTotalPointNumber();
            actual_piecewiseSpline_1 = splineCollection.getSplineModelForSplineIndex(1);
            actual_piecewiseSpline_2 = splineCollection.getSplineModelForSplineIndex(2);
            actual_piecewiseSpline_3 = splineCollection.getSplineModelForSplineIndex(3);
            actual_piecewiseSpline_4 = splineCollection.getSplineModelForSplineIndex(4);
            actual_piecewiseSpline_5 = splineCollection.getSplineModelForSplineIndex(5);

            testCase.verifyEqual(actual_splineNumber, exp_splineNumber);
            testCase.verifyEqual(actual_totalPointNumber, exp_totalPointNumber);
            
            testCase.verifyEqual(actual_piecewiseSpline_1.splineXpointCoordVector, exp_splineXpointCoordVector_1);
            testCase.verifyEqual(actual_piecewiseSpline_2.splineXpointCoordVector, exp_splineXpointCoordVector_2);
            testCase.verifyEqual(actual_piecewiseSpline_3.splineXpointCoordVector, exp_splineXpointCoordVector_3);
            testCase.verifyEqual(actual_piecewiseSpline_4.splineXpointCoordVector, exp_splineXpointCoordVector_4);
            testCase.verifyEqual(actual_piecewiseSpline_5.splineXpointCoordVector, exp_splineXpointCoordVector_5);
        end
        
        function testCreateFilledSplineCollection_5_splines_6_pts_x_randomX(testCase)
            exp_splineNumber = 5;
            exp_totalPointNumber = 30;

            splinePointNumbersArray = [6];
            isRandomX = 1;
            splineCollection = SplineCollection();
            splineCollection.createFilledSplineCollection(exp_splineNumber,...
                                                          splinePointNumbersArray,...
                                                          isRandomX);
            actual_splineNumber = splineCollection.getSplineNumber();
            actual_totalPointNumber = splineCollection.getTotalPointNumber();
            actual_piecewiseSpline_1 = splineCollection.getSplineModelForSplineIndex(1);
            actual_piecewiseSpline_2 = splineCollection.getSplineModelForSplineIndex(2);
            actual_piecewiseSpline_3 = splineCollection.getSplineModelForSplineIndex(3);
            actual_piecewiseSpline_4 = splineCollection.getSplineModelForSplineIndex(4);
            actual_piecewiseSpline_5 = splineCollection.getSplineModelForSplineIndex(5);

            testCase.verifyEqual(actual_splineNumber, exp_splineNumber);
            testCase.verifyEqual(actual_totalPointNumber, exp_totalPointNumber);
            testCase.verifyEqual(actual_piecewiseSpline_1.splineXpointCoordVector(1), 0);
            testCase.verifyEqual(actual_piecewiseSpline_1.splineXpointCoordVector(6), actual_piecewiseSpline_2.splineXpointCoordVector(1));
            testCase.verifyEqual(actual_piecewiseSpline_2.splineXpointCoordVector(6), actual_piecewiseSpline_3.splineXpointCoordVector(1));
            testCase.verifyEqual(actual_piecewiseSpline_3.splineXpointCoordVector(6), actual_piecewiseSpline_4.splineXpointCoordVector(1));
            testCase.verifyEqual(actual_piecewiseSpline_4.splineXpointCoordVector(6), actual_piecewiseSpline_5.splineXpointCoordVector(1));
        end
        
        function testCreateFilledSplineCollection_4_splines_n_pts_x_reg_spaced(testCase)
            exp_splineNumber = 4;
            exp_totalPointNumber = 19;
            exp_splineXpointCoordVector_1 = [0 1 2 3];
            exp_splineXpointCoordVector_2 = [3 4 5 6 7];
            exp_splineXpointCoordVector_3 = [7 8 9 10 11 12];
            exp_splineXpointCoordVector_4 = [12 13 14 15];

            splinePointNumbersArray = [4 5 6 4];
            isRandomX = 0;
            splineCollection = SplineCollection();
            splineCollection.createFilledSplineCollection(exp_splineNumber,...
                                                          splinePointNumbersArray,...
                                                          isRandomX);
            actual_splineNumber = splineCollection.getSplineNumber();
            actual_totalPointNumber = splineCollection.getTotalPointNumber();
            actual_piecewiseSpline_1 = splineCollection.getSplineModelForSplineIndex(1);
            actual_piecewiseSpline_2 = splineCollection.getSplineModelForSplineIndex(2);
            actual_piecewiseSpline_3 = splineCollection.getSplineModelForSplineIndex(3);
            actual_piecewiseSpline_4 = splineCollection.getSplineModelForSplineIndex(4);

            testCase.verifyEqual(actual_splineNumber, exp_splineNumber);
            testCase.verifyEqual(actual_totalPointNumber, exp_totalPointNumber);
            
            testCase.verifyEqual(actual_piecewiseSpline_1.splineXpointCoordVector, exp_splineXpointCoordVector_1);
            testCase.verifyEqual(actual_piecewiseSpline_2.splineXpointCoordVector, exp_splineXpointCoordVector_2);
            testCase.verifyEqual(actual_piecewiseSpline_3.splineXpointCoordVector, exp_splineXpointCoordVector_3);
            testCase.verifyEqual(actual_piecewiseSpline_4.splineXpointCoordVector, exp_splineXpointCoordVector_4);
        end
        
        function testCreateFilledSplineCollection_4_splines_n_pts_x_randomX(testCase)
            exp_splineNumber = 4;
            exp_totalPointNumber = 19;

            splinePointNumbersArray = [4 5 6 4];
            isRandomX = 1;
            splineCollection = SplineCollection();
            splineCollection.createFilledSplineCollection(exp_splineNumber,...
                                                          splinePointNumbersArray,...
                                                          isRandomX);
            actual_splineNumber = splineCollection.getSplineNumber();
            actual_totalPointNumber = splineCollection.getTotalPointNumber();
            actual_piecewiseSpline_1 = splineCollection.getSplineModelForSplineIndex(1);
            actual_piecewiseSpline_2 = splineCollection.getSplineModelForSplineIndex(2);
            actual_piecewiseSpline_3 = splineCollection.getSplineModelForSplineIndex(3);
            actual_piecewiseSpline_4 = splineCollection.getSplineModelForSplineIndex(4);

            testCase.verifyEqual(actual_splineNumber, exp_splineNumber);
            testCase.verifyEqual(actual_totalPointNumber, exp_totalPointNumber);
            
            testCase.verifyEqual(actual_piecewiseSpline_1.splineXpointCoordVector(1), 0);
            testCase.verifyEqual(actual_piecewiseSpline_1.splineXpointCoordVector(4), actual_piecewiseSpline_2.splineXpointCoordVector(1));
            testCase.verifyEqual(actual_piecewiseSpline_2.splineXpointCoordVector(5), actual_piecewiseSpline_3.splineXpointCoordVector(1));
            testCase.verifyEqual(actual_piecewiseSpline_3.splineXpointCoordVector(6), actual_piecewiseSpline_4.splineXpointCoordVector(1));
        end
        
        function testFillColorCellArray_7_splineParts(testCase)
            lineStyle = '-';
            splineCollection = SplineCollection();
            splinePartNumber = 7;
            actual_color_cellArray = splineCollection.fillColorCellArray(splinePartNumber, lineStyle);
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

        function testFillColorCellArray_8_splineParts(testCase)
            lineStyle = '-';
            splineCollection = SplineCollection();
            splinePartNumber = 8;
            actual_color_cellArray = splineCollection.fillColorCellArray(8, lineStyle);
            exp_color_cellArray{1} = 'r-';
            exp_color_cellArray{2} = 'y-';
            exp_color_cellArray{3} = 'm-';
            exp_color_cellArray{4} = 'k-';
            exp_color_cellArray{5} = 'g-';
            exp_color_cellArray{6} = 'c-';
            exp_color_cellArray{7} = 'b-';
            exp_color_cellArray{8} = 'r-';
            testCase.verifyEqual(actual_color_cellArray, exp_color_cellArray);
            
%            celldisp(actual_color_cellArray);
        end

        function testFillColorCellArray_1_splinePart(testCase)
            lineStyle = '-';
            splineCollection = SplineCollection();
            splinePartNumber = 1;
            actual_color_cellArray = splineCollection.fillColorCellArray(splinePartNumber, lineStyle);
            exp_color_cellArray{1} = 'r-';
            testCase.verifyEqual(actual_color_cellArray, exp_color_cellArray);
            
%            celldisp(actual_color_cellArray);
        end

        function testFillColorCellArray_6_points(testCase)
            lineStyle = '-';
            splineCollection = SplineCollection();
            actual_color_cellArray = splineCollection.fillColorCellArray(6, lineStyle);
            exp_color_cellArray{1} = 'r-';
            exp_color_cellArray{2} = 'y-';
            exp_color_cellArray{3} = 'm-';
            exp_color_cellArray{4} = 'k-';
            exp_color_cellArray{5} = 'g-';
            exp_color_cellArray{6} = 'c-';
            testCase.verifyEqual(actual_color_cellArray, exp_color_cellArray);
            
%            celldisp(actual_color_cellArray);
        end

        function testFillPointArray_7_points_x_regularly_spaced(testCase)
            startX = 1;
            pointNumber = 7;
            isRandomX = 0;
            splineCollection = SplineCollection();
            actual_pointArray = splineCollection.fillPointArray(startX, pointNumber, isRandomX);
            exp_pointArray = [1 2 3 4 5 6 7];
            testCase.verifyEqual(actual_pointArray(:,1), exp_pointArray');
            
%            actual_pointArray
        end

        function testFillPointArray_1_points_x_regularly_spaced(testCase)
            startX = 1;
            pointNumber = 1;
            isRandomX = 0;
            splineCollection = SplineCollection();
            actual_pointArray = splineCollection.fillPointArray(startX, pointNumber, isRandomX);
            exp_pointArray = [1];
            testCase.verifyEqual(actual_pointArray(:,1), exp_pointArray');
            
%            actual_pointArray
        end

        function testFillPointArray_7_points_x_randomly_spaced(testCase)
            startX = 1;
            pointNumber = 7;
            exp_endX = startX + pointNumber;
            isRandomX = 1;
            splineCollection = SplineCollection();
            actual_pointArray = splineCollection.fillPointArray(startX, pointNumber, isRandomX);
            % actual_pointArray
            testCase.verifyEqual(actual_pointArray(1,1), startX);
            testCase.verifyEqual(actual_pointArray(pointNumber,1), exp_endX);
        end

        function testFillPointArray_1_points_x_randomly_spaced(testCase)
            startX = 1;
            pointNumber = 1;
            isRandomX = 1;
            splineCollection = SplineCollection();
            actual_pointArray = splineCollection.fillPointArray(startX, pointNumber, isRandomX);
            % actual_pointArray
            exp_pointArray = [1];
            testCase.verifyEqual(actual_pointArray(:,1), exp_pointArray');

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
