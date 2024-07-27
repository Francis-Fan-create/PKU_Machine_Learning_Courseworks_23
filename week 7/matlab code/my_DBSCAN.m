function [idx, noise] = my_DBSCAN(data, epsilon, minPts) 

    bundle = 0;
    datasize = size(data,1);
    idx = zeros(datasize,1);
  
    distmat = pdist2(data,data);

    visited_or_not = false(datasize,1);
    noise = false(datasize,1);
 
    
    for index = 1 : datasize
        if visited_or_not(index) == false
            visited_or_not(index) = true;
            
            Neighbors = regionQuery(index, epsilon);
            if numel(Neighbors) < minPts
                noise(index) = true;
            else
                bundle = bundle + 1;
                ExpandCluster(index, Neighbors, bundle, epsilon, minPts)
            end  
        end
    end
    
    function ExpandCluster(index, Neighbors, cluster, eps, minPts)
        idx(index) = cluster;
        temp = 1;
        
        while true
            neighbor = Neighbors(temp); 
            if visited_or_not(neighbor) == false
                visited_or_not(neighbor) = true;
                NeighborsSecond = regionQuery(neighbor, eps);
                if numel(NeighborsSecond) >= minPts
                   Neighbors = [Neighbors NeighborsSecond]; 
                end
            end
            
            if idx(neighbor) == 0
                idx(neighbor) = cluster;
            end
            
            temp = temp + 1;
            if temp > numel(Neighbors)
                break;
            end
        end
    end

    function Neighbors = regionQuery(i, eps)
        Neighbors = find(distmat(i,:)<=eps);
    end
end