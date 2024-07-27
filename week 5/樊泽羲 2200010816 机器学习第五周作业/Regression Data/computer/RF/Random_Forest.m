clear all;
% Load the dataset
load computer.mat
f_train=computer(:,1:end-1);
l_train=computer(:,end);
%train model:RF
trees = 100;                                      % num of trees
leaf  = 5;                                        % min leaves
OOBPrediction = 'on';                             % open out of bag
OOBPredictorImportance = 'on';                    % importance of features
Method = 'regression';                            % task kind
net = TreeBagger(trees, f_train, l_train, 'OOBPredictorImportance', OOBPredictorImportance,...
      'Method', Method, 'OOBPrediction', OOBPrediction, 'minleaf', leaf);
view(net.Trees{1},Mode="graph");
plot(oobError(net))
xlabel("Number of Grown Trees")
ylabel("Generalization Error")
oobLabels = oobPredict(net);
ind = randsample(length(oobLabels),10);
table(l_train(ind,:),oobLabels(ind,:),...
    VariableNames=["TrueLabel" "PredictedLabel"])