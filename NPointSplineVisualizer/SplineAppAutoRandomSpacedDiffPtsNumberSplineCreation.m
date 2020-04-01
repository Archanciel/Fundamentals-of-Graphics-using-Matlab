clear all;

% he path added are accessible for all classes directly or indiorectly used
% by SplineAppCreator
addpath("./model");
addpath("./view");
addpath("./controller");


splineCollection = SplineCollection();

splineNumber = 6;

splinePointNumbersArray = [4 5 8 6 4 6];
isRandomX = 1;
splineCollection = SplineCollection();
splineCollection.createFilledSplineCollection(splineNumber,...
                                              splinePointNumbersArray,...
                                              isRandomX);

% linking model to conroller
splineController = SplineController(splineCollection);

% linking model to view
appView = SplineView(splineCollection);

% linking view to controller
splineController.addView(appView);

appView.plotPiecewiseSplines();
appView.show();


