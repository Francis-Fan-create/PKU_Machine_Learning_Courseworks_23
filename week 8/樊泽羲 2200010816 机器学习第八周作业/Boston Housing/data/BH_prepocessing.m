BH_array=table2array(BostonHousing(2:end,:));
BH_feature=BH_array(:,1:end-1);
BH_label=BH_array(:,end);
BH=[BH_feature BH_label];