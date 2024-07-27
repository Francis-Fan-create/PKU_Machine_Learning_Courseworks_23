function TV_gain=TV_gain(train_data,feature)
    %input: train_data:array,with last column labels
           %feature:double,corresponding to the index of feature in dat
    %output:TV gain of train_data on feature 
    classes=unique(train_data(:,end));
    K=length(classes);
    D=size(train_data,1);
    empirical_TV_array=zeros(K,1);
    k=0;
    for class=classes'
        k=k+1;
        C_k=sum(train_data(:,end)==class);
        empirical_TV_array(k)=-abs((C_k/D)-(1/K));
    end
    empirical_TV=sum(empirical_TV_array);
    feature_classes=unique(train_data(:,feature));
    n=length(feature_classes);
    conditional_TV_array=zeros(n,1);
    i=0;
    for feature_class=feature_classes'
        i=i+1;
        K_array=zeros(K,1);
        D_i_data=train_data(find(train_data(:,feature)==feature_class),:);
        D_i=length(D_i_data);
        for k=1:K
            D_ik=sum(D_i_data(:,end)==k);
            K_array(k)=-(D_i/D)*abs((D_ik/D_i)-(1/K));
        end
        conditional_TV_array(i)=sum(K_array);
    end
    conditional_TV=sum(conditional_TV_array);
    TV_gain=empirical_TV-conditional_TV;
end
