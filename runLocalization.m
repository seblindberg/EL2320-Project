function runLocalization( mapFilename, trackFilename )

CAR_LENGTH = 0.1;
ANIMATION_DELAY = 0.005;
N_PARTICLES = 2000;

% Load map and track
map = loadMap(mapFilename);
[track, control] = loadTrack(trackFilename);

map.deforme(diag([0.05 0.05]));
mapLines = map.getMapLines();

% Display map
figure(1);
map.plot();

currentState = track(:, 1);
controlState = currentState;

% Initialize particles
particles = particleDistribution(map, N_PARTICLES);

% Plot particles
particleHandle = line('XData', particles(1,:), 'YData', particles(2,:), ...
    'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 6, 'Color', 'blue');

carHandle = line('XData',0, 'YData',0, 'Color','red', ...
    'Marker','none', 'MarkerSize',8, 'LineWidth',4);

controlCarHandle = line('XData',0, 'YData',0, 'Color','green', ...
    'Marker','none', 'MarkerSize',8, 'LineWidth',4);

estimateHandle = line('XData',0, 'YData',0, 'Color','red', ...
    'Marker','o', 'MarkerSize',20, 'LineWidth',4);

nTrack = size(track, 2);

error = zeros(1, size(track, 2));
iError = 1;

for iTrack = 2:nTrack
    currentState = track(:, iTrack);
    currentControl = control(:, iTrack);
    
    speed = currentControl(1);
    acceleration = currentControl(2);
    heading = currentControl(3);
    
    %currentControl(1) = currentControl(1) + 0.08 * randn();
    %heading = heading + 0.03 * randn();
    
    controlState(4) = controlState(4) + heading;
    controlState(1) = controlState(1) + speed * 0.1 * cos(controlState(4));
    controlState(2) = controlState(2) + speed * 0.1 * sin(controlState(4));
    controlState(3) = speed;
    
    % Update true state
    set(carHandle, ...
        'XData', [currentState(1) (currentState(1) + CAR_LENGTH * cos(currentState(4)))], ...
        'YData', [currentState(2) (currentState(2) + CAR_LENGTH * sin(currentState(4)))]);
    
    set(controlCarHandle, ...
        'XData', [controlState(1) (controlState(1) + CAR_LENGTH * cos(controlState(4)))], ...
        'YData', [controlState(2) (controlState(2) + CAR_LENGTH * sin(controlState(4)))]);
    
    % Update particles
    particles = predict(particles, speed, heading, 0.1, diag([0.03 0.03]));
    
    % Weight particles
    [particles, likelyhood] = weight(mapLines, particles);
    
    if likelyhood < 0.00005
        particles = particleDistribution(map, N_PARTICLES);
    else
        % Resample particles
        particles = systematicResample(particles);
    end
    
    
    
    % Calculate position estimate
    meanPosition = mean(particles(1:2,:), 2);
    set(estimateHandle, 'XData', meanPosition(1), 'YData', meanPosition(2));
    
    % Determine error
    error(iTrack) = norm([currentState(1) - meanPosition(1) currentState(2) - meanPosition(2)]);
    
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

figure(2);
plot(error);

end