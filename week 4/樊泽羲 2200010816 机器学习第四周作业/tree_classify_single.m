function class=tree_classify_single(tree,data)
%input:tree:structure,a trained tree, C45 or TV_ID3
      %data:array,one piece of data to classify
%ouput:class:double,classification result
        piece=data;
        class=0;
        if strcmp(tree.type,'leaf')
            class=tree.label;
        else
            for j=1:numel(tree.children)
                a_child=tree.children{j};
                if ~isempty(a_child)
                    feature=a_child.criterion(1,1);
                    region=a_child.criterion(1,2);
                    if j<=numel(tree.children)-1
                        if piece(1,feature)==region
                            class=tree_classify_single(a_child,piece);
                        end
                    else
                        if class==0
                            class=tree_classify_single(a_child,piece);
                        end
                    end
                else
                    continue;
                end
            end
        end
end

