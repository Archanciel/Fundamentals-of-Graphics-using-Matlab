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
splineCollection = SplineCollection(splineCollectionCellVector,...
                                    4,...
                                    -2);


splineController = SplineController(splineCollection);
appView = SplineView(splineCollection, splineController);
splineController.splineView = appView;


appView.drawPiecewiseSpline();
appView.show();


