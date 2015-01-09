classdef MapLine < handle
    %MAPLINE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        startNode % The node at which the line start
        endNode   % The node at which the line ends
    end
    
    properties (Constant)
        DELTA_T = 0.1
        TURN_DISTANCE = 0.2
        MAX_ACCELERATION = 0.5
        MAX_SPEED = 1
        MIN_SPEED = 0.1
        VERBOSE = 1
    end
    
    methods
        function obj = MapLine(startNode, endNode)
            % Constructor that accepts a start and end node
            obj.startNode = startNode;
            obj.endNode = endNode;
        end
        
        function length = length(obj)
            % Calculate the length of the line
            startNode = [obj.startNode];
            endNode = [obj.endNode];
                        
            length = sqrt(sum(abs(endNode - startNode).^2, 1));
            %length = obj.startNode.distanceTo(obj.endNode);
        end
        
        function angle = angle(obj)
            % Calculate the angle of the line
            difference = obj.endNode - obj.startNode;
            angle = atan2(difference(2), difference(1));
        end
        
        function newMapLine = getRandomConnectedLine(obj)
            % Randomly pick a node connected to the end and create a new
            % line using the end node and the new node
            newEndNode = obj.endNode.getRandomRelatedNode(obj.startNode);
            newMapLine = MapLine(obj.endNode, newEndNode);
        end
        
        function position = mtimes(obj, fraction)
            % Get any position along the line by multiplying with a scalar.
            %   line * 0.5 will give the halfway point along the line
            %   line * 0 = position of startNode
            %   line * 1 = position of endNode
            position = obj.startNode.position + ...
                fraction * (obj.endNode - obj.startNode);
        end
        
        function isequal = eq(obj, otherLine)
            % Two lines are considered equal when their start and end nodes
            % match exactly
            if isempty(obj)
                isequal = false;
            else
                startNodes = [obj.startNode];
                endNodes = [obj.endNode];
                isequal = startNodes.eq(otherLine.startNode) & endNodes.eq(otherLine.endNode) ...
                    | startNodes.eq(otherLine.endNode) & endNodes.eq(otherLine.startNode);
            end
        end
        
        function index = index(obj)
            % The line index is the same as the lowest of the two nodes
            index = min([obj.startNode.index' obj.endNode.index']);
        end
        
        function position = positionFromStart(obj, distance)
            fraction = distance / obj.length;
            position = obj * fraction;
        end
        
        function position = positionFromEnd(obj, distance)
            fraction = 1 - distance / obj.length;
            position = obj * fraction;
        end
        
        function distance = shortestTurnDistance(obj, otherLine)
            distance = min([obj.TURN_DISTANCE ...
                            obj.length/2 ...
                            otherLine.length/2]);
        end
        
        function plot(obj, color)
            if nargin < 2
                color = 'b';
            end
            nLines = size(obj, 2);
            lines = [obj];
            
            wasHeld = ishold;
            
            if ~wasHeld
                hold on;
            end
                
            for iLine = 1:nLines
                plot([lines(iLine).startNode.x lines(iLine).endNode.x], ...
                     [lines(iLine).startNode.y lines(iLine).endNode.y], color);
            end
            
            if ~wasHeld
                hold off;
            end
        end
        
        
        function display(obj)
            nLines = size(obj, 2);
            lines = [obj];
            
            for iLine = 1:nLines
                fprintf('(%.1f, %.1f) --<%.1f /%.1f°>-- (%.1f, %.1f)\n', ...
                    lines(iLine).startNode.x, ...
                    lines(iLine).startNode.y, ...
                    lines(iLine).length, ...
                    lines(iLine).angle / pi * 180, ...
                    lines(iLine).endNode.x, ...
                    lines(iLine).endNode.y);
            end
        end
        
        
        function [xMin, xMax, yMin, yMax] = getBounds(obj)
            xValues = [obj.startNode.x obj.endNode.x];
            yValues = [obj.startNode.y obj.endNode.y];
            xMin = min(xValues);
            xMax = max(xValues);
            yMin = min(yValues);
            yMax = max(yValues);
        end
        
        
        function position = projectPoint(obj, point)
            vx = obj.endNode.x - obj.startNode.x;
            vy = obj.endNode.y - obj.startNode.y;
            
            dx = point(1,:)' - obj.startNode.x;
            dy = point(2,:)' - obj.startNode.y;
            
            tp = (dx .* vx + dy .* vy ) ./ (vx .* vx + vy .* vy);
            
            position = [obj.startNode.x + tp .* vx, obj.startNode.y + tp .* vy]';
        end
        
        
        function distance = distanceToPoint(obj, point)
            positionAlongLine = obj.projectPoint(point);
            distance = zeros(1, size(point, 2));
            
            % Line is not vertical
            if obj.startNode.x ~= obj.endNode.x
                % Separate left and right node
                if obj.startNode.x <= obj.endNode.x
                    pointsClosestToStartNode = positionAlongLine(1,:) < obj.startNode.x;
                    pointsClosestToEndNode   = positionAlongLine(1,:) > obj.endNode.x;
                else
                    pointsClosestToStartNode = positionAlongLine(1,:) > obj.startNode.x;
                    pointsClosestToEndNode   = positionAlongLine(1,:) < obj.endNode.x;
                end
                
            else
                % Separate top and bottom node
                if obj.startNode.y <= obj.endNode.y
                    pointsClosestToStartNode = positionAlongLine(2,:) < obj.startNode.y;
                    pointsClosestToEndNode   = positionAlongLine(2,:) > obj.endNode.y;
                else
                    pointsClosestToStartNode = positionAlongLine(2,:) > obj.startNode.y;
                    pointsClosestToEndNode   = positionAlongLine(2,:) < obj.endNode.y;
                end
            end
            
            pointsOnLine = ~pointsClosestToStartNode & ~pointsClosestToEndNode;
            
            % Calculate the different distances
            distance(pointsOnLine) = sqrt(sum(abs(...
                point(:,pointsOnLine) - positionAlongLine(:, pointsOnLine)).^2, 1));
            
            distance(pointsClosestToStartNode) = sqrt(sum(abs(...
                bsxfun(@minus, point(:, pointsClosestToStartNode), obj.startNode.position)).^2, 1));
            
            distance(pointsClosestToEndNode) = sqrt(sum(abs(...
                bsxfun(@minus, point(:, pointsClosestToEndNode), obj.endNode.position)).^2, 1));
        end
        
        
        function [fromNode, toNode, arc] = arcTo(obj, nextLine, verbose)
            if nargin < 3
                verbose = 0;
            end
            
            distance = obj.shortestTurnDistance(nextLine);
            
            deltaTheta = mod(nextLine.angle - obj.angle + pi, 2*pi) - pi;
            
            % Create two new nodes which will serve as beginning and end
            % points for the arc
            fromNode = TrackNode(obj.positionFromEnd(distance), obj.MAX_SPEED);
            toNode   = TrackNode(nextLine.positionFromStart(distance), obj.MAX_SPEED);
            
            % Create a line between the two points
            bisect = fromNode:toNode;
            
            if abs(deltaTheta) < 1e-10
                arc = bisect.ramp;
                return
            end
            
            %deltaTheta * 180 / pi
            
            % Calculate the radius of the arc
            r = bisect.length / (2 * sin(deltaTheta / 2));
            
            alpha = (pi - deltaTheta) / 2;

            circleCenterNode = fromNode + ...
                r * [cos(bisect.angle + alpha) sin(bisect.angle + alpha)];
            
            % Decide on what (constant) speed to use
            v = min([max([obj.MIN_SPEED abs(r)/2]) obj.MAX_SPEED]);
            
            % Calculate the length of the arc
            arcLength = abs(r * deltaTheta);
            
            % Divide the distance into discrete steps based on how far the
            % car will travel during each delta_t
            nSteps = round(arcLength / (obj.DELTA_T * v));
            
            % Correct for the rounding error introduced in the previous
            % step
            speed = arcLength / (obj.DELTA_T * nSteps);
            
            % Setup help lines
            circleFromLine = circleCenterNode:fromNode;
            circleToLine = circleCenterNode:toNode;
            
            if verbose > 0
                circleCenterNode.plot();
                circleFromLine.plot();
                circleToLine.plot();
            end
            
            
            angles = linspace(0, ...
                mod(circleToLine.angle - circleFromLine.angle + pi, 2*pi) - pi, ...
                nSteps) + circleFromLine.angle;
            
            
            arc = [circleCenterNode.x + cos(angles) * abs(r);
                   circleCenterNode.y + sin(angles) * abs(r);
                   repmat(speed, 1, nSteps);
                   linspace(0, mod(nextLine.angle - obj.angle + pi, 2*pi) - pi, nSteps) + obj.angle];
            
            % Remove the last element of the arc
            arc = arc(:, 1:end - 1);

            % Set the corrected speed for the two end nodes
            fromNode.setSpeed(speed);
            toNode.setSpeed(speed);
            
            if verbose > 0
                fromNode.plot('r');
                toNode.plot('g');
            end
        end
        
        function track = ramp(obj)
            % Ramp with a constant acceleration from the speed of the start
            % node to that of the end node
            
            % Return an empty track if the line has no length
            if obj.startNode == obj.endNode
                disp('Line has no length');
                track = zeros(4, 0);
                return;
            end
            
            % Calculate the time the ramp will take
            time = 2 * obj.length / (obj.startNode.speed + obj.endNode.speed);
            % Divide the time into discrete steps
            nSteps = max([round(time / obj.DELTA_T) 1]);
            % Adjust the ramp to the rounding error introduced
            adjustedTime = (nSteps) * obj.DELTA_T;
            
            roundingCorrectionFactor = time / adjustedTime;
            
            adjustedStartSpeed = obj.startNode.speed * roundingCorrectionFactor;
            adjustedEndSpeed = obj.endNode.speed * roundingCorrectionFactor;
            
            if nSteps == 1
                track = [obj.startNode.x;
                         obj.startNode.y;
                         adjustedStartSpeed;
                         obj.angle];
                
                return;
            end
            
            acceleration = (adjustedEndSpeed - adjustedStartSpeed) / adjustedTime;
                 
            steps = 0:(nSteps - 1);
            timeVec = steps * obj.DELTA_T;
           
            if acceleration == 0
                speedVec = repmat(adjustedStartSpeed, 1, nSteps);
            else
                speedVec = adjustedStartSpeed + acceleration * timeVec;
            end
            
            distanceVec = (speedVec + adjustedStartSpeed) / 2 .* timeVec;
            
            track = [(cos(obj.angle) * distanceVec + obj.startNode.x);
                     (sin(obj.angle) * distanceVec + obj.startNode.y);
                     speedVec;
                     repmat(obj.angle, 1, nSteps)];
        end
                        
        
        function track = rampUpDown(obj) 
            % Assume maximum speed to start with
            speed = obj.MAX_SPEED;
            % Calculate the time it will take to accelerate/deccelerate
            % to/from maximum speed
            tUp = (speed - obj.startNode.speed) / obj.MAX_ACCELERATION;
            tDown = (speed - obj.endNode.speed) / obj.MAX_ACCELERATION;
            
            % Determine the distance for the acceleration/deceleration
            rampUpDistance = obj.startNode.speed * tUp +  ...
                obj.MAX_ACCELERATION * tUp^2;
            
            rampDownDistance = obj.endNode.speed * tDown +  ...
                obj.MAX_ACCELERATION * tDown^2;
            
            % If the combined distance is longer than the entire stretch
            if rampUpDistance + rampDownDistance > obj.length
                rampUpDistance = rampUpDistance - (rampUpDistance - (obj.length - rampDownDistance)) / 2;
                rampDownDistance = obj.length - rampUpDistance;
                
                speed = 0.8 * speed;
                
                %tIntersect = (obj.endNode.speed - obj.startNode.speed) / (2 * obj.MAX_ACCELERATION);
            end
            
            maxNode = TrackNode(obj.positionFromStart(rampUpDistance), speed);
            minNode = TrackNode(obj.positionFromEnd(rampDownDistance), speed);
            
            maxNode.plot('c');
            minNode.plot('b');

            rampUpLine = obj.startNode:maxNode;
            constantLine = maxNode:minNode;
            rampDownLine = minNode:obj.endNode;
            
            rampUpLine.plot('g');
            constantLine.plot('b');
            rampDownLine.plot('r');
            
            track = [rampUpLine.ramp constantLine.ramp rampDownLine.ramp];
        end
    end
    
end

