clear all;
%twospirals
sp=twospirals(200,360,50,1.5,15);
%corners
% cor=corners(500);
% data=cor(:,1:2);
data=sp(:,1:2);
figure();
scatter(data(:,1),data(:,2),36,'blue','o')
saveas(gcf,'spiral_uncluster','png');
% saveas(gcf,'corner_uncluster','png');
% Specify range of epsilon and minPts values to test
epsilon_values = [0.2 0.4 0.6];
minPts_values = [5 10 15];
% Loop through parameter combinations
results = [];
for i = 1:length(epsilon_values)
   epsilon = epsilon_values(i);
   for j = 1:length(minPts_values)
       minPts = minPts_values(j);
       tic;
       % Run DBSCAN
       labels = my_DBSCAN(data, epsilon, minPts); 
       
       % Store clustering results  
       nClusters = max(labels);
       runtime = toc;  
       results = [results; nClusters runtime];
      
       % Plot clusters on PCA projection for visualization
       coeff = pca(data);  
       pcaData=data*coeff;
       figure();
       subplot(1,2,1);
       gscatter(pcaData(:,1),pcaData(:,2),labels,[],"o",3,'off')
       subplot(1,2,2);
       silhouette(data,labels)
       title(['$\epsilon=$' num2str(epsilon) ' minPts=' num2str(minPts)],'Interpreter','latex')
       name=sprintf('spiral_cluster_%d_%d',i,j);
       % name=sprintf('corner_cluster_%d_%d',i,j);
       saveas(gcf,name,'png')
   end
end

% Analyze results
figure; 
subplot(1,2,1); 
plot(results(:,1)); 
title('Number of Clusters');
subplot(1,2,2);
plot(results(:,2)); 
title('Run Time');
saveas(gcf,'experiment_result','png')

