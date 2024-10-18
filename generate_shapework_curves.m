%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MATLAB Script for Generating the Shape of Work Curves
% (Corresponding to Algorithm 1 from the research paper entitled 
% "Generation of the Shape of Work Curves")
%
% This script processes synthetic daily activity data to generate "work curves"
% by aggregating daily activity profiles based on total daily activity ranges.
% It calculates the average activity patterns over days with similar total activity,
% segmented by a specified window size (w = 150 minutes by default) and offset (o = 20 minutes).
%
% Key Steps:
% - Load pre-generated synthetic activity data ('data' and 'self_reports').
% - Define activity windows based on total daily activity.
% - For each window, calculate the average activity pattern across days where
%   total daily activity falls within that range.
% - Store and plot the resulting work curves, which represent typical activity
%   patterns over the course of a day for each window.
%
% Parameters:
% - w : Window size in minutes, determining the range of total daily activity
%       considered for each curve.
% - o : Offset in minutes, specifying the step size between consecutive windows.
%
% Outputs:
% - 'C' : A matrix where each row represents an aggregated work curve over 24 hours
%         for a given range of daily activity.
% - 'C_reports' : The average self-reported activity corresponding to each work curve.
%
% Optional:
% - A plot is generated showing all the computed work curves, illustrating how
%   the activity distribution changes based on different total daily activity windows.
%
% Usage:
% This script assumes that the synthetic data is preloaded from 'synthetic_data.mat',
% which contains 'data' (N x 24 matrix of daily activity per hour) and 'self_reports'
% (a vector of scaled self-reported activity levels).
%
% Author: Javier Hernandez (javierh@microsoft.com)
% Date: 10/18/2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Close all open figures and clear the workspace
close all;
clear all;

% Load data from 'synthetic_data.mat'
% Assumes that variables 'data' and 'self-reports' are loaded
load('synthetic_data')

% Assuming 'data' is an N x 24 matrix where each row is a day's activity per hour

% Parameters
w = 150; % Window size in minutes
o = 20;  % Offset in minutes

% Number of days
N = size(data, 1);

% Compute total activity T_d for each day
T_d = sum(data, 2); % Sum across hours for each day

% Initialize list of curves C as an empty matrix
C = []; % Each row will be a curve

% Find T_min and T_max
T_min = floor(min(T_d));
T_max = ceil(max(T_d));

C_reports = [];
% Loop over s = T_min to T_max - w with step o
for s = T_min:o:(T_max - w)
    % Define window W
    W = [s, s + w];

    % Find indices of days where total activity is within window W
    D_W = find(T_d >= W(1) & T_d < W(2));

    if ~isempty(D_W)
        % Compute A(t) for t = 1 to 24
        A = mean(data(D_W, :), 1); % Mean across the selected days

        % Append curve A(t) to C as a new row
        C = [C; A];

        % Compute average self-report for the curve
        C_reports = [C_reports; mean(self_reports(D_W))];
    end
end

% Optional: Plot the curves
figure;
hold on;
hours = 1:24;
[numCurves, ~] = size(C);
for i = 1:numCurves
    plot(hours, C(i, :), 'DisplayName', sprintf('Curve %d', i));
end
xlabel('Hour of the Day');
ylabel('Average Minutes of Activity');
title('Shape of Work Curves');
legend('show');
hold off;

save('shape_of_work','C','C_reports')


