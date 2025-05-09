%% Improving Cerebellar TMS Targeting: MRI-Neuronavigation and Landmark-Based Approaches Assessed by E-Field Modeling 

% Vridhi Rohiraa*, Xavier Corominas-Teruel*, Salim Ouarab, Traian Popa, Cécile Gallea#, Antoni Valero-Cabré# & Martina Bracco#

% *Equal Contriution
% #SeniorAuthorship

% Tasks in the script:
% 1. Generate Mesh head model with Charm


%% Create mesh model 

% To create the headmodel you need to imput the MPRageised (presurfed noise
% corrected) image % the origina INV1 image.

% Names acording to original name of mri 
subject_id = 'CRETMS_01_002'

% Example
filename = ['v_CRETMS_01_002_S5_T1w_mp2rage_UNI_Images_MPRAGEised_biascorrected.nii']; % change this by your corrected image
filename_2 = ['v_CRETMS_01_002_S2_T1w_mp2rage_INV1.nii']; %change this by your INV1 image

% Bother previous images need to be in  the same folter: on my case they are at F:\BRAINMAG_Li-rTMS\DATA\BrainNMAG_05_025\MRI
path_to_mri = ['...\2022_04_29_CRETMS_01_002\Head_model\'];% change this by your root folder


% Then, Run the SIMNIBS charm protocol in the terminal to segment the head tissues. 
% Please read the SIMNIBS charm website for further information:

cd(path_to_mri)
clc;
[status,cmdout] = system(['cd ',path_to_mri],'-echo');
pwd
[status,cmdout] = system(['...MATLAB\simnibs_env\Scripts\charm',' ',subject_id,' ',filename,' ',filename_2,  ' --forceqform --forcerun'], '-echo');

%%
