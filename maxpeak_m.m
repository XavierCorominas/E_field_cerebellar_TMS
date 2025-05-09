%% Improving Cerebellar TMS Targeting: MRI-Neuronavigation and Landmark-Based Approaches Assessed by E-Field Modeling 

% Vridhi Rohiraa*, Xavier Corominas-Teruel*, Salim Ouarab, Traian Popa, Cécile Gallea#, Antoni Valero-Cabré# & Martina Bracco#

% *Equal Contriution
% #SeniorAuthorship

% Tasks in the script:
% 1. Localize max peak across cohort and simulation condition

%% Localize max peak for normalization - TMS-neuronav DCC

% Define subject list with session information
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

% Base directory and folder structure
base_dir = '...\cRETMS_MRIs';
folder_structure = '%s_%s\\%s_T1w_mp2rage_UNI_Images\\Simnibs_simulation\\simulation_cer1_DCC';
fsavg_msh_name = '_TMS_1-0001_Magstim_DCC_scalar.msh';
field_name = 'magnE';

% Initialize
num_subjects = size(subjects, 1);
max_values = nan(num_subjects, 1);  % Store max magnE per subject

% Loop through all subjects
for i = 1:num_subjects
    % Get subject data
    sub_id = subjects{i, 1};
    date = subjects{i, 2};
    session = subjects{i, 3};

    % Build full mesh file path
    sub_folder = fullfile(base_dir, sprintf(folder_structure, date, sub_id, session));
    mesh_file = fullfile(sub_folder, [sub_id, fsavg_msh_name]);

    % Check if file exists
    if exist(mesh_file, 'file')
        disp(['File exists: ', mesh_file]);

        % Load mesh
        m = mesh_load_gmsh4(mesh_file);

                field_values = m.element_data{1,1}.tridata;
                field_values = field_values(m.triangle_regions==1002);

                % Remove values above the 99th percentile
                p99 = prctile(field_values, 99.9);
                filtered_values = field_values(field_values <= p99);

                % Now compute the max on filtered values
                max_values(i) = max(filtered_values);
                fprintf('Subject %s: max %s (99th percentile filtered) = %.4f\n', sub_id, field_name, max_values(i));
               
    else
        warning('Mesh file not found: %s', mesh_file);
    end
end

% Display max values matrix for all subjects
disp('Max values for each subject after 99th percentile filtering:');
disp(max_values);

% Ensure max_values is a row vector
max_values = max_values(:)';  % Convert max_values to a row vector if it's not

save('max_magnE_cer1_DCC_gm_999.mat', 'max_values')

%% Localize max peak for normalization - cer1_3 DCC

% Define subject list with session information
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

% Base directory and folder structure
base_dir = '...\cRETMS_MRIs';
folder_structure = '%s_%s\\%s_T1w_mp2rage_UNI_Images\\Simnibs_simulation\\simulation_cer_1_3cm_DCC';
fsavg_msh_name = '_TMS_1-0001_Magstim_DCC_scalar.msh';
field_name = 'magnE';

% Initialize
num_subjects = size(subjects, 1);
max_values = nan(num_subjects, 1);  % Store max magnE per subject

% Loop through all subjects
for i = 1:num_subjects
    % Get subject data
    sub_id = subjects{i, 1};
    date = subjects{i, 2};
    session = subjects{i, 3};

    % Build full mesh file path
    sub_folder = fullfile(base_dir, sprintf(folder_structure, date, sub_id, session));
    mesh_file = fullfile(sub_folder, [sub_id, fsavg_msh_name]);

    % Check if file exists
    if exist(mesh_file, 'file')
        disp(['File exists: ', mesh_file]);

        % Load mesh
        m = mesh_load_gmsh4(mesh_file);

                field_values = m.element_data{1,1}.tridata;
                field_values = field_values(m.triangle_regions==1002);

                % Remove values above the 99th percentile
                p99 = prctile(field_values, 99.9);
                filtered_values = field_values(field_values <= p99);

                % Now compute the max on filtered values
                max_values(i) = max(filtered_values);
                fprintf('Subject %s: max %s (99th percentile filtered) = %.4f\n', sub_id, field_name, max_values(i));
               
    else
        warning('Mesh file not found: %s', mesh_file);
    end
