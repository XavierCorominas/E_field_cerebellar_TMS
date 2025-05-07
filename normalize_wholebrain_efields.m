%% Improving Cerebellar TMS Targeting: MRI-Neuronavigation and Landmark-Based Approaches Assessed by E-Field Modeling 

% Vridhi Rohiraa*, Xavier Corominas-Teruel*, Salim Ouarab, Traian Popa, Cécile Gallea#, Antoni Valero-Cabré# & Martina Bracco#

% *Equal Contriution
% #SeniorAuthorship

% Tasks in the script:
% 1. Normalize e-field with 50% relative max, according to procedures outlined in https://www.brainstimjrnl.com/article/S1935-861X(12)00023-X/abstract

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
normalized_paths = cell(num_subjects, 1);

% Your subject-specific peak values 
load('max_magnE_cer1_DCC_gm_999.mat')
peak_values = max_values;


% --- NORMALIZATION LOOP ---
for i = 1:num_subjects
    subject_id = subjects{i, 1};
    date_folder = subjects{i, 2};
    sequence_folder = subjects{i, 3};

    input_file = fullfile(base_dir, ...
        sprintf('%s_%s', date_folder, subject_id), ...
        [sequence_folder '_T1w_mp2rage_UNI_Images'], ...
        'Simnibs_simulation', 'simulation_cer1_DCC', ...
        'mni_volumes', ...
        [subject_id '_TMS_1-0001_MagStim_DCC_scalar_MNI_magnE.nii.gz']);

        output_path = fullfile(base_dir, ...
        sprintf('%s_%s', date_folder, subject_id), ...
        [sequence_folder '_T1w_mp2rage_UNI_Images'], ...
        'Simnibs_simulation', 'simulation_cer1_DCC', ...
        'mni_volumes')
    
    % --- UNZIP .nii.gz to TEMP FILE ---
    tmp_dir = tempdir;
    [~, fname, ~] = fileparts(input_file);  % get name without .gz
    tmp_file = fullfile(tmp_dir, fname);    % full temp path (e.g., /tmp/subject001.nii)
    
    % Unzip to temp
    gunzip(input_file, tmp_dir);  % gunzip writes to tempdir
    
    % --- LOAD, NORMALIZE, SAVE ---
    V = spm_vol(tmp_file);         % Load uncompressed file
    Y = spm_read_vols(V);          % Read data
    Y_norm = Y / peak_values(i);   % Normalize by subject-specific peak
    
    % Save normalized file
    norm_file = fullfile(output_path, [subject_id '_TMS_1-0001_MagStim_DCC_scalar_MNI_magnE_norm_gm_999.nii']);
    V.fname = norm_file;
    spm_write_vol(V, Y_norm);
    
    % Delete temp file
    delete(tmp_file);

    normalized_paths{i} = V.fname;
end

% --- AVERAGING NORMALIZED IMAGES --- %

% Initialize the variable to store all file paths for DCC cer1
normalized_paths; % these should already contain the normalized paths from previous loop

% Check that you have the correct number of files (20 subjects)
if length(normalized_paths) ~= 20
    error('Expected 20 files for DCC cer1, found %d', length(normalized_paths));
end

% Load the first image to get the dimensions and header
V = spm_vol(normalized_paths{1});
[Y, ~] = spm_read_vols(V);
dims = size(Y);

% Initialize a variable to sum the images
sum_img = zeros(dims);

% Sum the images for all subjects
for i = 1:20
    V_temp = spm_vol(normalized_paths{i});
    Y_temp = spm_read_vols(V_temp);
    sum_img = sum_img + Y_temp; % Sum the images
end

% Calculate the average
avg_img = sum_img / 20;

% Save the average image
output_avg_file = fullfile(base_dir, 'Avg_results\mean_output_cer1_DCC_norm_gm_999.nii');
Vout = V;  % Use the header from the first image for the output
Vout.fname = output_avg_file;

% Write the average image to disk
spm_write_vol(Vout, avg_img);

% Print a message
fprintf('Average NIfTI image for DCC cer1 saved to %s\n', output_avg_file);


%% ----- DCC cer1_3 -----------%%

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
normalized_paths = cell(num_subjects, 1);

% Your subject-specific peak values 
load('max_magnE_cer_1_3cm_DCC_gm_999.mat')
peak_values = max_values;


