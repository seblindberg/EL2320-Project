function runLocalization( mapFilename, trackFilename )

CAR_LENGTH = 0.1;
ANIMATION_DELAY = 0.1;

% Load map and track
map = loadMap(mapFilename);
[track, control] = loadTrack(trackFilename);

% Display map
map.plot();

currentState = track(:, 1);
controlState = currentState;

% Initialize particles
particles = diag([4 6 1]) * rand(3, 1000);

% Plot particles
particleHandle = line('XData', particles(1,:), 'YData', particles(2,:), ...
    'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 6, 'Color', 'blue');

carHandle = line('XData',0, 'YData',0, 'Color','red', ...
    'Marker','none', 'MarkerSize',8, 'LineWidth',4);

controlCarHandle = line('XData',0, 'YData',0, 'Color','green', ...
    'Marker','none', 'MarkerSize',8, 'LineWidth',4);

nTrack = size(track, 2);

for iTrack = 2:nTrack
    currentState = track(:, iTrack);
    currentControl = control(:, iTrack);
    
    controlState(4) = controlState(4) + currentControl(2);
    controlState(1) = controlState(1) + currentControl(1) * 0.1 * cos(controlState(4));
    controlState(2) = controlState(2) + currentControl(1) * 0.1 * sin(controlState(4));
    controlState(3) = currentControl(1);
    
    % Update true state
    set(carHandle, ...
        'XData', [currentState(1) (currentState(1) + CAR_LENGTH * cos(currentState(4)))], ...
        'YData', [currentState(2) (currentState(2) + CAR_LENGTH * sin(currentState(4)))]);
    
    set(controlCarHandle, ...
        'XData', [controlState(1) (controlState(1) + CAR_LENGTH * cos(controlState(4)))], ...
        'YData', [controlState(2) (controlState(2) + CAR_LENGTH * sin(controlState(4)))]);
    
    % Update particles
    particles = particles + randn(3, 1000) * 0.01;
    
    % Weight particles
    
    
    % Resample particles
    
    
    % Calculate position estimate
    meanPosition = mean(particles(1:2,:), 2);
    
    % Determine error
    norm([currentState(1) - meanPosition(1) currentState(2) - meanPosition(2)])
    
    % Redraw particles
    set(particleHandle, ...
        'XData', particles(1,:), ...
        'YData', particles(2,:));
    
    title(sprintf('Frame: %d/%d', iTrack, nTrack));
    
    drawnow;
    
    if ANIMATION_DELAY > 0
        pause(ANIMATION_DELAY);
    end
end

end