function [ S, averageLikelyhood ] = weight( mapLines, S )
%WEIGHT Summary of this function goes here
%   Detailed explanation goes here

M = size(S, 2);

nMapLines = size(mapLines, 2);
minimumDistance = repmat(inf, 1, M);
associatedLine = zeros(1, M);

points = S(1:2, :);

for iMapLine = 1:nMapLines
    mapLine = mapLines(iMapLine);
    % Calculate the distance to the line for all points
    distance = mapLine.distanceToPoint(points);
    % Select all points which are closer to this line than any other
    distMask = distance < minimumDistance;
    % Store the distance and the line index
    minimumDistance(distMask) = distance(distMask);
    associatedLine(distMask) = iMapLine;
end

minimumDistance = exp(-minimumDistance.^2 / 0.01);

averageLikelyhood = sum(minimumDistance) / M;

% Normalize weights
S(4,:) = minimumDistance / sum(minimumDistance);

end