% --- NORMALIZATION LOOP ---
for i = 1:num_subjects
    subject_id = subjects{i, 1};
    date_folder = subjects{i, 2};
    sequence_folder = subjects{i, 3};

    input_file = fullfile(base_dir, ...
        sprintf('%s_%s', date_folder, subject_id), ...
        [sequence_folder '_T1w_mp2rage_UNI_Images'], ...
        'Simnibs_simulation', 'simulation_cer_1_3cm_DCC', ...
        'mni_volumes', ...
        [subject_id '_TMS_1-0001_MagStim_DCC_scalar_MNI_magnE.nii.gz']);

        output_path = fullfile(base_dir, ...
        sprintf('%s_%s', date_folder, subject_id), ...
        [sequence_folder '_T1w_mp2rage_UNI_Images'], ...
        'Simnibs_simulation', 'simulation_cer_1_3cm_DCC', ...
        'mni_volumes')
    
    % --- UNZIP .nii.gz to TEMP FILE ---
    tmp_dir = tempdir;
    [~, fname, ~] = fileparts(input_file);  % get name without .gz
    tmp_file = fullfile(tmp_dir, fname);    % full temp path (e.g., /tmp/subject001.nii)
    
    % Unzip to temp
    gunzip(input_file, tmp_dir);  % gunzip writes to tempdir
    
    % --- LOAD, NORMALIZE, SAVE ---
    V = spm_vol(tmp_file);         % Load uncompressed file
    Y = spm_read_vols(V);          % Read data
    Y_norm = Y / peak_values(i);   % Normalize by subject-specific peak
    
    % Save normalized file
    norm_file = fullfile(output_path, [subject_id '_TMS_1-0001_MagStim_DCC_scalar_MNI_magnE_norm_gm_999.nii']);
    V.fname = norm_file;
    spm_write_vol(V, Y_norm);
    
    % Delete temp file
    delete(tmp_file);

    normalized_paths{i} = V.fname;
end

% --- AVERAGING NORMALIZED IMAGES --- %

% Initialize the variable to store all file paths for DCC cer1
normalized_paths; % these should already contain the normalized paths from previous loop

% Check that you have the correct number of files (20 subjects)
if length(normalized_paths) ~= 20
    error('Expected 20 files for DCC cer1_3, found %d', length(normalized_paths));
end

% Load the first image to get the dimensions and header
V = spm_vol(normalized_paths{1});
[Y, ~] = spm_read_vols(V);
dims = size(Y);

% Initialize a variable to sum the images
sum_img = zeros(dims);

% Sum the images for all subjects
for i = 1:20
    V_temp = spm_vol(normalized_paths{i});
    Y_temp = spm_read_vols(V_temp);
    sum_img = sum_img + Y_temp; % Sum the images
end

% Calculate the average
avg_img = sum_img / 20;

% Save the average image
output_avg_file = fullfile(base_dir, 'Avg_results\mean_output_cer_1_3cm_DCC_norm_gm_999.nii');
Vout = V;  % Use the header from the first image for the output
Vout.fname = output_avg_file;

% Write the average image to disk
spm_write_vol(Vout, avg_img);

% Print a message
fprintf('Average NIfTI image for DCC cer1_3 saved to %s\n', output_avg_file);


%% ----- DCC cer mastoid -----------%%

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
normalized_paths = cell(num_subjects, 1);

% Your subject-specific peak values 
load('max_magnE_cer_mastoid_half_DCC_gm_999.mat')
peak_values = max_values;


