%% Improving Cerebellar TMS Targeting: MRI-Neuronavigation and Landmark-Based Approaches Assessed by E-Field Modeling 

% Vridhi Rohiraa*, Xavier Corominas-Teruel*, Salim Ouarab, Traian Popa, Cécile Gallea#, Antoni Valero-Cabré# & Martina Bracco#

% *Equal Contriution
% #SeniorAuthorship


% Tasks in the script:
% 1. Group average E-field projection

% Before running the scripts, the following software needs to be installed:
    % Simnibs4.0 or superior (https://simnibs.github.io/simnibs/build/html/index.html)
    % SUIT toolbox (https://www.diedrichsenlab.org/imaging/suit.htm)

%%

% Initialize subject details: ID, Date, and Sequence
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
    % Add additional subjects here
};

num_subjects = size(subjects, 1);
num_voxels = 28935; % Assuming there are 34 parcellations

% Base directory where subject folders are stored
base_dir = '...\cRETMS_MRIs';

% Initialize the matrix to store the data for all subjects
Data = zeros(num_voxels, num_subjects);

% Loop through each subject
for i = 1:num_subjects
    subject_id = subjects{i, 1};
    date_folder = subjects{i, 2};
    sequence_folder = subjects{i, 3};
    
    % Construct the full path to the data file for the current subject
    data_file = fullfile(base_dir, sprintf('%s_%s', date_folder, subject_id), ...
                        [sequence_folder '_T1w_mp2rage_UNI_Images'], ...
                        'Simnibs_simulation', 'simulation_cer_mastoid_half_DCC', ...
                        'suit', 'T1.nii', 'data.mat');
    
    % Check if the data file exists before trying to load it
    if ~isfile(data_file)
        warning('Data file not found for subject %s. Skipping.', subject_id);
        continue;
    end
    
    % Load the data structure for the current subject
    loaded_data = load(data_file); % Loads the .mat file
    
    % Store the data in the appropriate column of the Data matrix
    Data(:, i) = loaded_data.Data; % Assuming 'Data' is a column vector for each subject
    
end

%% 0.7 threshold

subject_data_1 = Data;  % Copy original data
[num_rows, num_subjects] = size(subject_data_1);

% Normalize each column using the provided max_values (1xN row vector)
subject_data_1 = subject_data_1 ./ max_values;  % Implicit expansion

% Threshold: replace values below 0.7 with NaN
subject_data_1(subject_data_1 < 0.7) = NaN;

% Count non-NaN values in each column
non_nan_counts_1 = sum(~isnan(subject_data_1), 1);  % 1 x num_subjects
non_nan_counts_1 = sum(~isnan(subject_data_1), 1)';  % Now N x 1

%% 0.5 threshold

subject_data_2 = Data;  % Copy original data
[num_rows, num_subjects] = size(subject_data_2);

% Normalize each column using the provided max_values (1xN row vector)
subject_data_2 = subject_data_2 ./ max_values;  % Implicit expansion

% Threshold: replace values below 0.7 with NaN
subject_data_2(subject_data_2 < 0.5) = NaN;

% Count non-NaN values in each column
non_nan_counts_2 = sum(~isnan(subject_data_2), 1)';  % Now N x 1

%%
