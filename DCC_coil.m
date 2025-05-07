
%% Improving Cerebellar TMS Targeting: MRI-Neuronavigation and Landmark-Based Approaches Assessed by E-Field Modeling 

% Vridhi Rohiraa*, Xavier Corominas-Teruel*, Salim Ouarab, Traian Popa, Cécile Gallea#, Antoni Valero-Cabré# & Martina Bracco#

% *Equal Contriution
% #SeniorAuthorship

% Tasks in the script:
% 1. Load head models (previously created with Simnibs/Charm) and do
% simulation according to your coil positions

% 2. Do projection to cerebellum with SUIT toolbox.

% Before running the scripts, the following software needs to be installed:
    % Simnibs4.0 or superior (https://simnibs.github.io/simnibs/build/html/index.html)
    % SUIT toolbox (https://www.diedrichsenlab.org/imaging/suit.htm)

%%  Set paths. 
clc;
clear all; 
close all; 

% Simnibs :
addpath('C:\Users\vridhi.rohira\Documents\MATLAB\simnibs_env\Lib\site-packages\simnibs\matlab_tools')

% Path to Suit:
addpath('\\iss\cenir\software\irm\spm12\toolbox\suit');


%%  Set subject parameters

% Define parameters
subject_id = '001';
date = '2022_04_25';
sequence = 'S04';
coil_pos = 'cer1';
coil_type = 'DCC';
rmt = 75
intensity = rmt/100*84.4e6


%% Path to originla T1 UNI presurfed;

path_to_mri_nifti = ['\\iss\cenir\analyse\irm\users\martina.bracco\cRETMS_MRIs\',date,'_CRETMS_01_',subject_id,'\',sequence,'_T1w_mp2rage_UNI_Images'];

% In case that we need to create the head model, creat it : 

%{
% Filter MP2range MRI automatically

% as a example: just need to imput the INV2 directory image and the UNi image 
% This functions is dependent of preesurfer, so we will need to install it
first (https://github.com/srikash/presurfer)
Then locate the IN2 and Uni images of your participant and run the code.

    presurf_MPRAGEise(INV2,UNI);

% Example 
presurf_MPRAGEise('E:\MartinaSimulations\001\S05_T1w_mp2rage_INV2\v_CRETMS_01_001_S5_T1w_mp2rage_INV2.nii','E:\MartinaSimulations\001\S04_T1w_mp2rage_UNI_Images\v_CRETMS_01_001_S4_T1w_mp2rage_UNI_Images.nii');

% Then create head model wtih simnibs. Change to correct path:
cd(path_to_mri_nifti)
clc;
[status,cmdout] = system(['cd ',path_to_mri_nifti],'-echo');

% Run the SIMNIBS charm protocol in the terminal to segment the head tissues. Please read the SIMNIBS website for further information:
[status,cmdout] = system(['C:\Users\XAVIER\SimNIBS-4.0\bin\charm',' ',subject_id, ' ' ,filename, ' --forceqform --forcerun'], '-echo');

%}


%% Load and visualize the surfaces generated with Charm

%{
% We are using all 9 layers of the mesh for the simulation : WM, GM, CSF, Scalp, Eye balls, Compact bone, Spongy bone, Blood, Muscle.
% Each layer will have a different conductivity (default on that case).

% GO to Root folder
cd([path_to_mri_nifti,'\m2m_cRETMS_01_',subject_id]);

%Load mesh and visualize
mesh = mesh_load_gmsh4([path_to_mri_nifti,'\m2m_cRETMS_01_',subject_id,'\cRETMS_01_',subject_id,'.msh']);
close all;


k = 1;
for i = [1,2,3,5,6,7,8,9,10]
surface_inds = find(mesh.triangle_regions == (1000+i));

meshes{k}.e = mesh.triangles(surface_inds,:);
meshes{k}.p = mesh.nodes;

k = k+1;
end


figure;
subplot(2,5,1);
surf_idx = 1; %WM
h = trisurf(meshes{surf_idx}.e, meshes{surf_idx}.p(:,1),  meshes{surf_idx}.p(:,2),...
    meshes{surf_idx}.p(:,3),'EdgeAlpha',0,'FaceAlpha',1, 'FaceColor', [0.9,0.9,0.9]);

axis off
view(-135,15)
%shading interp
lightangle(55,-35)
h.FaceLighting = 'gouraud';
h.AmbientStrength = 0.7;
h.DiffuseStrength = 0.4;
h.SpecularStrength = 0.9;
h.SpecularExponent = 25;
h.BackFaceLighting = 'lit';

subplot(2,5,2);
surf_idx = 2; %GM
h = trisurf(meshes{surf_idx}.e, meshes{surf_idx}.p(:,1),  meshes{surf_idx}.p(:,2),...
    meshes{surf_idx}.p(:,3),'EdgeAlpha',0,'FaceAlpha',1, 'FaceColor', [0.9,0.9,0.9]);

axis off
view(-135,15)
%shading interp
lightangle(55,-35)
h.FaceLighting = 'gouraud';
h.AmbientStrength = 0.7;
h.DiffuseStrength = 0.4;
h.SpecularStrength = 0.9;
h.SpecularExponent = 25;
h.BackFaceLighting = 'lit';


subplot(2,5,3);
surf_idx = 3; % CSF
h = trisurf(meshes{surf_idx}.e, meshes{surf_idx}.p(:,1),  meshes{surf_idx}.p(:,2),...
    meshes{surf_idx}.p(:,3),'EdgeAlpha',0,'FaceAlpha',1, 'FaceColor', [0.9,0.9,0.9]);
axis off
view(-135,15)
%shading interp
lightangle(55,-35)
h.FaceLighting = 'gouraud';
h.AmbientStrength = 0.7;
h.DiffuseStrength = 0.4;
h.SpecularStrength = 0.9;
h.SpecularExponent = 25;
h.BackFaceLighting = 'lit';

subplot(2,5,4);
surf_idx = 4; % Scalp

h = trisurf(meshes{surf_idx}.e, meshes{surf_idx}.p(:,1),  meshes{surf_idx}.p(:,2),...
    meshes{surf_idx}.p(:,3),'EdgeAlpha',0,'FaceAlpha',1, 'FaceColor', [254, 227, 212]/254);

axis off
view(-135,15)
%shading interp
lightangle(55,-35)
h.FaceLighting = 'gouraud';
h.AmbientStrength = 0.7;
h.DiffuseStrength = 0.4;
h.SpecularStrength = 0.9;
h.SpecularExponent = 25;
h.BackFaceLighting = 'lit';


subplot(2,5,5);
surf_idx = 5; % Eye balls
h = trisurf(meshes{surf_idx}.e, meshes{surf_idx}.p(:,1),  meshes{surf_idx}.p(:,2),...
    meshes{surf_idx}.p(:,3),'EdgeAlpha',0,'FaceAlpha',1, 'FaceColor', [254, 227, 212]/254);

axis off
view(-135,15)
%shading interp
lightangle(55,-35)
h.FaceLighting = 'gouraud';
h.AmbientStrength = 0.7;
h.DiffuseStrength = 0.4;
h.SpecularStrength = 0.9;
h.SpecularExponent = 25;
h.BackFaceLighting = 'lit';


subplot(2,5,6);
surf_idx = 6; % Compact bone
h = trisurf(meshes{surf_idx}.e, meshes{surf_idx}.p(:,1),  meshes{surf_idx}.p(:,2),...
    meshes{surf_idx}.p(:,3),'EdgeAlpha',0,'FaceAlpha',1, 'FaceColor', [254, 227, 212]/254);

axis off
view(-135,15)
%shading interp
lightangle(55,-35)
h.FaceLighting = 'gouraud';
h.AmbientStrength = 0.7;
h.DiffuseStrength = 0.4;
h.SpecularStrength = 0.9;
h.SpecularExponent = 25;
h.BackFaceLighting = 'lit';

subplot(2,5,7);
surf_idx = 7; % Spongy bone
h = trisurf(meshes{surf_idx}.e, meshes{surf_idx}.p(:,1),  meshes{surf_idx}.p(:,2),...
    meshes{surf_idx}.p(:,3),'EdgeAlpha',0,'FaceAlpha',1, 'FaceColor', [254, 227, 212]/254);

axis off
view(-135,15)
%shading interp
lightangle(55,-35)
h.FaceLighting = 'gouraud';
h.AmbientStrength = 0.7;
h.DiffuseStrength = 0.4;
h.SpecularStrength = 0.9;
h.SpecularExponent = 25;
h.BackFaceLighting = 'lit';


subplot(2,5,8);
surf_idx = 8; % Blood 
h = trisurf(meshes{surf_idx}.e, meshes{surf_idx}.p(:,1),  meshes{surf_idx}.p(:,2),...
    meshes{surf_idx}.p(:,3),'EdgeAlpha',0,'FaceAlpha',1, 'FaceColor', [254, 227, 212]/254);

axis off
view(-135,15)
%shading interp
lightangle(55,-35)
h.FaceLighting = 'gouraud';
h.AmbientStrength = 0.7;
h.DiffuseStrength = 0.4;
h.SpecularStrength = 0.9;
h.SpecularExponent = 25;
h.BackFaceLighting = 'lit';

subplot(2,5,9);
surf_idx = 9; % Eye musc.
h = trisurf(meshes{surf_idx}.e, meshes{surf_idx}.p(:,1),  meshes{surf_idx}.p(:,2),...
    meshes{surf_idx}.p(:,3),'EdgeAlpha',0,'FaceAlpha',1, 'FaceColor', [254, 227, 212]/254);

axis off
view(-135,15)
%shading interp
lightangle(55,-35)
h.FaceLighting = 'gouraud';
h.AmbientStrength = 0.7;
h.DiffuseStrength = 0.4;
h.SpecularStrength = 0.9;
h.SpecularExponent = 25;
h.BackFaceLighting = 'lit';

%}

%% Import TMS coil position from tms neuronavigator for simulation.

% As example we use Cerebellar target (cer2).
importdata([path_to_mri_nifti,'\Simnibs_simulation\',coil_pos,'.txt'])
% Brainsigh positions and simnibs are different. Transform them to simnibs
% space (https://simnibs.github.io/simnibs/build/html/documentation/neuronavigation/neuronavigation.html)

TMS_target = ans;
TMS_target.dataC(:,4) = TMS_target.data(1,1:3);
TMS_target.dataC(:,1) = TMS_target.data(1,4:6);
TMS_target.dataC(1,1) = TMS_target.dataC(1,1)*-1;
TMS_target.dataC(2,1) = TMS_target.dataC(2,1)*-1;
TMS_target.dataC(3,1) = TMS_target.dataC(3,1)*-1;
TMS_target.dataC(:,2) = TMS_target.data(1,7:9);
TMS_target.dataC(:,3) = TMS_target.data(1,10:12);
TMS_target.dataC(4,1:3) = 0;
TMS_target.dataC(4,4) = 1;


%%  RUN SIMULATION in subject 

% Save output path. Create a new folder on a desired location
save_path = ([path_to_mri_nifti ,'\Simnibs_simulation\']);
save_folder = [save_path,'simulation_',coil_pos,'_',coil_type]
if ~exist(save_folder)
      mkdir([save_folder]);
end

cd(save_folder)

% Start simulation session
s = sim_struct('SESSION');
%load mesh models of your subject
s.fnamehead = ([path_to_mri_nifti ,'\m2m_cRETMS_01_',subject_id,'\cRETMS_01_',subject_id,'.msh']);
% Output folder
s.pathfem = (save_folder);

% Fields to maps
 s.fields = 'e'; % Save the following results:
                   %  e: Electric field magnitude
                   %  E: Electric field vector
                   %  j: Current density magnitude
                   %  J: Current density vector


                   
% set different output maps                   
s.map_to_surf = true;   %  Map to subject's middle gray matter surface
s.map_to_fsavg = true;  %  Map to FreeSurfer's FSAverage group template
s.map_to_vol = true;    %  Save as nifti volume
s.map_to_MNI = true;    %  Save in MNI space

% Get fields everywhere: 
s.tissues_in_niftis = 'all'
            %s.tissues_in_niftis = [1,2,3]; % Results in the niftis will be masked 
                                            % to only show WM (1), GM (2), CSF(3)
                                            % (standarE: only GM)



% For the simulation with Figure of eight coil + automatically placing coil
% position + intensity 60% of magstim mashice and figure 8 coil:

% TMS coil position
s.poslist{1} = sim_struct('TMSLIST');
% % s.poslist{1}.pos.matsimnibs = TMS_target.dataC;%old this seems working
s.poslist{1}.pos(1).centre = [TMS_target.dataC(1,4), TMS_target.dataC(2,4),TMS_target.dataC(3,4)]; % this does not work
s.poslist{1}.pos(1).pos_ydir = 'FCz';

% Select coil
% s.poslist{1}.fnamecoil = fullfile('legacy_and_other','Magstim_70mm_Fig8.ccd'); % this is the 8 figure coil. 
s.poslist{1}.fnamecoil = fullfile('Drakaki_BrainStim_2022','MagStim_DCC.ccd'); % this is the dcc figure coil. 


% The available coils should come with the defaul installation of simnibs.
% If not, install the other coils from here:
% (https://simnibs.github.io/simnibs/build/html/documentation/coils.html#coil-fies)
% (https://github.com/simnibs/simnibs-coils)


% Coil-Scalp distance: 0mm. We select 0 because distance has to be exact
% the to the coordinates exported from Brainsight. Actually, when
% positioning the coil according to a matrix (i.e.,  coil position from
% brainsigth) this functions is not taked into account by the code.
s.poslist{1}.pos(1).distance = 2;

% Intensity. For our Magstim and coil combination 100%MSO = 114.7 di/dt A/s,
% hence, 60%MSO = 102.6 ( Based on :
% https://www.brainstimjrnl.com/article/S1935-861X(22)00077-8/fulltext )
% MagstimDCC - 84.4 - check 
s.poslist{1}.pos.didt = intensity;  


%{

%Alternatively, if there are problems of the coil positioning for the model
(given the differences betwen head models in brainsight and simnibs, place
the TMS coil manually in the MNI position with handle upwards):

% Positioning the coil according mni (transformed from subject space)
coordinates
s.poslist{1}.pos(1).centre = [TMS_target.dataC(1,4), TMS_target.dataC(2,4),TMS_target.dataC(3,4)];
 Point the coil handle up ( if you use the 8 figure coil for example, no need for de double cone coil), we just add 90 mm to the original M1 "y" coordinate
s.poslist{1}.pos(1).pos_ydir = 'O2';

% Select another coil, for example de double cone coil 
s.poslist{1}.fnamecoil = fullfile('Drakaki_BrainStim_2022','MagStim_DCC.ccd'); % this is the dcc figure coil. 

% Coil-Scalp distance: 2mm. We select 2 because we want to respect a minimum distance becasue
 the subject was wearing a cap for the electrodes. On that ocasion, this
 function will work becase we will place the coil manually and not
 according to Braisight.
s.poslist{1}.pos(1).distance = 2;

% Intensity. For our Magstim and coil combination (100%MSO = 84.4di/dt A/s, then 60%MSO = 50,6)
(Based on : https://www.brainstimjrnl.com/article/S1935-861X(22)00077-8/fulltext)
s.poslist{1}.pos.didt = 102.6e6;  

%}

run_simnibs(s)



%%  Visualize and "analyze" simulations 

%% Analyze simulations : EXAMPLE
% Subject number if different
%subject_id = '001';
head_1 = mesh_load_gmsh4([save_folder,'\cRETMS_01_',subject_id,'_TMS_1-0001_Magstim_DCC_scalar.msh']);

cortex_1.e =  head_1.triangles(head_1.triangle_regions == 1002,:);
cortex_1.p =  head_1.nodes;

% Make shure head.elements_data {2,1} corresponds to norme_E
E_field_1 = head_1.element_data{1,1}.tridata(head_1.triangle_regions==1002);
t_1 = E_field_1 > 0.5*max(E_field_1); 
figure;
trisurf(cortex_1.e,cortex_1.p(:,1),cortex_1.p(:,2),cortex_1.p(:,3),E_field_1,'EdgeAlpha',0.4)
axis off
c = colorbar
c.Limits = [0 120]
view(10,-10)
title(['E-field Strength'])
figure;
trisurf(cortex_1.e,cortex_1.p(:,1),cortex_1.p(:,2),cortex_1.p(:,3),double(t_1),'EdgeAlpha',0.4)
view(10,-10)
title(['Affected area (>50% Emax)'])
axis off
colorbar


% Some analyses exploring impact values
% Take the affected area values and compute peack, rrth percentile and median
peak = max(E_field_1);
E_field_1_av = E_field_1(E_field_1 > peak/2);
Stats_1_af(1,1) = max(E_field_1_av);
Stats_1_af(1,2) = prctile(E_field_1_av,99); % the most representative one of the peak impact 
Stats_1_af(1,3) = median(E_field_1_av);


% Another way of vizualizing results for example: 
m = mesh_load_gmsh4([save_folder,'\cRETMS_01_',subject_id,'_TMS_1-0001_Magstim_DCC_scalar.msh']);
mesh_show_surface(m);

saveas(figure(1), 'E_field_strength.fig');
saveas(figure(2), 'Affected_area.fig');
saveas(figure(3), 'Mesh_surface.fig');

%%  SUIT projection of subject results

%% Set subejct ( if different from the original one) and paths 

% Subject

location = coil_pos; 
condition = 'magnE';

% Set save path and copy t1 to the path
% cd ([path_to_mri_nifti,'\Simnibs_simulation\simulation_',coil_pos,'_',coil_type,'\']);

save_folder = [path_to_mri_nifti,'\Simnibs_simulation\simulation_',coil_pos,'_',coil_type,'\suit\']
if ~exist(save_folder)
      mkdir([save_folder]);
end


% Go to MRI subject location inside simnibs folder
cd ([path_to_mri_nifti,'\m2m_cRETMS_01_',subject_id,'\']);
% copy t1 for cer-segmentation
copyfile T1.nii.gz copy_T1.nii.gz

%
source = ([path_to_mri_nifti,'\m2m_cRETMS_01_',subject_id,'\T1.nii.gz'])
destination = ([path_to_mri_nifti,'\Simnibs_simulation\simulation_',coil_pos,'_',coil_type,'\suit\'])
movefile(source, destination);

%
movefile('copy_T1.nii.gz', 'T1.nii.gz');

%% Cerebellar parcellation from original t1

% go to suit subject folder
cd ([path_to_mri_nifti,'\Simnibs_simulation\simulation_',coil_pos,'_',coil_type,'\suit\']);

%uncompres file if compressed
compressedFile = 'T1.nii.gz';
outputFile = 'T1.nii';
gunzip(compressedFile, outputFile);

% Isolate cerebellum

addpath('C:\Users\vridhi.rohira\Documents\MATLAB\spm12')
spm('Defaults', 'fMRI');
spm_jobman('initcfg');
suit_defaults;
cd ([path_to_mri_nifti,'\Simnibs_simulation\simulation_',coil_pos,'_',coil_type,'\suit\T1.nii']);
suit_isolate_seg({'T1.nii'});

% Suit Normalization
addpath('C:\Users\vridhi.rohira\Documents\MATLAB\spm12\toolbox\OldNorm\')
addpath('C:\Users\vridhi.rohira\Documents\MATLAB\spm12\toolbox\DARTEL')
job.subjND.gray = ({['T1_seg1.nii']});
job.subjND.white = ({['T1_seg2.nii']});
job.subjND.isolation = ({['c_T1_pcereb.nii']});
suit_normalize_dartel(job);


% Uncompres image to normalize and save
cd ([path_to_mri_nifti,'\Simnibs_simulation\simulation_',coil_pos,'_',coil_type,'\subject_volumes']);
compressedFile = (['cRETMS_01_',subject_id,'_TMS_1-0001_Magstim_DCC_scalar_',condition,'.nii.gz']);
outputFile = (['cRETMS_01_',subject_id,'_TMS_1-0001_Magstim_DCC_scalar_',condition,'.nii']);
gunzip(compressedFile, outputFile);

% Move to root
sourceFile = ([path_to_mri_nifti,'\Simnibs_simulation\simulation_',coil_pos,'_',coil_type,'\subject_volumes\cRETMS_01_',subject_id,'_TMS_1-0001_Magstim_DCC_scalar_',condition,'.nii\cRETMS_01_',subject_id,'_TMS_1-0001_Magstim_DCC_scalar_',condition,'.nii']); % Replace with the actual file path
destinationFolder = ([save_path,'simulation_',coil_pos,'_',coil_type,'\suit\T1.nii\']);
% Move the file
movefile(sourceFile, destinationFolder);


% Go to suit t1 folder
 cd (destinationFolder)

% Normalization of e-fields to suit space
job.subj.affineTr = {['Affine_T1_seg1.mat']};
job.subj.flowfield = {['u_a_T1_seg1.nii']};
job.subj.resample = {['cRETMS_01_',subject_id,'_TMS_1-0001_Magstim_DCC_scalar_',condition,'.nii']};
job.subj.mask = {['c_T1_pcereb.nii']};
suit_reslice_dartel(job);


% Plot data in flat map
spm quit
Data=suit_map2surf(['wdcRETMS_01_',subject_id,'_TMS_1-0001_Magstim_DCC_scalar_magnE.nii'],'space','SUIT','stats',@minORmax,'depths', [0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8 2 2.2 2.4 2.6 2.8 3 3.2 3.4 3.78]);

%
suit_plotflatmap(Data,'threshold',50,'cscale',[0 120]) % threshold determines the lower cutoff of the values to be plotted (50%>affected area)
c = colorbar('Ticks',[0.02,0.16,0.32,0.48,0.64,0.8,0.999],'TickLabels',{'0','20','40','60','80','100','120'},'FontSize',15)
c.Label.String = 'V/m'
c.Label.FontSize = 15;
title(['E-strength mean affected area (>50V/m)'],'FontSize',20)
axis off
saveas(gcf,[subject_id,'_',condition,'_',location,'.png'])

% in case you want to save the results also in gigti format for other
% visualizators:
%{
C.cdata=suit_map2surf('wdcRETMS_01_001_TMS_1-0001_Magstim_70mm_Fig8_scalar_magnE.nii');
C=gifti(C);
save(C,'mygiftifile.func.gii');
%}

%Plot flatmp
%Data=suit_map2surf('wdcRETMS_01_001_TMS_1-0001_Magstim_70mm_Fig8_scalar_magnE.nii','space','SUIT','stats',@nanmean);

% Summarize data por lobules
data =  suit_ROI_summarize(['wdcRETMS_01_',subject_id,'_TMS_1-0001_Magstim_DCC_scalar_magnE.nii'],'atlas', ...
    'C:\Users\martina.bracco\OneDrive - ICM\Documents\MATLAB\spm12\toolbox\suit\cerebellar_atlases-master\Diedrichsen_2009\atl-Anatom_space-SUIT_dseg.nii','outfilename','lob_info');
save data 

% Results of the lobules appear per regions numbered from 1 to 34 in the c.nanmen variable.
% The list of the lobules is provided appart but here it is a resume:
   %{
Regions
    1   Left_I_IV
    2   Right_I_IV
    3   Left_V
    4   Right_V
    5   Left_VI
    6   Vermis_VI
    7   Right_VI
    8   Left_CrusI
    9   Vermis_CrusI
    10  Right_CrusI
    11  Left_CrusII
    12  Vermis_CrusII
    13  Right_CrusII
    14  Left_VIIb
    15  Vermis_VIIb
    16  Right_VIIb
    17  Left_VIIIa
    18  Vermis_VIIIa
    19  Right_VIIIa
    20  Left_VIIIb
    21  Vermis_VIIIb
    22  Right_VIIIb
    23  Left_IX
    24  Vermis_IX
    25  Right_IX
    26  Left_X
    27  Vermis_X
    28  Right_X
    29  Left_Dentate
    30  Right_Dentate
    31  Left_Interposed
    32  Right_Interposed
    33  Left_Fastigial
    34  Right_Fastigial

    %}


%% Mean of all flat maps for a given condition

% Imagine you did the procedure for 20 subjects of the 1cm-3cm based mesure
% and you want to do the mean of values and obtain the SUIT projected map
% of the group level.

% You just need to copy all your files of the SUIT individual projected
% data (i.e.,
% wdcRETMS_01_',subj,'_TMS_1-0001_Magstim_70mm_Fig8_scalar_magnE.nii), all
% together in one folder and then just do the mean of all of them. In fsl
% for example you can do something as simple as if you have 20 subject images: 


% fslmaths input1.nii.gz -add input2.nii.gz -add input3.nii.gz ... -div 20 mean_output_suit.nii.gz

%{
% 
% spm function for gran average 
% List of filenames
files = {
    'input1.nii'
    'input2.nii'
    'input3.nii'
    %...
    'input20.nii'
};

% Specify the output file
output = 'mean_output_suit.nii';

% Construct the expression for mean calculation
expr = '(i1 + i2 + i3 + ... + i20) / 20';

% Initialize the job structure
matlabbatch{1}.spm.util.imcalc.input = files;
matlabbatch{1}.spm.util.imcalc.output = output;
matlabbatch{1}.spm.util.imcalc.outdir = {''};
matlabbatch{1}.spm.util.imcalc.expression = expr;
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 16;

% Run the job
spm('defaults', 'FMRI');
spm_jobman('run', matlabbatch);

%}


% The mean_output_suit file then can be visualized in SUIT as follows (if  is compressed.gz descompress if necessary)

Data=suit_map2surf(['mean_output_suit.nii.gz'],'space','SUIT','stats',@minORmax,'depths', [0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8 2 2.2 2.4 2.6 2.8 3 3.2 3.4 3.78]);
suit_plotflatmap(Data,'threshold',50,'cscale',[0 120]) % threshold determines the lower cutoff of the values to be plotted
c = colorbar('Ticks',[0.02,0.16,0.32,0.48,0.64,0.8,0.999],'TickLabels',{'0','20','40','60','80','100','120'},'FontSize',15)
c.Label.String = 'V/m'
c.Label.FontSize = 15;
title(['E-strength mean affected area (>50V/m)'],'FontSize',20)
axis off

saveas(gcf,['afected_area_meanall.png'])
data_average = suit_ROI_summarize(['mean_output_suit.nii.gz'],'atlas','C:\Users\vridhi.rohira\Documents\MATLAB\spm12\toolbox\suit\cerebellar_atlases-master\Diedrichsen_2009\atl-Anatom_space-SUIT_dseg.nii','outfilename','lob_info');

