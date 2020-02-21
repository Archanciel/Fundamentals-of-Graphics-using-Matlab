classdef SplineView < matlab.apps.AppBase
% Source is chap1_8_adding_piecewise_spline_standard_form_app.mlapp
    % Properties that correspond to app components
    properties (Access = public)
        % constants
        SCATTER_POINT_SIZE = 15;
        XY_SLIDER_POINT_STEP = 0.1;
        X_SLIDER_SLOPE_STEP = 1;
        XY_SLIDER_ROUND = 1;
        SLOPE_SLIDER_ROUND = 0;
        PLOT_RESOLUTION = 100; % linspace 3rd param
        REPLACE_NUMBER = 6;
        DISPLAY_XY_VALUE_FORMAT = '%2.1f'
        X_SLIDER_MAJOR_TICK_LABEL_NUMBER = 5
        Y_SLIDER_MAJOR_TICK_LABEL_NUMBER = 10
        X_AXIS_MIN = -1
        X_AXIS_MAX = 17
        Y_SLIDER_MIN = -5
        Y_SLIDER_MAX = 10
        POINT_MENU_INIT_VALUE = 1
        POINT_MENU_CORRESPONDING_SLOPE_POINT_INIT_VALUE = -1

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
        splineCollection      model.SplineCollection
        splineController      controller.SplineController
        splineUIDataDic       containers.Map    % dictionary keyed with spline
                                                % name containing as value
                                                % the related SplineUIData
        splinePointAndSlopeMenuCorrespondingPointIndex
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Value changed function: pointSelectionMenu
        function pointSelectionMenuValueChanged(app, ~)
            pointIndex = app.getPointIndex();
            
            app.updateSliderXProperties(pointIndex);
            app.updateSliderYProperties(pointIndex);
        end

        function menuSelIndex = getPointSelectionMenuIndex(app)
            selectedMenuItemStr = app.pointSelectionMenu.Value;
            menuItemsCellArray = app.pointSelectionMenu.Items;
            menuSelIndex = find(strcmp(menuItemsCellArray, selectedMenuItemStr));
        end
        
        function updateSliderXProperties(app, pointIndex)
            sliderHandle = app.xCoordSlider;

            if pointIndex >= 1
                [xSliderMin, xSliderMax] = app.splineCollection.getMinMaxX(pointIndex, pointIndex, app.X_AXIS_MIN, app.X_AXIS_MAX, app.XY_SLIDER_POINT_STEP);
            elseif pointIndex > 0
                realPointIndex = pointIndex * 1000;
                [xSliderMin, xSliderMax] = app.splineCollection.getMinMaxX(realPointIndex, realPointIndex + 1, app.X_AXIS_MIN, app.X_AXIS_MAX, app.XY_SLIDER_POINT_STEP);
            else
                [xSliderMin, xSliderMax] = app.splineCollection.getMinMaxSlope();
            end
            
            sliderHandle.Limits = [xSliderMin xSliderMax];
            numericalMajorTickArray = app.computeMajorTicksArray(xSliderMin,...
                                                                 xSliderMax,...
                                                                 app.X_SLIDER_MAJOR_TICK_LABEL_NUMBER);
            sliderHandle.MajorTicks = numericalMajorTickArray; 

            if pointIndex >= 1
                realPointIndex = pointIndex;
            elseif pointIndex > 0
                realPointIndex = pointIndex * 1000;
            else
                realPointIndex = pointIndex;
            end
            
            if pointIndex > 0
                value = app.splineCollection.getXValueOfPoint(realPointIndex);
                app.xSliderLabel.Text = 'X    ';
                sliderHandle.MinorTicks = [xSliderMin:app.XY_SLIDER_POINT_STEP:xSliderMax];
            else
                value = app.splineCollection.getSlopeValueAtPoint(realPointIndex);
                app.xSliderLabel.Text = 'Slope';
                sliderHandle.MinorTicks = [xSliderMin:app.X_SLIDER_SLOPE_STEP:xSliderMax];
            end
            
            sliderHandle.Value = value;
            app.xCoordSliderTxtValue.Text = sprintf(app.DISPLAY_XY_VALUE_FORMAT,value);
        end 

        function majorTicksArray = computeMajorTicksArray(app,...
                                                          axMin,...
                                                          axMax,...
                                                          majorTickLabelssNumber)
            % This function fills a numerical array with the values of the
            % slider major tick labels. For example, if the slider enables
            % to select a value between 0 and 100, calling the function with
            % parms 0 100, 5 will return [0 20 40 60 80 100]
            axRange = axMax - axMin;
            majorTicksLength = axRange / majorTickLabelssNumber;
            majorTicksArray = zeros(1, majorTickLabelssNumber + 1);
            majorTicksArray(1) = axMin;
            
            for i = 1:majorTickLabelssNumber
                majorTick = axMin + (i * majorTicksLength);
                majorTicksArray(i + 1) = round(majorTick, 1);
            end
        end
                
        function updateSliderYProperties(app, pointIndex)
            sliderHandle = app.yCoordSlider;
            sliderHandle.Limits = [app.Y_SLIDER_MIN app.Y_SLIDER_MAX];
            numericalMajorTickArray = app.computeMajorTicksArray(app.Y_SLIDER_MIN,...
                                                                 app.Y_SLIDER_MAX,...
                                                                 app.Y_SLIDER_MAJOR_TICK_LABEL_NUMBER);

            if pointIndex >= 1
                realPointIndex = pointIndex;
            elseif pointIndex > 0
                realPointIndex = pointIndex * 1000;
            else
                realPointIndex = pointIndex;
            end
            
            if pointIndex > 0
                sliderHandle.MajorTicks = numericalMajorTickArray; 
                value = app.splineCollection.getYValueOfPoint(realPointIndex);
                sliderHandle.Value = value;
                app.yCoordSliderTxtValue.Text = sprintf(app.DISPLAY_XY_VALUE_FORMAT,value);
                set(app.yCoordSliderTxtValue, 'visible', 'on');
                set(sliderHandle, 'visible', 'on')
                set(app.ySliderLabel, 'visible', 'on');
            else
                set(app.yCoordSliderTxtValue, 'visible', 'off');
                set(sliderHandle, 'visible', 'off');
                set(app.ySliderLabel, 'visible', 'off');
            end
        end

        function pointIndex = getPointIndex(app)
            menuSelIndex = app.getPointSelectionMenuIndex();
            pointIndex = app.splinePointAndSlopeMenuCorrespondingPointIndex(menuSelIndex);
        end

        function roundedValue = get_x_roundedValue(app)
            sliderHandle = app.xCoordSlider;
            value = sliderHandle.Value;

            pointIndex = app.getPointIndex();
            
            if pointIndex > 0
                roundedValue = round(value, app.XY_SLIDER_ROUND);
            else
                roundedValue = round(value, app.SLOPE_SLIDER_ROUND);
            end
        end

        function roundedValue = get_y_roundedValue(app)
            sliderHandle = app.yCoordSlider;
            value = sliderHandle.Value;
            roundedValue = round(value, app.XY_SLIDER_ROUND);
        end
        
        function xCoordSliderValueChanged(app, ~)
            % SplineView callback function attached to the x slider
            % control. This function only updates the SlideView controls
            % impacted by the slider change. The spline redrawing is
            % under the responsibility of the SplineController.
            
            xRoundedValue = app.get_x_roundedValue();
            app.xCoordSlider.Value = double(xRoundedValue);
            app.xCoordSliderTxtValue.Text = sprintf(app.DISPLAY_XY_VALUE_FORMAT,xRoundedValue);
        end

        % Value changed function: yCoordSlider
        function yCoordSliderValueChanged(app, ~)
            % SplineView callback function attached to the y slider
            % control. This function only updates the SlideView controls
            % impacted by the slider change. The spline redrawing is
            % under the responsibility of the SplineController.
            
            yRoundedValue = app.get_y_roundedValue();
            app.yCoordSlider.Value = double(yRoundedValue);
            app.yCoordSliderTxtValue.Text = sprintf(app.DISPLAY_XY_VALUE_FORMAT,yRoundedValue);
        end
        
        % Component initialization
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
            app.panel.Position = [8 18 485 124];

            % Create xCoordSliderTxtValue
            app.xCoordSliderTxtValue = uilabel(app.panel);
            app.xCoordSliderTxtValue.Position = [444 92 35 22];

            % Create yCoordSliderTxtValue
            app.yCoordSliderTxtValue = uilabel(app.panel);
            app.yCoordSliderTxtValue.Position = [444 33 35 22];

            % Create xSliderLabel
            app.xSliderLabel = uilabel(app.panel);
            app.xSliderLabel.HorizontalAlignment = 'right';
            app.xSliderLabel.Position = [173 92 35 22];

            % Create xCoordSlider
            app.xCoordSlider = uislider(app.panel);
            app.xCoordSlider.ValueChangedFcn = createCallbackFcn(app, @xCoordSliderValueChanged, true);
            app.xCoordSlider.Position = [219 101 210 3];

            % initialize x slider limits, value and major ticks aswell as label xCoordSliderTxtValue
            app.updateSliderXProperties(app.POINT_MENU_CORRESPONDING_SLOPE_POINT_INIT_VALUE);
 
            % Create ySliderLabel
            app.ySliderLabel = uilabel(app.panel);
            app.ySliderLabel.HorizontalAlignment = 'right';
            app.ySliderLabel.Position = [173 33 25 22];
            app.ySliderLabel.Text = 'Y';

            % Create yCoordSlider
            app.yCoordSlider = uislider(app.panel);
            app.yCoordSlider.ValueChangedFcn = createCallbackFcn(app, @yCoordSliderValueChanged, true);
            app.yCoordSlider.Position = [219 42 210 3];

            % initialize x slider limits, value and major ticks aswell as label yCoordSliderTxtValue
            app.updateSliderYProperties(app.POINT_MENU_CORRESPONDING_SLOPE_POINT_INIT_VALUE);

            % Create pointDropDownLabel
            app.pointDropDownLabel = uilabel(app.panel);
            app.pointDropDownLabel.HorizontalAlignment = 'right';
            app.pointDropDownLabel.Position = [8 92 32 22];
            app.pointDropDownLabel.Text = 'Point';

            % Create pointSelectionMenu
            app.pointSelectionMenu = uidropdown(app.panel);
            app.pointSelectionMenu.ValueChangedFcn = createCallbackFcn(app, @pointSelectionMenuValueChanged, true);
            app.pointSelectionMenu.Position = [55 92 100 22];
            menuItemsCellArray = app.getSplinePointAndSlopeMenuItems();
            app.pointSelectionMenu.Items = menuItemsCellArray;
            app.pointSelectionMenu.Value = menuItemsCellArray{app.POINT_MENU_INIT_VALUE};
        end

        function [newPointLabelHandles, newScatteredPointHandle] = plotPointsAndLabels(app,...
                                                                                       Pn,...
                                                                                       pointsLabelStrings,...
                                                                                       pointsLabelHandles,...
                                                                                       scatteredPointsHandle)
            % currentSplineIndex argument == 1 indicaten that the first point label of the
            % additional spline must be shifted in order to avoid overwritting the
            % last point initial sline label
            %
            % Returns newPointLabelHandles so they can be deleted before being redrawn
            % and newSscatteredPointHandle which hosts the handle returned by the scatter
            % function

            app.deleteScatteredPoints(scatteredPointsHandle);
            app.deletePointLabels(pointsLabelHandles);

            newScatteredPointHandle = scatter(app.uiAxes, Pn(:,1),Pn(:,2), app.SCATTER_POINT_SIZE,'k','filled');

            % first point label is shifted to avoid overwritting the
            % last point label of the previous piecewise spline
            newPointLabelHandles{1} = text(app.uiAxes, Pn(1,1)+0.1, Pn(1,2)-0.1, pointsLabelStrings{1});
            newPointLabelHandles{2} = text(app.uiAxes, Pn(2,1)-0.3, Pn(2,2)-0.3, pointsLabelStrings{2});
            newPointLabelHandles{3} = text(app.uiAxes, Pn(3,1)-0.3, Pn(3,2)-0.3, pointsLabelStrings{3});
            newPointLabelHandles{4} = text(app.uiAxes, Pn(4,1)-0.3, Pn(4,2)-0.3, pointsLabelStrings{4});
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
            % Input: 0 1 or 2 arguments
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

            if nargin < 2
                fontsize = get(ax,'FontSize');
                fontname = get(ax,'FontName');
            end
            if nargin < 1
                ax = gca;
            end

            if nargin == 2
                if isfield(opt,'fontsize')
                    fontsize = opt.fontsize;
                else
                    fontsize = get(ax,'FontSize');
                end
                if isfield(opt,'fontname')
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

            if xlim(1)>0
                xlim(1) = 0;
            end

            if ylim(1)>0
                ylim(1) = 0;
            end

            if xlim(2) < 0
                xlim(2) = 0;
            end

            if ylim(2) < 0
                ylim(2) = 0;
            end

            set(ax,'xlim',xlim,'ylim',ylim);


            % -------------------------------------------------------------------------
            % Caculate size of the "axis tick marks"
            % -------------------------------------------------------------------------
            axpos = get(ax,'position');
            figpos = get(ax,'position');
            if (strcmp(get(ax,'Units'),'normalized')) 
                screensize = get(0, 'ScreenSize'); 
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
            for k = 1:length(xtick)
                newxtick(k) = line(ax, [xtick(k); xtick(k)],[-xticksize/2; xticksize/2]);
                if (xtick(k)~=0)
                    newxticklab(k) = text(ax, xtick(k),-1.5*xticksize, strtrim(xticklab(k,:)));
                    set(newxticklab(k),'HorizontalAlignment','center',...
                        'Fontsize',fontsize,'FontName',fontname);
                end
            end
            set(newxtick,'color',[0 0 0]);

            % Draw y-axis ticks
            for k = 1:length(ytick)
                newytick(k) = line(ax, [-yticksize/2; yticksize/2],[ytick(k); ytick(k)]);
                if (ytick(k)~=0)
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

            if nargout > 0
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
        
        function initializeSplineUIDataDic(app)
            % Initialize the SplineUIDataDic with SplineUIData's keyed
            % by related SplineModel names. Each SplineUIData is
            % initialized with the related spline point labels
            keyCellArray = app.splineCollection.getSplineNamesCellArray();
            splineNumber = app.splineCollection.getSplineNumber();
            valueCellArray = cell(1, splineNumber);
            app.splineUIDataDic = containers.Map(keyCellArray, valueCellArray);
            currentPointIndex = 1;
            
            for i = 1:splineNumber
                currentSplineModel = app.splineCollection.getSplineModel(i);
                currentSplineModelName = currentSplineModel.splineModelName;
                currentSplineUIData = view.SplineUIData();
                currentSplinePointNumber = currentSplineModel.getSplinePointNumber();
                currentSplinePointLabelStrCellArray = cell(1, currentSplinePointNumber);
                
                % filling the new SplineUIData with the related spline point labels
                for j = 1:currentSplinePointNumber
                    currentSplinePointLabelStrCellArray{j} = sprintf('P_{%d}', currentPointIndex);
                    currentPointIndex = currentPointIndex + 1;
                end
                
                currentSplineUIData.splinePointLabelStrCellArray = currentSplinePointLabelStrCellArray;
                currentSplineUIData.splineColorCellArray = currentSplineModel.getSplineColorCellArray(); 
                app.splineUIDataDic(currentSplineModelName) = currentSplineUIData;
            end 
        end   

        function splinePointAndSlopeMenuItemStrCellArray = getSplinePointAndSlopeMenuItems(app)
            % This function add slope menu items to the point drop down
            % menu initial item string cell array.
            %
            % The splinePointAndSlopeMenuCorrespondingPointIndex instance
            % variable hosts the SplineCollection point index corresponding
            % to the point drop down menu item. Slope drop down menu items
            % by convention have negative indexes, which will be
            % interpreded to differenciate a slope from a poiht selection
            % in the drop down menu callback function.
            menuItemCellArray = app.getAllSplinePointSelectionMenuValueStr();
            itemNumber = length(menuItemCellArray);
            splinePointAndSlopeMenuItemStrCellArray = cell(1, itemNumber);
            app.splinePointAndSlopeMenuCorrespondingPointIndex = zeros(1, itemNumber);
            n = 0;
            skipItem = 0;
            
            for i = 1:itemNumber
                if i == 1
                    % here, we add a 'Start slope' menu item followed by
                    % the 'P1' menu item.
                    n = i;
                    splinePointAndSlopeMenuItemStrCellArray{n} = 'Start slope';
                    app.splinePointAndSlopeMenuCorrespondingPointIndex(n) = -i;
                    n = n + 1;
                    splinePointAndSlopeMenuItemStrCellArray{n} = menuItemCellArray{i};
                    app.splinePointAndSlopeMenuCorrespondingPointIndex(n) = i;
                    n = n + 1;
                elseif i == itemNumber
                    % here, we add a 'End slope' menu item preceeded by
                    % the last point menu item.
                    splinePointAndSlopeMenuItemStrCellArray{n} = menuItemCellArray{i};
                    app.splinePointAndSlopeMenuCorrespondingPointIndex(n) = i;
                    n = n + 1;
                    splinePointAndSlopeMenuItemStrCellArray{n} = 'End slope';
                    app.splinePointAndSlopeMenuCorrespondingPointIndex(n) = -i;
                elseif mod(i, 4) == 0
                    % here, we add a 'Pi-i + 1 slope' menu item preceeded by
                    % the 'Pi-i + 1' point menu item. The slope menu item
                    % enable to modify the slope at this location. On the
                    % contrary, the 'Pi-i + 1' point menu item is used to
                    % alter the x or y coordinate of both the i and i + 1
                    % points. Its associated splinePointAndSlopeMenuCorrespondingPointIndex
                    % is positive and < 1.
                    splinePointAndSlopeMenuItemStrCellArray{n} = sprintf('P%d-%d', i, i + 1);
                    app.splinePointAndSlopeMenuCorrespondingPointIndex(n) = i/1000;
                    n = n + 1;
                    splinePointAndSlopeMenuItemStrCellArray{n} = sprintf('P%d-%d slope', i, i + 1);
                    app.splinePointAndSlopeMenuCorrespondingPointIndex(n) = -i;
                    n = n + 1;
                    skipItem = 1;
                else
                    if skipItem == 0
                        splinePointAndSlopeMenuItemStrCellArray{n} = menuItemCellArray{i};
                        app.splinePointAndSlopeMenuCorrespondingPointIndex(n) = i;
                        n = n + 1;
                    else
                        app.splinePointAndSlopeMenuCorrespondingPointIndex(n) = -i;      
                        skipItem = 0;
                    end
                end
            end
            
        end
        
        function splinePointSelectionMenuValueStrCellArray = getAllSplinePointSelectionMenuValueStr(app)
            % This function builds the string cell array used to fill the
            % point selection drop down menu. For each point in every
            % spline, a string Pi is created ('P1, P2, ...). 
            splineNumber = app.splineCollection.getSplineNumber();
            
            % preallocating cell array
            splinePointSelectionMenuValueStrCellArray = cell(1,splineNumber);
            pIndex = 0;
            
            for i = 1:splineNumber
                currentSplineModel = app.splineCollection.getSplineModel(i);
                
                for j = 1:length(currentSplineModel.splineXpointCoordVector)
                    pIndex = pIndex + 1;
                    splinePointSelectionMenuValueStrCellArray{pIndex} = strcat('P', num2str(pIndex));
                end
            end
        end

        function attachControllerToSliderChangeEvent(app)
            addlistener(app.xCoordSlider, 'ValueChanged', @(~,~)app.splineController.handle_X_CoordChanged(app.get_x_roundedValue(), app.getPointIndex()));
            addlistener(app.yCoordSlider, 'ValueChanged', @(~,~)app.splineController.handle_Y_CoordChanged(app.get_y_roundedValue(), app.getPointIndex()));
        end
                
        function deletePlottedPiecewiseSpline(app, pointIndex)
            % Deletes the spline which will be redrawn.
            splineModel = app.splineCollection.getSplineModelContainingPoint(pointIndex);
            splineUIData = app.splineUIDataDic(splineModel.splineModelName);
            plottedPiecewiseSplinesCellArray = splineUIData.splineLineHandleCellArray;
            elementNb = size(plottedPiecewiseSplinesCellArray, 2);

            for i = 1:elementNb
                delete(plottedPiecewiseSplinesCellArray{i});
            end
        end
        
        % Spline drawing methods
        function plotSpline(app,...
                            currentSplineIndex,...
                            maxSplineIndex)
            % Returns handles on the plotted piecewise splines
            % so that they can be deleted before redrawing them !
            splineModel = app.splineCollection.getSplineModel(currentSplineIndex);
            yFuncCellArray = splineModel.computePiecewiseSplineFunctions();
            Pn = [splineModel.splineXpointCoordVector(1,:)' splineModel.splineYpointCoordVector(1,:)'];
            spline_colors = app.splineUIDataDic(splineModel.splineModelName).splineColorCellArray; 

            % computing xx_func
            
            for i = 1:length(yFuncCellArray)
                y_func = yFuncCellArray{i};
                
                if i == 1
                    % handling first part of the 3 part piecewise spline
                    if currentSplineIndex == 1
                        % handling the first part of the the first piecewise spline of the
                        % piecewise spline collection. xx_func must start at first x minus one.
                        xx_func = linspace(Pn(i,1) - 1, Pn(i + 1,1), app.PLOT_RESOLUTION);
                    else
                        xx_func = linspace(Pn(i,1), Pn(i + 1,1), app.PLOT_RESOLUTION);
                    end
                elseif i == 3
                    % handling last part of the 3 part piecewise spline
                    if currentSplineIndex == maxSplineIndex
                        % handling the last part of the the last piecewise spline of the
                        % piecewise spline collection. xx_func must exceed last x by one.
                        xx_func = linspace(Pn(i,1), Pn(i + 1,1) + 1, app.PLOT_RESOLUTION);
                    else
                        xx_func = linspace(Pn(i,1), Pn(i + 1,1), app.PLOT_RESOLUTION);
                    end
                else
                    xx_func = linspace(Pn(i,1), Pn(i + 1,1), app.PLOT_RESOLUTION);
                end
                
                syms x
                
                yy_func = subs(y_func, x, xx_func);
                splineUIData = app.splineUIDataDic(splineModel.splineModelName);
                splineUIData.splineLineHandleCellArray{i} = plot(app.uiAxes, xx_func, yy_func, spline_colors{i});
                hold(app.uiAxes,'on');
            end

            splineUidata = app.splineUIDataDic(splineModel.splineModelName);
            points_labels = splineUidata.splinePointLabelStrCellArray; 
            splineUIData = app.splineUIDataDic(splineModel.splineModelName);
            pointLabelHandlesToDelete = splineUIData.splinePointLabelHandleCellArray;
            scatteredPointHandleToDelete = splineUIData.splineScatteredPointHandleCellArray;

            [newPointLabelHandles, newScatteredPointHandle] = app.plotPointsAndLabels(Pn,... 
                                                                                      points_labels,...
                                                                                      pointLabelHandlesToDelete,...
                                                                                      scatteredPointHandleToDelete);

            splineUIData.splinePointLabelHandleCellArray = newPointLabelHandles;
            splineUIData.splineScatteredPointHandleCellArray = newScatteredPointHandle;
        end
      
    end % end private methods section
    
    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = SplineView(splineCollection, splineController)
            app.splineCollection = splineCollection;
            app.splineController = splineController;
            app.initializeSplineUIDataDic()
            
            % Create UIFigure and components
            createComponents(app)
            app.attachControllerToSliderChangeEvent()
            
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

        function plotPiecewiseSplines(app)
            % plot all the piecewise splines contained in splineCollection
            maxSplineIndex = app.splineCollection.getSplineNumber();
            
            for i = 1:maxSplineIndex
                app.plotSpline(i,...
                               maxSplineIndex);
            end

            % Setting spline view title
            title(app.uiAxes, [sprintf("%d piecewise splines", maxSplineIndex) "in standard form"]);

            % Setting graph axis limits and ticks
            set(app.uiAxes,'ylim',[app.Y_SLIDER_MIN app.Y_SLIDER_MAX],'xlim',[app.X_AXIS_MIN app.X_AXIS_MAX],'xtick',app.X_AXIS_MIN:app.X_AXIS_MAX,'ytick',-5:10)

            % Calling axis cerntering code (found on Matworks Community
            % https://ch.mathworks.com/matlabcentral/fileexchange/22333-centered-coordinate-axes-in-2d-plots)
            opt.fontname = 'helvetica';
            opt.fontsize = 8;
            app.centeraxes(opt);
        end
        
        function replotSpline(app,...
                              pointIndex)
            % replotting the modified spline
            app.deletePlottedPiecewiseSpline(pointIndex);            
            maxSplineIndex = app.splineCollection.getSplineNumber();
            app.plotSpline(app.splineCollection.getSplineIndexOfSplineContainingPoint(pointIndex),...
                           maxSplineIndex);
        end
        
    end % end public methods section
end