function [ track ] = generateTrack( map, mapRelations, trackLenght )
%GENERATETRACK Summary of this function goes here
%   Detailed explanation goes here
%           | x        ...
%   track = | y        ...
%           | speed    ...
%           | angle    ...

nMap = size(map, 2);

DELTA_T = 1;
MAX_SPEED = 1;

% Pick a node at random
fromNodeIndex = randi([1 nMap]);
fromNode = map(:, fromNodeIndex);

% Get related nodes
fromNodeRelations = mapRelations{fromNodeIndex};

% Pick a related node randomly
toNodeIndex = fromNodeRelations(randi([1 size(fromNodeRelations, 2)]));
toNode = map(:, toNodeIndex);

% Calculate the current length of the line
lineLength = norm(toNode - fromNode);
lineAngle = atan2(toNode(2) - fromNode(2), toNode(1) - fromNode(1));

positionIncrement = 0.05 / lineLength;
positionRatio = rand();


% GENERATE (x, y, v, 0) FOR PART OF THE LINE
%   line: --|----------------|--
%      turn   drive at v_max   turn
% SELECT NEXT toNode
% CALCULATE DIFFERENCE IN ANGLE
% DETERMINE TURN SPEED AS A FUNCTION OF THE ANGLE DIFFERENCE
% GENERATE (x, y, v, theta) FOR TURN

end

