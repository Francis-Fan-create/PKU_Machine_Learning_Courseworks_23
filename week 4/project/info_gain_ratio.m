function info_gain_ratio=info_gain_ratio(train_data,feature)
    %input: train_data:array,with last column labels
           %feature:double,corresponding to the index of feature in dat
    %output:information gain ratio of train_data on feature   
    info_gain_j=info_gain(train_data,feature);
    D=size(train_data,1);
    feature_classes=unique(train_data(:,feature));
    H_A_D=zeros(length(feature_classes),1);
    i=0;
    for feature_class=feature_classes'
        i=i+1;
        D_i=size(train_data(find(train_data(:,feature)==feature_class)),1);
        H_A_D(i)=-(D_i/D)*log2(D_i/D);
    end
    deno=sum(H_A_D);
    info_gain_ratio=info_gain_j/deno;
end