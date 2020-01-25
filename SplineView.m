classdef SplineView < matlab.apps.AppBase
% Source is chap1_8_adding_piecewise_spline_standard_form_app.mlapp
    % Properties that correspond to app components
    properties (Access = public)
        UIFigure            matlab.ui.Figure
        UIAxes              matlab.ui.control.UIAxes
        XSliderTxtValue     matlab.ui.control.Label
        YSliderTxtValue     matlab.ui.control.Label
        XSliderLabel        matlab.ui.control.Label
        XSlider             matlab.ui.control.Slider
        YSliderLabel        matlab.ui.control.Label
        YSlider             matlab.ui.control.Slider
        PointDropDownLabel  matlab.ui.control.Label
        PointDropDown       matlab.ui.control.DropDown
        Panel               matlab.ui.container.Panel
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

            % Create XSliderTxtValue
            app.XSliderTxtValue = uilabel(app.Panel);
            app.XSliderTxtValue.Position = [384 92 25 22];
            app.XSliderTxtValue.Text = '10';

            % Create YSliderTxtValue
            app.YSliderTxtValue = uilabel(app.Panel);
            app.YSliderTxtValue.Position = [386 33 25 22];
            app.YSliderTxtValue.Text = '10';

            % Create XSliderLabel
            app.XSliderLabel = uilabel(app.Panel);
            app.XSliderLabel.HorizontalAlignment = 'right';
            app.XSliderLabel.Position = [173 92 25 22];
            app.XSliderLabel.Text = 'X';

            % Create XSlider
            app.XSlider = uislider(app.Panel);
            app.XSlider.Limits = [-1 9];
            app.XSlider.Position = [219 101 150 3];
            app.XSlider.Value = 3;

            % Create YSliderLabel
            app.YSliderLabel = uilabel(app.Panel);
            app.YSliderLabel.HorizontalAlignment = 'right';
            app.YSliderLabel.Position = [173 33 25 22];
            app.YSliderLabel.Text = 'Y';

            % Create YSlider
            app.YSlider = uislider(app.Panel);
            app.YSlider.Position = [219 42 150 3];

            % Create PointDropDownLabel
            app.PointDropDownLabel = uilabel(app.Panel);
            app.PointDropDownLabel.HorizontalAlignment = 'right';
            app.PointDropDownLabel.Position = [8 92 32 22];
            app.PointDropDownLabel.Text = 'Point';

            % Create PointDropDown
            app.PointDropDown = uidropdown(app.Panel);
            app.PointDropDown.Position = [55 92 100 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = SplineView

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