%% Improving Cerebellar TMS Targeting: MRI-Neuronavigation and Landmark-Based Approaches Assessed by E-Field Modeling 

% Vridhi Rohiraa*, Xavier Corominas-Teruel*, Salim Ouarab, Traian Popa, Cécile Gallea#, Antoni Valero-Cabré# & Martina Bracco#

% *Equal Contriution
% #SeniorAuthorship


% Tasks in the script:
% 1. Group average E-field flatmaps projection

% Before running the scripts, the following software needs to be installed:
    % Simnibs4.0 or superior (https://simnibs.github.io/simnibs/build/html/index.html)
    % SUIT toolbox (https://www.diedrichsenlab.org/imaging/suit.htm)

%% ----- DCC cer1 -----------%%
% Add paths to necessary toolboxes and initialize SPM
addpath(''); %private path to data and tools

spm('Defaults', 'fMRI');
spm_jobman('initcfg');
addpath('') %private path to data and tools

% Initialize SPM and add required toolboxes
spm('Defaults', 'fMRI');
spm_jobman('initcfg');
addpath(''); %private path to data and tools

% Subject details: ID, Date, and Sequence
subjects = {
    'cRETMS_01_001', '2022_04_25', 'S04';
    'cRETMS_01_002', '2022_04_29', 'S05';
    'cRETMS_01_003', '2022_05_03', 'S05';
    'cRETMS_01_004', '2022_05_05', 'S05';
    'cRETMS_01_005', '2022_04_14', 'S04';
    'cRETMS_01_006', '2022_05_06', 'S05';
    'cRETMS_01_007', '2022_05_09', 'S05';
    'cRETMS_01_010', '2022_05_18', 'S05';
    'cRETMS_01_011', '2022_05_24', 'S05';
    'cRETMS_01_013', '2022_06_07', 'S05';
    'cRETMS_01_014', '2022_06_14', 'S05';
    'cRETMS_01_015', '2022_07_04', 'S04';
    'cRETMS_01_016', '2022_07_20', 'S05';
    'cRETMS_01_017', '2022_08_30', 'S05';
    'cRETMS_01_018', '2022_08_31', 'S05';
    'cRETMS_01_020', '2022_09_01', 'S05';
    'cRETMS_01_021', '2022_09_06', 'S05';
    'cRETMS_01_022', '2022_09_08', 'S05';
    'cRETMS_01_023', '2022_09_09', 'S05';
    'cRETMS_01_024', '2023_04_13', 'S05';
};

% Corresponding peak values (in the same order)
load('max_magnE_cer1_DCC_gm_999.mat')
peak_values = max_values;

% Number of subjects
num_subjects = size(subjects, 1);

% Base directory where subject folders are stored
base_dir = ''; %private path to data and tools

% Initialize path lists
file_paths = cell(num_subjects, 1);
normalized_paths = cell(num_subjects, 1);
matlabbatch = [];

% Normalize each image
for i = 1:num_subjects
    subject_id = subjects{i, 1};
    date_folder = subjects{i, 2};
    sequence_folder = subjects{i, 3};
    peak = peak_values(i);

    % Construct path to original image
    subject_folder = fullfile(base_dir, sprintf('%s_%s', date_folder, subject_id), ...
                              [sequence_folder '_T1w_mp2rage_UNI_Images'], ...
                              'Simnibs_simulation', 'simulation_cer1_DCC', ...
                              'suit','T1.nii');

    input_file = fullfile(subject_folder, ...
                  ['wd', subject_id, '_TMS_1-0001_Magstim_DCC_scalar_magnE.nii']);

    % Output file for normalized image
    [input_dir, input_name, ~] = fileparts(input_file);
    norm_file = fullfile(input_dir, [input_name '_norm_gm_999.nii']);
    normalized_paths{i} = norm_file;

    % Create normalization batch for this subject
    matlabbatch{i}.spm.util.imcalc.input = {input_file};
    matlabbatch{i}.spm.util.imcalc.output = norm_file;
    matlabbatch{i}.spm.util.imcalc.outdir = {''};
    matlabbatch{i}.spm.util.imcalc.expression = sprintf('i1 / %f', peak);
    matlabbatch{i}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{i}.spm.util.imcalc.options.mask = 0;
    matlabbatch{i}.spm.util.imcalc.options.interp = 1;
    matlabbatch{i}.spm.util.imcalc.options.dtype = 16;
end

% Run normalization jobs
spm_jobman('run', matlabbatch);

% --------- Averaging normalized images ---------

% Output file for the group mean
output_file = fullfile(base_dir, 'cerebellar flat maps', 'mean_output_suit_cer1_DCC_norm_gm_999.nii');

% Create dynamic expression for averaging
expr = '(';
for i = 1:num_subjects
    if i < num_subjects
        expr = [expr sprintf('i%d + ', i)];
    else
        expr = [expr sprintf('i%d', i)];
    end
end
expr = [expr sprintf(') / %d', num_subjects)];

% Create averaging batch
mean_batch{1}.spm.util.imcalc.input = normalized_paths;
mean_batch{1}.spm.util.imcalc.output = output_file;
mean_batch{1}.spm.util.imcalc.outdir = {''};
mean_batch{1}.spm.util.imcalc.expression = expr;
mean_batch{1}.spm.util.imcalc.options.dmtx = 0;
mean_batch{1}.spm.util.imcalc.options.mask = 0;
mean_batch{1}.spm.util.imcalc.options.interp = 1;
mean_batch{1}.spm.util.imcalc.options.dtype = 16;

% Run averaging job
spm_jobman('run', mean_batch);


% Define the file path
file_path = fullfile(base_dir, 'cerebellar flat maps', 'mean_output_suit_cer1_DCC_norm_gm_999.nii');

% Print the path
disp(['Attempting to open file at: ', file_path]);

% Call suit_map2surf
Data = suit_map2surf(file_path, 'space','SUIT','stats', @minORmax, 'depths', [0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8 2 2.2 2.4 2.6 2.8 3 3.2 3.4 3.78]);


% % Plot the flatmap
% figure;
% suit_plotflatmap(Data, 'threshold', 50, 'cscale', [0 120]);
% 
% % Add a color bar
% c = colorbar('Ticks', [0.02, 0.16, 0.32, 0.48, 0.64, 0.8, 0.999], ...
%              'TickLabels', {'0', '20', '40', '60', '80', '100', '120'}, 'FontSize', 15);
% c.Label.String = 'V/m';
% c.Label.FontSize = 15;
% 
% % Add a title
% title('E-strength mean affected area (>50V/m)', 'FontSize', 20);
% 
% % Hide axes
% axis off;

% % Calculate the 95th percentile
% percentile_99 = prctile(Data, 90);
% 
% % Set all values below the 99th percentile to 0
% Data(Data < percentile_99) = NaN;
% 
% % Plot the flatmap
% figure;
% suit_plotflatmap(Data, 'threshold', 0,'cscale', [0 120]);
% 
% % Add a color bar
% c = colorbar('Ticks', [0.02, 0.16, 0.32, 0.48, 0.64, 0.8, 0.999], ...
%              'TickLabels', {'0', '20', '40', '60', '80', '100', '120'}, 'FontSize', 15);
% c.Label.String = 'V/m';
% c.Label.FontSize = 15;

% % Add a title
% title('E-strength mean affected area (>99th percentile)', 'FontSize', 20);
% 
% % Hide axes
% axis off;

% Plot the flatmap
figure;
suit_plotflatmap(Data, 'threshold', 0.5, 'cscale', [0 1]);

% Get the current colormap and modify it
n_colors = 256; % Total number of colors in the colormap

% Define grey for the 0-50 range
grey_color = [0.7, 0.7, 0.7];  % Light grey

% Get the current colormap (this retains the original color scale)
current_colormap = colormap;

% Determine how many colors correspond to the 0-50 range
n_grey = round(n_colors * 0.5 / 1);  % Number of colors to assign to grey

% Replace the first part of the colormap (corresponding to 0-50) with grey
current_colormap(1:n_grey, :) = repmat(grey_color, n_grey, 1);

% Apply the modified colormap (grey for 0-50, original colors for 50-120)
colormap(current_colormap);

% Add the colorbar with numbers from 0 to 120
c = colorbar('Ticks', [0, 0.5, 1], ...
             'TickLabels', {'0', '0.5', '1'}, 'FontSize', 15);
c.Label.String = 'V/m';
c.Label.FontSize = 15;

% Ensure the color axis covers the correct range (0-120)
caxis([0 1]);

% Add a title
title('cer1_DCC', 'FontSize', 20);

% Hide axes
axis off;


exportgraphics(gcf, 'C:\Users\vridhi.rohira\Desktop\Flatmap\cer1_DCC_output.jpg', 'Resolution', 600);


%% ----- DCC cer_1_3 -----------%%

spm('Defaults', 'fMRI');
spm_jobman('initcfg');
addpath('');%private path to data and tools

% Initialize SPM and add required toolboxes
spm('Defaults', 'fMRI');
spm_jobman('initcfg');
addpath('');%private path to data and tools

% Subject details: ID, Date, and Sequence
subjects = {
    'cRETMS_01_001', '2022_04_25', 'S04';
    'cRETMS_01_002', '2022_04_29', 'S05';
    'cRETMS_01_003', '2022_05_03', 'S05';
    'cRETMS_01_004', '2022_05_05', 'S05';
    'cRETMS_01_005', '2022_04_14', 'S04';
    'cRETMS_01_006', '2022_05_06', 'S05';
    'cRETMS_01_007', '2022_05_09', 'S05';
    'cRETMS_01_010', '2022_05_18', 'S05';
    'cRETMS_01_011', '2022_05_24', 'S05';
    'cRETMS_01_013', '2022_06_07', 'S05';
    'cRETMS_01_014', '2022_06_14', 'S05';
    'cRETMS_01_015', '2022_07_04', 'S04';
    'cRETMS_01_016', '2022_07_20', 'S05';
    'cRETMS_01_017', '2022_08_30', 'S05';
    'cRETMS_01_018', '2022_08_31', 'S05';
    'cRETMS_01_020', '2022_09_01', 'S05';
    'cRETMS_01_021', '2022_09_06', 'S05';
    'cRETMS_01_022', '2022_09_08', 'S05';
    'cRETMS_01_023', '2022_09_09', 'S05';
    'cRETMS_01_024', '2023_04_13', 'S05';
};

% Corresponding peak values (in the same order)
load('max_magnE_cer_1_3cm_DCC_gm_999.mat')
peak_values = max_values;

% Number of subjects
num_subjects = size(subjects, 1);

% Base directory where subject folders are stored
base_dir = ''; %private path to data and tools

% Initialize path lists
file_paths = cell(num_subjects, 1);
normalized_paths = cell(num_subjects, 1);
matlabbatch = [];

% Normalize each image
for i = 1:num_subjects
    subject_id = subjects{i, 1};
    date_folder = subjects{i, 2};
    sequence_folder = subjects{i, 3};
    peak = peak_values(i);

    % Construct path to original image
    subject_folder = fullfile(base_dir, sprintf('%s_%s', date_folder, subject_id), ...
                              [sequence_folder '_T1w_mp2rage_UNI_Images'], ...
                              'Simnibs_simulation', 'simulation_cer_1_3cm_DCC', ...
                              'suit','T1.nii');

    input_file = fullfile(subject_folder, ...
                  ['wd', subject_id, '_TMS_1-0001_Magstim_DCC_scalar_magnE.nii']);

    % Output file for normalized image
    [input_dir, input_name, ~] = fileparts(input_file);
    norm_file = fullfile(input_dir, [input_name '_norm_gm_999.nii']);
    normalized_paths{i} = norm_file;

    % Create normalization batch for this subject
    matlabbatch{i}.spm.util.imcalc.input = {input_file};
    matlabbatch{i}.spm.util.imcalc.output = norm_file;
    matlabbatch{i}.spm.util.imcalc.outdir = {''};
    matlabbatch{i}.spm.util.imcalc.expression = sprintf('i1 / %f', peak);
    matlabbatch{i}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{i}.spm.util.imcalc.options.mask = 0;
    matlabbatch{i}.spm.util.imcalc.options.interp = 1;
    matlabbatch{i}.spm.util.imcalc.options.dtype = 16;
end

% Run normalization jobs
spm_jobman('run', matlabbatch);

% --------- Averaging normalized images ---------

% Output file for the group mean
output_file = fullfile(base_dir, 'cerebellar flat maps', 'mean_output_suit_cer_1_3cm_DCC_norm_gm_999.nii');

% Create dynamic expression for averaging
expr = '(';
for i = 1:num_subjects
    if i < num_subjects
        expr = [expr sprintf('i%d + ', i)];
    else
        expr = [expr sprintf('i%d', i)];
    end
end
expr = [expr sprintf(') / %d', num_subjects)];

% Create averaging batch
mean_batch{1}.spm.util.imcalc.input = normalized_paths;
mean_batch{1}.spm.util.imcalc.output = output_file;
mean_batch{1}.spm.util.imcalc.outdir = {''};
mean_batch{1}.spm.util.imcalc.expression = expr;
mean_batch{1}.spm.util.imcalc.options.dmtx = 0;
mean_batch{1}.spm.util.imcalc.options.mask = 0;
mean_batch{1}.spm.util.imcalc.options.interp = 1;
mean_batch{1}.spm.util.imcalc.options.dtype = 16;

% Run averaging job
spm_jobman('run', mean_batch);


% Define the file path
file_path = fullfile(base_dir, 'cerebellar flat maps', 'mean_output_suit_cer_1_3cm_DCC_norm_gm_999.nii');

% Print the path
disp(['Attempting to open file at: ', file_path]);

% Call suit_map2surf
Data = suit_map2surf(file_path, 'space','SUIT','stats', @minORmax, 'depths', [0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8 2 2.2 2.4 2.6 2.8 3 3.2 3.4 3.78]);


% % Plot the flatmap
% figure;
% suit_plotflatmap(Data, 'threshold', 50, 'cscale', [0 120]);
% 
% % Add a color bar
% c = colorbar('Ticks', [0.02, 0.16, 0.32, 0.48, 0.64, 0.8, 0.999], ...
%              'TickLabels', {'0', '20', '40', '60', '80', '100', '120'}, 'FontSize', 15);
% c.Label.String = 'V/m';
% c.Label.FontSize = 15;
% 
% % Add a title
% title('E-strength mean affected area (>50V/m)', 'FontSize', 20);
% 
% % Hide axes
% axis off;

% % Calculate the 95th percentile
% percentile_99 = prctile(Data, 90);
% 
% % Set all values below the 99th percentile to 0
% Data(Data < percentile_99) = NaN;
% 
% % Plot the flatmap
% figure;
% suit_plotflatmap(Data, 'threshold', 0,'cscale', [0 120]);
% 
% % Add a color bar
% c = colorbar('Ticks', [0.02, 0.16, 0.32, 0.48, 0.64, 0.8, 0.999], ...
%              'TickLabels', {'0', '20', '40', '60', '80', '100', '120'}, 'FontSize', 15);
% c.Label.String = 'V/m';
% c.Label.FontSize = 15;

% % Add a title
% title('E-strength mean affected area (>99th percentile)', 'FontSize', 20);
% 
% % Hide axes
% axis off;

% Plot the flatmap
figure;
suit_plotflatmap(Data, 'threshold', 0.5, 'cscale', [0 1]);

% Get the current colormap and modify it
n_colors = 256; % Total number of colors in the colormap

% Define grey for the 0-50 range
grey_color = [0.7, 0.7, 0.7];  % Light grey

% Get the current colormap (this retains the original color scale)
current_colormap = colormap;

% Determine how many colors correspond to the 0-50 range
n_grey = round(n_colors * 0.5 / 1);  % Number of colors to assign to grey

% Replace the first part of the colormap (corresponding to 0-50) with grey
current_colormap(1:n_grey, :) = repmat(grey_color, n_grey, 1);

% Apply the modified colormap (grey for 0-50, original colors for 50-120)
colormap(current_colormap);

% Add the colorbar with numbers from 0 to 120
c = colorbar('Ticks', [0, 0.5, 1], ...
             'TickLabels', {'0', '0.5', '1'}, 'FontSize', 15);
c.Label.String = 'V/m';
c.Label.FontSize = 15;

% Ensure the color axis covers the correct range (0-120)
caxis([0 1]);

% Add a title
title('cer13_DCC', 'FontSize', 20);

% Hide axes
axis off


exportgraphics(gcf, 'cer_1_3cm_DCC_output.jpg', 'Resolution', 600);

%% ----- DCC cer mastoid -----------%%
spm('Defaults', 'fMRI');
spm_jobman('initcfg');


% Subject details: ID, Date, and Sequence
subjects = {
    'cRETMS_01_001', '2022_04_25', 'S04';
    'cRETMS_01_002', '2022_04_29', 'S05';
    'cRETMS_01_003', '2022_05_03', 'S05';
    'cRETMS_01_004', '2022_05_05', 'S05';
    'cRETMS_01_005', '2022_04_14', 'S04';
    'cRETMS_01_006', '2022_05_06', 'S05';
    'cRETMS_01_007', '2022_05_09', 'S05';
    'cRETMS_01_010', '2022_05_18', 'S05';
    'cRETMS_01_011', '2022_05_24', 'S05';
    'cRETMS_01_013', '2022_06_07', 'S05';
    'cRETMS_01_014', '2022_06_14', 'S05';
    'cRETMS_01_015', '2022_07_04', 'S04';
    'cRETMS_01_016', '2022_07_20', 'S05';
    'cRETMS_01_017', '2022_08_30', 'S05';
    'cRETMS_01_018', '2022_08_31', 'S05';
    'cRETMS_01_020', '2022_09_01', 'S05';
    'cRETMS_01_021', '2022_09_06', 'S05';
    'cRETMS_01_022', '2022_09_08', 'S05';
    'cRETMS_01_023', '2022_09_09', 'S05';
    'cRETMS_01_024', '2023_04_13', 'S05';
};

% Corresponding peak values (in the same order)
load('max_magnE_cer_mastoid_half_DCC_gm_999.mat')
peak_values = max_values;

% Number of subjects
num_subjects = size(subjects, 1);


% Initialize path lists
file_paths = cell(num_subjects, 1);
normalized_paths = cell(num_subjects, 1);
matlabbatch = [];

% Normalize each image
for i = 1:num_subjects
    subject_id = subjects{i, 1};
    date_folder = subjects{i, 2};
    sequence_folder = subjects{i, 3};
    peak = peak_values(i);

    % Construct path to original image
    subject_folder = fullfile(base_dir, sprintf('%s_%s', date_folder, subject_id), ...
                              [sequence_folder '_T1w_mp2rage_UNI_Images'], ...
                              'Simnibs_simulation', 'simulation_cer_mastoid_DCC', ...
                              'suit','T1.nii');

    input_file = fullfile(subject_folder, ...
                  ['wd', subject_id, '_TMS_1-0001_Magstim_DCC_scalar_magnE.nii']);

    % Output file for normalized image
    [input_dir, input_name, ~] = fileparts(input_file);
    norm_file = fullfile(input_dir, [input_name '_norm_gm_999.nii']);
    normalized_paths{i} = norm_file;

    % Create normalization batch for this subject
    matlabbatch{i}.spm.util.imcalc.input = {input_file};
    matlabbatch{i}.spm.util.imcalc.output = norm_file;
    matlabbatch{i}.spm.util.imcalc.outdir = {''};
    matlabbatch{i}.spm.util.imcalc.expression = sprintf('i1 / %f', peak);
    matlabbatch{i}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{i}.spm.util.imcalc.options.mask = 0;
    matlabbatch{i}.spm.util.imcalc.options.interp = 1;
    matlabbatch{i}.spm.util.imcalc.options.dtype = 16;
end

% Run normalization jobs
spm_jobman('run', matlabbatch);

% --------- Averaging normalized images ---------

% Output file for the group mean
output_file = fullfile(base_dir, 'cerebellar flat maps', 'mean_output_suit_cer_mastoid_DCC_norm_gm_999.nii');

% Create dynamic expression for averaging
expr = '(';
for i = 1:num_subjects
    if i < num_subjects
        expr = [expr sprintf('i%d + ', i)];
    else
        expr = [expr sprintf('i%d', i)];
    end
end
expr = [expr sprintf(') / %d', num_subjects)];

% Create averaging batch
mean_batch{1}.spm.util.imcalc.input = normalized_paths;
mean_batch{1}.spm.util.imcalc.output = output_file;
mean_batch{1}.spm.util.imcalc.outdir = {''};
mean_batch{1}.spm.util.imcalc.expression = expr;
mean_batch{1}.spm.util.imcalc.options.dmtx = 0;
mean_batch{1}.spm.util.imcalc.options.mask = 0;
mean_batch{1}.spm.util.imcalc.options.interp = 1;
mean_batch{1}.spm.util.imcalc.options.dtype = 16;

% Run averaging job
spm_jobman('run', mean_batch);


% Define the file path
file_path = fullfile(base_dir, 'cerebellar flat maps', 'mean_output_suit_cer_mastoid_DCC_norm_gm_999.nii');

% Print the path
disp(['Attempting to open file at: ', file_path]);

% Call suit_map2surf
Data = suit_map2surf(file_path, 'space','SUIT','stats', @minORmax, 'depths', [0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8 2 2.2 2.4 2.6 2.8 3 3.2 3.4 3.78]);


% % Plot the flatmap
% figure;
% suit_plotflatmap(Data, 'threshold', 50, 'cscale', [0 120]);
% 
% % Add a color bar
% c = colorbar('Ticks', [0.02, 0.16, 0.32, 0.48, 0.64, 0.8, 0.999], ...
%              'TickLabels', {'0', '20', '40', '60', '80', '100', '120'}, 'FontSize', 15);
% c.Label.String = 'V/m';
% c.Label.FontSize = 15;
% 
% % Add a title
% title('E-strength mean affected area (>50V/m)', 'FontSize', 20);
% 
% % Hide axes
% axis off;

% % Calculate the 95th percentile
% percentile_99 = prctile(Data, 90);
% 
% % Set all values below the 99th percentile to 0
% Data(Data < percentile_99) = NaN;
% 
% % Plot the flatmap
% figure;
% suit_plotflatmap(Data, 'threshold', 0,'cscale', [0 120]);
% 
% % Add a color bar
% c = colorbar('Ticks', [0.02, 0.16, 0.32, 0.48, 0.64, 0.8, 0.999], ...
%              'TickLabels', {'0', '20', '40', '60', '80', '100', '120'}, 'FontSize', 15);
% c.Label.String = 'V/m';
% c.Label.FontSize = 15;

% % Add a title
% title('E-strength mean affected area (>99th percentile)', 'FontSize', 20);
% 
% % Hide axes
% axis off;


% Plot the flatmap
figure;
suit_plotflatmap(Data, 'threshold', 0.5, 'cscale', [0 1]);

% Get the current colormap and modify it
n_colors = 256; % Total number of colors in the colormap

% Define grey for the 0-50 range
grey_color = [0.7, 0.7, 0.7];  % Light grey

% Get the current colormap (this retains the original color scale)
current_colormap = colormap;

% Determine how many colors correspond to the 0-50 range
n_grey = round(n_colors * 0.5 / 1);  % Number of colors to assign to grey

% Replace the first part of the colormap (corresponding to 0-50) with grey
current_colormap(1:n_grey, :) = repmat(grey_color, n_grey, 1);

% Apply the modified colormap (grey for 0-50, original colors for 50-120)
colormap(current_colormap);

% Add the colorbar with numbers from 0 to 120
c = colorbar('Ticks', [0, 0.5, 1], ...
             'TickLabels', {'0', '0.5', '1'}, 'FontSize', 15);
c.Label.String = 'V/m';
c.Label.FontSize = 15;

% Ensure the color axis covers the correct range (0-120)
caxis([0 1]);


% Add a title
title('cer_mast_DCC', 'FontSize', 20);

% Hide axes
axis off


exportgraphics(gcf, 'cer_mastoid_half_DCC_output.jpg', 'Resolution', 600);

%% ----- F8 cer1 -----------%%
% Add paths to necessary toolboxes and initialize SPM

spm('Defaults', 'fMRI');
spm_jobman('initcfg');

% Initialize SPM and add required toolboxes
spm('Defaults', 'fMRI');
spm_jobman('initcfg');

% Subject details: ID, Date, and Sequence
subjects = {
    'cRETMS_01_001', '2022_04_25', 'S04';
    'cRETMS_01_002', '2022_04_29', 'S05';
    'cRETMS_01_003', '2022_05_03', 'S05';
    'cRETMS_01_004', '2022_05_05', 'S05';
    'cRETMS_01_005', '2022_04_14', 'S04';
    'cRETMS_01_006', '2022_05_06', 'S05';
    'cRETMS_01_007', '2022_05_09', 'S05';
    'cRETMS_01_010', '2022_05_18', 'S05';
    'cRETMS_01_011', '2022_05_24', 'S05';
    'cRETMS_01_013', '2022_06_07', 'S05';
    'cRETMS_01_014', '2022_06_14', 'S05';
    'cRETMS_01_015', '2022_07_04', 'S04';
    'cRETMS_01_016', '2022_07_20', 'S05';
    'cRETMS_01_017', '2022_08_30', 'S05';
    'cRETMS_01_018', '2022_08_31', 'S05';
    'cRETMS_01_020', '2022_09_01', 'S05';
    'cRETMS_01_021', '2022_09_06', 'S05';
    'cRETMS_01_022', '2022_09_08', 'S05';
    'cRETMS_01_023', '2022_09_09', 'S05';
    'cRETMS_01_024', '2023_04_13', 'S05';
};

% Corresponding peak values (in the same order)
load('max_magnE_cer1_fig8_gm_999.mat')
peak_values = max_values;

% Number of subjects
num_subjects = size(subjects, 1);

% Base directory where subject folders are stored
base_dir = '\\iss\cenir\analyse\irm\users\martina.bracco\cRETMS_MRIs\';

% Initialize path lists
file_paths = cell(num_subjects, 1);
normalized_paths = cell(num_subjects, 1);
matlabbatch = [];

% Normalize each image
for i = 1:num_subjects
    subject_id = subjects{i, 1};
    date_folder = subjects{i, 2};
    sequence_folder = subjects{i, 3};
    peak = peak_values(i);

    % Construct path to original image
    subject_folder = fullfile(base_dir, sprintf('%s_%s', date_folder, subject_id), ...
                              [sequence_folder '_T1w_mp2rage_UNI_Images'], ...
                              'Simnibs_simulation', 'simulation_cer1_figure8', ...
                              'suit','T1.nii');

    input_file = fullfile(subject_folder, ...
                  ['wd', subject_id, '_TMS_1-0001_Magstim_70mm_fig8_scalar_magnE.nii']);

    % Output file for normalized image
    [input_dir, input_name, ~] = fileparts(input_file);
    norm_file = fullfile(input_dir, [input_name '_norm_gm_999.nii']);
    normalized_paths{i} = norm_file;

    % Create normalization batch for this subject
    matlabbatch{i}.spm.util.imcalc.input = {input_file};
    matlabbatch{i}.spm.util.imcalc.output = norm_file;
    matlabbatch{i}.spm.util.imcalc.outdir = {''};
    matlabbatch{i}.spm.util.imcalc.expression = sprintf('i1 / %f', peak);
    matlabbatch{i}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{i}.spm.util.imcalc.options.mask = 0;
    matlabbatch{i}.spm.util.imcalc.options.interp = 1;
    matlabbatch{i}.spm.util.imcalc.options.dtype = 16;
end

% Run normalization jobs
spm_jobman('run', matlabbatch);

% --------- Averaging normalized images ---------

% Output file for the group mean
output_file = fullfile(base_dir, 'cerebellar flat maps', 'mean_output_suit_cer1_fig8_norm_gm_999.nii');

% Create dynamic expression for averaging
expr = '(';
for i = 1:num_subjects
    if i < num_subjects
        expr = [expr sprintf('i%d + ', i)];
    else
        expr = [expr sprintf('i%d', i)];
    end
end
expr = [expr sprintf(') / %d', num_subjects)];

% Create averaging batch
mean_batch{1}.spm.util.imcalc.input = normalized_paths;
mean_batch{1}.spm.util.imcalc.output = output_file;
mean_batch{1}.spm.util.imcalc.outdir = {''};
mean_batch{1}.spm.util.imcalc.expression = expr;
mean_batch{1}.spm.util.imcalc.options.dmtx = 0;
mean_batch{1}.spm.util.imcalc.options.mask = 0;
mean_batch{1}.spm.util.imcalc.options.interp = 1;
mean_batch{1}.spm.util.imcalc.options.dtype = 16;

% Run averaging job
spm_jobman('run', mean_batch);


% Define the file path
file_path = fullfile(base_dir, 'cerebellar flat maps', 'mean_output_suit_cer1_fig8_norm_gm_999.nii');

% Print the path
disp(['Attempting to open file at: ', file_path]);

% Call suit_map2surf
Data = suit_map2surf(file_path, 'space','SUIT','stats', @minORmax, 'depths', [0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8 2 2.2 2.4 2.6 2.8 3 3.2 3.4 3.78]);


% % Plot the flatmap
% figure;
% suit_plotflatmap(Data, 'threshold', 50, 'cscale', [0 120]);
% 
% % Add a color bar
% c = colorbar('Ticks', [0.02, 0.16, 0.32, 0.48, 0.64, 0.8, 0.999], ...
%              'TickLabels', {'0', '20', '40', '60', '80', '100', '120'}, 'FontSize', 15);
% c.Label.String = 'V/m';
% c.Label.FontSize = 15;
% 
% % Add a title
% title('E-strength mean affected area (>50V/m)', 'FontSize', 20);
% 
% % Hide axes
% axis off;

% % Calculate the 95th percentile
% percentile_99 = prctile(Data, 90);
% 
% % Set all values below the 99th percentile to 0
% Data(Data < percentile_99) = NaN;
% 
% % Plot the flatmap
% figure;
% suit_plotflatmap(Data, 'threshold', 0,'cscale', [0 120]);
% 
% % Add a color bar
% c = colorbar('Ticks', [0.02, 0.16, 0.32, 0.48, 0.64, 0.8, 0.999], ...
%              'TickLabels', {'0', '20', '40', '60', '80', '100', '120'}, 'FontSize', 15);
% c.Label.String = 'V/m';
% c.Label.FontSize = 15;

% % Add a title
% title('E-strength mean affected area (>99th percentile)', 'FontSize', 20);
% 
% % Hide axes
% axis off;


% Plot the flatmap
figure;
suit_plotflatmap(Data, 'threshold', 0.5, 'cscale', [0 1]);

% Get the current colormap and modify it
n_colors = 256; % Total number of colors in the colormap

% Define grey for the 0-50 range
grey_color = [0.7, 0.7, 0.7];  % Light grey

% Get the current colormap (this retains the original color scale)
current_colormap = colormap;

% Determine how many colors correspond to the 0-50 range
n_grey = round(n_colors * 0.5 / 1);  % Number of colors to assign to grey

% Replace the first part of the colormap (corresponding to 0-50) with grey
current_colormap(1:n_grey, :) = repmat(grey_color, n_grey, 1);

% Apply the modified colormap (grey for 0-50, original colors for 50-120)
colormap(current_colormap);

% Add the colorbar with numbers from 0 to 120
c = colorbar('Ticks', [0, 0.5, 1], ...
             'TickLabels', {'0', '0.5', '1'}, 'FontSize', 15);
c.Label.String = 'V/m';
c.Label.FontSize = 15;

% Ensure the color axis covers the correct range (0-120)
caxis([0 1]);

% Add a title
title('cer1_f8', 'FontSize', 20);

% Hide axes
axis off


exportgraphics(gcf, 'cer1_fig8_output.jpg', 'Resolution', 600);


%% ----- F8 cer_1_3 -----------%%

spm('Defaults', 'fMRI');
spm_jobman('initcfg');


% Initialize SPM and add required toolboxes
spm('Defaults', 'fMRI');
spm_jobman('initcfg');

% Subject details: ID, Date, and Sequence
subjects = {
    'cRETMS_01_001', '2022_04_25', 'S04';
    'cRETMS_01_002', '2022_04_29', 'S05';
    'cRETMS_01_003', '2022_05_03', 'S05';
    'cRETMS_01_004', '2022_05_05', 'S05';
    'cRETMS_01_005', '2022_04_14', 'S04';
    'cRETMS_01_006', '2022_05_06', 'S05';
    'cRETMS_01_007', '2022_05_09', 'S05';
    'cRETMS_01_010', '2022_05_18', 'S05';
    'cRETMS_01_011', '2022_05_24', 'S05';
    'cRETMS_01_013', '2022_06_07', 'S05';
    'cRETMS_01_014', '2022_06_14', 'S05';
    'cRETMS_01_015', '2022_07_04', 'S04';
    'cRETMS_01_016', '2022_07_20', 'S05';
    'cRETMS_01_017', '2022_08_30', 'S05';
    'cRETMS_01_018', '2022_08_31', 'S05';
    'cRETMS_01_020', '2022_09_01', 'S05';
    'cRETMS_01_021', '2022_09_06', 'S05';
    'cRETMS_01_022', '2022_09_08', 'S05';
    'cRETMS_01_023', '2022_09_09', 'S05';
    'cRETMS_01_024', '2023_04_13', 'S05';
};

% Corresponding peak values (in the same order)
load('max_magnE_cer_1_3cm_fig8_gm_999.mat')
peak_values = max_values;

% Number of subjects
num_subjects = size(subjects, 1);

% Base directory where subject folders are stored
base_dir = '\\iss\cenir\analyse\irm\users\martina.bracco\cRETMS_MRIs\';

% Initialize path lists
file_paths = cell(num_subjects, 1);
normalized_paths = cell(num_subjects, 1);
matlabbatch = [];

% Normalize each image
for i = 1:num_subjects
    subject_id = subjects{i, 1};
    date_folder = subjects{i, 2};
    sequence_folder = subjects{i, 3};
    peak = peak_values(i);

    % Construct path to original image
    subject_folder = fullfile(base_dir, sprintf('%s_%s', date_folder, subject_id), ...
                              [sequence_folder '_T1w_mp2rage_UNI_Images'], ...
                              'Simnibs_simulation', 'simulation_cer_1_3cm_figure8', ...
                              'suit','T1.nii');

    input_file = fullfile(subject_folder, ...
                  ['wd', subject_id, '_TMS_1-0001_Magstim_70mm_fig8_scalar_magnE.nii']);

    % Output file for normalized image
    [input_dir, input_name, ~] = fileparts(input_file);
    norm_file = fullfile(input_dir, [input_name '_norm_gm_999.nii']);
    normalized_paths{i} = norm_file;

    % Create normalization batch for this subject
    matlabbatch{i}.spm.util.imcalc.input = {input_file};
    matlabbatch{i}.spm.util.imcalc.output = norm_file;
    matlabbatch{i}.spm.util.imcalc.outdir = {''};
    matlabbatch{i}.spm.util.imcalc.expression = sprintf('i1 / %f', peak);
    matlabbatch{i}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{i}.spm.util.imcalc.options.mask = 0;
    matlabbatch{i}.spm.util.imcalc.options.interp = 1;
    matlabbatch{i}.spm.util.imcalc.options.dtype = 16;
end

% Run normalization jobs
spm_jobman('run', matlabbatch);

% --------- Averaging normalized images ---------

% Output file for the group mean
output_file = fullfile(base_dir, 'cerebellar flat maps', 'mean_output_suit_cer_1_3cm_fig8_norm_gm_999.nii');

% Create dynamic expression for averaging
expr = '(';
for i = 1:num_subjects
    if i < num_subjects
        expr = [expr sprintf('i%d + ', i)];
    else
        expr = [expr sprintf('i%d', i)];
    end
end
expr = [expr sprintf(') / %d', num_subjects)];

% Create averaging batch
mean_batch{1}.spm.util.imcalc.input = normalized_paths;
mean_batch{1}.spm.util.imcalc.output = output_file;
mean_batch{1}.spm.util.imcalc.outdir = {''};
mean_batch{1}.spm.util.imcalc.expression = expr;
mean_batch{1}.spm.util.imcalc.options.dmtx = 0;
mean_batch{1}.spm.util.imcalc.options.mask = 0;
mean_batch{1}.spm.util.imcalc.options.interp = 1;
mean_batch{1}.spm.util.imcalc.options.dtype = 16;

% Run averaging job
spm_jobman('run', mean_batch);


% Define the file path
file_path = fullfile(base_dir, 'cerebellar flat maps', 'mean_output_suit_cer_1_3cm_fig8_norm_gm_999.nii');

% Print the path
disp(['Attempting to open file at: ', file_path]);

% Call suit_map2surf
Data = suit_map2surf(file_path, 'space','SUIT','stats', @minORmax, 'depths', [0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8 2 2.2 2.4 2.6 2.8 3 3.2 3.4 3.78]);


% % Plot the flatmap
% figure;
% suit_plotflatmap(Data, 'threshold', 50, 'cscale', [0 120]);
% 
% % Add a color bar
% c = colorbar('Ticks', [0.02, 0.16, 0.32, 0.48, 0.64, 0.8, 0.999], ...
%              'TickLabels', {'0', '20', '40', '60', '80', '100', '120'}, 'FontSize', 15);
% c.Label.String = 'V/m';
% c.Label.FontSize = 15;
% 
% % Add a title
% title('E-strength mean affected area (>50V/m)', 'FontSize', 20);
% 
% % Hide axes
% axis off;

% % Calculate the 95th percentile
% percentile_99 = prctile(Data, 90);
% 
% % Set all values below the 99th percentile to 0
% Data(Data < percentile_99) = NaN;
% 
% % Plot the flatmap
% figure;
% suit_plotflatmap(Data, 'threshold', 0,'cscale', [0 120]);
% 
% % Add a color bar
% c = colorbar('Ticks', [0.02, 0.16, 0.32, 0.48, 0.64, 0.8, 0.999], ...
%              'TickLabels', {'0', '20', '40', '60', '80', '100', '120'}, 'FontSize', 15);
% c.Label.String = 'V/m';
% c.Label.FontSize = 15;

% % Add a title
% title('E-strength mean affected area (>99th percentile)', 'FontSize', 20);
% 
% % Hide axes
% axis off;


% Plot the flatmap
figure;
suit_plotflatmap(Data, 'threshold', 0.5, 'cscale', [0 1]);

% Get the current colormap and modify it
n_colors = 256; % Total number of colors in the colormap

% Define grey for the 0-50 range
grey_color = [0.7, 0.7, 0.7];  % Light grey

% Get the current colormap (this retains the original color scale)
current_colormap = colormap;

% Determine how many colors correspond to the 0-50 range
n_grey = round(n_colors * 0.5 / 1);  % Number of colors to assign to grey

% Replace the first part of the colormap (corresponding to 0-50) with grey
current_colormap(1:n_grey, :) = repmat(grey_color, n_grey, 1);

% Apply the modified colormap (grey for 0-50, original colors for 50-120)
colormap(current_colormap);

% Add the colorbar with numbers from 0 to 120
c = colorbar('Ticks', [0, 0.5, 1], ...
             'TickLabels', {'0', '0.5', '1'}, 'FontSize', 15);
c.Label.String = 'V/m';
c.Label.FontSize = 15;

% Ensure the color axis covers the correct range (0-120)
caxis([0 1]);

% Add a title
title('cer13_f8', 'FontSize', 20);

% Hide axes
axis off


exportgraphics(gcf, 'cer_1_3cm_fig8_output.jpg', 'Resolution', 600);


%% ----- F8 cer mastoid -----------%%

spm('Defaults', 'fMRI');
spm_jobman('initcfg');


% Initialize SPM and add required toolboxes
spm('Defaults', 'fMRI');
spm_jobman('initcfg');

% Subject details: ID, Date, and Sequence
subjects = {
    'cRETMS_01_001', '2022_04_25', 'S04';
    'cRETMS_01_002', '2022_04_29', 'S05';
    'cRETMS_01_003', '2022_05_03', 'S05';
    'cRETMS_01_004', '2022_05_05', 'S05';
    'cRETMS_01_005', '2022_04_14', 'S04';
    'cRETMS_01_006', '2022_05_06', 'S05';
    'cRETMS_01_007', '2022_05_09', 'S05';
    'cRETMS_01_010', '2022_05_18', 'S05';
    'cRETMS_01_011', '2022_05_24', 'S05';
    'cRETMS_01_013', '2022_06_07', 'S05';
    'cRETMS_01_014', '2022_06_14', 'S05';
    'cRETMS_01_015', '2022_07_04', 'S04';
    'cRETMS_01_016', '2022_07_20', 'S05';
    'cRETMS_01_017', '2022_08_30', 'S05';
    'cRETMS_01_018', '2022_08_31', 'S05';
    'cRETMS_01_020', '2022_09_01', 'S05';
    'cRETMS_01_021', '2022_09_06', 'S05';
    'cRETMS_01_022', '2022_09_08', 'S05';
    'cRETMS_01_023', '2022_09_09', 'S05';
    'cRETMS_01_024', '2023_04_13', 'S05';
};

% Corresponding peak values (in the same order)
load('max_magnE_cer_mastoid_half_fig8_gm_999.mat')
peak_values = max_values;

% Number of subjects
num_subjects = size(subjects, 1);

% Base directory where subject folders are stored
base_dir = '\\iss\cenir\analyse\irm\users\martina.bracco\cRETMS_MRIs\';

% Initialize path lists
file_paths = cell(num_subjects, 1);
normalized_paths = cell(num_subjects, 1);
matlabbatch = [];

% Normalize each image
for i = 1:num_subjects
    subject_id = subjects{i, 1};
    date_folder = subjects{i, 2};
    sequence_folder = subjects{i, 3};
    peak = peak_values(i);

    % Construct path to original image
    subject_folder = fullfile(base_dir, sprintf('%s_%s', date_folder, subject_id), ...
                              [sequence_folder '_T1w_mp2rage_UNI_Images'], ...
                              'Simnibs_simulation', 'simulation_cer_mastoid_figure8', ...
                              'suit','T1.nii');

    input_file = fullfile(subject_folder, ...
                  ['wd', subject_id, '_TMS_1-0001_Magstim_70mm_fig8_scalar_magnE.nii']);

    % Output file for normalized image
    [input_dir, input_name, ~] = fileparts(input_file);
    norm_file = fullfile(input_dir, [input_name '_norm_gm_999.nii']);
    normalized_paths{i} = norm_file;

    % Create normalization batch for this subject
    matlabbatch{i}.spm.util.imcalc.input = {input_file};
    matlabbatch{i}.spm.util.imcalc.output = norm_file;
    matlabbatch{i}.spm.util.imcalc.outdir = {''};
    matlabbatch{i}.spm.util.imcalc.expression = sprintf('i1 / %f', peak);
    matlabbatch{i}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{i}.spm.util.imcalc.options.mask = 0;
    matlabbatch{i}.spm.util.imcalc.options.interp = 1;
    matlabbatch{i}.spm.util.imcalc.options.dtype = 16;
end

% Run normalization jobs
spm_jobman('run', matlabbatch);

% --------- Averaging normalized images ---------

% Output file for the group mean
output_file = fullfile(base_dir, 'cerebellar flat maps', 'mean_output_suit_cer_mastoid_fig8_norm_gm_999.nii');

% Create dynamic expression for averaging
expr = '(';
for i = 1:num_subjects
    if i < num_subjects
        expr = [expr sprintf('i%d + ', i)];
    else
        expr = [expr sprintf('i%d', i)];
    end
end
expr = [expr sprintf(') / %d', num_subjects)];

% Create averaging batch
mean_batch{1}.spm.util.imcalc.input = normalized_paths;
mean_batch{1}.spm.util.imcalc.output = output_file;
mean_batch{1}.spm.util.imcalc.outdir = {''};
mean_batch{1}.spm.util.imcalc.expression = expr;
mean_batch{1}.spm.util.imcalc.options.dmtx = 0;
mean_batch{1}.spm.util.imcalc.options.mask = 0;
mean_batch{1}.spm.util.imcalc.options.interp = 1;
mean_batch{1}.spm.util.imcalc.options.dtype = 16;

% Run averaging job
spm_jobman('run', mean_batch);


% Define the file path
file_path = fullfile(base_dir, 'cerebellar flat maps', 'mean_output_suit_cer_mastoid_fig8_norm_gm_999.nii');

% Print the path
disp(['Attempting to open file at: ', file_path]);

% Call suit_map2surf
Data = suit_map2surf(file_path, 'space','SUIT','stats', @minORmax, 'depths', [0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8 2 2.2 2.4 2.6 2.8 3 3.2 3.4 3.78]);


% % Plot the flatmap
% figure;
% suit_plotflatmap(Data, 'threshold', 50, 'cscale', [0 120]);
% 
% % Add a color bar
% c = colorbar('Ticks', [0.02, 0.16, 0.32, 0.48, 0.64, 0.8, 0.999], ...
%              'TickLabels', {'0', '20', '40', '60', '80', '100', '120'}, 'FontSize', 15);
% c.Label.String = 'V/m';
% c.Label.FontSize = 15;
% 
% % Add a title
% title('E-strength mean affected area (>50V/m)', 'FontSize', 20);
% 
% % Hide axes
% axis off;

% % Calculate the 95th percentile
% percentile_99 = prctile(Data, 90);
% 
% % Set all values below the 99th percentile to 0
% Data(Data < percentile_99) = NaN;
% 
% % Plot the flatmap
% figure;
% suit_plotflatmap(Data, 'threshold', 0,'cscale', [0 120]);
% 
% % Add a color bar
% c = colorbar('Ticks', [0.02, 0.16, 0.32, 0.48, 0.64, 0.8, 0.999], ...
%              'TickLabels', {'0', '20', '40', '60', '80', '100', '120'}, 'FontSize', 15);
% c.Label.String = 'V/m';
% c.Label.FontSize = 15;

% % Add a title
% title('E-strength mean affected area (>99th percentile)', 'FontSize', 20);
% 
% % Hide axes
% axis off;

% Plot the flatmap
figure;
suit_plotflatmap(Data, 'threshold', 0.5, 'cscale', [0 1]);

% Get the current colormap and modify it
n_colors = 256; % Total number of colors in the colormap

% Define grey for the 0-50 range
grey_color = [0.7, 0.7, 0.7];  % Light grey

% Get the current colormap (this retains the original color scale)
current_colormap = colormap;

% Determine how many colors correspond to the 0-50 range
n_grey = round(n_colors * 0.5 / 1);  % Number of colors to assign to grey

% Replace the first part of the colormap (corresponding to 0-50) with grey
current_colormap(1:n_grey, :) = repmat(grey_color, n_grey, 1);

% Apply the modified colormap (grey for 0-50, original colors for 50-120)
colormap(current_colormap);

% Add the colorbar with numbers from 0 to 120
c = colorbar('Ticks', [0, 0.5, 1], ...
             'TickLabels', {'0', '0.5', '1'}, 'FontSize', 15);
c.Label.String = 'V/m';
c.Label.FontSize = 15;

% Ensure the color axis covers the correct range (0-120)
caxis([0 1]);


% Add a title
title('mast_f8', 'FontSize', 20);

% Hide axes
axis off


exportgraphics(gcf, 'cer_mastoid_half_fig8_output.jpg', 'Resolution', 600);

%% END 
