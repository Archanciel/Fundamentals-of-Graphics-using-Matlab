% initial piecewise splines points coordinates

p1 = [0 1];
p2 = [2 2];
p3 = [5 0];
p4 = [8 0];

P_1_4 = [p1;p2;p3;p4];

% initial piecewise spline drawing parms

points_labels{1} = 'P_1';
points_labels{2} = 'P_2';
points_labels{3} = 'P_3';
points_labels{4} = 'P_4';

spline_colors{1} = 'b';
spline_colors{2} = 'r';
spline_colors{3} = 'm';

splineModel = SplineModel(P_1_4,...
                          4,...
                          -2,...
                          points_labels,...
                          spline_colors);

splineCollectionCellVector{1} = splineModel;

% additional piecewise splines points coordinates

p5 = [8 0];
p6 = [9 -1];
p7 = [10 3];
p8 = [11 2];

P_5_8 = [p5;p6;p7;p8];

% additional piecewise spline drawing parms

points_labels{1} = 'P_5';
points_labels{2} = 'P_6';
points_labels{3} = 'P_7';
points_labels{4} = 'P_8';

spline_colors{1} = 'b';
spline_colors{2} = 'r';
spline_colors{3} = 'm';

additionalSplineModel = SplineModel(P_5_8,...
                                   -2,...
                                   0,...
                                   points_labels,...
                                   spline_colors);

splineCollectionCellVector{2} = additionalSplineModel;

splineCollection = SplineCollection(splineCollectionCellVector,...
                                    4,...
                                    -2);

splineController = SplineController(splineCollection);
appView = SplineView(splineCollection, splineController);
splineController.splineView = appView;


appView.drawPiecewiseSpline();
appView.show();


