
function [iw,a] = do_suit_seg(fanat,par)

% segmentation suit

% fanat : Images T1


if ~exist('par')
    par='';
end
defpar.foldername = 'suit';
defpar.reference ='...spm12/toolbox/suit_old/atlas/Cerebellum-SUIT.nii';
defpar.refinv = {}
par = complet_struct(par,defpar);
reference =cellstr(char(par.reference));


if isempty(par.refinv)
    par.refinv = fanat;
elseif length(par.refinv) ~= length(fanat)
    error('length Refrence indidual is not same with fanat');
end
    

a ={};
nbr = 1;
for i = 1:length(fanat)
    
    
    [pp, name] = get_parent_path(fanat{i});
    name = char(name);
    
     tmp_suit = gdir(fanat{i},par.foldername);

    if ~isempty(tmp_suit)
        fprintf('%s was segmented...\n',name)
        nbr =nbr+1;
        
    else
                 
         fanat_suit = fanat(i);

        
        if isempty(fanat_suit)
             fanat_suit = gfile(pp);

        end
        
        if isempty(fanat_suit)
            error('--- no T1 file ---')
        else
            fprintf('move orientation %s',name) 
         
            folder_suit = r_mkdir(pp,par.foldername);
            fanat_suit = r_movefile(fanat_suit,folder_suit,'copy');
             
            fanat_suit = cellstr(char(fanat_suit));
            % Test number files in suit folder
            if length(fanat_suit)> 1
                fprintf('\n chose anatomique T1 image \n')
                fanat_suit = gfile(folder_suit);
            end
            
         
            
            if isempty(fanat_suit)
                fprintf('%s has no t1. skipping...\n', name);
                continue
            end
            
            
            
            if i==nbr  % get spm once
                spm fmri
            end

            fprintf('--%s : using only t1 file in suit_isolation_seg\n', name);
            suit_isolate_seg(fanat_suit, 'maskp', 0.1);
            
            % normalization with dentate mask
            job = '';
            job.subjND.gray = cellstr(char(get_subdir_regex_files(folder_suit, 'seg1', par)));
            job.subjND.white = cellstr(char(get_subdir_regex_files(folder_suit, 'seg2', par)));
            job.subjND.isolation = cellstr(char(get_subdir_regex_files(folder_suit, 'pcereb', par)));
            try
            suit_normalize_dartel(job);
            catch ME
                a = {a;{pp}};
                continue
            end
     
            %
            %         % reslice to subject space
            fprintf('--%s : reslicing to native space\n', i);
            job = '';
            job.Affine = cellstr(char(get_subdir_regex_files(folder_suit, '^Affine', par)));
            job.flowfield = cellstr(char(get_subdir_regex_files(folder_suit, '^u_a', par)));
            job.resample = reference;
            job.ref = par.refinv(i);
            suit_reslice_dartel_inv(job);
            %
            %
            %
            %         % To Get individual lobular volume
            %
            %         cerebellum_stats = char(fullfile(folder_suit, 'suit_cerebellar_lobules.csv'));
            %
            %         if ~exist(cerebellum_stats, 'file')
            %             cmd = '';
            %             cmd = sprintf('%s\necho "" >> %s\n', cmd, cerebellum_stats);
            %             cmd = sprintf('%s\necho -n subjectID, Left_I_IV, Right_I_IV, Left_V, Right_V, Left_VI, Vermis_VI, Right_VI, Left_CrusI, Vermis_CrusI, Right_CrusI, Left_CrusII, >> %s\n', cmd, cerebellum_stats);
            %             cmd = sprintf('%s\necho -n Vermis_CrusII, Right_CrusII, Left_VIIb, Vermis_VIIb, Right_VIIb, Left_VIIIa, Vermis_VIIIa, Right_VIIIa, Left_VIIIb, Vermis_VIIIb, Right_VIIIb, >> %s\n', cmd, cerebellum_stats);
            %             cmd = sprintf('%s\necho -n Left_IX, Vermis_IX, Right_IX, Left_X, Vermis_X, Right_X, Left_Dentate, Right_Dentate, Left_Interposed, Right_Interposed, Left_Fastigial, Right_Fastigial >> %s\n', cmd, cerebellum_stats);
            %             unix(cmd);
            %         end
            %
            %
            %         native_lobules = char(get_subdir_regex_files(folder_suit, 'iw_Lobules', par));
            %
            %         cmd = '';
            %         cmd = sprintf('%s\necho "" >> %s\n', cmd, cerebellum_stats);
            %         cmd = sprintf('%s\necho -n %s, >> %s\n', cmd, name, cerebellum_stats);
            %
            %         l_thresh = 0; u_thresh = 2;
            %         for kk = 1 : 34
            %             vol_cmd = sprintf('fslstats %s -l %d -u %d -V \n', native_lobules, l_thresh, u_thresh);
            %             [~, lob_vol] = unix(vol_cmd);
            %             lob_vol = regexp(lob_vol, ' ', 'split');
            %             lob_vol = lob_vol{1};
            %
            %             cmd = sprintf('%s\necho -n %s, >> %s \n', cmd, lob_vol, cerebellum_stats);
            %             l_thresh = l_thresh + 1;
            %             u_thresh = u_thresh + 1;
            %
            %         end
            %
            %         unix(cmd);
            %
            %
            %
            
            
        end
    end
end

close all ; % close spm
 iw = gfile(folder_suit, '^iw');

end

