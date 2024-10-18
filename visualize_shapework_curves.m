%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MATLAB Script for Visualizing the Shape of Work Curves
% (Associated with the research paper entitled "Generation of the Shape of Work Curves")
%
% This script visualizes the shape of work curves that were generated in the previous
% step (corresponding to the 'C' matrix) by creating a 3D surface plot. The plot
% shows the average minutes of activity per hour across days, with the color of the
% surface representing the self-reported activity levels ('C_reports') for each curve.
%
% Key Steps:
% - Load precomputed work curves ('C') and self-reported activity levels ('C_reports')
%   from 'shape_of_work.mat'.
% - Customize the colormap by modifying the 'hot' colormap to avoid extreme color
%   values.
% - Map the self-reported activity values to the customized colormap and assign these
%   colors to the surface plot.
% - Plot the 3D surface showing the activity distribution over hours of the day, with
%   additional enhancements such as a mesh overlay and color bar for reference.
%
% Outputs:
% - A 3D surface plot showing the shape of work curves with activity levels and 
%   self-reported values mapped to a custom colormap.
%
%
% Usage:
% This script assumes that the work curve data ('C') and self-reported values
% ('C_reports') have been preloaded from 'shape_of_work.mat'. It then generates a
% 3D surface plot representing the synthetic activity patterns across different hours
% of the day and total daily activity levels.
%
% Author: Javier Hernandez (javierh@microsoft.com)
% Date: 10/18/2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Close all open figures and clear the workspace
close all;
clear all;

% Load data from 'shape_of_work.mat'
% Assumes that variables 'C' and 'C_reports' are loaded
load('shape_of_work');

% Create a custom colormap
% Flip the 'hot' colormap upside down
colormap2 = flipud(hot);

% Trim the first and last 20 colors to avoid extreme color values
colormap2 = colormap2(20:end-20, :);

% Assign the customized colormap to 'list_colors'
list_colors = colormap2;

% Map 'C_reports' values to colormap indices
% Scale 'C_reports' to the range of colormap indices
scaled_indices = round(...
    (C_reports - min(C_reports)) / (max(C_reports) - min(C_reports)) * (size(list_colors, 1) - 1) + 1);

% Get the corresponding colors for each value in 'C_reports'
colors = list_colors(scaled_indices', :);  % Transpose to match dimensions

% Prepare data for plotting
% Create meshgrid for the X (hours) and Y (days)
[X, ~] = meshgrid(1:size(C, 2), 1:size(C, 1));

% Calculate total activity per day and replicate across columns
Y = repmat(sum(C, 2), 1, size(C, 2));

% 'Z' is the activity data from 'C'
Z = C;

% Prepare the color data 'Z2' for the surface plot
% Reshape 'colors' to match the dimensions of 'Z' and replicate across columns
Z2 = repmat(reshape(colors, [size(colors, 1), 1, 3]), 1, size(Z, 2), 1);

% Plot the shape of work
figure;

% Plot the surface with the custom colors
s = surf(X, Y, Z, Z2);
view([17.10, 28.20]);          % Set the viewing angle
s.EdgeColor = 'none';          % Remove edge lines from the surface

hold on;

% Add a mesh overlay for visual effect
m = mesh(X, Y, Z);
m.EdgeColor = 'black';
m.FaceColor = 'none';
m.FaceAlpha = 0.4;

% Configure the colorbar
% Add a colorbar to the figure
c = colorbar;

% Define colorbar tick values based on 'C_reports' range
c_ticks = linspace(min(C_reports(:)), max(C_reports(:)), 5);
c_ticks = round(c_ticks * 100) / 100;  % Round to two decimal places

% Set the colorbar ticks to match the data range in 'Z'
c.Ticks = linspace(min(Z(:)), max(Z(:)), length(c_ticks));

% Set the colorbar tick labels
c.TickLabels = arrayfun(@num2str, c_ticks, 'UniformOutput', false);

% Label the axes
xlabel('Hour of the Day');
ylabel('Total Activity per Day (minutes)');
zlabel('Computer Activity per Hour (minutes)');

% Set the font size for better readability
set(gca, 'FontSize', 10);

% Set the X-axis limits and ticks
xlim([1, 24]);
set(gca, 'XTick', 1:2:24);

% Set the Y-axis ticks (Total activity per day)
set(gca, 'YTick', round(linspace(min(Y(:)), max(Y(:)), 10)));

% Apply the custom colormap
colormap(colormap2);

% Add a title to the plot
title('Synthetic Data', 'Interpreter', 'none');