% --- NORMALIZATION LOOP ---
for i = 1:num_subjects
    subject_id = subjects{i, 1};
    date_folder = subjects{i, 2};
    sequence_folder = subjects{i, 3};

    input_file = fullfile(base_dir, ...
        sprintf('%s_%s', date_folder, subject_id), ...
        [sequence_folder '_T1w_mp2rage_UNI_Images'], ...
        'Simnibs_simulation', 'simulation_cer_mastoid_DCC', ...
        'mni_volumes', ...
        [subject_id '_TMS_1-0001_MagStim_DCC_scalar_MNI_magnE.nii.gz']);

        output_path = fullfile(base_dir, ...
        sprintf('%s_%s', date_folder, subject_id), ...
        [sequence_folder '_T1w_mp2rage_UNI_Images'], ...
        'Simnibs_simulation', 'simulation_cer_mastoid_DCC', ...
        'mni_volumes')
    
    % --- UNZIP .nii.gz to TEMP FILE ---
    tmp_dir = tempdir;
    [~, fname, ~] = fileparts(input_file);  % get name without .gz
    tmp_file = fullfile(tmp_dir, fname);    % full temp path (e.g., /tmp/subject001.nii)
    
    % Unzip to temp
    gunzip(input_file, tmp_dir);  % gunzip writes to tempdir
    
    % --- LOAD, NORMALIZE, SAVE ---
    V = spm_vol(tmp_file);         % Load uncompressed file
    Y = spm_read_vols(V);          % Read data
    Y_norm = Y / peak_values(i);   % Normalize by subject-specific peak
    
    % Save normalized file
    norm_file = fullfile(output_path, [subject_id '_TMS_1-0001_MagStim_DCC_scalar_MNI_magnE_norm_gm_999.nii']);
    V.fname = norm_file;
    spm_write_vol(V, Y_norm);
    
    % Delete temp file
    delete(tmp_file);

    normalized_paths{i} = V.fname;
end

% --- AVERAGING NORMALIZED IMAGES --- %

% Initialize the variable to store all file paths for DCC cer1
normalized_paths; % these should already contain the normalized paths from previous loop

% Check that you have the correct number of files (20 subjects)
if length(normalized_paths) ~= 20
    error('Expected 20 files for DCC mastoid, found %d', length(normalized_paths));
end

% Load the first image to get the dimensions and header
V = spm_vol(normalized_paths{1});
[Y, ~] = spm_read_vols(V);
dims = size(Y);

% Initialize a variable to sum the images
sum_img = zeros(dims);

% Sum the images for all subjects
for i = 1:20
    V_temp = spm_vol(normalized_paths{i});
    Y_temp = spm_read_vols(V_temp);
    sum_img = sum_img + Y_temp; % Sum the images
end

% Calculate the average
avg_img = sum_img / 20;

% Save the average image
output_avg_file = fullfile(base_dir, 'Avg_results\mean_output_cer_mastoid_half_DCC_norm_gm_999.nii');
Vout = V;  % Use the header from the first image for the output
Vout.fname = output_avg_file;

% Write the average image to disk
spm_write_vol(Vout, avg_img);

% Print a message
fprintf('Average NIfTI image for DCC mastoid saved to %s\n', output_avg_file);

%% ----- fig8 cer1 -----------%%

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
normalized_paths = cell(num_subjects, 1);

% Your subject-specific peak values 
load('max_magnE_cer1_fig8_gm_999.mat')
peak_values = max_values;


% --- NORMALIZATION LOOP ---
for i = 1:num_subjects
    subject_id = subjects{i, 1};
    date_folder = subjects{i, 2};
    sequence_folder = subjects{i, 3};

    input_file = fullfile(base_dir, ...
        sprintf('%s_%s', date_folder, subject_id), ...
        [sequence_folder '_T1w_mp2rage_UNI_Images'], ...
        'Simnibs_simulation', 'simulation_cer1_figure8', ...
        'mni_volumes', ...
        [subject_id '_TMS_1-0001_MagStim_70mm_fig8_scalar_MNI_magnE.nii.gz']);

        output_path = fullfile(base_dir, ...
        sprintf('%s_%s', date_folder, subject_id), ...
        [sequence_folder '_T1w_mp2rage_UNI_Images'], ...
        'Simnibs_simulation', 'simulation_cer1_figure8', ...
        'mni_volumes')
    
    % --- UNZIP .nii.gz to TEMP FILE ---
    tmp_dir = tempdir;
    [~, fname, ~] = fileparts(input_file);  % get name without .gz
    tmp_file = fullfile(tmp_dir, fname);    % full temp path (e.g., /tmp/subject001.nii)
    
    % Unzip to temp
    gunzip(input_file, tmp_dir);  % gunzip writes to tempdir
    
    % --- LOAD, NORMALIZE, SAVE ---
    V = spm_vol(tmp_file);         % Load uncompressed file
    Y = spm_read_vols(V);          % Read data
    Y_norm = Y / peak_values(i);   % Normalize by subject-specific peak
    
    % Save normalized file
    norm_file = fullfile(output_path, [subject_id '_TMS_1-0001_MagStim_70mm_fig8_scalar_MNI_magnE_norm_gm_999.nii']);
    V.fname = norm_file;
    spm_write_vol(V, Y_norm);
    
    % Delete temp file
    delete(tmp_file);

    normalized_paths{i} = V.fname;
