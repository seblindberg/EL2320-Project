function runLocalization()

% Load map
map = loadMap();

% Display map
map.plot();

% Initialize particles
state = [];

% Plot particles
particleHandle = line('XData', state(1,:), 'YData', state(2,:), ...
    'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 6, 'Color', 'blue');

end