%% Test distanceTo

nodeA = MapNode(1, 1);
nodeB = MapNode(1, 2);

nodeC = MapNode(2, 2);
nodeD = MapNode(1, 2);

nodesAB = [nodeA nodeB];
nodesCD = [nodeC nodeD];

nodesAB.distanceTo(nodesCD)

%% Test getRandomConnection

nodeA = MapNode(3, 3);
nodeB = MapNode(2.6, 5);
nodeC = MapNode(2, 5);

nodeB.addRelation(nodeA);
nodeB.addRelation(nodeC);

lineAB = MapLine(nodeA, nodeB);
lineBC = MapLine(nodeB, nodeC);

clf;
hold on;
axis equal;

lineAB.plot();
lineBC.plot();

lineAB
line1.getRandomConnectedLine()

%% Test arcTo

nodeA = MapNode(2.6, 5);
nodeB = MapNode(3, 3);
nodeC = MapNode(2, 2);

line1 = MapLine(nodeA, nodeB);
lineBC = MapLine(nodeB, nodeC);

clf;
hold on;
axis equal;

line1.plot();
lineBC.plot();

[from, to, arc] = line1.arcTo(lineBC);

from.plot();
to.plot();

plot(arc(1,:), arc(2,:));

%% Test generateTrack

map = loadMap();

track = generateTrack(map, 2, 1);

%runTrack(map, track);

%% Test positionFromEnd
figure(2);
clf;
nodeA = MapNode(3,2);
nodeB = MapNode(2,3);
lineAB = nodeA:nodeB;

lineAB.plot();
hold on;
pos = lineAB.positionFromEnd(0.2);
plot(pos(1), pos(2), 'o');
hold off;

%%
%plot(track(1,:), track(2,:), 'o')

% nodeA = TrackNode(1, 1, 0.5);
% nodeB = TrackNode(2, 2, 0.1);
% 
% lineAB = nodeA:nodeB;
% 
% clf;
% subplot(2, 1, 1);
% hold on;
% 
% nodeA.plot();
% nodeB.plot();
% 
% track = lineAB.rampUpDown;
% 
% plot(track(1,:), track(2,:), 'o')
% 
% 
% 
% subplot(2, 1, 2);
% plot(track(3,:));

%% Test MapLine equals

nodeA = MapNode(2, 3);
nodeB = MapNode(4, 5);
nodeC = MapNode(4, 4);

lineA = nodeA:nodeB;
lineB = nodeB:nodeA;
lineC = nodeC:nodeA;

if lineA == lineA && lineA == lineB && lineA ~= lineC
    disp('Everything is ok');
else
    disp('Test failed');
end

%% Test MapLine equals on vector

nodeA = MapNode(2, 3);
nodeB = MapNode(4, 5);
nodeC = MapNode(4, 4);

lineA = nodeA:nodeB;
lines = [nodeA:nodeB nodeB:nodeA nodeC:nodeA];

if (lines == lineA) == [1 1 0]
    disp('Everything is ok');
else
    disp('Test failed');
end

%% Test get Map lines

map = loadMap();
map.getMapLines()

%% Test project point

clf;
axis equal;

nodeA = MapNode(1, 1);
nodeB = MapNode(2, 3);

lineA = nodeA:nodeB;

point = [0 -1; 1 2; 1 3; 3 3]';

hold on;
lineA.plot();
plot(point(1,:), point(2,:), 'r*');

pos = lineA.projectPoint(point)

plot(pos(1,:), pos(2,:), 'g*');
tic
lineA.distanceToPoint(point)
toc
%% Test Create track

map = loadMap();
track = generateTrack(map, 20);
saveTrack(track, 'test-track');
runTrack(map, track);

%% Test runLocalization

runLocalization('test-map', 'test-track');


%% Test particleDistribution

map = loadMap();

particles = particleDistribution(map, 100);

map.plot();
hold on;
plot(particles(1,:), particles(2,:), '.');
