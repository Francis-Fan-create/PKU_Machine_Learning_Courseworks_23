clear all;
% Load the agaricuslepiota table
load('agaricuslepiota.mat');

% Reorder the columns
reordered_table = agaricuslepiota(:, [2:end, 1]);

for col = 1:size(reordered_table, 2)
    [unique_classes{col}, ~, class_indices] = unique(reordered_table(:, col));
    my_data(:, col) = class_indices;
end
% Delete rows with NaN values
my_data(any(isnan(my_data), 2), :) = [];

%assume we have imported a numerical data array named my_data,with last
%column labels
split_data=cvpartition(my_data(:,end),"KFold",10);
%cross validation
train_array=zeros(10,1);
test_array=zeros(10,1);
for test_index=1:10
    train_logic=training(split_data,test_index);
    test_logic=test(split_data,test_index);
    train_data=my_data(train_logic,:);
    test_data=my_data(test_logic,:);
    tree=ID3(train_data,1:size(train_data,2)-1,1e-8);
    training_results=tree_classify(tree,train_data);
    test_results=tree_classify(tree,test_data);
    train_key=my_data(train_logic,end);
    test_key=my_data(test_logic,end);
    train_score=sum(training_results==train_key)/length(train_key);
    test_score=sum(test_results==test_key)/length(test_key);
    train_array(test_index)=train_score;
    test_array(test_index)=test_score;
end
plot(train_array','--bo');
hold on
plot(test_array','-r+')
hold off
confu(tree,test_data,'C45');
train_fin_term=mean(train_array,1)
test_fin_term=mean(test_array,1)
function tree=ID3(D,A,epsilon)


%input:D:array,dataset,with last column labels
      %A:array:indices of all features selected
      %epsilon: threshold in ID3
%output:tree:sturcture,a trained decision tree
    epsilon=epsilon/exp(0.5);
    %we use exponetially decaying threshold
    if length(unique(D(:,end)))==1
        tree.type='leaf';
        tree.label=D(1,end);
    elseif isempty(A)
        tree.type='leaf';
        tree.label=mode(D(:,end));
    else
        info_gains=zeros(length(A),1);
        j=0;
        for feature=A
            j=j+1;
            info_gain_j=info_gain(D,feature);
            info_gains(j)=info_gain_j;
        end
        [max_info_gain,max_id]=max(info_gains);
        if max_info_gain<epsilon
            tree.type='leaf';
            tree.label=mode(D(:,end));
        else
            max_feature_array=D(:,max_id);
            max_feature_classes=unique(max_feature_array);
            info_gain_classes=zeros(length(max_feature_classes),1);
            u=0;
            for class=max_feature_classes'
                u=u+1;
                temp_D=D;
                temp=(D(:,max_id)==class);
                temp_D(:,max_id)=temp;
                info_gain_class=info_gain_ratio(temp_D,max_id);
                info_gain_classes(u)=info_gain_class;
            end
            num_of_expand=ceil(length(max_feature_classes)/2);
            %choose half of nodes to expand
            tree_cell={};
            [~,classes_id]=maxk(info_gain_classes,num_of_expand);
            count=0;
            for id=classes_id'
                count=count+1;
                id_data=D(find(D(:,max_id)==id),:);
                if size(id_data,1)>0
                    A_bar=A(A~=max_id);
                    subtree=ID3(id_data,A_bar,epsilon);
                    subtree.criterion=[max_id,id];
                    tree_cell{count}=subtree;
                end
            end
            tree.children=tree_cell;
            tree.type='branch';
        end
    end
end