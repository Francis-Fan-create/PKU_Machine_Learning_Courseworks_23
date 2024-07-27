clear all;
% Load the dataset
load wine.mat
f_train=wine(:,2:end);
l_train=wine(:,1);
%train model:Bagging
t=templateTree("MinLeafSize",5);    
net= fitensemble(f_train,l_train,'Bag',100,t,'Type','classification','KFold',5);
kflc = kfoldLoss(net,'Mode','cumulative');
figure;
plot(kflc);
ylabel('10-fold Misclassification rate');
xlabel('Learning cycle');