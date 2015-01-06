% nodeA = mapNode(2, 2);
% nodeB = mapNode(3, 1);
% nodeC = mapNode(1, 1);
% 
% line1 = mapLine(nodeA, nodeB);
% line2 = mapLine(nodeB, nodeC);
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

