function plotMapPoint(map, mapRelations, index, verbose)
%DRAWMAPPOINT Plot a map point
%   Detailed explanation goes here

    % Get coordinates for point
    mapPoint = map(:, index);
    
    if verbose > 0
        text(mapPoint(1), mapPoint(2), num2str(index), ...
            'VerticalAlignment','bottom', 'HorizontalAlignment','right')
    end
    
    relations = mapRelations{index}(mapRelations{index} > index);
    nRelations = size(relations, 2);
    
    if nRelations > 0
        for iRelation = 1:nRelations
            relationIndex = relations(iRelation);
            relationMapPoint = map(:, relationIndex);

            plot([mapPoint(1) relationMapPoint(1)], ...
                 [mapPoint(2) relationMapPoint(2)], 'b');
            
            plotMapPoint(map, mapRelations, relationIndex, verbose);
        end
    end
end

