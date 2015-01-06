function handle = plotTrack( map, mapRelations, track )
%PLOTTRACK Summary of this function goes here
%   Detailed explanation goes here

handle = plotMap(map, mapRelations, 1);

x = track(1, :);
y = track(2, :);

line('XData', x, ...
     'YData', y, ...
     'Color','r', 'Marker','.', 'MarkerSize',8, 'LineWidth',2);
             
line('XData', x(1), ...
     'YData', y(1), ...
     'Color','r', 'Marker','o', 'MarkerSize',12);

 line('XData', x(end), ...
      'YData', y(end), ...
      'Color','r', 'Marker','s', 'MarkerSize',12);

% LABEL_SPACING = 10;
% nLabels = floor(size(x, 2) / LABEL_SPACING);
% 
% for iLabel = 1:nLabels
%     text(x((iLabel - 1) * LABEL_SPACING + 1), ...
%          y((iLabel - 1) * LABEL_SPACING + 1), num2str(iLabel), ...
%          'VerticalAlignment','bottom', 'HorizontalAlignment','right');
% end
             
end

