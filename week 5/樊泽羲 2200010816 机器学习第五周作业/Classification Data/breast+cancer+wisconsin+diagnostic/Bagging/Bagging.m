clear all;
% Load the dataset
load wdbc.mat
f_train=wdbc(:,3:end);
l_train=wdbc(:,2);
%train model:Bagging
t=templateTree("MinLeafSize",5);    
net= fitensemble(f_train,l_train,'Bag',100,t,'Type','classification','KFold',5);
kflc = kfoldLoss(net,'Mode','cumulative');
figure;
plot(kflc);
ylabel('10-fold Misclassification rate');
xlabel('Learning cycle');