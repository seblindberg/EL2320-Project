function runTrack( map, track )
%RUNTRACK Summary of this function goes here
%   Detailed explanation goes here

ANIMATION_DELAY = 0.1;

%h = plotMap(map, mapRelations, 1);
map.plot();

carMarker = line('XData',0, 'YData',0, 'Color','r', ...
    'Marker','none', 'MarkerSize',8, 'LineWidth',4);

nTrack = size(track, 2);

hold on;

for iTrack = 1:nTrack
    currentState = track(:, iTrack);
    
    x = currentState(1);
    y = currentState(2);
    speed = currentState(3);
    angle = currentState(4);
    
    set(carMarker, 'XData', [x (x + 0.1 * cos(angle))], ...
                   'YData', [y (y + 0.1 * sin(angle))]);
               
    plot(x, y, '.r');
               
    title(sprintf('Frame: %d/%d', iTrack, nTrack));
    drawnow;
    
    if ANIMATION_DELAY > 0
        pause(ANIMATION_DELAY);
    end
end

