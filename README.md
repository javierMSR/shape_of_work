# Shape of Work Curves

This repository contains MATLAB scripts for generating, processing, and visualizing work curves, as described in the research paper entitled *Triple Peak Day: Work Rhythms of Software Developers in Hybrid Work*. The scripts should be run in the specified order to reproduce the workflow.

## Files and Workflow

1. **`generate_synthetic_activity.m`**  
   This script generates synthetic daily activity data that emulates typical patterns observed in real-world studies, though it is meant for illustration purposes only. The generated data can be replaced by user-provided data if available. The output is saved as `synthetic_data.mat`, containing the activity data (`data`) and self-reported values (`self_reports`).

2. **`generate_shapework_curves.m`**  
   This script takes the synthetic or user-provided activity data and processes it to generate the shape of work curves. It aggregates daily activity patterns based on total daily activity levels, grouping similar days and creating a set of work curves. The output is saved as `shape_of_work.mat`. This corresponds to Algorithm 1 in the paper.

3. **`visualize_shapework_curves.m`**  
   This script visualizes the shape of work curves generated in the previous step. It creates a 3D surface plot, where the activity distribution over time is represented, and colors are mapped to self-reported activity levels for each curve.

## Usage Instructions

To run the full workflow:

1. Run **`generate_synthetic_activity.m`** to generate the synthetic dataset or replace this step with your own data in a compatible format (`data` as an N x 24 matrix, `self_reports` as an N x 1 vector).
2. Run **`generate_shapework_curves.m`** to generate the shape of work curves.
3. Finally, run **`visualize_shapework_curves.m`** to visualize the results.

Each script must be run in sequence for the visualization to work correctly.

## Requirements

This code was run and tested using **MATLAB R2022b**.

---

**Author:** Javier Hernandez  
**Contact:** javierh@microsoft.com
