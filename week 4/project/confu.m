function confu(tree,test_data,name)
%input:tree:structure,a trained tree
       %test_data:array,with last column labels
       %name:string,tree's name
%output:NaN
    predict=tree_classify(tree,test_data);
    true_ans=test_data(:,end);
    figure;
    cm=confusionchart(true_ans,predict);
    conf_name=sprintf('Confusion Matrix, Tree:%s',name);
    cm.Title=conf_name;
    cm.RowSummary='row-normalized';
    cm.ColumnSummary='column-normalized';
end