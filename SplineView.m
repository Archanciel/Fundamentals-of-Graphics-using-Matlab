classdef SplineView < matlab.apps.AppBase
% Source is chap1_8_adding_piecewise_spline_standard_form_app.mlapp
    % Properties that correspond to app components
    properties (Access = public)
        % constants
        SCATTER_POINT_SIZE = 15;
        XY_SLIDER_STEP = 0.1;
        PLOT_RESOLUTION = 100; % linspace 3rd param

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
        splineCollection      SplineCollection
        splineController      SplineController
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
        end
    end
    
    % Spline drawing methods
    methods (Access = private)
        
        function plotPartialPiecewiseSpline(app,...
                                            isAdditionalSpline)
            %Returns handles on the plotted piecewise splines
            %so that they can be deleted before redrawing them !
            splineModel = app.splineCollection.getSplineModel(1);
            yFuncCellArray = splineModel.computePiecewiseSplineFunctions();
            Pn = [splineModel.splineXpointCoordVector(1,:)' splineModel.splineYpointCoordVector(1,:)'];

            points_labels = splineModel.splinePointLabelStrCellVector; 
            spline_colors = splineModel.splineColorCellVector; 

            for i = 1:length(yFuncCellArray)
                y_func = yFuncCellArray{i};
                
                if i == 1
                    xx_func = linspace(Pn(i,1) - 1, Pn(i + 1,1), app.PLOT_RESOLUTION);
                elseif i == 3
                    if isAdditionalSpline == 0
                        xx_func = linspace(Pn(i,1), Pn(i + 1,1), app.PLOT_RESOLUTION);
                    else
                        xx_func = linspace(Pn(i,1), Pn(i + 1,1) + 1, app.PLOT_RESOLUTION);
                    end
                else
                    xx_func = linspace(Pn(i,1), Pn(i + 1,1), app.PLOT_RESOLUTION);
                end
                
                syms x
                
                yy_func = subs(y_func, x, xx_func);
                splineModel.splineLineHandleCellVector{i} = plot(app.uiAxes, xx_func, yy_func, spline_colors{i});
                hold(app.uiAxes,'on');
            end
