%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MATLAB Script for Generating Synthetic Daily Activity Profiles
%
% This script simulates daily activity patterns over a specified number of
% days (N = 1000 by default) by generating synthetic data that represents
% the minutes of activity for each hour of the day. Activity peaks are modeled
% using Gaussian functions to simulate common activity periods such as mid-morning,
% afternoon, and evening. The total daily activity is constrained to a range
% of [100, 650] minutes.
%
% Key Steps:
% - For each day, generate a random total daily activity between a specified
%   minimum and maximum.
% - Create Gaussian activity profiles centered around specific hours to simulate
%   realistic peaks in activity (e.g., 10 AM, 2 PM, 9 PM).
% - Normalize and scale the activity profile to match the randomly selected
%   total activity.
% - Introduce noise and apply capping to ensure realistic hourly activity limits.
% - Verify that the total activity per day is within the predefined range.
% - Output the synthetic activity data and scaled self-reported activity vectors
%   for further analysis or use.
%
% Outputs:
% - 'data' : A matrix (N x 24) where each row represents the hourly activity 
%            for a given day.
% - 'self_reports' : A scaled version of the total daily activity, normalized
%                    to the range [0, 1], representing self-reported activity.
%
% Optional:
% - A bar plot is generated showing the average daily activity profile across
%   all days.
%
% Usage:
% Modify the parameters (e.g., number of days, activity range) as needed before
% running the script. Results are saved to 'synthetic_data.mat'.
%
% Author: Javier Hernandez (javierh@microsoft.com)
% Date: 10/18/2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Close all open figures and clear the workspace
close all;
clear all;

% Number of samples (days)
N = 1000;

% Preallocate the data matrix
data = zeros(N, 24);

% Define the hours
hours = 0:23;

% Standard deviation for the Gaussians
sigma = 1;

% Desired total activity range
min_total_activity = 100;
max_total_activity = 650;

% Loop over each day
for i = 1:N
    % Generate total activity for the day (random between min and max)
    total_minutes = randi([min_total_activity, max_total_activity]);
    
    % Random variation in Gaussian amplitudes
    A1 = 1 + 0.1 * randn();       % For the 10:00 AM peak
    A2 = 1 + 0.1 * randn();       % For the 2:00 PM peak
    A3 = 0.5 + 0.05 * randn();    % For the 9:00 PM peak (smaller height)
    
    % Random shifts in the centers of the Gaussians
    mu1 = 10 + 0.5 * randn();     % Around 10:00 AM
    mu2 = 14 + 0.5 * randn();     % Around 2:00 PM
    mu3 = 21 + 0.5 * randn();     % Around 9:00 PM
    
    % Compute the Gaussian functions
    G1 = A1 * exp(-((hours - mu1).^2) / (2 * sigma^2));
    G2 = A2 * exp(-((hours - mu2).^2) / (2 * sigma^2));
    G3 = A3 * exp(-((hours - mu3).^2) / (2 * sigma^2));
    
    % Sum the Gaussians to get the activity profile
    activity_profile = G1 + G2 + G3;
    
    % Normalize the activity profile so that the sum equals 1
    activity_profile = activity_profile / sum(activity_profile);
    
    % Scale the activity profile by the total minutes of activity
    per_hour_activity = total_minutes * activity_profile;
    
    % Add some noise to make it more realistic
    per_hour_activity = per_hour_activity + 5 * randn(size(per_hour_activity));
    
    % Ensure no negative values
    per_hour_activity(per_hour_activity < 0) = 0;
    
    % Cap the per-hour activity at 60 minutes (maximum possible)
    per_hour_activity(per_hour_activity > 60) = 60;
    
    % Recalculate total activity after noise and capping
    total_activity_after_capping = sum(per_hour_activity);
    
    % Adjust total activity if necessary
    if total_activity_after_capping < min_total_activity
        % Scale up per_hour_activity proportionally, without exceeding 60 minutes per hour
        scaling_factor = min_total_activity / total_activity_after_capping;
        per_hour_activity = per_hour_activity * scaling_factor;
        per_hour_activity(per_hour_activity > 60) = 60; % Ensure no values exceed 60
        
        % Recalculate total activity after scaling and capping
        total_activity_after_capping = sum(per_hour_activity);
        
        % If still below minimum, distribute remaining minutes to hours with less than 60 minutes
        if total_activity_after_capping < min_total_activity
            deficit = min_total_activity - total_activity_after_capping;
            available_hours = per_hour_activity < 60;
            per_hour_activity(available_hours) = per_hour_activity(available_hours) + ...
                (deficit / sum(available_hours));
            per_hour_activity(per_hour_activity > 60) = 60; % Ensure no values exceed 60
        end
    elseif total_activity_after_capping > max_total_activity
        % Scale down per_hour_activity proportionally
        scaling_factor = max_total_activity / total_activity_after_capping;
        per_hour_activity = per_hour_activity * scaling_factor;
    end
    
    % Store the data
    data(i, :) = per_hour_activity;
end

% Optional: Plot the average activity profile over all days
average_activity = mean(data);


figure;
bar(hours, average_activity);
xlabel('Hour of the Day');
ylabel('Average Minutes of Activity');
title('Average Daily Activity Profile');

% Optional: Verify that per-hour activity does not exceed 60 minutes
assert(all(data(:) <= 60), 'Error: Some per-hour activities exceed 60 minutes.');

% Optional: Verify that total activity per day is within the specified range
total_activity_per_day = sum(data, 2);
fprintf('Total activity per day ranges from %.2f to %.2f minutes.\n', min(total_activity_per_day), max(total_activity_per_day));


vect = sum(data,2);
vect = scale(vect,min(vect),max(vect),0,1);
self_reports = vect;


save('synthetic_data','data','self_reports')