end

% Display max values matrix for all subjects
disp('Max values for each subject after 99th percentile filtering:');
disp(max_values);

% Ensure max_values is a row vector
max_values = max_values(:)';  % Convert max_values to a row vector if it's not

save('max_magnE_cer_1_3cm_DCC_gm_999.mat', 'max_values')

%% Localize max peak for normalization - cer-m DCC

% Define subject list with session information
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

% Base directory and folder structure
base_dir = '...\cRETMS_MRIs';
folder_structure = '%s_%s\\%s_T1w_mp2rage_UNI_Images\\Simnibs_simulation\\simulation_cer_mastoid_DCC';
fsavg_msh_name = '_TMS_1-0001_Magstim_DCC_scalar.msh';
field_name = 'magnE';

% Initialize
num_subjects = size(subjects, 1);
max_values = nan(num_subjects, 1);  % Store max magnE per subject

% Loop through all subjects
for i = 1:num_subjects
    % Get subject data
    sub_id = subjects{i, 1};
    date = subjects{i, 2};
    session = subjects{i, 3};

    % Build full mesh file path
    sub_folder = fullfile(base_dir, sprintf(folder_structure, date, sub_id, session));
    mesh_file = fullfile(sub_folder, [sub_id, fsavg_msh_name]);

    % Check if file exists
    if exist(mesh_file, 'file')
        disp(['File exists: ', mesh_file]);

        % Load mesh
        m = mesh_load_gmsh4(mesh_file);

                field_values = m.element_data{1,1}.tridata;
                field_values = field_values(m.triangle_regions==1002);

                % Remove values above the 99th percentile
                p99 = prctile(field_values, 99.9);
                filtered_values = field_values(field_values <= p99);

                % Now compute the max on filtered values
                max_values(i) = max(filtered_values);
                fprintf('Subject %s: max %s (99th percentile filtered) = %.4f\n', sub_id, field_name, max_values(i));
               
    else
        warning('Mesh file not found: %s', mesh_file);
    end
end

% Display max values matrix for all subjects
disp('Max values for each subject after 99th percentile filtering:');
disp(max_values);

% Ensure max_values is a row vector
max_values = max_values(:)';  % Convert max_values to a row vector if it's not

save('max_magnE_cer_mastoid_half_DCC_gm_999.mat', 'max_values')

%% Localize max peak for normalization - TMS neuronav fig8

% Define subject list with session information
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

% Base directory and folder structure
base_dir = '...\cRETMS_MRIs';
folder_structure = '%s_%s\\%s_T1w_mp2rage_UNI_Images\\Simnibs_simulation\\simulation_cer1_figure8';
fsavg_msh_name = '_TMS_1-0001_Magstim_70mm_Fig8_scalar.msh';
field_name = 'magnE';

% Initialize
num_subjects = size(subjects, 1);
max_values = nan(num_subjects, 1);  % Store max magnE per subject

% Loop through all subjects
for i = 1:num_subjects
    % Get subject data
    sub_id = subjects{i, 1};
    date = subjects{i, 2};
    session = subjects{i, 3};

    % Build full mesh file path
    sub_folder = fullfile(base_dir, sprintf(folder_structure, date, sub_id, session));
    mesh_file = fullfile(sub_folder, [sub_id, fsavg_msh_name]);

    % Check if file exists
    if exist(mesh_file, 'file')
        disp(['File exists: ', mesh_file]);

        % Load mesh
        m = mesh_load_gmsh4(mesh_file);

                field_values = m.element_data{1,1}.tridata;
                field_values = field_values(m.triangle_regions==1002);

                % Remove values above the 99th percentile
                p99 = prctile(field_values, 99.9);
                filtered_values = field_values(field_values <= p99);

                % Now compute the max on filtered values
                max_values(i) = max(filtered_values);
                fprintf('Subject %s: max %s (99th percentile filtered) = %.4f\n', sub_id, field_name, max_values(i));
               
    else
        warning('Mesh file not found: %s', mesh_file);
    end
end

% Display max values matrix for all subjects
disp('Max values for each subject after 99th percentile filtering:');
disp(max_values);

