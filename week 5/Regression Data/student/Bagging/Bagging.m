clear all;
% Load the dataset
load student.mat
f_train=student(:,1:end-1);
l_train=student(:,end);
%train model:Bagging
t=templateTree("MinLeafSize",5);    
net= fitensemble(f_train,l_train,'Bag',100,t,'Type','regression','KFold',5);
kflc = kfoldLoss(net,'Mode','cumulative');
figure;
plot(kflc);
ylabel('Generalization Error');
xlabel('Learning cycle');