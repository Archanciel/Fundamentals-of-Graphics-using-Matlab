classdef SplineView < matlab.apps.AppBase
% Source is chap1_8_adding_piecewise_spline_standard_form_app.mlapp
    % Properties that correspond to app components
    properties (Access = public)
        % UI controls
        UIFigure              matlab.ui.Figure;
        UIAxes                matlab.ui.control.UIAxes;
        Panel                 matlab.ui.container.Panel;
        XCoordSliderTxtValue  matlab.ui.control.Label;
        YCoordSliderTxtValue  matlab.ui.control.Label;
        XSliderLabel          matlab.ui.control.Label;
        XCoordSlider          matlab.ui.control.Slider;
        YSliderLabel          matlab.ui.control.Label;
        YCoordSlider          matlab.ui.control.Slider;
        PointDropDownLabel    matlab.ui.control.Label;
        PointSelectionMenu    matlab.ui.control.DropDown;
        
        % other properties
        splineModel           SplineModel;
        splineDrawingParm     SplineDrawingParm
        splineController      SplineController;
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Value changed function: PointSelectionMenu
        function PointSelectionMenuValueChanged(app, event)
            value = app.PointSelectionMenu.Value;
            
        end

        % Value changed function: XCoordSlider
        function XCoordSliderValueChanged(app, event)
            value = app.XCoordSlider.Value;
            
        end

        % Value changed function: YCoordSlider
        function YCoordSliderValueChanged(app, event)
            value = app.YCoordSlider.Value;
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 70 770 714];
            app.UIFigure.Name = 'UI Figure';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Piecewise splines')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            app.UIAxes.Position = [8 159 763 556];

            % Create Panel
            app.Panel = uipanel(app.UIFigure);
            app.Panel.Position = [8 18 407 124];

            % Create XCoordSliderTxtValue
            app.XCoordSliderTxtValue = uilabel(app.Panel);
            app.XCoordSliderTxtValue.Position = [384 92 25 22];
            app.XCoordSliderTxtValue.Text = '10';

            % Create YCoordSliderTxtValue
            app.YCoordSliderTxtValue = uilabel(app.Panel);
            app.YCoordSliderTxtValue.Position = [386 33 25 22];
            app.YCoordSliderTxtValue.Text = '10';

            % Create XSliderLabel
            app.XSliderLabel = uilabel(app.Panel);
            app.XSliderLabel.HorizontalAlignment = 'right';
            app.XSliderLabel.Position = [173 92 25 22];
            app.XSliderLabel.Text = 'X';

            % Create XCoordSlider
            app.XCoordSlider = uislider(app.Panel);
            app.XCoordSlider.Limits = [10 90];
            app.XCoordSlider.ValueChangedFcn = createCallbackFcn(app, @XCoordSliderValueChanged, true);
            app.XCoordSlider.Position = [219 101 150 3];
            app.XCoordSlider.Value = 10;

            % Create YSliderLabel
            app.YSliderLabel = uilabel(app.Panel);
            app.YSliderLabel.HorizontalAlignment = 'right';
            app.YSliderLabel.Position = [173 33 25 22];
            app.YSliderLabel.Text = 'Y';

            % Create YCoordSlider
            app.YCoordSlider = uislider(app.Panel);
            app.YCoordSlider.ValueChangedFcn = createCallbackFcn(app, @YCoordSliderValueChanged, true);
            app.YCoordSlider.Position = [219 42 150 3];

            % Create PointDropDownLabel
            app.PointDropDownLabel = uilabel(app.Panel);
            app.PointDropDownLabel.HorizontalAlignment = 'right';
            app.PointDropDownLabel.Position = [8 92 32 22];
            app.PointDropDownLabel.Text = 'Point';

            % Create PointSelectionMenu
            app.PointSelectionMenu = uidropdown(app.Panel);
            app.PointSelectionMenu.ValueChangedFcn = createCallbackFcn(app, @PointSelectionMenuValueChanged, true);
            app.PointSelectionMenu.Position = [55 92 100 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
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
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end