end

% --- AVERAGING NORMALIZED IMAGES --- %

% Initialize the variable to store all file paths for DCC cer1
normalized_paths; % these should already contain the normalized paths from previous loop

% Check that you have the correct number of files (20 subjects)
if length(normalized_paths) ~= 20
    error('Expected 20 files for f8 cer1, found %d', length(normalized_paths));
end

% Load the first image to get the dimensions and header
V = spm_vol(normalized_paths{1});
[Y, ~] = spm_read_vols(V);
dims = size(Y);

% Initialize a variable to sum the images
sum_img = zeros(dims);

% Sum the images for all subjects
for i = 1:20
    V_temp = spm_vol(normalized_paths{i});
    Y_temp = spm_read_vols(V_temp);
    sum_img = sum_img + Y_temp; % Sum the images
end

% Calculate the average
avg_img = sum_img / 20;

% Save the average image
output_avg_file = fullfile(base_dir, 'Avg_results\mean_output_cer1_figure8_norm_gm_999.nii');
Vout = V;  % Use the header from the first image for the output
Vout.fname = output_avg_file;

% Write the average image to disk
spm_write_vol(Vout, avg_img);

% Print a message
fprintf('Average NIfTI image for f8 cer1 saved to %s\n', output_avg_file);

%% ----- figure8 -----------%%

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
normalized_paths = cell(num_subjects, 1);

% Your subject-specific peak values 
load('max_magnE_cer_1_3cm_fig8_gm_999.mat')
peak_values = max_values;


% --- NORMALIZATION LOOP ---
for i = 1:num_subjects
    subject_id = subjects{i, 1};
    date_folder = subjects{i, 2};
    sequence_folder = subjects{i, 3};

    input_file = fullfile(base_dir, ...
        sprintf('%s_%s', date_folder, subject_id), ...
        [sequence_folder '_T1w_mp2rage_UNI_Images'], ...
        'Simnibs_simulation', 'simulation_cer_1_3cm_figure8', ...
        'mni_volumes', ...
        [subject_id '_TMS_1-0001_MagStim_70mm_fig8_scalar_MNI_magnE.nii.gz']);

        output_path = fullfile(base_dir, ...
        sprintf('%s_%s', date_folder, subject_id), ...
        [sequence_folder '_T1w_mp2rage_UNI_Images'], ...
        'Simnibs_simulation', 'simulation_cer_1_3cm_figure8', ...
        'mni_volumes')
    
    % --- UNZIP .nii.gz to TEMP FILE ---
    tmp_dir = tempdir;
    [~, fname, ~] = fileparts(input_file);  % get name without .gz
    tmp_file = fullfile(tmp_dir, fname);    % full temp path (e.g., /tmp/subject001.nii)
    
    % Unzip to temp
    gunzip(input_file, tmp_dir);  % gunzip writes to tempdir
    
    % --- LOAD, NORMALIZE, SAVE ---
    V = spm_vol(tmp_file);         % Load uncompressed file
    Y = spm_read_vols(V);          % Read data
    Y_norm = Y / peak_values(i);   % Normalize by subject-specific peak
    
    % Save normalized file
    norm_file = fullfile(output_path, [subject_id '_TMS_1-0001_MagStim_70mm_fig8_scalar_MNI_magnE_norm_gm_999.nii']);
    V.fname = norm_file;
    spm_write_vol(V, Y_norm);
    
    % Delete temp file
    delete(tmp_file);

    normalized_paths{i} = V.fname;
end

% --- AVERAGING NORMALIZED IMAGES --- %

% Initialize the variable to store all file paths for DCC cer1
normalized_paths; % these should already contain the normalized paths from previous loop

% Check that you have the correct number of files (20 subjects)
if length(normalized_paths) ~= 20
    error('Expected 20 files for f8 cer1_3, found %d', length(normalized_paths));
end

% Load the first image to get the dimensions and header
V = spm_vol(normalized_paths{1});
[Y, ~] = spm_read_vols(V);
dims = size(Y);

