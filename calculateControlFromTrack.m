function control = calculateControlFromTrack( track )
%CALCULATESTATEFROMTRACK Summary of this function goes here
%   Detailed explanation goes here

control = [track(3,:);
          [0 diff(track(3,:))/0.1];
          [0 diff(track(4,:))]];

end

