%% Improving Cerebellar TMS Targeting: MRI-Neuronavigation and Landmark-Based Approaches Assessed by E-Field Modeling 

% Vridhi Rohiraa*, Xavier Corominas-Teruel*, Salim Ouarab, Traian Popa, Cécile Gallea#, Antoni Valero-Cabré# & Martina Bracco#

% *Equal Contriution
% #SeniorAuthorship

% Tasks in the script:
% 1. Quantify occipital spread



addpath('') % private path to data and tools

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
base_dir = ''; %private path to data and tools
folder_structure = ''; %private path to data and tools
fsavg_msh_name = '_TMS_1-0001_Magstim_70mm_Fig8_scalar_fsavg.msh';
field_name = 'magnE';

% Initialize matrix for storing raw values for each region for each subject
num_subjects = size(subjects, 1);
raw_fields_matrix = cell(num_subjects, 4); % 4 occipital regions

% Load fsaverage mesh once outside the loop
[m_fsavg, snames] = mesh_load_fssurf('fsaverage', 'label', 'DK40');

% Loop over each subject
for i = 1:num_subjects
    sub_id = subjects{i, 1};
    date = subjects{i, 2};
    session = subjects{i, 3};

    sub_folder = fullfile(base_dir, sprintf(folder_structure, date, sub_id, session));
    mesh_file = fullfile(sub_folder, [sub_id, fsavg_msh_name]);

    if exist(mesh_file, 'file')
        disp(['File exists: ', mesh_file]);

        m = mesh_load_gmsh4(mesh_file);
        field_idx = get_field_idx(m, field_name, 'node');

        if ~isempty(field_idx)
            field_data = m.node_data{field_idx}.data;

            if isnumeric(field_data)
                regions = {'rh.lateraloccipital', 'rh.lingual', 'rh.cuneus', 'rh.pericalcarine'};

                for r = 1:length(regions)
                    region_name = regions{r};
                    roi_idx = find(strcmpi(snames, region_name));

                    if ~isempty(roi_idx)
                        node_idx = m_fsavg.node_data{end}.data == roi_idx;

                        if any(node_idx)
                            data = field_data(node_idx);

                            if ~isempty(data) && ~isnan(max_values(i)) && max_values(i) ~= 0
                                data = data / max_values(i);
                                raw_fields_matrix{i, r} = data;
                                fprintf('Subject %s: Normalized data for %s using max_values %.2f\n', sub_id, region_name, max_values(i));
                            else
                                raw_fields_matrix{i, r} = NaN;
                                fprintf('Subject %s: Skipped normalization for %s due to invalid max_values\n', sub_id, region_name);
                            end
                        else
                            raw_fields_matrix{i, r} = NaN;
                            fprintf('Subject %s: No nodes in region %s\n', sub_id, region_name);
                        end
                    else
                        raw_fields_matrix{i, r} = NaN;
                        fprintf('Subject %s: Region %s not found\n', sub_id, region_name);
                    end
                end
            else
                disp(['Field data for ', sub_id, ' is not numeric.']);
                raw_fields_matrix{i, :} = NaN;
            end
        else
            disp(['Field index for ', field_name, ' not found.']);
            raw_fields_matrix{i, :} = NaN;
        end
    else
        disp(['File not found: ', mesh_file]);
        raw_fields_matrix{i, :} = NaN;
    end
end

disp(raw_fields_matrix);

%% Weighted Average Calculation (using normalized raw_fields_matrix)

avg_fields_matrix = NaN(num_subjects, 4);  % Initialize the output matrix
[m_fsavg, snames] = mesh_load_fssurf('fsaverage', 'label', 'DK40');
nodes_areas = mesh_get_node_areas(m_fsavg);

regions = {'rh.lateraloccipital', 'rh.lingual', 'rh.cuneus', 'rh.pericalcarine'};

for i = 1:num_subjects
    sub_id = subjects{i, 1};

    for r = 1:length(regions)
        region_name = regions{r};
        roi_idx = find(strcmpi(snames, region_name));

        if ~isempty(roi_idx)
            node_idx = m_fsavg.node_data{end}.data == roi_idx;

            if any(node_idx)
                raw_values = raw_fields_matrix{i, r};
                area_values = nodes_areas(node_idx);

                if ~isempty(raw_values) && ~all(isnan(raw_values))
                    valid_idx = ~isnan(raw_values) & ~isnan(area_values);
                    raw_values_valid = raw_values(valid_idx);
                    area_values_valid = area_values(valid_idx);

                    if ~isempty(raw_values_valid)
                        weighted_avg = sum(raw_values_valid .* area_values_valid) / sum(area_values_valid);
                    else
                        weighted_avg = NaN;
                    end

                    avg_fields_matrix(i, r) = weighted_avg;
                    fprintf('Subject %s: Weighted average %s in %s: %f\n', sub_id, field_name, region_name, weighted_avg);
                else
                    avg_fields_matrix(i, r) = NaN;
                    fprintf('Subject %s: No valid values in region %s\n', sub_id, region_name);
                end
            else
                avg_fields_matrix(i, r) = NaN;
                fprintf('Subject %s: No nodes in region %s\n', sub_id, region_name);
            end
        else
            avg_fields_matrix(i, r) = NaN;
            fprintf('Subject %s: Region %s not found\n', sub_id, region_name);
        end
    end
end

lh = avg_fields_matrix(:, 1);
average_lh = nanmean(lh);

%% Plotting

regions = {'rh.lateraloccipital', 'rh.lingual', 'rh.cuneus', 'rh.pericalcarine'};

figure;
boxplot(avg_fields_matrix, 'Labels', regions);
xlabel('Regions');
ylabel(['Average ', field_name]);
title(['Box Plot of ', field_name, ' Across Subjects by Region']);
ylim([0 1])


%% END