% Initialize a variable to sum the images
sum_img = zeros(dims);

% Sum the images for all subjects
for i = 1:20
    V_temp = spm_vol(normalized_paths{i});
    Y_temp = spm_read_vols(V_temp);
    sum_img = sum_img + Y_temp; % Sum the images
end

% Calculate the average
avg_img = sum_img / 20;

% Save the average image
output_avg_file = fullfile(base_dir, 'Avg_results\mean_output_cer_1_3cm_figure8_norm_gm_999.nii');
Vout = V;  % Use the header from the first image for the output
Vout.fname = output_avg_file;

% Write the average image to disk
spm_write_vol(Vout, avg_img);

% Print a message
fprintf('Average NIfTI image for f8 cer1_3 saved to %s\n', output_avg_file);

%% ----- figure8 cermast -----------%%

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
normalized_paths = cell(num_subjects, 1);

% Your subject-specific peak values 
load('max_magnE_cer_mastoid_half_fig8_gm_999.mat')
peak_values = max_values;


% --- NORMALIZATION LOOP ---
for i = 1:num_subjects
    subject_id = subjects{i, 1};
    date_folder = subjects{i, 2};
    sequence_folder = subjects{i, 3};

    input_file = fullfile(base_dir, ...
        sprintf('%s_%s', date_folder, subject_id), ...
        [sequence_folder '_T1w_mp2rage_UNI_Images'], ...
        'Simnibs_simulation', 'simulation_cer_mastoid_figure8', ...
        'mni_volumes', ...
        [subject_id '_TMS_1-0001_MagStim_70mm_fig8_scalar_MNI_magnE.nii.gz']);

        output_path = fullfile(base_dir, ...
        sprintf('%s_%s', date_folder, subject_id), ...
        [sequence_folder '_T1w_mp2rage_UNI_Images'], ...
        'Simnibs_simulation', 'simulation_cer_mastoid_figure8', ...
        'mni_volumes')
    
    % --- UNZIP .nii.gz to TEMP FILE ---
    tmp_dir = tempdir;
    [~, fname, ~] = fileparts(input_file);  % get name without .gz
    tmp_file = fullfile(tmp_dir, fname);    % full temp path (e.g., /tmp/subject001.nii)
    
    % Unzip to temp
    gunzip(input_file, tmp_dir);  % gunzip writes to tempdir
    
    % --- LOAD, NORMALIZE, SAVE ---
    V = spm_vol(tmp_file);         % Load uncompressed file
    Y = spm_read_vols(V);          % Read data
    Y_norm = Y / peak_values(i);   % Normalize by subject-specific peak
    
    % Save normalized file
    norm_file = fullfile(output_path, [subject_id '_TMS_1-0001_MagStim_70mm_fig8_scalar_MNI_magnE_norm_gm_999.nii']);
    V.fname = norm_file;
    spm_write_vol(V, Y_norm);
    
    % Delete temp file
    delete(tmp_file);

    normalized_paths{i} = V.fname;
end

% --- AVERAGING NORMALIZED IMAGES --- %

% Initialize the variable to store all file paths for DCC cer1
normalized_paths; % these should already contain the normalized paths from previous loop

% Check that you have the correct number of files (20 subjects)
if length(normalized_paths) ~= 20
    error('Expected 20 files for f8 mastoid, found %d', length(normalized_paths));
end

% Load the first image to get the dimensions and header
V = spm_vol(normalized_paths{1});
[Y, ~] = spm_read_vols(V);
dims = size(Y);

% Initialize a variable to sum the images
sum_img = zeros(dims);

% Sum the images for all subjects
for i = 1:20
    V_temp = spm_vol(normalized_paths{i});
    Y_temp = spm_read_vols(V_temp);
    sum_img = sum_img + Y_temp; % Sum the images
end

% Calculate the average
avg_img = sum_img / 20;

% Save the average image
output_avg_file = fullfile(base_dir, 'Avg_results\mean_output_cer_mastoid_half_figure8_norm_gm_999.nii');
Vout = V;  % Use the header from the first image for the output
Vout.fname = output_avg_file;

% Write the average image to disk
spm_write_vol(Vout, avg_img);

% Print a message
fprintf('Average NIfTI image for f8 mastoid saved to %s\n', output_avg_file);

%% END

