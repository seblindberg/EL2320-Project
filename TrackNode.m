classdef TrackNode < MapNode
    %TRACKNODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        speed
    end
    
    methods
        function obj = TrackNode(x, y, speed)
            if nargin == 3
                x = [x y];
            elseif nargin == 2
                speed = y;
            elseif nargin == 1
                speed = 0.0;
            end
            
            obj = obj@MapNode(x);
            obj.speed = speed;
        end
        
        function setSpeed(obj, newSpeed)
            obj.speed = newSpeed;
        end
        
        function s = getSpeed(obj)
            s = obj.speed;
        end
        
        function h = plot(obj, color)
            if nargin < 2
                color = 'r';
            end
            
            plot@MapNode(obj, color);
            
            text(obj.x, obj.y, sprintf('%.1f', obj.speed), ...
            'VerticalAlignment','bottom', 'HorizontalAlignment','right');
        end
        
        function tl = colon(obj, toNode)
            % Creates a track line from two map points
            tl = TrackLine(obj, toNode);
        end
    end
    
end

