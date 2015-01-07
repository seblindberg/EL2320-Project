function [ track, control ] = loadTrack( filename )
%LOADTRACK Summary of this function goes here
%   Detailed explanation goes here

load(['Tracks/' filename]);

track   = TRACK;
control = CONTROL;

end

