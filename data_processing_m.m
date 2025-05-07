%% Improving Cerebellar TMS Targeting: MRI-Neuronavigation and Landmark-Based Approaches Assessed by E-Field Modeling 

% Vridhi Rohiraa*, Xavier Corominas-Teruel*, Salim Ouarab, Traian Popa, Cécile Gallea#, Antoni Valero-Cabré# & Martina Bracco#

% *Equal Contriution
% #SeniorAuthorship


% Tasks in the script:
% 1. Group average E-field projection

% Before running the scripts, the following software needs to be installed:
    % Simnibs4.0 or superior (https://simnibs.github.io/simnibs/build/html/index.html)
    % SUIT toolbox (https://www.diedrichsenlab.org/imaging/suit.htm)

%% Data processing for stats

clear all

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
num_parcellations = 34; % Assuming there are 34 parcellations

% Base directory where subject folders are stored
base_dir = '\\iss\cenir\analyse\irm\users\martina.bracco\cRETMS_MRIs';

% Initialize the matrix to store the nanmean values for all subjects
nanmean_matrix = zeros(num_parcellations, num_subjects);

% Loop through each subject
for i = 1:num_subjects
    subject_id = subjects{i, 1};
    date_folder = subjects{i, 2};
    sequence_folder = subjects{i, 3};
    
    % Construct the full path to the data file for the current subject
    data_file = fullfile(base_dir, sprintf('%s_%s', date_folder, subject_id), ...
                        [sequence_folder '_T1w_mp2rage_UNI_Images'], ...
                        'Simnibs_simulation', 'simulation_cer1_figure8', ...
                        'suit', 'T1.nii', 'data.mat');
    
    % Check if the data file exists before trying to load it
    if ~isfile(data_file)
        warning('Data file not found for subject %s. Skipping.', subject_id);
        continue;
    end
    
    % Load the data structure for the current subject
    loaded_data = load(data_file); % Loads the .mat file
    data = loaded_data.data; % Access the 'data' structure
    
    % Extract the 'nanmean' field and store it in the matrix
    nanmean_matrix(:,i) = data.nanmean; % Storing the 34x1 double into the matrix
end

%%
% % Step 1: Compute the mean across subjects (columns)
% mean_values = mean(nanmean_matrix, 2);  % 34x1 vector, mean for each parcellation
% 
% % Step 2: Compute the standard error across subjects (columns)
% standard_error = std(nanmean_matrix, 0, 2) / sqrt(num_subjects);  % 34x1 vector
% 
% % Step 3: Plot the mean values with error bars as bar plots
% figure;  % Create a new figure
% bar(mean_values, 'FaceColor', [0.7 0.7 0.7], 'EdgeColor', 'none');  % Plot as bar chart
% hold on;  % Keep the existing plot
% 
% % Add error bars to the bar chart
% errorbar(mean_values, standard_error, 'k.', 'LineWidth', 1.5);  % 'k.' for black error bars
% 
% % Step 4: Highlight specific parcellations (13, 19, 22)
% highlighted_parcellations = [13, 19, 22];  % Parcellations to highlight
% highlight_color = 'r';  % Red color for highlighting
% marker_size = 10;  % Size of the marker
% 
% % Plot red circles on the specified parcellations
% plot(highlighted_parcellations, mean_values(highlighted_parcellations), ...
%     'o', 'MarkerEdgeColor', highlight_color, 'MarkerSize', marker_size, ...
%     'LineWidth', 2);
% 
% % Add labels to the highlighted parcellations
% labels = {'Right Crus II', 'Right VIIIa', 'Right VIIIb'};  % Labels for the highlighted parcellations
% label_offset = 0.1;  % Offset to position the label above the error bar
% 
% for i = 1:length(highlighted_parcellations)
%     x = highlighted_parcellations(i);
%     y = mean_values(x);
%     err = standard_error(x);
%     
%     % Position the label slightly above the top of the error bar
%     text(x, y + err + label_offset, labels{i}, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center', ...
%         'Color', highlight_color, 'FontSize', 10, 'FontWeight', 'bold');
% end
% 
% % Step 5: Customize the plot
% xlabel('Parcellation');  % Label for x-axis
% ylabel('Mean Activation');  % Label for y-axis
% title('Mean Activation in Cerebellum with Error Bars');  % Plot title
% grid on;  % Turn on the grid for better readability
% 
% % Set the y-axis scale from 0 to 125 (uncomment if necessary)
% ylim([0 100]);
% 
% % Step 6: Set x-axis labels as parcellation names
% parcellation_names = {'Left I-IV', 'Right I-IV', 'Left V', 'Right V', 'Left VI', ...
%     'Vermis VI', 'Right VI', 'Left Crus I', 'Vermis Crus I', 'Right Crus I', ...
%     'Left Crus II', 'Vermis Crus II', 'Right Crus II', 'Left VIIb', 'Vermis VIIb', ...
%     'Right VIIb', 'Left VIIIa', 'Vermis VIIIa', 'Right VIIIa', 'Left VIIIb', ...
%     'Vermis VIIIb', 'Right VIIIb', 'Left IX', 'Vermis IX', 'Right IX', ...
%     'Left X', 'Vermis X', 'Right X', 'Left Dentate', 'Right Dentate', ...
%     'Left Interposed', 'Right Interposed', 'Left Fastigial', 'Right Fastigial'};
% 
% % Step 6: Set x-axis labels as parcellation names
% xticks(1:34);  % Assuming 34 parcellations
% xticklabels(parcellation_names);  % Set the x-axis labels to the parcellation names
% xtickangle(45);  % Rotate the x-axis labels for better readability
% 
% hold off;  % Release the plot


%% Extracting specific parcellations 

% Define the indices for the specific parcellations
index_right_crus_2 = 13;   % Parcellation 13
index_right_8a = 19;       % Parcellation 19
index_right_8b = 22;       % Parcellation 22

% Initialize matrices to store the extracted data
right_crus_2 = zeros(num_subjects, 1);
right_8a = zeros(num_subjects, 1);
right_8b = zeros(num_subjects, 1);

%Extract data for each specified parcellation
right_crus_2 = nanmean_matrix(index_right_crus_2, :);
right_8a = nanmean_matrix(index_right_8a, :);
right_8b = nanmean_matrix(index_right_8b, :);

% Display the extracted matrices
disp('Right Crus II:');
disp(right_crus_2);

disp('Right VIIIa:');
disp(right_8a);

disp('Right VIIIb:');
disp(right_8b);

% Compute the column-wise average of right_8a and right_8b
average_right_8a_b = (right_8a + right_8b) / 2;

% Display the computed average
disp('Average of Right VIIIa and Right VIIIb for each column:');
disp(average_right_8a_b);

% Transpose the matrices
right_crus_2_transposed = right_crus_2';
right_8a_transposed = right_8a';
right_8b_transposed = right_8b';
average_right_8a_b_transposed = average_right_8a_b';

% Display the transposed matrices
disp('Right Crus II Transposed:');
disp(right_crus_2_transposed);

disp('Right VIIIa Transposed:');
disp(right_8a_transposed);

disp('Right VIIIb Transposed:');
disp(right_8b_transposed);

disp('Average of Right VIIIa and Right VIIIb Transposed:');
disp(average_right_8a_b_transposed);

all_data_crusII(:,1) = right_crus_2_transposed;
all_data_lob8(:,1) = average_right_8a_b_transposed;

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
num_parcellations = 34; % Assuming there are 34 parcellations

% Base directory where subject folders are stored
base_dir = '\\iss\cenir\analyse\irm\users\martina.bracco\cRETMS_MRIs';

% Initialize the matrix to store the nanmean values for all subjects
nanmean_matrix = zeros(num_parcellations, num_subjects);

% Loop through each subject
for i = 1:num_subjects
    subject_id = subjects{i, 1};
    date_folder = subjects{i, 2};
    sequence_folder = subjects{i, 3};
    
    % Construct the full path to the data file for the current subject
    data_file = fullfile(base_dir, sprintf('%s_%s', date_folder, subject_id), ...
                        [sequence_folder '_T1w_mp2rage_UNI_Images'], ...
                        'Simnibs_simulation', 'simulation_cer_1_3cm_figure8', ...
                        'suit', 'T1.nii', 'data.mat');
    
    % Check if the data file exists before trying to load it
    if ~isfile(data_file)
        warning('Data file not found for subject %s. Skipping.', subject_id);
        continue;
    end
    
    % Load the data structure for the current subject
    loaded_data = load(data_file); % Loads the .mat file
    data = loaded_data.data; % Access the 'data' structure
    
    % Extract the 'nanmean' field and store it in the matrix
    nanmean_matrix(:,i) = data.nanmean; % Storing the 34x1 double into the matrix
end

%%
% % Step 1: Compute the mean across subjects (columns)
% mean_values = mean(nanmean_matrix, 2);  % 34x1 vector, mean for each parcellation
% 
% % Step 2: Compute the standard error across subjects (columns)
% standard_error = std(nanmean_matrix, 0, 2) / sqrt(num_subjects);  % 34x1 vector
% 
% % Step 3: Plot the mean values with error bars as bar plots
% figure;  % Create a new figure
% bar(mean_values, 'FaceColor', [0.7 0.7 0.7], 'EdgeColor', 'none');  % Plot as bar chart
% hold on;  % Keep the existing plot
% 
% % Add error bars to the bar chart
% errorbar(mean_values, standard_error, 'k.', 'LineWidth', 1.5);  % 'k.' for black error bars
% 
% % Step 4: Highlight specific parcellations (13, 19, 22)
% highlighted_parcellations = [13, 19, 22];  % Parcellations to highlight
% highlight_color = 'r';  % Red color for highlighting
% marker_size = 10;  % Size of the marker
% 
% % Plot red circles on the specified parcellations
% plot(highlighted_parcellations, mean_values(highlighted_parcellations), ...
%     'o', 'MarkerEdgeColor', highlight_color, 'MarkerSize', marker_size, ...
%     'LineWidth', 2);
% 
% % Add labels to the highlighted parcellations
% labels = {'Right Crus II', 'Right VIIIa', 'Right VIIIb'};  % Labels for the highlighted parcellations
% label_offset = 0.1;  % Offset to position the label above the error bar
% 
% for i = 1:length(highlighted_parcellations)
%     x = highlighted_parcellations(i);
%     y = mean_values(x);
%     err = standard_error(x);
%     
%     % Position the label slightly above the top of the error bar
%     text(x, y + err + label_offset, labels{i}, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center', ...
%         'Color', highlight_color, 'FontSize', 10, 'FontWeight', 'bold');
% end
% 
% % Step 5: Customize the plot
% xlabel('Parcellation');  % Label for x-axis
% ylabel('Mean Activation');  % Label for y-axis
% title('Mean Activation in Cerebellum with Error Bars');  % Plot title
% grid on;  % Turn on the grid for better readability
% 
% % Set the y-axis scale from 0 to 125 (uncomment if necessary)
% ylim([0 100]);
% 
% % Step 6: Set x-axis labels as parcellation names
% parcellation_names = {'Left I-IV', 'Right I-IV', 'Left V', 'Right V', 'Left VI', ...
%     'Vermis VI', 'Right VI', 'Left Crus I', 'Vermis Crus I', 'Right Crus I', ...
%     'Left Crus II', 'Vermis Crus II', 'Right Crus II', 'Left VIIb', 'Vermis VIIb', ...
%     'Right VIIb', 'Left VIIIa', 'Vermis VIIIa', 'Right VIIIa', 'Left VIIIb', ...
%     'Vermis VIIIb', 'Right VIIIb', 'Left IX', 'Vermis IX', 'Right IX', ...
%     'Left X', 'Vermis X', 'Right X', 'Left Dentate', 'Right Dentate', ...
%     'Left Interposed', 'Right Interposed', 'Left Fastigial', 'Right Fastigial'};
% 
% % Step 6: Set x-axis labels as parcellation names
% xticks(1:34);  % Assuming 34 parcellations
% xticklabels(parcellation_names);  % Set the x-axis labels to the parcellation names
% xtickangle(45);  % Rotate the x-axis labels for better readability
% 
% hold off;  % Release the plot


%% Extracting specific parcellations 

% Define the indices for the specific parcellations
index_right_crus_2 = 13;   % Parcellation 13
index_right_8a = 19;       % Parcellation 19
index_right_8b = 22;       % Parcellation 22

% Initialize matrices to store the extracted data
right_crus_2 = zeros(num_subjects, 1);
right_8a = zeros(num_subjects, 1);
right_8b = zeros(num_subjects, 1);

%Extract data for each specified parcellation
right_crus_2 = nanmean_matrix(index_right_crus_2, :);
right_8a = nanmean_matrix(index_right_8a, :);
right_8b = nanmean_matrix(index_right_8b, :);

% Display the extracted matrices
disp('Right Crus II:');
disp(right_crus_2);

disp('Right VIIIa:');
disp(right_8a);

disp('Right VIIIb:');
disp(right_8b);

% Compute the column-wise average of right_8a and right_8b
average_right_8a_b = (right_8a + right_8b) / 2;

% Display the computed average
disp('Average of Right VIIIa and Right VIIIb for each column:');
disp(average_right_8a_b);

% Transpose the matrices
right_crus_2_transposed = right_crus_2';
right_8a_transposed = right_8a';
right_8b_transposed = right_8b';
average_right_8a_b_transposed = average_right_8a_b';

% Display the transposed matrices
disp('Right Crus II Transposed:');
disp(right_crus_2_transposed);

disp('Right VIIIa Transposed:');
disp(right_8a_transposed);

disp('Right VIIIb Transposed:');
disp(right_8b_transposed);

disp('Average of Right VIIIa and Right VIIIb Transposed:');
disp(average_right_8a_b_transposed);

all_data_crusII(:,2) = right_crus_2_transposed;
all_data_lob8(:,2) = average_right_8a_b_transposed;

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
num_parcellations = 34; % Assuming there are 34 parcellations

% Base directory where subject folders are stored
base_dir = '\\iss\cenir\analyse\irm\users\martina.bracco\cRETMS_MRIs';

% Initialize the matrix to store the nanmean values for all subjects
nanmean_matrix = zeros(num_parcellations, num_subjects);

% Loop through each subject
for i = 1:num_subjects
    subject_id = subjects{i, 1};
    date_folder = subjects{i, 2};
    sequence_folder = subjects{i, 3};
    
    % Construct the full path to the data file for the current subject
    data_file = fullfile(base_dir, sprintf('%s_%s', date_folder, subject_id), ...
                        [sequence_folder '_T1w_mp2rage_UNI_Images'], ...
                        'Simnibs_simulation', 'simulation_cer_mastoid_half_figure8', ...
                        'suit', 'T1.nii', 'data.mat');
    
    % Check if the data file exists before trying to load it
    if ~isfile(data_file)
        warning('Data file not found for subject %s. Skipping.', subject_id);
        continue;
    end
    
    % Load the data structure for the current subject
    loaded_data = load(data_file); % Loads the .mat file
    data = loaded_data.data; % Access the 'data' structure
    
    % Extract the 'nanmean' field and store it in the matrix
    nanmean_matrix(:,i) = data.nanmean; % Storing the 34x1 double into the matrix
end

%%
% % Step 1: Compute the mean across subjects (columns)
% mean_values = mean(nanmean_matrix, 2);  % 34x1 vector, mean for each parcellation
% 
% % Step 2: Compute the standard error across subjects (columns)
% standard_error = std(nanmean_matrix, 0, 2) / sqrt(num_subjects);  % 34x1 vector
% 
% % Step 3: Plot the mean values with error bars as bar plots
% figure;  % Create a new figure
% bar(mean_values, 'FaceColor', [0.7 0.7 0.7], 'EdgeColor', 'none');  % Plot as bar chart
% hold on;  % Keep the existing plot
% 
% % Add error bars to the bar chart
% errorbar(mean_values, standard_error, 'k.', 'LineWidth', 1.5);  % 'k.' for black error bars
% 
% % Step 4: Highlight specific parcellations (13, 19, 22)
% highlighted_parcellations = [13, 19, 22];  % Parcellations to highlight
% highlight_color = 'r';  % Red color for highlighting
% marker_size = 10;  % Size of the marker
% 
% % Plot red circles on the specified parcellations
% plot(highlighted_parcellations, mean_values(highlighted_parcellations), ...
%     'o', 'MarkerEdgeColor', highlight_color, 'MarkerSize', marker_size, ...
%     'LineWidth', 2);
% 
% % Add labels to the highlighted parcellations
% labels = {'Right Crus II', 'Right VIIIa', 'Right VIIIb'};  % Labels for the highlighted parcellations
% label_offset = 0.1;  % Offset to position the label above the error bar
% 
% for i = 1:length(highlighted_parcellations)
%     x = highlighted_parcellations(i);
%     y = mean_values(x);
%     err = standard_error(x);
%     
%     % Position the label slightly above the top of the error bar
%     text(x, y + err + label_offset, labels{i}, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center', ...
%         'Color', highlight_color, 'FontSize', 10, 'FontWeight', 'bold');
% end
% 
% % Step 5: Customize the plot
% xlabel('Parcellation');  % Label for x-axis
% ylabel('Mean Activation');  % Label for y-axis
% title('Mean Activation in Cerebellum with Error Bars');  % Plot title
% grid on;  % Turn on the grid for better readability
% 
% % Set the y-axis scale from 0 to 125 (uncomment if necessary)
% ylim([0 100]);
% 
% % Step 6: Set x-axis labels as parcellation names
% parcellation_names = {'Left I-IV', 'Right I-IV', 'Left V', 'Right V', 'Left VI', ...
%     'Vermis VI', 'Right VI', 'Left Crus I', 'Vermis Crus I', 'Right Crus I', ...
%     'Left Crus II', 'Vermis Crus II', 'Right Crus II', 'Left VIIb', 'Vermis VIIb', ...
%     'Right VIIb', 'Left VIIIa', 'Vermis VIIIa', 'Right VIIIa', 'Left VIIIb', ...
%     'Vermis VIIIb', 'Right VIIIb', 'Left IX', 'Vermis IX', 'Right IX', ...
%     'Left X', 'Vermis X', 'Right X', 'Left Dentate', 'Right Dentate', ...
%     'Left Interposed', 'Right Interposed', 'Left Fastigial', 'Right Fastigial'};
% 
% % Step 6: Set x-axis labels as parcellation names
% xticks(1:34);  % Assuming 34 parcellations
% xticklabels(parcellation_names);  % Set the x-axis labels to the parcellation names
% xtickangle(45);  % Rotate the x-axis labels for better readability
% 
% hold off;  % Release the plot


%% Extracting specific parcellations 

% Define the indices for the specific parcellations
index_right_crus_2 = 13;   % Parcellation 13
index_right_8a = 19;       % Parcellation 19
index_right_8b = 22;       % Parcellation 22

% Initialize matrices to store the extracted data
right_crus_2 = zeros(num_subjects, 1);
right_8a = zeros(num_subjects, 1);
right_8b = zeros(num_subjects, 1);

%Extract data for each specified parcellation
right_crus_2 = nanmean_matrix(index_right_crus_2, :);
right_8a = nanmean_matrix(index_right_8a, :);
right_8b = nanmean_matrix(index_right_8b, :);

% Display the extracted matrices
disp('Right Crus II:');
disp(right_crus_2);

disp('Right VIIIa:');
disp(right_8a);

disp('Right VIIIb:');
disp(right_8b);

% Compute the column-wise average of right_8a and right_8b
average_right_8a_b = (right_8a + right_8b) / 2;

% Display the computed average
disp('Average of Right VIIIa and Right VIIIb for each column:');
disp(average_right_8a_b);

% Transpose the matrices
right_crus_2_transposed = right_crus_2';
right_8a_transposed = right_8a';
right_8b_transposed = right_8b';
average_right_8a_b_transposed = average_right_8a_b';

% Display the transposed matrices
disp('Right Crus II Transposed:');
disp(right_crus_2_transposed);

disp('Right VIIIa Transposed:');
disp(right_8a_transposed);

disp('Right VIIIb Transposed:');
disp(right_8b_transposed);

disp('Average of Right VIIIa and Right VIIIb Transposed:');
disp(average_right_8a_b_transposed);

all_data_crusII(:,3) = right_crus_2_transposed;
all_data_lob8(:,3) = average_right_8a_b_transposed;

%%

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
num_parcellations = 34; % Assuming there are 34 parcellations

% Base directory where subject folders are stored
base_dir = '\\iss\cenir\analyse\irm\users\martina.bracco\cRETMS_MRIs';

% Initialize the matrix to store the nanmean values for all subjects
nanmean_matrix = zeros(num_parcellations, num_subjects);

% Loop through each subject
for i = 1:num_subjects
    subject_id = subjects{i, 1};
    date_folder = subjects{i, 2};
    sequence_folder = subjects{i, 3};
    
    % Construct the full path to the data file for the current subject
    data_file = fullfile(base_dir, sprintf('%s_%s', date_folder, subject_id), ...
                        [sequence_folder '_T1w_mp2rage_UNI_Images'], ...
                        'Simnibs_simulation', 'simulation_cer1_DCC_scal_intensity', ...
                        'suit', 'T1.nii', 'data.mat');
    
    % Check if the data file exists before trying to load it
    if ~isfile(data_file)
        warning('Data file not found for subject %s. Skipping.', subject_id);
        continue;
    end
    
    % Load the data structure for the current subject
    loaded_data = load(data_file); % Loads the .mat file
    data = loaded_data.data; % Access the 'data' structure
    
    % Extract the 'nanmean' field and store it in the matrix
    nanmean_matrix(:,i) = data.nanmean; % Storing the 34x1 double into the matrix
end

%%
% % Step 1: Compute the mean across subjects (columns)
% mean_values = mean(nanmean_matrix, 2);  % 34x1 vector, mean for each parcellation
% 
% % Step 2: Compute the standard error across subjects (columns)
% standard_error = std(nanmean_matrix, 0, 2) / sqrt(num_subjects);  % 34x1 vector
% 
% % Step 3: Plot the mean values with error bars as bar plots
% figure;  % Create a new figure
% bar(mean_values, 'FaceColor', [0.7 0.7 0.7], 'EdgeColor', 'none');  % Plot as bar chart
% hold on;  % Keep the existing plot
% 
% % Add error bars to the bar chart
% errorbar(mean_values, standard_error, 'k.', 'LineWidth', 1.5);  % 'k.' for black error bars
% 
% % Step 4: Highlight specific parcellations (13, 19, 22)
% highlighted_parcellations = [13, 19, 22];  % Parcellations to highlight
% highlight_color = 'r';  % Red color for highlighting
% marker_size = 10;  % Size of the marker
% 
% % Plot red circles on the specified parcellations
% plot(highlighted_parcellations, mean_values(highlighted_parcellations), ...
%     'o', 'MarkerEdgeColor', highlight_color, 'MarkerSize', marker_size, ...
%     'LineWidth', 2);
% 
% % Add labels to the highlighted parcellations
% labels = {'Right Crus II', 'Right VIIIa', 'Right VIIIb'};  % Labels for the highlighted parcellations
% label_offset = 0.1;  % Offset to position the label above the error bar
% 
% for i = 1:length(highlighted_parcellations)
%     x = highlighted_parcellations(i);
%     y = mean_values(x);
%     err = standard_error(x);
%     
%     % Position the label slightly above the top of the error bar
%     text(x, y + err + label_offset, labels{i}, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center', ...
%         'Color', highlight_color, 'FontSize', 10, 'FontWeight', 'bold');
% end
% 
% % Step 5: Customize the plot
% xlabel('Parcellation');  % Label for x-axis
% ylabel('Mean Activation');  % Label for y-axis
% title('Mean Activation in Cerebellum with Error Bars');  % Plot title
% grid on;  % Turn on the grid for better readability
% 
% % Set the y-axis scale from 0 to 125 (uncomment if necessary)
% ylim([0 100]);
% 
% % Step 6: Set x-axis labels as parcellation names
% parcellation_names = {'Left I-IV', 'Right I-IV', 'Left V', 'Right V', 'Left VI', ...
%     'Vermis VI', 'Right VI', 'Left Crus I', 'Vermis Crus I', 'Right Crus I', ...
%     'Left Crus II', 'Vermis Crus II', 'Right Crus II', 'Left VIIb', 'Vermis VIIb', ...
%     'Right VIIb', 'Left VIIIa', 'Vermis VIIIa', 'Right VIIIa', 'Left VIIIb', ...
%     'Vermis VIIIb', 'Right VIIIb', 'Left IX', 'Vermis IX', 'Right IX', ...
%     'Left X', 'Vermis X', 'Right X', 'Left Dentate', 'Right Dentate', ...
%     'Left Interposed', 'Right Interposed', 'Left Fastigial', 'Right Fastigial'};
% 
% % Step 6: Set x-axis labels as parcellation names
% xticks(1:34);  % Assuming 34 parcellations
% xticklabels(parcellation_names);  % Set the x-axis labels to the parcellation names
% xtickangle(45);  % Rotate the x-axis labels for better readability
% 
% hold off;  % Release the plot


%% Extracting specific parcellations 

% Define the indices for the specific parcellations
index_right_crus_2 = 13;   % Parcellation 13
index_right_8a = 19;       % Parcellation 19
index_right_8b = 22;       % Parcellation 22

% Initialize matrices to store the extracted data
right_crus_2 = zeros(num_subjects, 1);
right_8a = zeros(num_subjects, 1);
right_8b = zeros(num_subjects, 1);

%Extract data for each specified parcellation
right_crus_2 = nanmean_matrix(index_right_crus_2, :);
right_8a = nanmean_matrix(index_right_8a, :);
right_8b = nanmean_matrix(index_right_8b, :);

% Display the extracted matrices
disp('Right Crus II:');
disp(right_crus_2);

disp('Right VIIIa:');
disp(right_8a);

disp('Right VIIIb:');
disp(right_8b);

% Compute the column-wise average of right_8a and right_8b
average_right_8a_b = (right_8a + right_8b) / 2;

% Display the computed average
disp('Average of Right VIIIa and Right VIIIb for each column:');
disp(average_right_8a_b);

% Transpose the matrices
right_crus_2_transposed = right_crus_2';
right_8a_transposed = right_8a';
right_8b_transposed = right_8b';
average_right_8a_b_transposed = average_right_8a_b';

% Display the transposed matrices
disp('Right Crus II Transposed:');
disp(right_crus_2_transposed);

disp('Right VIIIa Transposed:');
disp(right_8a_transposed);

disp('Right VIIIb Transposed:');
disp(right_8b_transposed);

disp('Average of Right VIIIa and Right VIIIb Transposed:');
disp(average_right_8a_b_transposed);

all_data_crusII(:,4) = right_crus_2_transposed;
all_data_lob8(:,4) = average_right_8a_b_transposed;

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
num_parcellations = 34; % Assuming there are 34 parcellations

% Base directory where subject folders are stored
base_dir = '\\iss\cenir\analyse\irm\users\martina.bracco\cRETMS_MRIs';

% Initialize the matrix to store the nanmean values for all subjects
nanmean_matrix = zeros(num_parcellations, num_subjects);

% Loop through each subject
for i = 1:num_subjects
    subject_id = subjects{i, 1};
    date_folder = subjects{i, 2};
    sequence_folder = subjects{i, 3};
    
    % Construct the full path to the data file for the current subject
    data_file = fullfile(base_dir, sprintf('%s_%s', date_folder, subject_id), ...
                        [sequence_folder '_T1w_mp2rage_UNI_Images'], ...
                        'Simnibs_simulation', 'simulation_cer_1_3cm_DCC_scal_intensity', ...
                        'suit', 'T1.nii', 'data.mat');
    
    % Check if the data file exists before trying to load it
    if ~isfile(data_file)
        warning('Data file not found for subject %s. Skipping.', subject_id);
        continue;
    end
    
    % Load the data structure for the current subject
    loaded_data = load(data_file); % Loads the .mat file
    data = loaded_data.data; % Access the 'data' structure
    
    % Extract the 'nanmean' field and store it in the matrix
    nanmean_matrix(:,i) = data.nanmean; % Storing the 34x1 double into the matrix
end

%%
% % Step 1: Compute the mean across subjects (columns)
% mean_values = mean(nanmean_matrix, 2);  % 34x1 vector, mean for each parcellation
% 
% % Step 2: Compute the standard error across subjects (columns)
% standard_error = std(nanmean_matrix, 0, 2) / sqrt(num_subjects);  % 34x1 vector
% 
% % Step 3: Plot the mean values with error bars as bar plots
% figure;  % Create a new figure
% bar(mean_values, 'FaceColor', [0.7 0.7 0.7], 'EdgeColor', 'none');  % Plot as bar chart
% hold on;  % Keep the existing plot
% 
% % Add error bars to the bar chart
% errorbar(mean_values, standard_error, 'k.', 'LineWidth', 1.5);  % 'k.' for black error bars
% 
% % Step 4: Highlight specific parcellations (13, 19, 22)
% highlighted_parcellations = [13, 19, 22];  % Parcellations to highlight
% highlight_color = 'r';  % Red color for highlighting
% marker_size = 10;  % Size of the marker
% 
% % Plot red circles on the specified parcellations
% plot(highlighted_parcellations, mean_values(highlighted_parcellations), ...
%     'o', 'MarkerEdgeColor', highlight_color, 'MarkerSize', marker_size, ...
%     'LineWidth', 2);
% 
% % Add labels to the highlighted parcellations
% labels = {'Right Crus II', 'Right VIIIa', 'Right VIIIb'};  % Labels for the highlighted parcellations
% label_offset = 0.1;  % Offset to position the label above the error bar
% 
% for i = 1:length(highlighted_parcellations)
%     x = highlighted_parcellations(i);
%     y = mean_values(x);
%     err = standard_error(x);
%     
%     % Position the label slightly above the top of the error bar
%     text(x, y + err + label_offset, labels{i}, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center', ...
%         'Color', highlight_color, 'FontSize', 10, 'FontWeight', 'bold');
% end
% 
% % Step 5: Customize the plot
% xlabel('Parcellation');  % Label for x-axis
% ylabel('Mean Activation');  % Label for y-axis
% title('Mean Activation in Cerebellum with Error Bars');  % Plot title
% grid on;  % Turn on the grid for better readability
% 
% % Set the y-axis scale from 0 to 125 (uncomment if necessary)
% ylim([0 100]);
% 
% % Step 6: Set x-axis labels as parcellation names
% parcellation_names = {'Left I-IV', 'Right I-IV', 'Left V', 'Right V', 'Left VI', ...
%     'Vermis VI', 'Right VI', 'Left Crus I', 'Vermis Crus I', 'Right Crus I', ...
%     'Left Crus II', 'Vermis Crus II', 'Right Crus II', 'Left VIIb', 'Vermis VIIb', ...
%     'Right VIIb', 'Left VIIIa', 'Vermis VIIIa', 'Right VIIIa', 'Left VIIIb', ...
%     'Vermis VIIIb', 'Right VIIIb', 'Left IX', 'Vermis IX', 'Right IX', ...
%     'Left X', 'Vermis X', 'Right X', 'Left Dentate', 'Right Dentate', ...
%     'Left Interposed', 'Right Interposed', 'Left Fastigial', 'Right Fastigial'};
% 
% % Step 6: Set x-axis labels as parcellation names
% xticks(1:34);  % Assuming 34 parcellations
% xticklabels(parcellation_names);  % Set the x-axis labels to the parcellation names
% xtickangle(45);  % Rotate the x-axis labels for better readability
% 
% hold off;  % Release the plot


%% Extracting specific parcellations 

% Define the indices for the specific parcellations
index_right_crus_2 = 13;   % Parcellation 13
index_right_8a = 19;       % Parcellation 19
index_right_8b = 22;       % Parcellation 22

% Initialize matrices to store the extracted data
right_crus_2 = zeros(num_subjects, 1);
right_8a = zeros(num_subjects, 1);
right_8b = zeros(num_subjects, 1);

%Extract data for each specified parcellation
right_crus_2 = nanmean_matrix(index_right_crus_2, :);
right_8a = nanmean_matrix(index_right_8a, :);
right_8b = nanmean_matrix(index_right_8b, :);

% Display the extracted matrices
disp('Right Crus II:');
disp(right_crus_2);

disp('Right VIIIa:');
disp(right_8a);

disp('Right VIIIb:');
disp(right_8b);

% Compute the column-wise average of right_8a and right_8b
average_right_8a_b = (right_8a + right_8b) / 2;

% Display the computed average
disp('Average of Right VIIIa and Right VIIIb for each column:');
disp(average_right_8a_b);

% Transpose the matrices
right_crus_2_transposed = right_crus_2';
right_8a_transposed = right_8a';
right_8b_transposed = right_8b';
average_right_8a_b_transposed = average_right_8a_b';

% Display the transposed matrices
disp('Right Crus II Transposed:');
disp(right_crus_2_transposed);

disp('Right VIIIa Transposed:');
disp(right_8a_transposed);

disp('Right VIIIb Transposed:');
disp(right_8b_transposed);

disp('Average of Right VIIIa and Right VIIIb Transposed:');
disp(average_right_8a_b_transposed);

all_data_crusII(:,5) = right_crus_2_transposed;
all_data_lob8(:,5) = average_right_8a_b_transposed;

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
num_parcellations = 34; % Assuming there are 34 parcellations

% Base directory where subject folders are stored
base_dir = '\\iss\cenir\analyse\irm\users\martina.bracco\cRETMS_MRIs';

% Initialize the matrix to store the nanmean values for all subjects
nanmean_matrix = zeros(num_parcellations, num_subjects);

% Loop through each subject
for i = 1:num_subjects
    subject_id = subjects{i, 1};
    date_folder = subjects{i, 2};
    sequence_folder = subjects{i, 3};
    
    % Construct the full path to the data file for the current subject
    data_file = fullfile(base_dir, sprintf('%s_%s', date_folder, subject_id), ...
                        [sequence_folder '_T1w_mp2rage_UNI_Images'], ...
                        'Simnibs_simulation', 'simulation_cer_mastoid_half_DCC_scal_intensity', ...
                        'suit', 'T1.nii', 'data.mat');
    
    % Check if the data file exists before trying to load it
    if ~isfile(data_file)
        warning('Data file not found for subject %s. Skipping.', subject_id);
        continue;
    end
    
    % Load the data structure for the current subject
    loaded_data = load(data_file); % Loads the .mat file
    data = loaded_data.data; % Access the 'data' structure
    
    % Extract the 'nanmean' field and store it in the matrix
    nanmean_matrix(:,i) = data.nanmean; % Storing the 34x1 double into the matrix
end

%%
% % Step 1: Compute the mean across subjects (columns)
% mean_values = mean(nanmean_matrix, 2);  % 34x1 vector, mean for each parcellation
% 
% % Step 2: Compute the standard error across subjects (columns)
% standard_error = std(nanmean_matrix, 0, 2) / sqrt(num_subjects);  % 34x1 vector
% 
% % Step 3: Plot the mean values with error bars as bar plots
% figure;  % Create a new figure
% bar(mean_values, 'FaceColor', [0.7 0.7 0.7], 'EdgeColor', 'none');  % Plot as bar chart
% hold on;  % Keep the existing plot
% 
% % Add error bars to the bar chart
% errorbar(mean_values, standard_error, 'k.', 'LineWidth', 1.5);  % 'k.' for black error bars
% 
% % Step 4: Highlight specific parcellations (13, 19, 22)
% highlighted_parcellations = [13, 19, 22];  % Parcellations to highlight
% highlight_color = 'r';  % Red color for highlighting
% marker_size = 10;  % Size of the marker
% 
% % Plot red circles on the specified parcellations
% plot(highlighted_parcellations, mean_values(highlighted_parcellations), ...
%     'o', 'MarkerEdgeColor', highlight_color, 'MarkerSize', marker_size, ...
%     'LineWidth', 2);
% 
% % Add labels to the highlighted parcellations
% labels = {'Right Crus II', 'Right VIIIa', 'Right VIIIb'};  % Labels for the highlighted parcellations
% label_offset = 0.1;  % Offset to position the label above the error bar
% 
% for i = 1:length(highlighted_parcellations)
%     x = highlighted_parcellations(i);
%     y = mean_values(x);
%     err = standard_error(x);
%     
%     % Position the label slightly above the top of the error bar
%     text(x, y + err + label_offset, labels{i}, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center', ...
%         'Color', highlight_color, 'FontSize', 10, 'FontWeight', 'bold');
% end
% 
% % Step 5: Customize the plot
% xlabel('Parcellation');  % Label for x-axis
% ylabel('Mean Activation');  % Label for y-axis
% title('Mean Activation in Cerebellum with Error Bars');  % Plot title
% grid on;  % Turn on the grid for better readability
% 
% % Set the y-axis scale from 0 to 125 (uncomment if necessary)
% ylim([0 100]);
% 
% % Step 6: Set x-axis labels as parcellation names
% parcellation_names = {'Left I-IV', 'Right I-IV', 'Left V', 'Right V', 'Left VI', ...
%     'Vermis VI', 'Right VI', 'Left Crus I', 'Vermis Crus I', 'Right Crus I', ...
%     'Left Crus II', 'Vermis Crus II', 'Right Crus II', 'Left VIIb', 'Vermis VIIb', ...
%     'Right VIIb', 'Left VIIIa', 'Vermis VIIIa', 'Right VIIIa', 'Left VIIIb', ...
%     'Vermis VIIIb', 'Right VIIIb', 'Left IX', 'Vermis IX', 'Right IX', ...
%     'Left X', 'Vermis X', 'Right X', 'Left Dentate', 'Right Dentate', ...
%     'Left Interposed', 'Right Interposed', 'Left Fastigial', 'Right Fastigial'};
% 
% % Step 6: Set x-axis labels as parcellation names
% xticks(1:34);  % Assuming 34 parcellations
% xticklabels(parcellation_names);  % Set the x-axis labels to the parcellation names
% xtickangle(45);  % Rotate the x-axis labels for better readability
% 
% hold off;  % Release the plot


%% Extracting specific parcellations 

% Define the indices for the specific parcellations
index_right_crus_2 = 13;   % Parcellation 13
index_right_8a = 19;       % Parcellation 19
index_right_8b = 22;       % Parcellation 22

% Initialize matrices to store the extracted data
right_crus_2 = zeros(num_subjects, 1);
right_8a = zeros(num_subjects, 1);
right_8b = zeros(num_subjects, 1);

%Extract data for each specified parcellation
right_crus_2 = nanmean_matrix(index_right_crus_2, :);
right_8a = nanmean_matrix(index_right_8a, :);
right_8b = nanmean_matrix(index_right_8b, :);

% Display the extracted matrices
disp('Right Crus II:');
disp(right_crus_2);

disp('Right VIIIa:');
disp(right_8a);

disp('Right VIIIb:');
disp(right_8b);

% Compute the column-wise average of right_8a and right_8b
average_right_8a_b = (right_8a + right_8b) / 2;

% Display the computed average
disp('Average of Right VIIIa and Right VIIIb for each column:');
disp(average_right_8a_b);

% Transpose the matrices
right_crus_2_transposed = right_crus_2';
right_8a_transposed = right_8a';
right_8b_transposed = right_8b';
average_right_8a_b_transposed = average_right_8a_b';

% Display the transposed matrices
disp('Right Crus II Transposed:');
disp(right_crus_2_transposed);

disp('Right VIIIa Transposed:');
disp(right_8a_transposed);

disp('Right VIIIb Transposed:');
disp(right_8b_transposed);

disp('Average of Right VIIIa and Right VIIIb Transposed:');
disp(average_right_8a_b_transposed);

all_data_crusII(:,6) = right_crus_2_transposed;
all_data_lob8(:,6) = average_right_8a_b_transposed;

%%
all_data = [all_data_crusII all_data_lob8]

%%