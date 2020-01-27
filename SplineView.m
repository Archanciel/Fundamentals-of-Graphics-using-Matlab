classdef SplineView < matlab.apps.AppBase
% Source is chap1_8_adding_piecewise_spline_standard_form_app.mlapp
    % Properties that correspond to app components
    properties (Access = public)
        % UI controls
        uiFigure              matlab.ui.Figure
        uiAxes                matlab.ui.control.UIAxes
        panel                 matlab.ui.container.Panel
        xCoordSliderTxtValue  matlab.ui.control.Label
        yCoordSliderTxtValue  matlab.ui.control.Label
        xSliderLabel          matlab.ui.control.Label
        xCoordSlider          matlab.ui.control.Slider
        ySliderLabel          matlab.ui.control.Label
        yCoordSlider          matlab.ui.control.Slider
        pointDropDownLabel    matlab.ui.control.Label
        pointSelectionMenu    matlab.ui.control.DropDown
        
        % other properties
        splineModel           SplineModel;
        splineDrawingParm     SplineDrawingParm
        splineController      SplineController;
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Value changed function: pointSelectionMenu
        function pointSelectionMenuValueChanged(app, event)
            value = app.pointSelectionMenu.Value;
            
        end

        % Value changed function: xCoordSlider
        function xCoordSliderValueChanged(app, event)
            value = app.xCoordSlider.Value;
            
        end

        % Value changed function: yCoordSlider
        function yCoordSliderValueChanged(app, event)
            value = app.yCoordSlider.Value;
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create uiFigure and hide until all components are created
            app.uiFigure = uifigure('Visible', 'off');
            app.uiFigure.Position = [100 70 794 714];
            app.uiFigure.Name = 'UI Figure';

            % Create uiAxes
            app.uiAxes = uiaxes(app.uiFigure);
            title(app.uiAxes, 'Piecewise splines')
            xlabel(app.uiAxes, 'X')
            ylabel(app.uiAxes, 'Y')
            app.uiAxes.Position = [8 159 763 556];

            % Create panel
            app.panel = uipanel(app.uiFigure);
            app.panel.Position = [8 18 407 124];

            % Create xCoordSliderTxtValue
            app.xCoordSliderTxtValue = uilabel(app.panel);
            app.xCoordSliderTxtValue.Position = [384 92 25 22];
            app.xCoordSliderTxtValue.Text = '10';

            % Create yCoordSliderTxtValue
            app.yCoordSliderTxtValue = uilabel(app.panel);
            app.yCoordSliderTxtValue.Position = [386 33 25 22];
            app.yCoordSliderTxtValue.Text = '10';

            % Create xSliderLabel
            app.xSliderLabel = uilabel(app.panel);
            app.xSliderLabel.HorizontalAlignment = 'right';
            app.xSliderLabel.Position = [173 92 25 22];
            app.xSliderLabel.Text = 'X';

            % Create xCoordSlider
            app.xCoordSlider = uislider(app.panel);
            app.xCoordSlider.Limits = [10 90];
            app.xCoordSlider.ValueChangedFcn = createCallbackFcn(app, @xCoordSliderValueChanged, true);
            app.xCoordSlider.Position = [219 101 150 3];
            app.xCoordSlider.Value = 10;

            % Create ySliderLabel
            app.ySliderLabel = uilabel(app.panel);
            app.ySliderLabel.HorizontalAlignment = 'right';
            app.ySliderLabel.Position = [173 33 25 22];
            app.ySliderLabel.Text = 'Y';

            % Create yCoordSlider
            app.yCoordSlider = uislider(app.panel);
            app.yCoordSlider.ValueChangedFcn = createCallbackFcn(app, @yCoordSliderValueChanged, true);
            app.yCoordSlider.Position = [219 42 150 3];

            % Create pointDropDownLabel
            app.pointDropDownLabel = uilabel(app.panel);
            app.pointDropDownLabel.HorizontalAlignment = 'right';
            app.pointDropDownLabel.Position = [8 92 32 22];
            app.pointDropDownLabel.Text = 'Point';

            % Create pointSelectionMenu
            app.pointSelectionMenu = uidropdown(app.panel);
            app.pointSelectionMenu.ValueChangedFcn = createCallbackFcn(app, @pointSelectionMenuValueChanged, true);
            app.pointSelectionMenu.Position = [55 92 100 22];

            % Show the figure after all components are created
            app.uiFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = SplineView(splineModel, splineDrawingParm, splineController)
            app.splineModel = splineModel;
            app.splineDrawingParm = splineDrawingParm;
            app.splineController = splineController;
            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.uiFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.uiFigure)
        end
    end
end