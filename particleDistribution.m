function [ particles ] = particleDistribution( map, connections,M)


dist = zeros(size(connections,1),1);
for i = 1:size(connections,1);
    dist(i,:) = pdist([map(connections(i,1),:) ; map(connections(i,2),:)],'euclidean');
end

% dist
% connections

cdf = cumsum(dist);
max_cdf = max(cdf);
cdf = cdf/max_cdf;
%Particle population size
S = zeros(2,M);
cumulative_sum = zeros(1,M);

r_0 = rand / M;
% Determining how many particles are allocated to each line based on their
% length.
for m = 1 : M
    i = find(cdf >= r_0,1,'first');
    S(:,m) = [i dist(i,1)];
    cumulative_sum(1,m) = r_0;
    
    r_0 = r_0 + 1/M;
    
end

%need to add a 1 to the end or we will miss the last line
changeInDist = [logical(diff(S(2,:))) 1];
norm_prob = zeros(1,M);
min_cdf = 0;
max_cdf = cdf
k = 1;
l = 1;
for i = 1:M
    if (changeInDist(i) == 1)
        norm_prob(1,k:i) = ( cumulative_sum(1,k:i) - min_cdf ) / (max_cdf(l) - min_cdf);
        k = i+1;
        %assign current max cdf value to next min value.
        min_cdf = max_cdf(l);
        l = l + 1;
    end
    
        
%     else
%         norm_prob(1,k+1:i) = (cumulative_sum(1,k+1:i) - cumulative_sum(1,k+1) )/ (cumulative_sum(1,i) - cumulative_sum(1,k+1));
%     end
end


[S' norm_prob' cumulative_sum' changeInDist']




  
    
       
    



end

