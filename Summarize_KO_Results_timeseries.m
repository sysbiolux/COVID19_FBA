% Summerize results of Single Gene Deletion

% Find mat files output from essentiality analysis with SKO
model_files = dir('./KO_data/timeseries/');
model_files = {model_files.name};
model_files = model_files(find(startsWith(model_files,'SKO')));

T_SKO = cell2table(cell(0,5));

for m=1:numel(model_files)
    filepath = model_files{m};
    X = load(strcat('./KO_data/timeseries/',filepath)) ;
    models = fieldnames(X) ;
    %models = models(find(contains(models,'_cov')));
    SKO_genes = models(find(startsWith(models,'SKO_')));
    SKO_safe = SKO_genes(find(contains(SKO_genes,'_safe')));
    SKO_toxic = SKO_genes(find(contains(SKO_genes,'_toxic')));
    SKO_unk = SKO_genes(find(contains(SKO_genes,'_unk')));
    SKO_cov = models(find(contains(models,'genes_cov')));

    N = numel(SKO_safe)/1;
    for k=1:N
       grp = strsplit(filepath,'_'); %strsplit(SKO_toxic{k*2},'_')
       grp = strjoin(grp(2:3),'_');
       generic_model = strsplit(filepath,'_');
       generic_model = generic_model(4);
       generic_model = cell2mat(generic_model);
       sko_safe  = strjoin( X.(SKO_safe{k}),',');
       sko_toxic  = strjoin(X.(SKO_toxic{k})',',');
       sko_cov  = X.(SKO_cov{k});
       sko_unk  = strjoin(string(X.(SKO_unk{k}))',',')
       model_ctl  = X.('model_ctl');
       if isstruct(model_ctl) == 0
           sko_unk = strjoin(sko_cov',',');
           sko_safe = '';
           sko_toxic = '';
       end
       x = table({grp},{generic_model}, {sko_safe},{sko_toxic},{sko_unk});
       x.Properties.VariableNames = [{'Var1'},{'Var2'},{'Var3'},{'Var4'},{'Var5'}];
       T_SKO = [T_SKO ; x];
    end
end

% for xx=1:numel(model_files)
%     filepath = model_files{xx};
%     X = load(strcat('KO_data/timeseries/',filepath)) ;
%     models = fieldnames(X) ;
%     %models = models(find(contains(models,'_cov')));
%     SKO_genes = models(find(startsWith(models,'SKO_')));
%     SKO_ctl = SKO_genes(find(contains(SKO_genes,'_ctl')));
%     SKO_cov = SKO_genes(find(contains(SKO_genes,'_cov')));
%     SKO_unk = SKO_genes(find(contains(SKO_genes,'_unk')))
% 
%     N = numel(SKO_cov);
% 	filepath = filepath(5:end);
%     for k=1:N
%        grp = strsplit(filepath,'_'); %strsplit(SKO_toxic{k*2},'_')
%        grp = strjoin(grp(1:2),'_'); %grp(3)
%        %grp = cell2mat(grp); %grp{1, 1}
%        sko_ctl  =  X.(SKO_ctl{k});
%        sko_cov  = X.(SKO_cov{k});
%        model_ctl  = X.('model_ctl');
%        sko_toxic = strjoin(intersect(sko_cov,sko_ctl),',');
%        sko_safe = strjoin(setdiff(sko_cov,sko_ctl),',');
%        sko_unk = '0';
%        % search for infected models with mock model, to assign their genes
%         % as unkown safety
%        if isstruct(model_ctl) == 0
%            sko_unk = sko_safe;
%            sko_safe = '0';
%            sko_toxic = '0';
%        end
%        generic_model = strsplit(filepath,'_');
%        generic_model = generic_model(3);
%        generic_model = cell2mat(generic_model)
%        x = table({grp},{generic_model}, {sko_safe},{sko_toxic},{sko_unk});
% 
%        x.Properties.VariableNames = [{'Var1'},{'Var2'},{'Var3'},{'Var4'},{'Var5'}];
%        T_SKO = [T_SKO ; x];
%     end
% end

T_SKO.Properties.VariableNames = [{'Series'},{'RECON'},{'SKO_Safe'},{'SKO_Toxic'},{'SKO_Unknown'}]
writetable(T_SKO,'KO_data/timeseries_SKO_All.csv');


% Summerize results of Double Gene Deletion
model_files = dir('./KO_data/timeseries/');
model_files = {model_files.name};
model_files = model_files(find(startsWith(model_files,'DKO')));

T_DKO = cell2table(cell(0,5));
for i=1:numel(model_files)
    filepath = model_files{i};
    X = load(strcat('KO_data/timeseries/',filepath)) ;
    models = fieldnames(X) ;
    %models = models(find(endsWith(models,'_cov')));
    DKO_genes = models(find(startsWith(models,'DKO_')));
    DKO_safe = DKO_genes(find(contains(DKO_genes,'_safe')));
    DKO_toxic = DKO_genes(find(contains(DKO_genes,'_toxic')));
    DKO_non_ess = DKO_genes(find(contains(DKO_genes,'_non_ess')));
    DKO_syn = DKO_genes(find(contains(DKO_genes,'_syn')));
    DKO_both = DKO_genes(find(contains(DKO_genes,'_both')));
    N = numel(DKO_safe);
    for k=1:N
       grp = strsplit(filepath,'_'); %strsplit(SKO_toxic{k*2},'_')
       grp = string(strjoin(grp(2:3),'_')); %grp(3)
       dKO_safe  = X.(DKO_safe{k})
       dKO_toxic  = X.(DKO_toxic{k})
       if istable(dKO_toxic)~=1
           dKO_toxic = table(string(dKO_toxic(:,1)),string(dKO_toxic(:,2)));
           dKO_toxic.Properties.VariableNames = [{'c'},{'r'}];
       end
       if istable(dKO_safe)~=1
           dKO_safe = table(string(dKO_safe(:,1)),string(dKO_safe(:,2)));
           dKO_safe.Properties.VariableNames = [{'c'},{'r'}];
       end
       %dKO_non_ess  = X.(DKO_non_ess{k})
       %dKO_syn  = X.(DKO_syn{k})
       dKO = [dKO_safe;dKO_toxic];
       safety = [repmat('Safe_',size(dKO_safe,1),1);repmat('Toxic',size(dKO_toxic,1),1)];
       if size(safety,1)==1
           safety = char(safety);
           safety = {safety};
           safety = table(safety)
           %safety.Properties.VariableNames = {'safety'}
       else
           safety = table(safety);

       end
       generic_model = strsplit(filepath,'_');
       generic_model = generic_model(4);
       generic_model = cell2mat(generic_model)
       
       if size(safety,1)==1
           grp = grp{1}
           %generic_model = table(string([repmat(generic_model(1,3),size(dKO,1),1)]));
           %generic_model =generic_model)
           grp = repmat(grp,size(dKO,1),1);
           grp= table(string(grp));
       else
           generic_model = table([repmat(generic_model(1),size(dKO,1),1)]);
           grp = repmat(grp,size(dKO,1),1);
       end
       %x = horzcat(grp, string(dKO),table2cell( safety),table2cell(generic_model));
       x = table( grp,dKO(:,1),dKO(:,2),table2cell(safety),table2cell(generic_model));
       %x = table(x,5);
       %x1 = x.x;
       x.Properties.VariableNames = [{'Var1'},{'Var2'},{'Var3'},{'Var4'},{'Var5'}];
       T_DKO = [T_DKO ; x];
    end
end

T_DKO.Properties.VariableNames = [{'Series'},{'Gene1'},{'Gene2'},{'Safe_Toxic'},{'RECON_Model'}]
% x = horzcat(T_DKO(:,1),T_DKO(:,3),T_DKO(:,2),T_DKO(:,4),T_DKO(:,5));
% T_DKO = [T_DKO ; x];
T_DKO.Gene2 = T_DKO.Gene2.r
T_DKO.Gene1 = T_DKO.Gene1.c
% Series = T_DKO{:,1};
% T_DKO.Series = Series;
writetable(T_DKO,'KO_data/timeseries_DKO_All.csv');