% Ensure max_values is a row vector
max_values = max_values(:)';  % Convert max_values to a row vector if it's not

save('max_magnE_cer1_fig8_gm_999.mat', 'max_values')

%% Localize max peak for normalization - cer1_3 fig8

% Define subject list with session information
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

% Base directory and folder structure
base_dir = '...\cRETMS_MRIs';
folder_structure = '%s_%s\\%s_T1w_mp2rage_UNI_Images\\Simnibs_simulation\\simulation_cer_1_3cm_figure8';
fsavg_msh_name = '_TMS_1-0001_Magstim_70mm_fig8_scalar.msh';
field_name = 'magnE';

% Initialize
num_subjects = size(subjects, 1);
max_values = nan(num_subjects, 1);  % Store max magnE per subject

% Loop through all subjects
for i = 1:num_subjects
    % Get subject data
    sub_id = subjects{i, 1};
    date = subjects{i, 2};
    session = subjects{i, 3};

    % Build full mesh file path
    sub_folder = fullfile(base_dir, sprintf(folder_structure, date, sub_id, session));
    mesh_file = fullfile(sub_folder, [sub_id, fsavg_msh_name]);

    % Check if file exists
    if exist(mesh_file, 'file')
        disp(['File exists: ', mesh_file]);

        % Load mesh
        m = mesh_load_gmsh4(mesh_file);

                field_values = m.element_data{1,1}.tridata;
                field_values = field_values(m.triangle_regions==1002);

                % Remove values above the 99th percentile
                p99 = prctile(field_values, 99.9);
                filtered_values = field_values(field_values <= p99);

                % Now compute the max on filtered values
                max_values(i) = max(filtered_values);
                fprintf('Subject %s: max %s (99th percentile filtered) = %.4f\n', sub_id, field_name, max_values(i));
               
    else
        warning('Mesh file not found: %s', mesh_file);
    end
end

% Display max values matrix for all subjects
disp('Max values for each subject after 99th percentile filtering:');
disp(max_values);

% Ensure max_values is a row vector
max_values = max_values(:)';  % Convert max_values to a row vector if it's not

save('max_magnE_cer_1_3cm_fig8_gm_999.mat', 'max_values')

%% Localize max peak for normalization - cer-m fig8

% Define subject list with session information
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

% Base directory and folder structure
base_dir = '...\cRETMS_MRIs';
folder_structure = '%s_%s\\%s_T1w_mp2rage_UNI_Images\\Simnibs_simulation\\simulation_cer_mastoid_figure8';
fsavg_msh_name = '_TMS_1-0001_Magstim_70mm_Fig8_scalar.msh';
field_name = 'magnE';

% Initialize
num_subjects = size(subjects, 1);
max_values = nan(num_subjects, 1);  % Store max magnE per subject

% Loop through all subjects
for i = 1:num_subjects
    % Get subject data
    sub_id = subjects{i, 1};
    date = subjects{i, 2};
    session = subjects{i, 3};

    % Build full mesh file path
    sub_folder = fullfile(base_dir, sprintf(folder_structure, date, sub_id, session));
    mesh_file = fullfile(sub_folder, [sub_id, fsavg_msh_name]);

    % Check if file exists
    if exist(mesh_file, 'file')
        disp(['File exists: ', mesh_file]);

        % Load mesh
        m = mesh_load_gmsh4(mesh_file);

                field_values = m.element_data{1,1}.tridata;
                field_values = field_values(m.triangle_regions==1002);

                % Remove values above the 99th percentile
                p99 = prctile(field_values, 99.9);
                filtered_values = field_values(field_values <= p99);

                % Now compute the max on filtered values
                max_values(i) = max(filtered_values);
                fprintf('Subject %s: max %s (99th percentile filtered) = %.4f\n', sub_id, field_name, max_values(i));
               
    else
        warning('Mesh file not found: %s', mesh_file);
    end
end

% Display max values matrix for all subjects
disp('Max values for each subject after 99th percentile filtering:');
disp(max_values);

% Ensure max_values is a row vector
max_values = max_values(:)';  % Convert max_values to a row vector if it's not

save('max_magnE_cer_mastoid_half_fig8_gm_999.mat', 'max_values')

%% END
