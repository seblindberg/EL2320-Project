nodeA = MapNode(3, 3);
nodeB = MapNode(2, 2);
nodeC = MapNode(1, 1);

line1 = MapLine(nodeC, nodeB);
line2 = MapLine(nodeB, nodeA);

clf;
hold on;
axis equal;

line1.plot();
line2.plot();

line1
line2

[from, to, arc] = line1.arcTo(line2);

from.plot();
to.plot();

plot(arc(1,:), arc(2,:), '*');