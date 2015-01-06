% nodeA = MapNode(2, 2);
% nodeB = MapNode(3, 1);
% nodeC = MapNode(1, 1);
% 
% line1 = MapLine(nodeA, nodeB);
% line2 = MapLine(nodeB, nodeC);
% 
% clf;
% hold on;
% axis equal;
% 
% line1.plot();
% line2.plot();
% 
% line1
% line2
% 
% [from, to, arc] = line1.arcTo(line2);
% 
% from.plot();
% to.plot();
% 
% plot(arc(1,:), arc(2,:));

map = loadMap();

%map.plot();

track = generateTrack(map, 20);
runTrack(map, track);
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
map.getMapLines().plot()




