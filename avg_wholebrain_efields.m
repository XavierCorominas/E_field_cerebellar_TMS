%% Improving Cerebellar TMS Targeting: MRI-Neuronavigation and Landmark-Based Approaches Assessed by E-Field Modeling 

% Vridhi Rohiraa*, Xavier Corominas-Teruel*, Salim Ouarab, Traian Popa, Cécile Gallea#, Antoni Valero-Cabré# & Martina Bracco#

% *Equal Contriution
% #SeniorAuthorship


% Tasks in the script:
% 1. Group average E-field projection

% Before running the scripts, the following software needs to be installed:
    % Simnibs4.0 or superior (https://simnibs.github.io/simnibs/build/html/index.html)
    % SUIT toolbox (https://www.diedrichsenlab.org/imaging/suit.htm)

%% ----- DCC cer1 -----------%%

spm('Defaults', 'fMRI');
spm_jobman('initcfg');
addpath('\\iss\cenir\software\irm\spm12\toolbox\suit-3.7');

% Subject info
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

num_subjects = size(subjects, 1);

base_dir = '\\iss\cenir\analyse\irm\users\martina.bracco\cRETMS_MRIs\';
file_paths = cell(num_subjects, 1);

% --- NORMALIZATION LOOP ---
for i = 1:num_subjects
    i
    subject_id = subjects{i, 1};
    date_folder = subjects{i, 2};
    sequence_folder = subjects{i, 3};

    gz_file = fullfile(base_dir, ...
        sprintf('%s_%s', date_folder, subject_id), ...
        [sequence_folder '_T1w_mp2rage_UNI_Images'], ...
        'Simnibs_simulation', 'simulation_cer1_DCC_scal_intensity', ...
        'mni_volumes', ...
        [subject_id '_TMS_1-0001_MagStim_DCC_scalar_MNI_magnE.nii.gz']);

    % Unzip file if needed
    if exist(gz_file, 'file')
        gunzip(gz_file);
    end

    % Update file path to point to uncompressed .nii
    nii_file = gz_file(1:end-3);
    file_paths{i} = nii_file;
end

% --- AVERAGING IMAGES --- %

% Check that you have the correct number of files (20 subjects)
if length(file_paths) ~= 20
    error('Expected 20 files for DCC cer1, found %d', length(file_paths));
end

% Load the first image to get the dimensions and header
V = spm_vol(file_paths{1});
[Y, ~] = spm_read_vols(V);
dims = size(Y);

% Initialize a variable to sum the images
sum_img = zeros(dims);

% Sum the images for all subjects
for i = 1:20
    V_temp = spm_vol(file_paths{i});
    Y_temp = spm_read_vols(V_temp);
    sum_img = sum_img + Y_temp; % Sum the images
end

% Calculate the average
avg_img = sum_img / 20;

% Save the average image
output_avg_file = fullfile(base_dir, 'Avg_results\mean_output_cer1_DCC_scal_intensity.nii');
Vout = V;  % Use the header from the first image for the output
Vout.fname = output_avg_file;

% Write the average image to disk
spm_write_vol(Vout, avg_img);

% Print a message
fprintf('Average NIfTI image for DCC cer1 saved to %s\n', output_avg_file);

%% ----- DCC cer13 -----------%%

spm('Defaults', 'fMRI');
spm_jobman('initcfg');
addpath('\\iss\cenir\software\irm\spm12\toolbox\suit-3.7');

% Subject info
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

num_subjects = size(subjects, 1);

base_dir = '\\iss\cenir\analyse\irm\users\martina.bracco\cRETMS_MRIs\';
file_paths = cell(num_subjects, 1);

% --- NORMALIZATION LOOP ---
for i = 1:num_subjects
    i
    subject_id = subjects{i, 1};
    date_folder = subjects{i, 2};
    sequence_folder = subjects{i, 3};

    gz_file = fullfile(base_dir, ...
        sprintf('%s_%s', date_folder, subject_id), ...
        [sequence_folder '_T1w_mp2rage_UNI_Images'], ...
        'Simnibs_simulation', 'simulation_cer_1_3cm_DCC_scal_intensity', ...
        'mni_volumes', ...
        [subject_id '_TMS_1-0001_MagStim_DCC_scalar_MNI_magnE.nii.gz']);

    % Unzip file if needed
    if exist(gz_file, 'file')
        gunzip(gz_file);
    end

    % Update file path to point to uncompressed .nii
    nii_file = gz_file(1:end-3);
    file_paths{i} = nii_file;
end

% --- AVERAGING IMAGES --- %

% Check that you have the correct number of files (20 subjects)
if length(file_paths) ~= 20
    error('Expected 20 files for DCC cer_1_3cm, found %d', length(file_paths));
end

% Load the first image to get the dimensions and header
V = spm_vol(file_paths{1});
[Y, ~] = spm_read_vols(V);
dims = size(Y);

% Initialize a variable to sum the images
sum_img = zeros(dims);

% Sum the images for all subjects
for i = 1:20
    V_temp = spm_vol(file_paths{i});
    Y_temp = spm_read_vols(V_temp);
    sum_img = sum_img + Y_temp; % Sum the images
end

% Calculate the average
avg_img = sum_img / 20;

% Save the average image
output_avg_file = fullfile(base_dir, 'Avg_results\mean_output_cer_1_3cm_DCC_scal_intensity.nii');
Vout = V;  % Use the header from the first image for the output
Vout.fname = output_avg_file;

% Write the average image to disk
spm_write_vol(Vout, avg_img);

% Print a message
fprintf('Average NIfTI image for DCC cer_1_3cm saved to %s\n', output_avg_file);
%% ----- DCC cer m -----------%%

spm('Defaults', 'fMRI');
spm_jobman('initcfg');
addpath('\\iss\cenir\software\irm\spm12\toolbox\suit-3.7');

% Subject info
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

num_subjects = size(subjects, 1);

base_dir = '\\iss\cenir\analyse\irm\users\martina.bracco\cRETMS_MRIs\';
file_paths = cell(num_subjects, 1);

% --- NORMALIZATION LOOP ---
for i = 1:num_subjects
    i
    subject_id = subjects{i, 1};
    date_folder = subjects{i, 2};
    sequence_folder = subjects{i, 3};

    gz_file = fullfile(base_dir, ...
        sprintf('%s_%s', date_folder, subject_id), ...
        [sequence_folder '_T1w_mp2rage_UNI_Images'], ...
        'Simnibs_simulation', 'simulation_cer_mastoid_half_DCC_scal_intensity', ...
        'mni_volumes', ...
        [subject_id '_TMS_1-0001_MagStim_DCC_scalar_MNI_magnE.nii.gz']);

    % Unzip file if needed
    if exist(gz_file, 'file')
        gunzip(gz_file);
    end

    % Update file path to point to uncompressed .nii
    nii_file = gz_file(1:end-3);
    file_paths{i} = nii_file;
end

% --- AVERAGING IMAGES --- %

% Check that you have the correct number of files (20 subjects)
if length(file_paths) ~= 20
    error('Expected 20 files for DCC cer_mastoid_half, found %d', length(file_paths));
end

% Load the first image to get the dimensions and header
V = spm_vol(file_paths{1});
[Y, ~] = spm_read_vols(V);
dims = size(Y);

% Initialize a variable to sum the images
sum_img = zeros(dims);

% Sum the images for all subjects
for i = 1:20
    V_temp = spm_vol(file_paths{i});
    Y_temp = spm_read_vols(V_temp);
    sum_img = sum_img + Y_temp; % Sum the images
end

% Calculate the average
avg_img = sum_img / 20;

% Save the average image
output_avg_file = fullfile(base_dir, 'Avg_results\mean_output_cer_mastoid_half_DCC_scal_intensity.nii');
Vout = V;  % Use the header from the first image for the output
Vout.fname = output_avg_file;

% Write the average image to disk
spm_write_vol(Vout, avg_img);

% Print a message
fprintf('Average NIfTI image for DCC cer_mastoid_half saved to %s\n', output_avg_file);


% %% ----- f8 cer1 -----------%%
% 
% spm('Defaults', 'fMRI');
% spm_jobman('initcfg');
% addpath('\\iss\cenir\software\irm\spm12\toolbox\suit-3.7');
% 
% % Subject info
% subjects = {
%     'cRETMS_01_001', '2022_04_25', 'S04';
%     'cRETMS_01_002', '2022_04_29', 'S05';
%     'cRETMS_01_003', '2022_05_03', 'S05';
%     'cRETMS_01_004', '2022_05_05', 'S05';
%     'cRETMS_01_005', '2022_04_14', 'S04';
%     'cRETMS_01_006', '2022_05_06', 'S05';
%     'cRETMS_01_007', '2022_05_09', 'S05';
%     'cRETMS_01_010', '2022_05_18', 'S05';
%     'cRETMS_01_011', '2022_05_24', 'S05';
%     'cRETMS_01_013', '2022_06_07', 'S05';
%     'cRETMS_01_014', '2022_06_14', 'S05';
%     'cRETMS_01_015', '2022_07_04', 'S04';
%     'cRETMS_01_016', '2022_07_20', 'S05';
%     'cRETMS_01_017', '2022_08_30', 'S05';
%     'cRETMS_01_018', '2022_08_31', 'S05';
%     'cRETMS_01_020', '2022_09_01', 'S05';
%     'cRETMS_01_021', '2022_09_06', 'S05';
%     'cRETMS_01_022', '2022_09_08', 'S05';
%     'cRETMS_01_023', '2022_09_09', 'S05';
%     'cRETMS_01_024', '2023_04_13', 'S05';
% };
% 
% num_subjects = size(subjects, 1);
% 
% base_dir = '\\iss\cenir\analyse\irm\users\martina.bracco\cRETMS_MRIs\';
% file_paths = cell(num_subjects, 1);
% 
% % --- NORMALIZATION LOOP ---
% for i = 1:num_subjects
%     i
%     subject_id = subjects{i, 1};
%     date_folder = subjects{i, 2};
%     sequence_folder = subjects{i, 3};
% 
%     gz_file = fullfile(base_dir, ...
%         sprintf('%s_%s', date_folder, subject_id), ...
%         [sequence_folder '_T1w_mp2rage_UNI_Images'], ...
%         'Simnibs_simulation', 'simulation_cer1_figure8_fix_intensity', ...
%         'mni_volumes', ...
%         [subject_id '_TMS_1-0001_MagStim_70mm_Fig8_scalar_MNI_magnE.nii.gz']);
% 
%     % Unzip file if needed
%     if exist(gz_file, 'file')
%         gunzip(gz_file);
%     end
% 
%     % Update file path to point to uncompressed .nii
%     nii_file = gz_file(1:end-3);
%     file_paths{i} = nii_file;
% end
% 
% % --- AVERAGING IMAGES --- %
% 
% % Check that you have the correct number of files (20 subjects)
% if length(file_paths) ~= 20
%     error('Expected 20 files for fig8 cer1, found %d', length(file_paths));
% end
% 
% % Load the first image to get the dimensions and header
% V = spm_vol(file_paths{1});
% [Y, ~] = spm_read_vols(V);
% dims = size(Y);
% 
% % Initialize a variable to sum the images
% sum_img = zeros(dims);
% 
% % Sum the images for all subjects
% for i = 1:20
%     V_temp = spm_vol(file_paths{i});
%     Y_temp = spm_read_vols(V_temp);
%     sum_img = sum_img + Y_temp; % Sum the images
% end
% 
% % Calculate the average
% avg_img = sum_img / 20;
% 
% % Save the average image
% output_avg_file = fullfile(base_dir, 'Avg_results\mean_output_cer1_figure8_fix_intensity.nii');
% Vout = V;  % Use the header from the first image for the output
% Vout.fname = output_avg_file;
% 
% % Write the average image to disk
% spm_write_vol(Vout, avg_img);
% 
% % Print a message
% fprintf('Average NIfTI image for figure8 cer1 saved to %s\n', output_avg_file);
% 
% %% ----- figure8 cer13 -----------%%
% 
% spm('Defaults', 'fMRI');
% spm_jobman('initcfg');
% addpath('\\iss\cenir\software\irm\spm12\toolbox\suit-3.7');
% 
% % Subject info
% subjects = {
%     'cRETMS_01_001', '2022_04_25', 'S04';
%     'cRETMS_01_002', '2022_04_29', 'S05';
%     'cRETMS_01_003', '2022_05_03', 'S05';
%     'cRETMS_01_004', '2022_05_05', 'S05';
%     'cRETMS_01_005', '2022_04_14', 'S04';
%     'cRETMS_01_006', '2022_05_06', 'S05';
%     'cRETMS_01_007', '2022_05_09', 'S05';
%     'cRETMS_01_010', '2022_05_18', 'S05';
%     'cRETMS_01_011', '2022_05_24', 'S05';
%     'cRETMS_01_013', '2022_06_07', 'S05';
%     'cRETMS_01_014', '2022_06_14', 'S05';
%     'cRETMS_01_015', '2022_07_04', 'S04';
%     'cRETMS_01_016', '2022_07_20', 'S05';
%     'cRETMS_01_017', '2022_08_30', 'S05';
%     'cRETMS_01_018', '2022_08_31', 'S05';
%     'cRETMS_01_020', '2022_09_01', 'S05';
%     'cRETMS_01_021', '2022_09_06', 'S05';
%     'cRETMS_01_022', '2022_09_08', 'S05';
%     'cRETMS_01_023', '2022_09_09', 'S05';
%     'cRETMS_01_024', '2023_04_13', 'S05';
% };
% 
% num_subjects = size(subjects, 1);
% 
% base_dir = '\\iss\cenir\analyse\irm\users\martina.bracco\cRETMS_MRIs\';
% file_paths = cell(num_subjects, 1);
% 
% % --- NORMALIZATION LOOP ---
% for i = 1:num_subjects
%     i
%     subject_id = subjects{i, 1};
%     date_folder = subjects{i, 2};
%     sequence_folder = subjects{i, 3};
% 
%     gz_file = fullfile(base_dir, ...
%         sprintf('%s_%s', date_folder, subject_id), ...
%         [sequence_folder '_T1w_mp2rage_UNI_Images'], ...
%         'Simnibs_simulation', 'simulation_cer_1_3cm_figure8_fix_intensity', ...
%         'mni_volumes', ...
%         [subject_id '_TMS_1-0001_MagStim_70mm_Fig8_scalar_MNI_magnE.nii.gz']);
% 
%     % Unzip file if needed
%     if exist(gz_file, 'file')
%         gunzip(gz_file);
%     end
% 
%     % Update file path to point to uncompressed .nii
%     nii_file = gz_file(1:end-3);
%     file_paths{i} = nii_file;
% end
% 
% % --- AVERAGING IMAGES --- %
% 
% % Check that you have the correct number of files (20 subjects)
% if length(file_paths) ~= 20
%     error('Expected 20 files for figure8 cer_1_3cm, found %d', length(file_paths));
% end
% 
% % Load the first image to get the dimensions and header
% V = spm_vol(file_paths{1});
% [Y, ~] = spm_read_vols(V);
% dims = size(Y);
% 
% % Initialize a variable to sum the images
% sum_img = zeros(dims);
% 
% % Sum the images for all subjects
% for i = 1:20
%     V_temp = spm_vol(file_paths{i});
%     Y_temp = spm_read_vols(V_temp);
%     sum_img = sum_img + Y_temp; % Sum the images
% end
% 
% % Calculate the average
% avg_img = sum_img / 20;
% 
% % Save the average image
% output_avg_file = fullfile(base_dir, 'Avg_results\mean_output_cer_1_3cm_figure8_fix_intensity.nii');
% Vout = V;  % Use the header from the first image for the output
% Vout.fname = output_avg_file;
% 
% % Write the average image to disk
% spm_write_vol(Vout, avg_img);
% 
% % Print a message
% fprintf('Average NIfTI image for figure8 cer_1_3cm saved to %s\n', output_avg_file);
% %% ----- figure8 cer m -----------%%
% 
% spm('Defaults', 'fMRI');
% spm_jobman('initcfg');
% addpath('\\iss\cenir\software\irm\spm12\toolbox\suit-3.7');
% 
% % Subject info
% subjects = {
%     'cRETMS_01_001', '2022_04_25', 'S04';
%     'cRETMS_01_002', '2022_04_29', 'S05';
%     'cRETMS_01_003', '2022_05_03', 'S05';
%     'cRETMS_01_004', '2022_05_05', 'S05';
%     'cRETMS_01_005', '2022_04_14', 'S04';
%     'cRETMS_01_006', '2022_05_06', 'S05';
%     'cRETMS_01_007', '2022_05_09', 'S05';
%     'cRETMS_01_010', '2022_05_18', 'S05';
%     'cRETMS_01_011', '2022_05_24', 'S05';
%     'cRETMS_01_013', '2022_06_07', 'S05';
%     'cRETMS_01_014', '2022_06_14', 'S05';
%     'cRETMS_01_015', '2022_07_04', 'S04';
%     'cRETMS_01_016', '2022_07_20', 'S05';
%     'cRETMS_01_017', '2022_08_30', 'S05';
%     'cRETMS_01_018', '2022_08_31', 'S05';
%     'cRETMS_01_020', '2022_09_01', 'S05';
%     'cRETMS_01_021', '2022_09_06', 'S05';
%     'cRETMS_01_022', '2022_09_08', 'S05';
%     'cRETMS_01_023', '2022_09_09', 'S05';
%     'cRETMS_01_024', '2023_04_13', 'S05';
% };
% 
% num_subjects = size(subjects, 1);
% 
% base_dir = '\\iss\cenir\analyse\irm\users\martina.bracco\cRETMS_MRIs\';
% file_paths = cell(num_subjects, 1);
% 
% % --- NORMALIZATION LOOP ---
% for i = 1:num_subjects
%     i
%     subject_id = subjects{i, 1};
%     date_folder = subjects{i, 2};
%     sequence_folder = subjects{i, 3};
% 
%     gz_file = fullfile(base_dir, ...
%         sprintf('%s_%s', date_folder, subject_id), ...
%         [sequence_folder '_T1w_mp2rage_UNI_Images'], ...
%         'Simnibs_simulation', 'simulation_cer_mastoid_half_figure8_fix_intensity', ...
%         'mni_volumes', ...
%         [subject_id '_TMS_1-0001_MagStim_70mm_Fig8_scalar_MNI_magnE.nii.gz']);
% 
%     % Unzip file if needed
%     if exist(gz_file, 'file')
%         gunzip(gz_file);
%     end
% 
%     % Update file path to point to uncompressed .nii
%     nii_file = gz_file(1:end-3);
%     file_paths{i} = nii_file;
% end
% 
% % --- AVERAGING IMAGES --- %
% 
% % Check that you have the correct number of files (20 subjects)
% if length(file_paths) ~= 20
%     error('Expected 20 files for figure8 cer_mastoid_half, found %d', length(file_paths));
% end
% 
% % Load the first image to get the dimensions and header
% V = spm_vol(file_paths{1});
% [Y, ~] = spm_read_vols(V);
% dims = size(Y);
% 
% % Initialize a variable to sum the images
% sum_img = zeros(dims);
% 
% % Sum the images for all subjects
% for i = 1:20
%     V_temp = spm_vol(file_paths{i});
%     Y_temp = spm_read_vols(V_temp);
%     sum_img = sum_img + Y_temp; % Sum the images
% end
% 
% % Calculate the average
% avg_img = sum_img / 20;
% 
% % Save the average image
% output_avg_file = fullfile(base_dir, 'Avg_results\mean_output_cer_mastoid_half_figure8_fix_intensity.nii');
% Vout = V;  % Use the header from the first image for the output
% Vout.fname = output_avg_file;
% 
% % Write the average image to disk
% spm_write_vol(Vout, avg_img);
% 
% % Print a message
% fprintf('Average NIfTI image for figure8 cer_mastoid_half saved to %s\n', output_avg_file);