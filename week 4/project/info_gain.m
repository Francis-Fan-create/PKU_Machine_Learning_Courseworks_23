function info_gain=info_gain(train_data,feature)
    %input: train_data:array,with last column labels
           %feature:double,corresponding to the index of feature in dat
    %output:information gain of train_data on feature 
    classes=unique(train_data(:,end));
    K=length(classes);
    D=size(train_data,1);
    k=0;
    empirical_entropy_array=zeros(K,1);
    for class=classes'
        k=k+1;
        C_k=sum(train_data(:,end)==class);
        empirical_entropy_array(k)=-(C_k/D)*log2(C_k/D);
    end
    empirical_entropy=sum(empirical_entropy_array);
    feature_classes=unique(train_data(:,feature));
    n=length(feature_classes);
    conditional_entropy_array=zeros(n,1);
    i=0;
    for feature_class=feature_classes'
        i=i+1;
        K_array=zeros(K,1);
        D_i_data=train_data(find(train_data(:,feature)==feature_class),:);
        D_i=size(D_i_data,1);
        for k=1:K
            D_ik=sum(D_i_data(:,end)==k);
            if D_ik~=0
                K_array(k,1)=-(D_ik/D_i)*log2(D_ik/D_i)*(D_i/D);
            end
        end
        conditional_entropy_array(i)=sum(K_array);
    end
    conditional_entropy=sum(conditional_entropy_array);
    info_gain=empirical_entropy-conditional_entropy;
end