%{
            if isAdditionalSpline == 0
            else
                xx_ONE = linspace(Pn(1,1), Pn(2,1), app.PLOT_RESOLUTION);
                yy_ONE = subs(y_ONE, x, xx_ONE);
            end


            
            xx_lim_TWO = [Pn(2,1) Pn(3,1)];
            xx_TWO = linspace(xx_lim_TWO(1,1),xx_lim_TWO(1,2), app.PLOT_RESOLUTION);
            yy_TWO = subs(y_TWO, x, xx_TWO);
            app.splineDrawingData.splineLineHandleCellVector{2} = plot(app.uiAxes, xx_TWO, yy_TWO, spline_colors{2});

            if isAdditionalSpline == 0
                xx_THREE = linspace(Pn(3,1), Pn(4,1), app.PLOT_RESOLUTION);
                yy_THREE = subs(y_THREE, x, xx_THREE);
            else
                xx_THREE = linspace(Pn(3,1), Pn(4,1) + 1, app.PLOT_RESOLUTION);
                yy_THREE = subs(y_THREE, x, xx_THREE);
            end

            app.splineDrawingData.splineLineHandleCellVector{3} = plot(app.uiAxes, xx_THREE, yy_THREE, spline_colors{3});
%}
            if isAdditionalSpline == 0
                pointLabelHandlesToDelete = splineModel.splinePointLabelHandleVector;
            else
                pointLabelHandlesToDelete = splineModel.additionalSplinePointLabelHandleVector;
            end

            if isAdditionalSpline == 0
                scatteredPointHandleToDelete = splineModel.splineScatteredPointHandleVector;
            else
                scatteredPointHandleToDelete = splineModel.additionalSplineScatteredPointHandleVector;
            end

            [newPointLabelHandles, newScatteredPointHandle] = app.plotPointsAndLabels(Pn,... 
                                                                                  points_labels,...
                                                                                  isAdditionalSpline,...
                                                                                  pointLabelHandlesToDelete,...
                                                                                  scatteredPointHandleToDelete);

            if isAdditionalSpline == 0
                splineModel.splinePointLabelHandleVector = newPointLabelHandles;
                splineModel.splineScatteredPointHandleVector = newScatteredPointHandle;
            else
                splineModel.additionalSplinePointLabelHandleVector = newPointLabelHandles;
                splineModel.additionalSplineScatteredPointHandleVector = newScatteredPointHandle;
            end
        end

        function [newPointLabelHandles, newScatteredPointHandle] = plotPointsAndLabels(app,...
                                                                                       Pn,...
                                                                                       pointsLabelStrings,...
                                                                                       isAdditionalSpline,...
                                                                                       pointsLabelHandles,...
                                                                                       scatteredPointsHandle)
            % isAdditionalSpline argument == 1 indicaten that the first point label of the
            % additional spline must be shifted in order to avoid overwritting the
            % last point initial sline label
            %
            % Returns newPointLabelHandles so they can be deleted before being redrawn
            % and newSscatteredPointHandle which hosts the handle returned by the scatter
            % function

            app.deleteScatteredPoints(scatteredPointsHandle);
            app.deletePointLabels(pointsLabelHandles);

            newScatteredPointHandle = scatter(app.uiAxes, Pn(:,1),Pn(:,2), app.SCATTER_POINT_SIZE,'k','filled');

            if isAdditionalSpline == 1
                % in this case, the point label is written in a shifted position
                % in order to avoid overwrittinf the initial spline last point
                % label since the two points share the same x-y coordinates
                newPointLabelHandles{1} = text(app.uiAxes, Pn(1,1)-0.3, Pn(1,2)-0.3, pointsLabelStrings{1});
            else
                newPointLabelHandles{1} = text(app.uiAxes, Pn(1,1)+0.1, Pn(1,2)-0.1, pointsLabelStrings{1});
            end

            newPointLabelHandles{2} = text(app.uiAxes, Pn(2,1)+0.1, Pn(2,2)-0.1, pointsLabelStrings{2});
            newPointLabelHandles{3} = text(app.uiAxes, Pn(3,1)+0.1, Pn(3,2)-0.1, pointsLabelStrings{3});
            newPointLabelHandles{4} = text(app.uiAxes, Pn(4,1)+0.1, Pn(4,2)-0.1, pointsLabelStrings{4});
        end
        function deletePointLabels(app,...
                                   pointLabelHandels)
            elementNb = size(pointLabelHandels, 2);

            for i = 1:elementNb
                delete(pointLabelHandels{i});
            end
        end

        function deleteScatteredPoints(app,...
                                       scatteredPointsHandle)
            % scatteredPointsHandle hosts the handle returned by the scatter
            % function
            elementNb = size(scatteredPointsHandle, 2);

            if elementNb > 0
                delete(scatteredPointsHandle);
            end
        end

        function out = centeraxes(app, opt)
            % out = centeraxes(ax,opt)
            %==========================================================================
            % Center the coordinate axes of a plot so that they pass through the 
            % origin.
            %
            % Input: 0, 1 or 2 arguments
            %        0: Moves the coordinate axes of 'gca', i.e. the currently active 
            %           axes.
            %        1: ax, a handle to the axes which should be moved.
            %        2: ax, opt, where opt is a struct with further options
            %                opt.fontsize = 'size of axis tick labels'
            %                opt.fontname = name of axis tick font.
            %
            % If the opt struct is ommitted, the current values for the axes are used.
            %
            % Output: stuct out containing handles to all line objects created by this
            %         function.
            %
            %==========================================================================
            % Version: 1.2
            % Created: October 1, 2008, by Johan E. Carlson
            % Last modified: September 13, 2015, by Johan E. Carlson
            %==========================================================================

            ax = app.uiAxes;

            if nargin < 2,
                fontsize = get(ax,'FontSize');
                fontname = get(ax,'FontName');
            end
            if nargin < 1,
                ax = gca;
            end

            if nargin == 2,
                if isfield(opt,'fontsize'),
                    fontsize = opt.fontsize;
                else
                    fontsize = get(ax,'FontSize');
                end;
                if isfield(opt,'fontname'),
                    fontname = opt.fontname;
                else
                    fontname = get(ax,'FontName');
                end
            end

        %    axes(ax);
            set(ax,'color',[1 1 1]);
            xtext = get(get(ax,'xlabel'),'string');
            ytext = get(get(ax,'ylabel'),'string');

            %--------------------------------------------------------------------------
            % Check if the current coordinate system include the origin. If not, change
            % it so that it does!
            %--------------------------------------------------------------------------
            xlim = 1.1*get(ax,'xlim');
            ylim = 1.1*get(ax,'ylim');
            set(ax,'xlim',xlim);
            set(ax,'ylim',ylim);

            if xlim(1)>0,
                xlim(1) = 0;
            end

            if ylim(1)>0,
                ylim(1) = 0;
            end

            if xlim(2) < 0,
                xlim(2) = 0;
            end

            if ylim(2) < 0,
                ylim(2) = 0;
            end;

            set(ax,'xlim',xlim,'ylim',ylim);


            % -------------------------------------------------------------------------
            % Caculate size of the "axis tick marks"
            % -------------------------------------------------------------------------
            axpos = get(ax,'position');
            figpos = get(ax,'position');
            if (strcmp(get(ax,'Units'),'normalized')) 
                screensize = get( 0, 'ScreenSize' ); 
                figpos = figpos.*screensize; 
            end

            aspectratio = axpos(4) / (axpos(3));
            xsize = xlim(2) - xlim(1);
            ysize = ylim(2) - ylim(1);
            xticksize = ysize/figpos(4)*12;
            yticksize = xsize*aspectratio/figpos(3)*12;

            % -------------------------------------------------------------------------
            % Store old tick values and tick labels
            % -------------------------------------------------------------------------
            ytick = get(ax,'YTick');
            xtick = get(ax,'XTick');
            xticklab = get(ax,'XTickLabel');
            yticklab = get(ax,'YTickLabel');

            % -------------------------------------------------------------------------
            % Draw new coordinate system
            % -------------------------------------------------------------------------

            yax = line(ax, [0; 0],[ylim(1)-1; ylim(2)]);
            xax = line(ax, [xlim(1); xlim(2)],[0; 0]);
            set(xax,'color',[0 0 0])
            set(yax,'color',[0 0 0])

            % Draw x-axis ticks
            for k = 1:length(xtick),
                newxtick(k) = line(ax, [xtick(k); xtick(k)],[-xticksize/2; xticksize/2]);
                if (xtick(k)~=0),
                    newxticklab(k) = text(ax, xtick(k),-1.5*xticksize, strtrim(xticklab(k,:)));
                    set(newxticklab(k),'HorizontalAlignment','center',...
                        'Fontsize',fontsize,'FontName',fontname);
                end
            end
            set(newxtick,'color',[0 0 0]);

            % Draw y-axis ticks
            for k = 1:length(ytick),
                newytick(k) = line(ax, [-yticksize/2; yticksize/2],[ytick(k); ytick(k)]);
                if (ytick(k)~=0),
                    newyticklab(k) = text(ax, -.8*yticksize,ytick(k), yticklab(k,:));
                    set(newyticklab(k),'HorizontalAlignment','right',...
                        'FontSize',fontsize,'FontName',fontname);
                end
            end
            set(newytick,'color',[0 0 0]);

            %--------------------------------------------------------------------------
            % Move xlabels
            %--------------------------------------------------------------------------
            newxlabel = text(ax, xlim(2),-1.5*xticksize,xtext);
            set(newxlabel,'HorizontalAlignment','center',...
                'FontWeight','demi','FontSize',fontsize+2,'FontName',fontname);

            newylabel = text(ax, -yticksize,ylim(2)*1.02,ytext);
            set(newylabel,'HorizontalAlignment','right','VerticalAlignment','top',...
                'FontWeight','demi','FontSize',fontsize+2,'FontName',fontname);

            %--------------------------------------------------------------------------
            % Create arrowheads
            %--------------------------------------------------------------------------
            x = [0; -yticksize/4; yticksize/4];
            y = [ylim(2); ylim(2)-xticksize; ylim(2)-xticksize];
            patch(ax, x,y,[0 0 0])

            x = [xlim(2); xlim(2)-yticksize; xlim(2)-yticksize];
            y = [0; xticksize/4; -xticksize/4];
            patch(ax, x,y,[0 0 0])

            ax.XGrid = 'on';
            ax.YGrid = 'on';

            axis = 'off';
