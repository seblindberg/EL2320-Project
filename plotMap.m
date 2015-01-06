function handle = plotMap(map, mapRelations, verbose)
%PLOTMAP Plot a map with lines connecting the related nodes
%   Detailed explanation goes here

    MARGIN = 1;

    handle = gcf;
    clf;

    if nargin < 3
        verbose = 0;
    end
    
    xMin = min(map(1,:));
    xMax = max(map(1,:));
    
    yMin = min(map(2,:));
    yMax = max(map(2,:));
    
    axis([xMin-MARGIN xMax+MARGIN yMin-MARGIN yMax+MARGIN]);
    axis equal;
    hold on;

    plotMapPoint(map, mapRelations, 1, verbose);
    
    hold off;
    axis manual;
end

