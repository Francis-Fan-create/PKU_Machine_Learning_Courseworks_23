function classes=tree_classify(tree,data)
%input:tree:structure,a trained tree, C45 or TV_ID3
      %data:array,one piece of data to classify
%ouput:class:array,classification result
    classes=zeros(size(data,1),1);
    for k=1:length(classes)
        datum=data(k,:);
        class=tree_classify_single(tree,datum);
        classes(k,1)=class;
    end
end

