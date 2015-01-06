function  distance = weightCalculation(startP, endP, particleP)



a = [endP(1) - startP(1), endP(2) - startP(2); startP(2) - endP(2), endP(1) - startP(1)];

b = [particleP(1)*(endP(1) - startP(1)) + particleP(2)*(endP(2) - startP(2)); ...
    startP(2)*(endP(1) - startP(1)) - startP(1)*(endP(2) - startP(2))];

projPoint = (a\b)'


if projPoint < startP
    distance = pdist([startP;particleP], 'euclidean');
elseif projPoint > endP
    distance = pdist([endP;particleP], 'euclidean');
else
    distance = pdist([projPoint; particleP], 'euclidean');
end

figure;
points = [startP; endP; particleP; projPoint];
plot(points(:,1),points(:,2),'*');
hold on
plot([startP(1) endP(1)], [startP(2) endP(2)])
    
%Ouput is distance to line. 




end

