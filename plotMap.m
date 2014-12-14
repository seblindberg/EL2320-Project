function handle = plotMap(map, mapRelations, verbose)
%PLOTMAP Plot a map with lines connecting the related nodes
%   Detailed explanation goes here

    handle = gcf;
    clf;

    if nargin < 3
        verbose = 0;
    end
    
    xMax = max(map(1,:));
    yMax = max(map(2,:));
    
    axis([0 xMax+1 0 yMax+1]);
    axis('equal');

    hold on;

    plotMapPoint(map, mapRelations, 1, verbose);
end

