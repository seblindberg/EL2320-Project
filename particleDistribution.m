function [ particlePosition ] = particleDistribution( map, M)


lines = map.getMapLines;
lines(1,1).angle
dist = zeros(1, size(lines,2));
for i = 1:size(dist,2);
    dist(:,i) = lines(:,i).length;
end

 
% dist = zeros(size(connections,1),1);
% for i = 1:size(connections,1);
%     dist(i,:) = pdist([map(connections(i,1),:) ; map(connections(i,2),:)],'euclidean');
% end
% 
% dist
% connections

cdf = cumsum(dist);
max_cdf = max(cdf);
cdf = cdf/max_cdf;
S = zeros(2,M);
cumulative_sum = zeros(1,M);

r_0 = rand / M;
% Determining how many particles are allocated to each line based on their
% length.
for m = 1 : M
    i = find(cdf >= r_0,1,'first');
    S(:,m) = [i dist(1,i)];
    cumulative_sum(1,m) = r_0;
    
    r_0 = r_0 + 1/M;
    
end

%need to add a 1 to the end or we will miss the last line
changeOfLine = [logical(diff(S(1,:))) 1];
norm_prob = zeros(1,M);
min_cdf = 0;
max_cdf = cdf;
k = 1;
l = 1;
d = 1;
particlePosition = zeros(3, M);


for i = 1:M
    if (changeOfLine(i) == 1)
        normalizedProbTemp = ( cumulative_sum(1,k:i) - min_cdf ) / (max_cdf(l) - min_cdf);
        norm_prob(1,k:i) = normalizedProbTemp;
        %assign current max cdf value to next min value.
        min_cdf = max_cdf(l);
        
        %Calculate the position of each generated particle
        for j = 1:size(normalizedProbTemp,2)
           particlePosition(1:2,d) = lines(1,S(1,i)) * normalizedProbTemp(1,j);
           particlePosition(3,d) =  mod(lines(1,S(1,i)).angle,pi) + round(rand)*(pi);

           
           
           d = d+1;
        end
        
        k = i+1;
        l = l + 1; 


    end
    
end

%Data print which shows the following:
% [Connection number
% Dist of Connection 
% Distance percentage of line where particle is to be place
% Particle PosX
% Particle PosY
% 1 when a we are about to switch to another line]
[S' norm_prob' particlePosition' changeOfLine'];




  
    
       
    



end

