classdef TrackLine < MapLine
    %TRACKLINE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    properties (Constant)
%         DELTA_T = 0.1
%         TURN_DISTANCE = 0.2
%         MAX_ACCELERATION = 0.5
%         MAX_SPEED = 1
%         MIN_SPEED = 0.1
%         VERBOSE = 1
    end
    
    methods
        function obj = TrackLine(startNode, endNode)
            obj = obj@MapLine(startNode, endNode);
        end
        
        
    end
    
end

