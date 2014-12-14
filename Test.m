[Map, Rel] = loadMap();

plotMap(Map, Rel, 1);

carMarker = line('XData',0, 'YData',0, 'Color','r', ...
    'Marker','none', 'MarkerSize',8, 'LineWidth',4);

% Pick a node at random
fromNodeIndex = randi([1 nMap]);
fromNode = Map(:, fromNodeIndex);

fromNodeRelations = Rel{fromNodeIndex};
toNodeIndex = fromNodeRelations(randi([1 size(fromNodeRelations, 2)]));
toNode = Map(:, toNodeIndex);

lineLength = norm(toNode - fromNode);
lineAngle = atan2(toNode(2) - fromNode(2), toNode(1) - fromNode(1));
positionIncrement = 0.05 / lineLength;
positionRatio = rand();

for iFrame = 1:1000
    position = positionRatio * (toNode - fromNode) + fromNode;
    positionRatio = positionRatio + positionIncrement;
    
    set(carMarker, 'XData',[position(1) 2], 'YData',[position(2) 2]);
    drawnow;
    
    % Pick a new destination
    if positionRatio >= 1
        positionRatio = 0;
        
        fromNodeRelations = Rel{toNodeIndex};
        fromNodeRelationIndex = randi([1 (size(fromNodeRelations, 2) - 1)])
        
        nextToNodeIndex = fromNodeRelations(fromNodeRelationIndex);
        if nextToNodeIndex == fromNodeIndex;
            nextToNodeIndex = fromNodeRelations(fromNodeRelationIndex + 1);
        end
        
        fromNodeIndex = toNodeIndex;
        toNodeIndex = nextToNodeIndex;
        
        fromNode = Map(:, fromNodeIndex);
        toNode = Map(:, toNodeIndex);
        
        lineLength = norm(toNode - fromNode);
        positionIncrement = 0.05 / lineLength;
        
        previousLineAngle = lineAngle;
        lineAngle = atan2(toNode(2) - fromNode(2), toNode(1) - fromNode(1));
        
        angleDifference = (previousLineAngle - lineAngle);
    end
end
