clear all;
% Load the dataset
load computer.mat
f_train=computer(:,1:end-1);
l_train=computer(:,end);
%train model:Bagging
t=templateTree("MinLeafSize",5);    
net= fitensemble(f_train,l_train,'Bag',100,t,'Type','regression','KFold',5);
kflc = kfoldLoss(net,'Mode','cumulative');
figure;
plot(kflc);
ylabel('Generalization Error');
xlabel('Learning cycle');