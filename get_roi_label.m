function  get_roi_label(imglabels,par)


if ~exist('par','var')
    par = ''; % for defpar
end

defpar.output = '';
defpar.colorlut = '';
defpar.prefix = '';
defpar.name ={};  %
defpar.code = []; % vecteur of labels 

defpar.roicode = [];
defpar.redo     = 0;

path = pwd;

par = complet_struct(par,defpar);

%addpath('...irm/freesurfer7.0_centos08/matlab')
if isempty(par.colorlut) && isempty(par.name)
    [code, name, rgv,tt] = read_fscolorlut('...irm/freesurfer7.0_centos08/FreeSurferColorLUT.txt')
elseif isempty(par.name)
    [code, name] = readLut(par.colorlut);
    
end

if ~isempty(par.name)
    name = par.name
    code = par.code
end


nbr = 1;
for i = 1:length(imglabels)
    
    [vol_hdr, img] = nifti_spm_vol(imglabels{i});
    
    all_label = unique(img(:));
    all_label(find(isnan(all_label(:)))) = 0;
    all_label = unique(all_label(:));
    for one_label = nbr:length(all_label)
        
        dataroi = zeros(size(img));
        
        
        
        dataroi(img==all_label(one_label)) = 1;
        
        roi_name = name(code == all_label(one_label),:);
        
        roi_name = erase(roi_name, ' ');
        
        vol_hdr.fname = [par.prefix  roi_name '.nii'];
        
        cd(par.output{i});
        
        spm_write_vol(vol_hdr, dataroi);
        
    end
    
end

cd(path);

end
