%% Improving Cerebellar TMS Targeting: MRI-Neuronavigation and Landmark-Based Approaches Assessed by E-Field Modeling 

% Vridhi Rohiraa*, Xavier Corominas-Teruel*, Salim Ouarab, Traian Popa, Cécile Gallea#, Antoni Valero-Cabré# & Martina Bracco#

% *Equal Contriution
% #SeniorAuthorship


% Tasks in the script:
% Parcelate the cerebellum and create overlay the MRI scan with the cerebellar area of interest

%% Set paths

% close all
% clear all
% clc

% mainpath = '';

% dir =[''];

%% DEFINE ORIGIN WITH SPM 
% the origin has to be set at ac (anterior commissure)

% open spm

% spm

% 1. go to fMRI
% 2. go to Display
% 3. open the right MRI file
% 4. click on origin
% 5. select ac
% 6. click on set origin
% 7. click on reorientation
% 8. choose the right one and when it ask if you want to save for the
% future press NO (need to check whether this second step is needed)
% close spm: you're now ready

%% Parcelate cerebellum

cd(dir)
fanat = gfile(dir,'sub_62.nii');


% main parcelation
par.reference = '...atlas/cerebellar_atlases/Diedrichsen_2009/atl-Anatom_space-SUIT_dseg.nii';
a = do_suit_seg(fanat,par);


%% MASK

cereb = gdir(dir,'suit')
iw = gfile(cereb,'^iw');
[outdir, ~] = get_parent_path(iw)
label = {[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31],[32],[33],[34]}

outnames = {'Left_I_IV','Right_I_IV','Left_V','Right_V','Left_VI','Vermis_VI','Right_VI','Left_CrusI','Vermis_CrusI','Right_CrusI', ...
    'Left_CrusII','Vermis_CrusII','Right_CrusII','Left_VIIb', 'Vermis_VIIb','Right_VIIb','Left_VIIIa','Vermis_VIIIa', ...
    'Right_VIIIa','Left_VIIIb','Vermis_VIIIb','Right_VIIIb','Left_IX','Vermis_IX','Right_IX','Left_X',...
    'Vermis_X','Right_X','Left_Dentate','Right_Dentate','Left_Interposed','Right_Interposed','Left_Fastigial','Right_Fastigial'}

roi = write_multiple_mask(iw,label,outnames, outdir);

cd([dir,'/suit'])


%%

[info, vol] =nifti_spm_vol(fanat{1});
[infoROi, volRoi]=  nifti_spm_vol(roi{13}); % rigth VIIIb = 22; 
myImage = vol;
myImage(volRoi>0) = 5000;

info.fname = 'anat_and_CrusII.nii'
spm_write_vol(info,myImage);

%%

[infoROi, volRoi]=  nifti_spm_vol(roi{19}); % rigth VIIIa = 19; right Crus II = 13
myImage(volRoi>0) = 100;

info.fname = 'anat_and_CrusII_VIIIa.nii'
spm_write_vol(info,myImage);

%%

[infoROi, volRoi]=  nifti_spm_vol(roi{22}); % right Crus II = 13
myImage(volRoi>0) = 100;

info.fname = 'anat_and_CrusII_VIIIa_VIIIb.nii'
spm_write_vol(info,myImage);

%%

[infoROi, volRoi]=  nifti_spm_vol(roi{16}); % rigth VIIB = 16
myImage(volRoi>0) = 1000;
info.fname = 'anat_and_VIIb.nii'
spm_write_vol(info,myImage);

%% END


