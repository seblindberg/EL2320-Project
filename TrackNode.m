classdef TrackNode < mapNode
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
            
            obj = obj@mapNode(x);
            obj.speed = speed;
        end
        
        function setSpeed(obj, newSpeed)
            obj.speed = newSpeed;
        end
        
        function s = getSpeed(obj)
            s = obj.speed;
        end
        
        function h = plot(obj)
            h = plot(obj.position(1), obj.position(2), '*');
            text(obj.position(1), obj.position(2), sprintf('%.1f', obj.speed), ...
            'VerticalAlignment','bottom', 'HorizontalAlignment','right');
        end
    end
    
end

