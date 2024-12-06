%% 
% This script is to parcelate the cerebellum and create overlay the MRI
% scan with the cerebellar area of interest

% Created by Salim OUARAB
% Later modified by Martina BRACCO

%%
% Before starting, make sure the MRI scan you want to use in nifti. If not,
% you can transform it by using MRICRON

%%

%% SET THE PATH
% and unzip the MRI if needed

% close all
% clear all
% 
% %first set the right path and directory and unzip the nifty file
% 
% %  mainpath = '/network/lustre/iss02/cenir/analyse/irm/users/martina.bracco/Cer_parcellation';
% mainpath = '\\l2export\iss02.cenir\analyse\irm\users\martina.bracco\Cer_parcellation\';
% 
% addpath(mainpath)
% cd(mainpath)
% 
% subj = '001'
% 
% % dir =['/network/lustre/iss02/cenir/analyse/irm/users/martina.bracco/Cer_parcellation/cRETMS_01_',subj,'/S04_T1w_mp2rage_UNI_Images'];
% dir =['\\l2export\iss02.cenir\analyse\irm\users\martina.bracco\Cer_parcellation\cRETMS_01_',subj,'\S04_T1w_mp2rage_UNI_Images'];


%%

 %unzip

%  fanat = gfile(dir,'^Images')
% 
% unzip_volume(fanat)

% fanat = gfile(dir,'^clean')

%% REMOVE THE 'SALT AND PEPPER' BACKGROUND NOISE

% open the extention of spm
spm_jobman

% To determine which regularization factor to use, you can use the job SPM > Tools > MP2RAGE > Interactive remove background
% This will display the original UNI image and the denoised version with a popup where you can enter the regularization level and check the result immediatly :

% When you are setteled with your regularization level, use "normal" job SPM > Tools > MP2RAGE > Remove background :


%% DEFINE ORIGIN WITH SPM !!!
% the origin has to be set at ac (anterior commissure)

% open spm

spm

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

%%
% set again the right path and directory and unzip the nifty file

close all
clear all

mainpath = '/network/lustre/iss02/cenir/analyse/irm/users/martina.bracco/Cer_parcellation/Linux';
% mainpath = '\\l2export\iss02.cenir\analyse\irm\users\martina.bracco\Cer_parcellation';
addpath(mainpath)
cd(mainpath)

subj = '023'

% dir =['/network/lustre/iss02/cenir/analyse/irm/users/martina.bracco/Cer_parcellation/Martina/'];

 dir =['/network/lustre/iss02/levy/analyze/valerocabre/analyse/mbracco/cRETMS_1/MRI/Collected_data/cRETMS_01_',subj,'_E2_024/S05_T1w_mp2rage_UNI_Images'];
% dir =['/network/lustre/dtlake01/levy/analyze/valerocabre/analyse/mbracco/cRETMS_1/MRI/Collected_data/cRETMS_01_002/S05_T1w_mp2rage_UNI_Images']
% dir =['\\l2export\iss02.cenir\analyse\irm\users\martina.bracco\Cer_parcellation\cRETMS_01_',subj,'\S04_T1w_mp2rage_UNI_Images\'];
cd(dir)


fanat = gfile(dir,'^clean_');


%% SEGMENT
% this is going to take a few minutes

a = do_suit_seg(fanat);


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

% you can check the results now
% module load FSL/6.0.3


% fsleyes

cd([dir,'/suit'])


%%

[info, vol] =nifti_spm_vol(fanat{1});

[infoROi, volRoi]=  nifti_spm_vol(roi{22}); % rigth VIIIb = 22; 
myImage = vol;
myImage(volRoi>0) = 5000;

info.fname = 'anat_and_VIIIb.nii'

spm_write_vol(info,myImage);

%%

[infoROi, volRoi]=  nifti_spm_vol(roi{19}); % rigth VIIIa = 19; right Crus II = 13

myImage(volRoi>0) = 1000;

info.fname = 'anat_and_VIIIb_VIIIa.nii'

spm_write_vol(info,myImage);

%%

[infoROi, volRoi]=  nifti_spm_vol(roi{13}); % right Crus II = 13

myImage(volRoi>0) = 1000;

info.fname = 'anat_and_VIIIb_VIIIa_CII.nii'

spm_write_vol(info,myImage);
%%

[infoROi, volRoi]=  nifti_spm_vol(roi{16}); % rigth VIIB = 16

myImage(volRoi>0) = 5000;

info.fname = 'anat_and_VIIIb_VIIIa_CII_VIIb.nii'

spm_write_vol(info,myImage);
%%

[info, vol] =nifti_spm_vol(fanat{1});

[infoROi, volRoi]=  nifti_spm_vol(roi{13}); % rigth VIIIb = 22; 
myImage = vol;
myImage(volRoi>0) = 5000;

info.fname = 'anat_and_CII.nii'

spm_write_vol(info,myImage);