%            box off;
            %--------------------------------------------------------------------------
            % Create output struct
            %--------------------------------------------------------------------------

            if nargout > 0,
                out.xaxis = xax;
                out.yaxis = yax;
                out.xtick = newxtick;
                out.ytick = newytick;
                out.xticklabel = newxticklab;
                out.yticklabel = newyticklab;
                out.newxlabel = newxlabel;
                out.newylabel = newylabel;
            end 
        end
      
    end
        
    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = SplineView(splineCollection, splineController)
            app.splineCollection = splineCollection;
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
        
        function show(app)
            app.uiFigure.Visible = 'on';
        end

        function drawPiecewiseSpline(app)
            isAdditionalSpline = 0; % first point label will be shifted to avoid overwritting
                                    % last point label of initial piecewise spline
            app.plotPartialPiecewiseSpline(isAdditionalSpline);

            xlabel(app.uiAxes,'x');
            ylabel(app.uiAxes, 'y');
            title(app.uiAxes, ["Piecewise spline + 1" "standard form - " "partial curves"]);

            [xAxisMin, xAxisMax] = app.splineCollection.getXAxisLimits();

            set(app.uiAxes,'ylim',[-5 10],'xlim',[xAxisMin xAxisMax],'xtick',xAxisMin:xAxisMax,'ytick',-5:10)
            opt.fontname = 'helvetica';
            opt.fontsize = 8;

            app.centeraxes(opt);
        end
    end
end