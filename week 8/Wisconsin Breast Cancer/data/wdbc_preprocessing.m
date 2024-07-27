% wdbc_label=wdbc(:,1);
% wdbc_feature=wdbc(:,2:end);
% wdbc_feature=table2array(wdbc_feature)
% wdbc_label=table2array(wdbc_label);
% wdbc_bool=wdbc_label=="M";
wdbc=[wdbc_feature wdbc_bool] ;