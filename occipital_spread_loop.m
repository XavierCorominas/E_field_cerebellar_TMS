%% Improving Cerebellar TMS Targeting: MRI-Neuronavigation and Landmark-Based Approaches Assessed by E-Field Modeling 

% Vridhi Rohiraa*, Xavier Corominas-Teruel*, Salim Ouarab, Traian Popa, Cécile Gallea#, Antoni Valero-Cabré# & Martina Bracco#

% *Equal Contriution
% #SeniorAuthorship

% Tasks in the script:
% 1. Quantify occipital spread

%%

addpath('...\simnibs\matlab_tools')
addpath('...\MATLAB\spm12')

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
    % Add additional subjects here
};

% Base directory and folder structure
base_dir = '...\cRETMS_MRIs';
folder_structure = '%s_%s\\%s_T1w_mp2rage_UNI_Images\\Simnibs_simulation\\simulation_cer_mastoid_half_figure8_fix_intensity\\fsavg_overlays';
fsavg_msh_name = '_TMS_1-0001_Magstim_70mm_Fig8_scalar_fsavg.msh';
field_name = 'magnE';

% Initialize matrix for storing average values for each subject and region
num_subjects = size(subjects, 1);
avg_fields_matrix = NaN(num_subjects, 4); % Assuming 4 regions

% Loop over each subject
for i = 1:num_subjects
    % Extract subject details
    sub_id = subjects{i, 1};
    date = subjects{i, 2};
    session = subjects{i, 3};

    % Construct the correct folder path for the current subject
    sub_folder = fullfile(base_dir, sprintf(folder_structure, date, sub_id, session));

    % Construct the full file path
    mesh_file = fullfile(sub_folder, [sub_id, fsavg_msh_name]);

    % Check if the file exists
    if exist(mesh_file, 'file')
        disp(['File exists: ', mesh_file]);

        % Load the mesh file
        m = mesh_load_gmsh4(mesh_file); 

        % Extract field data
        field_idx = get_field_idx(m, field_name, 'node');
        if ~isempty(field_idx)
            field_data = m.node_data{field_idx}.data;
            
            if isnumeric(field_data)
                % Calculate average in predefined regions
                regions = {'lh.lateraloccipital', 'lh.lingual', 'lh.cuneus', 'lh.pericalcarine'};
                
                % Load the fsaverage mesh with region labels
                [m, snames] = mesh_load_fssurf('fsaverage', 'label', 'DK40');
                nodes_areas = mesh_get_node_areas(m);
                
                % Loop over each region
                for r = 1:length(regions)
                    region_name = regions{r};
                    roi_idx = find(strcmpi(snames, region_name));
                    
                    if ~isempty(roi_idx)
                        node_idx = m.node_data{end}.data == roi_idx;
                        
                        if any(node_idx)
                            avg_field_roi = sum(field_data(node_idx) .* nodes_areas(node_idx)) / sum(nodes_areas(node_idx));
                            avg_fields_matrix(i, r) = avg_field_roi;
                            fprintf('Subject %s: Average %s in %s: %f\n', sub_id, field_name, region_name, avg_field_roi);
                        else
                            avg_fields_matrix(i, r) = NaN;
                            fprintf('Subject %s: No nodes in region %s\n', sub_id, region_name);
                        end
                    else
                        avg_fields_matrix(i, r) = NaN;
                        fprintf('Subject %s: Region %s not found\n', sub_id, region_name);
                    end
                end
            else
                disp(['Field data for ', sub_id, ' is not numeric.']);
                avg_fields_matrix(i, :) = NaN;
            end
        else
            disp(['Field index for ', field_name, ' not found.']);
            avg_fields_matrix(i, :) = NaN;
        end
    else
        disp(['File not found: ', mesh_file]);
        avg_fields_matrix(i, :) = NaN;
    end
end

% Calculate the average of the regions for each subject
lh = avg_fields_matrix (:, 1)


%% Plotting

% Create a box plot
figure;
boxplot(avg_fields_matrix, 'Labels', regions);
xlabel('Left Hemisphere Regions');
ylabel(['Average ', field_name]);
title(['Box Plot of ', field_name, ' Across Subjects (LH)']);
ylim([0 140]);

%% Bar plot

regions = {'rh.lateraloccipital', 'rh.lingual', 'rh.cuneus', 'rh.pericalcarine'};

% Calculate mean and standard error for each region
mean_values = mean(avg_fields_matrix, 1);
stderr_values = std(avg_fields_matrix, 0, 1) / sqrt(size(avg_fields_matrix, 1));

% Create bar plot
figure;
bar(mean_values);
hold on;

% Add error bars
errorbar(mean_values, stderr_values, 'k', 'LineStyle', 'none');

% Customize plot
set(gca, 'XTickLabel', regions);
xlabel('Regions');
ylabel(['Average ', field_name]);
title(['Bar Plot of ', field_name, ' Across Subjects by Region']);
ylim([0 140]);

hold off;

%% END
