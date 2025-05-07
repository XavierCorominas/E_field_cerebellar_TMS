%% Improving Cerebellar TMS Targeting: MRI-Neuronavigation and Landmark-Based Approaches Assessed by E-Field Modeling 

% Vridhi Rohiraa*, Xavier Corominas-Teruel*, Salim Ouarab, Traian Popa, Cécile Gallea#, Antoni Valero-Cabré# & Martina Bracco#

% *Equal Contriution
% #SeniorAuthorship


% Tasks in the script:
% 1. Group average E-field flatmaps projection

% Before running the scripts, the following software needs to be installed:
    % Simnibs4.0 or superior (https://simnibs.github.io/simnibs/build/html/index.html)
    % SUIT toolbox (https://www.diedrichsenlab.org/imaging/suit.htm)


%% cer 1 TMS-Neuronavig fig8

% Add paths to necessary toolboxes and initialize SPM
% addpath('');


spm('Defaults', 'fMRI');
spm_jobman('initcfg');
addpath('\\iss\cenir\software\irm\spm12\toolbox\suit-3.7');
% addpath('\\iss\cenir\software\irm\spm12\toolbox\suit');

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

% Number of subjects
num_subjects = size(subjects, 1);

% Base directory where subject folders are stored
base_dir = '\\iss\cenir\analyse\irm\users\martina.bracco\cRETMS_MRIs\';

% Initialize list to store file paths
file_paths = cell(num_subjects, 1);

% Loop through each subject to construct the full file paths
for i = 1:num_subjects
    subject_id = subjects{i, 1};
    date_folder = subjects{i, 2};
    sequence_folder = subjects{i, 3};
    
    % Construct the full path to the subject's folder
    subject_folder = fullfile(base_dir, sprintf('%s_%s', date_folder, subject_id), ...
                              [sequence_folder '_T1w_mp2rage_UNI_Images'], ...
                              'Simnibs_simulation', 'simulation_cer1_figure8', ...
                              'suit','T1.nii');
    
    % Construct the input file name (NIfTI file)
    input_file = fullfile(subject_folder, ['wd', subject_id, '_TMS_1-0001_Magstim_70mm_Fig8_scalar_magnE.nii']);
    
    % Store the file path in the list
    file_paths{i} = input_file;
end

% Define the output file name
output_file = fullfile(base_dir, 'cerebellar flat maps', 'mean_output_suit_cer1_Fig8.nii');

% Generate the expression for mean calculation dynamically
expr = '(';
for i = 1:num_subjects
    if i == num_subjects
        expr = [expr sprintf('i%d', i)];  % Add the last image without a '+'
    else
        expr = [expr sprintf('i%d + ', i)];
    end
end
expr = [expr sprintf(') / %d', num_subjects)];

% Initialize the batch for image calculation in SPM
matlabbatch{1}.spm.util.imcalc.input = file_paths;
matlabbatch{1}.spm.util.imcalc.output = output_file;
matlabbatch{1}.spm.util.imcalc.outdir = {''};  % Output directory, use '' for current directory
matlabbatch{1}.spm.util.imcalc.expression = expr;
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 16;

% Run the job to calculate the mean image
spm_jobman('run', matlabbatch);

% Define the file path
file_path = fullfile(base_dir, 'cerebellar flat maps', 'mean_output_suit_cer1_Fig8.nii');

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
suit_plotflatmap(Data, 'threshold', 50, 'cscale', [0 120]);

% Get the current colormap and modify it
n_colors = 256; % Total number of colors in the colormap

% Define grey for the 0-50 range
grey_color = [0.7, 0.7, 0.7];  % Light grey

% Get the current colormap (this retains the original color scale)
current_colormap = colormap;

% Determine how many colors correspond to the 0-50 range
n_grey = round(n_colors * 50 / 120);  % Number of colors to assign to grey

% Replace the first part of the colormap (corresponding to 0-50) with grey
current_colormap(1:n_grey, :) = repmat(grey_color, n_grey, 1);

% Apply the modified colormap (grey for 0-50, original colors for 50-120)
colormap(current_colormap);

% Add the colorbar with numbers from 0 to 120
c = colorbar('Ticks', [0, 20, 40, 60, 80, 100, 120], ...
             'TickLabels', {'0', '20', '40', '60', '80', '100', '120'}, 'FontSize', 15);
c.Label.String = 'V/m';
c.Label.FontSize = 15;

% Ensure the color axis covers the correct range (0-120)
caxis([0 120]);

% Add a title
title('E-strength mean affected area (>50V/m)', 'FontSize', 20);

% Hide axes
axis off;

% Summarize data using the cerebellar atlas
% atlas_path = 'C:\Users\vridhi.rohira\Documents\MATLAB\spm12\toolbox\suit\cerebellar_atlases-master\Diedrichsen_2009\atl-Anatom_space-SUIT_dseg.nii';
atlas_path = 'C:\Users\martina.bracco\OneDrive - ICM\Documents\MATLAB\spm12\toolbox\suit\cerebellar_atlases-master\Diedrichsen_2009\atl-Anatom_space-SUIT_dseg.nii';

data_average = suit_ROI_summarize([output_file], ...
                                  'atlas', atlas_path, ...
                                  'outfilename', 'lob_info');

%% cer 1_3 fig8
% Add paths to necessary toolboxes and initialize SPM
% addpath('');

spm('Defaults', 'fMRI');
spm_jobman('initcfg');
addpath('\\iss\cenir\software\irm\spm12\toolbox\suit-3.7');
% addpath('\\iss\cenir\software\irm\spm12\toolbox\suit');

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

% Number of subjects
num_subjects = size(subjects, 1);

% Base directory where subject folders are stored
base_dir = '\\iss\cenir\analyse\irm\users\martina.bracco\cRETMS_MRIs\';

% Initialize list to store file paths
file_paths = cell(num_subjects, 1);

% Loop through each subject to construct the full file paths
for i = 1:num_subjects
    subject_id = subjects{i, 1};
    date_folder = subjects{i, 2};
    sequence_folder = subjects{i, 3};
    
    % Construct the full path to the subject's folder
    subject_folder = fullfile(base_dir, sprintf('%s_%s', date_folder, subject_id), ...
                              [sequence_folder '_T1w_mp2rage_UNI_Images'], ...
                              'Simnibs_simulation', 'simulation_cer_1_3cm_figure8', ...
                              'suit','T1.nii');
    
    % Construct the input file name (NIfTI file)
    input_file = fullfile(subject_folder, ['wd', subject_id, '_TMS_1-0001_Magstim_70mm_Fig8_scalar_magnE.nii']);
    
    % Store the file path in the list
    file_paths{i} = input_file;
end

% Define the output file name
output_file = fullfile(base_dir, 'cerebellar flat maps', 'mean_output_suit_cer_1_3cm_Fig8.nii');

% Generate the expression for mean calculation dynamically
expr = '(';
for i = 1:num_subjects
    if i == num_subjects
        expr = [expr sprintf('i%d', i)];  % Add the last image without a '+'
    else
        expr = [expr sprintf('i%d + ', i)];
    end
end
expr = [expr sprintf(') / %d', num_subjects)];

% Initialize the batch for image calculation in SPM
matlabbatch{1}.spm.util.imcalc.input = file_paths;
matlabbatch{1}.spm.util.imcalc.output = output_file;
matlabbatch{1}.spm.util.imcalc.outdir = {''};  % Output directory, use '' for current directory
matlabbatch{1}.spm.util.imcalc.expression = expr;
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 16;

% Run the job to calculate the mean image
spm_jobman('run', matlabbatch);

% Define the file path
file_path = fullfile(base_dir, 'cerebellar flat maps', 'mean_output_suit_cer_1_3cm_Fig8.nii');

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
suit_plotflatmap(Data, 'threshold', 50, 'cscale', [0 120]);

% Get the current colormap and modify it
n_colors = 256; % Total number of colors in the colormap

% Define grey for the 0-50 range
grey_color = [0.7, 0.7, 0.7];  % Light grey

% Get the current colormap (this retains the original color scale)
current_colormap = colormap;

% Determine how many colors correspond to the 0-50 range
n_grey = round(n_colors * 50 / 120);  % Number of colors to assign to grey

% Replace the first part of the colormap (corresponding to 0-50) with grey
current_colormap(1:n_grey, :) = repmat(grey_color, n_grey, 1);

% Apply the modified colormap (grey for 0-50, original colors for 50-120)
colormap(current_colormap);

% Add the colorbar with numbers from 0 to 120
c = colorbar('Ticks', [0, 20, 40, 60, 80, 100, 120], ...
             'TickLabels', {'0', '20', '40', '60', '80', '100', '120'}, 'FontSize', 15);
c.Label.String = 'V/m';
c.Label.FontSize = 15;

% Ensure the color axis covers the correct range (0-120)
caxis([0 120]);

% Add a title
title('E-strength mean affected area (>50V/m)', 'FontSize', 20);

% Hide axes
axis off;

% Summarize data using the cerebellar atlas
% atlas_path = 'C:\Users\vridhi.rohira\Documents\MATLAB\spm12\toolbox\suit\cerebellar_atlases-master\Diedrichsen_2009\atl-Anatom_space-SUIT_dseg.nii';
atlas_path = 'C:\Users\martina.bracco\OneDrive - ICM\Documents\MATLAB\spm12\toolbox\suit\cerebellar_atlases-master\Diedrichsen_2009\atl-Anatom_space-SUIT_dseg.nii';

data_average = suit_ROI_summarize([output_file], ...
                                  'atlas', atlas_path, ...
                                  'outfilename', 'lob_info');

%% cer mastoid-half fig8
% addpath('');

spm('Defaults', 'fMRI');
spm_jobman('initcfg');
addpath('\\iss\cenir\software\irm\spm12\toolbox\suit-3.7');
% addpath('\\iss\cenir\software\irm\spm12\toolbox\suit');

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

% Number of subjects
num_subjects = size(subjects, 1);

% Base directory where subject folders are stored
base_dir = '\\iss\cenir\analyse\irm\users\martina.bracco\cRETMS_MRIs\';

% Initialize list to store file paths
file_paths = cell(num_subjects, 1);

% Loop through each subject to construct the full file paths
for i = 1:num_subjects
    subject_id = subjects{i, 1};
    date_folder = subjects{i, 2};
    sequence_folder = subjects{i, 3};
    
    % Construct the full path to the subject's folder
    subject_folder = fullfile(base_dir, sprintf('%s_%s', date_folder, subject_id), ...
                              [sequence_folder '_T1w_mp2rage_UNI_Images'], ...
                              'Simnibs_simulation', 'simulation_cer_mastoid_half_figure8', ...
                              'suit','T1.nii');
    
    % Construct the input file name (NIfTI file)
    input_file = fullfile(subject_folder, ['wd', subject_id, '_TMS_1-0001_Magstim_70mm_Fig8_scalar_magnE.nii']);
    
    % Store the file path in the list
    file_paths{i} = input_file;
end

% Define the output file name
output_file = fullfile(base_dir, 'cerebellar flat maps', 'mean_output_suit_cer_mastoid_half_Fig8.nii');

% Generate the expression for mean calculation dynamically
expr = '(';
for i = 1:num_subjects
    if i == num_subjects
        expr = [expr sprintf('i%d', i)];  % Add the last image without a '+'
    else
        expr = [expr sprintf('i%d + ', i)];
    end
end
expr = [expr sprintf(') / %d', num_subjects)];

% Initialize the batch for image calculation in SPM
matlabbatch{1}.spm.util.imcalc.input = file_paths;
matlabbatch{1}.spm.util.imcalc.output = output_file;
matlabbatch{1}.spm.util.imcalc.outdir = {''};  % Output directory, use '' for current directory
matlabbatch{1}.spm.util.imcalc.expression = expr;
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 16;

% Run the job to calculate the mean image
spm_jobman('run', matlabbatch);

% Define the file path
file_path = fullfile(base_dir, 'cerebellar flat maps', 'mean_output_suit_cer_mastoid_half_Fig8.nii');

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
suit_plotflatmap(Data, 'threshold', 50, 'cscale', [0 120]);

% Get the current colormap and modify it
n_colors = 256; % Total number of colors in the colormap

% Define grey for the 0-50 range
grey_color = [0.7, 0.7, 0.7];  % Light grey

% Get the current colormap (this retains the original color scale)
current_colormap = colormap;

% Determine how many colors correspond to the 0-50 range
n_grey = round(n_colors * 50 / 120);  % Number of colors to assign to grey

% Replace the first part of the colormap (corresponding to 0-50) with grey
current_colormap(1:n_grey, :) = repmat(grey_color, n_grey, 1);

% Apply the modified colormap (grey for 0-50, original colors for 50-120)
colormap(current_colormap);

% Add the colorbar with numbers from 0 to 120
c = colorbar('Ticks', [0, 20, 40, 60, 80, 100, 120], ...
             'TickLabels', {'0', '20', '40', '60', '80', '100', '120'}, 'FontSize', 15);
c.Label.String = 'V/m';
c.Label.FontSize = 15;

% Ensure the color axis covers the correct range (0-120)
caxis([0 120]);

% Add a title
title('E-strength mean affected area (>50V/m)', 'FontSize', 20);

% Hide axes
axis off;

% Summarize data using the cerebellar atlas
% atlas_path = 'C:\Users\vridhi.rohira\Documents\MATLAB\spm12\toolbox\suit\cerebellar_atlases-master\Diedrichsen_2009\atl-Anatom_space-SUIT_dseg.nii';
atlas_path = 'C:\Users\martina.bracco\OneDrive - ICM\Documents\MATLAB\spm12\toolbox\suit\cerebellar_atlases-master\Diedrichsen_2009\atl-Anatom_space-SUIT_dseg.nii';

data_average = suit_ROI_summarize([output_file], ...
                                  'atlas', atlas_path, ...
                                  'outfilename', 'lob_info');

%% cer 1 TMS-neuronav DCC
% Add paths to necessary toolboxes and initialize SPM
% addpath('');

spm('Defaults', 'fMRI');
spm_jobman('initcfg');
addpath('\\iss\cenir\software\irm\spm12\toolbox\suit-3.7');
% addpath('\\iss\cenir\software\irm\spm12\toolbox\suit');

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

% Number of subjects
num_subjects = size(subjects, 1);

% Base directory where subject folders are stored
base_dir = '\\iss\cenir\analyse\irm\users\martina.bracco\cRETMS_MRIs\';

% Initialize list to store file paths
file_paths = cell(num_subjects, 1);

% Loop through each subject to construct the full file paths
for i = 1:num_subjects
    subject_id = subjects{i, 1};
    date_folder = subjects{i, 2};
    sequence_folder = subjects{i, 3};
    
    % Construct the full path to the subject's folder
    subject_folder = fullfile(base_dir, sprintf('%s_%s', date_folder, subject_id), ...
                              [sequence_folder '_T1w_mp2rage_UNI_Images'], ...
                              'Simnibs_simulation', 'simulation_cer1_DCC_scal_intensity', ...
                              'suit','T1.nii');
    
    % Construct the input file name (NIfTI file)
    input_file = fullfile(subject_folder, ['wd', subject_id, '_TMS_1-0001_MagStim_DCC_scalar_magnE.nii']);
    
    % Store the file path in the list
    file_paths{i} = input_file;
end

% Define the output file name
output_file = fullfile(base_dir, 'cerebellar flat maps', 'mean_output_suit_cer1_DCC_scal_intensity.nii');

% Generate the expression for mean calculation dynamically
expr = '(';
for i = 1:num_subjects
    if i == num_subjects
        expr = [expr sprintf('i%d', i)];  % Add the last image without a '+'
    else
        expr = [expr sprintf('i%d + ', i)];
    end
end
expr = [expr sprintf(') / %d', num_subjects)];

% Initialize the batch for image calculation in SPM
matlabbatch{1}.spm.util.imcalc.input = file_paths;
matlabbatch{1}.spm.util.imcalc.output = output_file;
matlabbatch{1}.spm.util.imcalc.outdir = {''};  % Output directory, use '' for current directory
matlabbatch{1}.spm.util.imcalc.expression = expr;
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 16;

% Run the job to calculate the mean image
spm_jobman('run', matlabbatch);

% Define the file path
file_path = fullfile(base_dir, 'cerebellar flat maps', 'mean_output_suit_cer1_DCC_scal_intensity.nii');

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
suit_plotflatmap(Data, 'threshold', 50, 'cscale', [0 120]);

% Get the current colormap and modify it
n_colors = 256; % Total number of colors in the colormap

% Define grey for the 0-50 range
grey_color = [0.7, 0.7, 0.7];  % Light grey

% Get the current colormap (this retains the original color scale)
current_colormap = colormap;

% Determine how many colors correspond to the 0-50 range
n_grey = round(n_colors * 50 / 120);  % Number of colors to assign to grey

% Replace the first part of the colormap (corresponding to 0-50) with grey
current_colormap(1:n_grey, :) = repmat(grey_color, n_grey, 1);

% Apply the modified colormap (grey for 0-50, original colors for 50-120)
colormap(current_colormap);

% Add the colorbar with numbers from 0 to 120
c = colorbar('Ticks', [0, 20, 40, 60, 80, 100, 120], ...
             'TickLabels', {'0', '20', '40', '60', '80', '100', '120'}, 'FontSize', 15);
c.Label.String = 'V/m';
c.Label.FontSize = 15;

% Ensure the color axis covers the correct range (0-120)
caxis([0 120]);

% Add a title
title('E-strength mean affected area (>50V/m)', 'FontSize', 20);

% Hide axes
axis off;

% Summarize data using the cerebellar atlas
% atlas_path = 'C:\Users\vridhi.rohira\Documents\MATLAB\spm12\toolbox\suit\cerebellar_atlases-master\Diedrichsen_2009\atl-Anatom_space-SUIT_dseg.nii';
atlas_path = 'C:\Users\martina.bracco\OneDrive - ICM\Documents\MATLAB\spm12\toolbox\suit\cerebellar_atlases-master\Diedrichsen_2009\atl-Anatom_space-SUIT_dseg.nii';

data_average = suit_ROI_summarize([output_file], ...
                                  'atlas', atlas_path, ...
                                  'outfilename', 'lob_info');

%% cer 1_3 DCC
% Add paths to necessary toolboxes and initialize SPM
% addpath('');

spm('Defaults', 'fMRI');
spm_jobman('initcfg');
addpath('\\iss\cenir\software\irm\spm12\toolbox\suit-3.7');
% addpath('\\iss\cenir\software\irm\spm12\toolbox\suit');

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

% Number of subjects
num_subjects = size(subjects, 1);

% Base directory where subject folders are stored
base_dir = '\\iss\cenir\analyse\irm\users\martina.bracco\cRETMS_MRIs\';

% Initialize list to store file paths
file_paths = cell(num_subjects, 1);
% Loop through each subject to construct the full file paths
for i =1:num_subjects
    subject_id = subjects{i, 1};
    date_folder = subjects{i, 2};
    sequence_folder = subjects{i, 3};
    
    % Construct the full path to the subject's folder
    subject_folder = fullfile(base_dir, sprintf('%s_%s', date_folder, subject_id), ...
                              [sequence_folder '_T1w_mp2rage_UNI_Images'], ...
                              'Simnibs_simulation', 'simulation_cer_1_3cm_DCC_scal_intensity', ...
                              'suit','T1.nii');
   
    % Construct the input file name (NIfTI file)
    input_file = fullfile(subject_folder, ['wd', subject_id, '_TMS_1-0001_MagStim_DCC_scalar_magnE.nii']);
    % Store the file path in the list
    file_paths{i} = input_file;
end

% Define the output file name
output_file = fullfile(base_dir, 'cerebellar flat maps', 'mean_output_suit_cer_1_3cm_DCC_scal_intensity.nii');

% Generate the expression for mean calculation dynamically
expr = '(';
for i = 1:num_subjects
    if i == num_subjects
        expr = [expr sprintf('i%d', i)];  % Add the last image without a '+'
    else
        expr = [expr sprintf('i%d + ', i)];
    end
end
expr = [expr sprintf(') / %d', num_subjects)];

% Initialize the batch for image calculation in SPM
matlabbatch{1}.spm.util.imcalc.input = file_paths;
matlabbatch{1}.spm.util.imcalc.output = output_file;
matlabbatch{1}.spm.util.imcalc.outdir = {''};  % Output directory, use '' for current directory
matlabbatch{1}.spm.util.imcalc.expression = expr;
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 16;

% Run the job to calculate the mean image
spm_jobman('run', matlabbatch);

% Define the file path
file_path = fullfile(base_dir, 'cerebellar flat maps', 'mean_output_suit_cer_1_3cm_DCC_scal_intensity.nii');

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
suit_plotflatmap(Data, 'threshold', 50, 'cscale', [0 120]);

% Get the current colormap and modify it
n_colors = 256; % Total number of colors in the colormap

% Define grey for the 0-50 range
grey_color = [0.7, 0.7, 0.7];  % Light grey

% Get the current colormap (this retains the original color scale)
current_colormap = colormap;

% Determine how many colors correspond to the 0-50 range
n_grey = round(n_colors * 50 / 120);  % Number of colors to assign to grey

% Replace the first part of the colormap (corresponding to 0-50) with grey
current_colormap(1:n_grey, :) = repmat(grey_color, n_grey, 1);

% Apply the modified colormap (grey for 0-50, original colors for 50-120)
colormap(current_colormap);

% Add the colorbar with numbers from 0 to 120
c = colorbar('Ticks', [0, 20, 40, 60, 80, 100, 120], ...
             'TickLabels', {'0', '20', '40', '60', '80', '100', '120'}, 'FontSize', 15);
c.Label.String = 'V/m';
c.Label.FontSize = 15;

% Ensure the color axis covers the correct range (0-120)
caxis([0 120]);

% Add a title
title('E-strength mean affected area (>50V/m)', 'FontSize', 20);

% Hide axes
axis off;

% Summarize data using the cerebellar atlas
% atlas_path = 'C:\Users\vridhi.rohira\Documents\MATLAB\spm12\toolbox\suit\cerebellar_atlases-master\Diedrichsen_2009\atl-Anatom_space-SUIT_dseg.nii';
atlas_path = 'C:\Users\martina.bracco\OneDrive - ICM\Documents\MATLAB\spm12\toolbox\suit\cerebellar_atlases-master\Diedrichsen_2009\atl-Anatom_space-SUIT_dseg.nii';

data_average = suit_ROI_summarize([output_file], ...
                                  'atlas', atlas_path, ...
                                  'outfilename', 'lob_info');

%% cer mastoid-half DCC
% Add paths to necessary toolboxes and initialize SPM
% addpath('');

spm('Defaults', 'fMRI');
spm_jobman('initcfg');
addpath('\\iss\cenir\software\irm\spm12\toolbox\suit-3.7');
% addpath('\\iss\cenir\software\irm\spm12\toolbox\suit');

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

% Number of subjects
num_subjects = size(subjects, 1);

% Base directory where subject folders are stored
base_dir = '\\iss\cenir\analyse\irm\users\martina.bracco\cRETMS_MRIs\';

% Initialize list to store file paths
file_paths = cell(num_subjects, 1);

% Loop through each subject to construct the full file paths
for i = 1:num_subjects
    subject_id = subjects{i, 1};
    date_folder = subjects{i, 2};
    sequence_folder = subjects{i, 3};
    
    % Construct the full path to the subject's folder
    subject_folder = fullfile(base_dir, sprintf('%s_%s', date_folder, subject_id), ...
                              [sequence_folder '_T1w_mp2rage_UNI_Images'], ...
                              'Simnibs_simulation', 'simulation_cer_mastoid_half_DCC_scal_intensity', ...
                              'suit','T1.nii');
    
    % Construct the input file name (NIfTI file)
    input_file = fullfile(subject_folder, ['wd', subject_id, '_TMS_1-0001_MagStim_DCC_scalar_magnE.nii']);
    
    % Store the file path in the list
    file_paths{i} = input_file;
end

% Define the output file name
output_file = fullfile(base_dir, 'cerebellar flat maps', 'mean_output_suit_cer_mastoid_half_DCC_scal_intensity.nii');

% Generate the expression for mean calculation dynamically
expr = '(';
for i = 1:num_subjects
    if i == num_subjects
        expr = [expr sprintf('i%d', i)];  % Add the last image without a '+'
    else
        expr = [expr sprintf('i%d + ', i)];
    end
end
expr = [expr sprintf(') / %d', num_subjects)];

% Initialize the batch for image calculation in SPM
matlabbatch{1}.spm.util.imcalc.input = file_paths;
matlabbatch{1}.spm.util.imcalc.output = output_file;
matlabbatch{1}.spm.util.imcalc.outdir = {''};  % Output directory, use '' for current directory
matlabbatch{1}.spm.util.imcalc.expression = expr;
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 16;

% Run the job to calculate the mean image
spm_jobman('run', matlabbatch);

% Define the file path
file_path = fullfile(base_dir, 'cerebellar flat maps', 'mean_output_suit_cer_mastoid_half_DCC_scal_intensity.nii');

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
suit_plotflatmap(Data, 'threshold', 50, 'cscale', [0 120]);

% Get the current colormap and modify it
n_colors = 256; % Total number of colors in the colormap

% Define grey for the 0-50 range
grey_color = [0.7, 0.7, 0.7];  % Light grey

% Get the current colormap (this retains the original color scale)
current_colormap = colormap;

% Determine how many colors correspond to the 0-50 range
n_grey = round(n_colors * 50 / 120);  % Number of colors to assign to grey

% Replace the first part of the colormap (corresponding to 0-50) with grey
current_colormap(1:n_grey, :) = repmat(grey_color, n_grey, 1);

% Apply the modified colormap (grey for 0-50, original colors for 50-120)
colormap(current_colormap);

% Add the colorbar with numbers from 0 to 120
c = colorbar('Ticks', [0, 20, 40, 60, 80, 100, 120], ...
             'TickLabels', {'0', '20', '40', '60', '80', '100', '120'}, 'FontSize', 15);
c.Label.String = 'V/m';
c.Label.FontSize = 15;

% Ensure the color axis covers the correct range (0-120)
caxis([0 120]);

% Add a title
title('E-strength mean affected area (>50V/m)', 'FontSize', 20);

% Hide axes
axis off;

% Summarize data using the cerebellar atlas
% atlas_path = 'C:\Users\vridhi.rohira\Documents\MATLAB\spm12\toolbox\suit\cerebellar_atlases-master\Diedrichsen_2009\atl-Anatom_space-SUIT_dseg.nii';
atlas_path = 'C:\Users\martina.bracco\OneDrive - ICM\Documents\MATLAB\spm12\toolbox\suit\cerebellar_atlases-master\Diedrichsen_2009\atl-Anatom_space-SUIT_dseg.nii';

data_average = suit_ROI_summarize([output_file], ...
                                  'atlas', atlas_path, ...
                                  'outfilename', 'lob_info');

%% END