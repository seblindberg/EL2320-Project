function [ track ] = generateTrack( map, trackLenght )
%GENERATETRACK Summary of this function goes here
%   Detailed explanation goes here
%           | x        ...
%           | y        ...
%   track = | speed    ...
%           | heading  ...
%           | angle    ...

track = [];

% Resolution in time
DELTA_T           = 0.2;

MAX_SPEED         = 0.5; % m/s
MIN_SPEED         = 0.05;
MAX_ACCELERATION  = 1;   % m/s^

TURN_DISTANCE     = 0.2; % m


startNode = map.getRandomNode;
endNode = startNode.getRandomRelatedNode;

currentMapLine = startNode:endNode;

nextMapLine = currentMapLine.getRandomConnectedLine();

previousToPoint = TrackNode(startNode.position);

clf;

hold on
axis equal;

for i = 1:trackLenght

    %currentMapLine.plot();
    %nextMapLine.plot();

    [from, to, arc] = currentMapLine.arcTo(nextMapLine);
        
    if previousToPoint == from
        
    else
        l = previousToPoint:from;
        track = [track l.rampUpDown()];
    end
    
    track = [track arc];
    
    previousToPoint = to;
    
    currentMapLine = nextMapLine;
    nextMapLine = currentMapLine.getRandomConnectedLine();

end



return

% Pick a node at random as the initial position
fromNodeIndex     = randi([1 nMap]);
fromNodeRelations = mapRelations{fromNodeIndex};
toNodeIndex       = randi([1 size(fromNodeRelations, 2)]);

turnDistance      = TURN_DISTANCE;
lineAngle         = 0.0;
turnFromPosition  = -map(:, toNodeIndex) * turnDistance;

track = zeros(5, trackLenght);
iTrack = 1;

% Pick a node at random as the initial position
iNodeA = randi([1 nMap]);
nodeARelations = mapRelations{iNodeA};
iNodeARelations = randi([1 size(nodeARelations, 2)]);

while trackLength > 0
    nodeBRelations = mapRelations{iNodeB};
    
    % Decide where to go next
    iNodeC = randi([1 (size(nodeBRelations, 2) - 1)]);
    
end

while trackLenght > 0
    % Get related nodes    
    fromNodeRelations = mapRelations{toNodeIndex};
    
    % Pick a related node randomly
    fromNodeRelationIndex = randi([1 (size(fromNodeRelations, 2) - 1)]);
    nextToNodeIndex = fromNodeRelations(fromNodeRelationIndex);
    
    % Make sure the new node is not the same as the one we came from
    if nextToNodeIndex == fromNodeIndex;
        nextToNodeIndex = fromNodeRelations(fromNodeRelationIndex + 1);
    end

    % Move to the next line
    fromNodeIndex = toNodeIndex;
    toNodeIndex   = nextToNodeIndex;

    % Look up coordinates for line end points
    fromNode = map(:, fromNodeIndex);
    toNode   = map(:, toNodeIndex);
    
    % Save previous line angle and turn distance
    previousTurnDistance = turnDistance;
    previousLineAngle = lineAngle;

    % Calculate the length and angle of the line
    lineLength = norm(toNode - fromNode);
    lineAngle = atan2(toNode(2) - fromNode(2), toNode(1) - fromNode(1));
    
    lineAngleDifference = abs(previousLineAngle - lineAngle);
    
    lineAngleDifference * 180 / pi
    
    % Distance from toNode from which to start turning.
    turnDistance = min(turnDistance, lineLength / 2);
    
    if turnDistance < previousTurnDistance
        turnFromPosition = turnFromPosition + ...
            (fromNode - turnFromPosition) * turnDistance / previousTurnDistance;
        
        % TODO: Pad the rest of the way
    end
    
    turnToPosition = fromNode + (toNode - fromNode) * ...
                     (turnDistance / lineLength);
    
    turnRadius = norm(turnToPosition(1) - turnFromPosition(1), ...
                      turnToPosition(2) - turnFromPosition(2)) / ...
                 (2 * sin(lineAngleDifference / 2));
             
    norm(turnToPosition(1) - turnFromPosition(1), ...
                      turnToPosition(2) - turnFromPosition(2))
        

    % Number of steps
    nLineSteps = floor(lineLength / (DELTA_T * MAX_SPEED));
    
    % The entire set will not fit
    if nLineSteps > trackLenght
        % Move the end point closer
        toNode = fromNode + (trackLenght / nLineSteps) * (toNode - fromNode);
        nLineSteps = trackLenght;
    end
    
    x = linspace(fromNode(1), toNode(1), nLineSteps);
    y = linspace(fromNode(2), toNode(2), nLineSteps);
    
    speed = ones(1, nLineSteps) * MAX_SPEED;
    angle = ones(1, nLineSteps) * lineAngle;
        
    track(:, iTrack:(iTrack + nLineSteps - 1)) = [x;
                        y;
                        speed;
                        angle;
                        zeros(1, nLineSteps)];
                    
    iTrack = iTrack + nLineSteps;
    trackLenght = trackLenght - nLineSteps;
    
    turnDistance = min(lineLength - turnDistance, TURN_DISTANCE);
    turnFromPosition = fromNode + (toNode - fromNode) * ...
        (1 - turnDistance / lineLength);
end

% GENERATE (x, y, v, theta, 0) FOR PART OF THE LINE
%   line: --|----------------|--+--|
%      turn   drive at v_max   turn
% SELECT NEXT toNode
% CALCULATE DIFFERENCE IN ANGLE
% DETERMINE TURN SPEED AS A FUNCTION OF THE ANGLE DIFFERENCE
% GENERATE (x, y, v, theta, angle) FOR TURN

end

