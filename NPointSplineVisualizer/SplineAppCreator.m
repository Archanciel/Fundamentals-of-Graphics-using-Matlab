clear all;

% he path added are accessible for all classes directly or indiorectly used
% by SplineAppCreator
addpath("./model");
addpath("./view");
addpath("./controller");


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

% linking model to conroller
splineController = SplineController(splineCollection);

% linking model to view
appView = SplineView(splineCollection);

% linking view to controller
splineController.addView(appView);

appView.plotPiecewiseSplines();
appView.show();


