nodeA = mapNode(3, 3);
nodeB = mapNode(2, 2);
nodeC = mapNode(1, 1);

line1 = mapLine(nodeC, nodeB);
line2 = mapLine(nodeB, nodeA);

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