function saveTrack( TRACK, filename )
%SAVETRACK Summary of this function goes here
%   Detailed explanation goes here

CONTROL = calculateControlFromTrack(TRACK);

save(['Tracks/' filename], 'TRACK', 'CONTROL');

end

