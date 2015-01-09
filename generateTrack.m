function [ track ] = generateTrack( map, trackLenght, verbose )
%GENERATETRACK Summary of this function goes here
%   Detailed explanation goes here
%           | x        ...
%           | y        ...
%   track = | speed    ...
%           | heading  ...

if nargin < 3
    verbose = 0;
end

track = [];

% Resolution in time
DELTA_T           = 0.2;

MAX_SPEED         = 0.5; % m/s
MIN_SPEED         = 0.05;
MAX_ACCELERATION  = 1;   % m/s^

TURN_DISTANCE     = 0.2; % m


startNode = map.getRandomNode;
endNode = startNode.getRandomRelatedNode;

currentMapLine = TrackLine(startNode, endNode);

nextMapLine = currentMapLine.getRandomConnectedLine();

previousToPoint = TrackNode(startNode.position);

if verbose > 0
    map.plot(1, 'k');
    hold on;
    
    startNode.plot('m', 'o');
end

for i = 1:trackLenght

    if verbose > 0
        %currentMapLine.plot();
        %nextMapLine.plot();
    end

    % Create an arc from the current line to the nex
    [from, to, arc] = currentMapLine.arcTo(nextMapLine, verbose);
    
    % Drive along the line if there is room for it. If the line is too
    % short only the two arcs will fit.
    if previousToPoint ~= from
        l = previousToPoint:from;
        track = [track l.rampUpDown()];        
    end
    
    track = [track arc];
    
    % Move on the next line
    previousToPoint = to;
    currentMapLine  = nextMapLine;
    nextMapLine     = currentMapLine.getRandomConnectedLine();
end

end

