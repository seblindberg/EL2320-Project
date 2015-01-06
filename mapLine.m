classdef mapLine < handle
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
        function obj = mapLine(startNode, endNode)
            % Constructor that accepts a start and end node
            obj.startNode = startNode;
            obj.endNode = endNode;
        end
        
        function length = length(obj)
            % Calculate the length of the line
            length = norm(obj.endNode - obj.startNode);
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
            newMapLine = mapLine(obj.endNode, newEndNode);
        end
        
        function position = mtimes(obj, fraction)
            position = obj.startNode.position + ...
                fraction * (obj.endNode - obj.startNode);
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
        
        function h = plot(obj)
            h = plot([obj.startNode.position(1) obj.endNode.position(1)], ...
                     [obj.startNode.position(2) obj.endNode.position(2)]);
        end
        
        
        function display(obj)
            size(obj);
            fprintf('(%.1f, %.1f) --[%.1f /%.1f°]-- (%.1f, %.1f)\n', ...
                obj.startNode.position(1), ...
                obj.startNode.position(2), ...
                obj.length, ...
                obj.angle / pi * 180, ...
                obj.endNode.position(1), ...
                obj.endNode.position(2));
        end
        
        function [fromNode, toNode, arc] = arcTo(obj, nextLine)
            
            distance = obj.shortestTurnDistance(nextLine);
            
            deltaTheta = mod(nextLine.angle - obj.angle + pi, 2*pi) - pi
            
            % Create two new nodes which will serve as beginning and end
            % points for the arc
            fromNode = TrackNode(obj.positionFromEnd(distance), obj.MAX_SPEED);
            toNode   = TrackNode(nextLine.positionFromStart(distance), obj.MAX_SPEED);
            
            % Create a line between the two points
            bisect = fromNode:toNode;
                        
            if deltaTheta == 0
                arc = bisect.ramp;
                return
            end
            
            %deltaTheta * 180 / pi
            
            % Calculate the radius of the arc
            r = bisect.length / (2 * sin(deltaTheta / 2))
            
            alpha = (pi - deltaTheta) / 2;

            circleCenterNode = fromNode + ...
                r * [cos(bisect.angle + alpha) sin(bisect.angle + alpha)];
            
            % Decide on what (constant) speed to use
            v = min([max([obj.MIN_SPEED abs(r)]) obj.MAX_SPEED]);
            
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
            
            if obj.VERBOSE
                circleCenterNode.plot();
                circleFromLine.plot();
                circleToLine.plot();
            end
            
            
            angles = linspace(0, ...
                mod(circleToLine.angle - circleFromLine.angle + pi, 2*pi) - pi, ...
                nSteps) + circleFromLine.angle;
            
            
            arc = [circleCenterNode.position(1) + cos(angles) * abs(r);
                   circleCenterNode.position(2) + sin(angles) * abs(r);
                   repmat(speed, 1, nSteps);
                   linspace(0, mod(nextLine.angle - obj.angle + pi, 2*pi) - pi, nSteps) + obj.angle];
            
            % Remove the last element of the arc
            arc = arc(:, 1:end - 1);

            % Set the corrected speed for the two end nodes
            fromNode.setSpeed(speed);
            toNode.setSpeed(speed);
        end
        
        function track = ramp(obj)
            % Ramp with a constant acceleration from the speed of the start
            % node to that of the end node
            
            if obj.startNode == obj.endNode
                track = zeros(4, 0);
                return;
            end
            obj.startNode
            time = 2 * obj.length / (obj.startNode.speed + obj.endNode.speed);
            
            nSteps = ceil(time / obj.DELTA_T);
            
            adjustedTime = (nSteps) * obj.DELTA_T;
            roundingCorrectionFactor = time / adjustedTime;
            
            adjustedStartSpeed = obj.startNode.speed * roundingCorrectionFactor;
            adjustedEndSpeed = obj.endNode.speed * roundingCorrectionFactor;
            
            acceleration = (adjustedEndSpeed - adjustedStartSpeed) / adjustedTime;
           
            steps = 0:(nSteps - 1);
            timeVec = steps * obj.DELTA_T;
           
            if acceleration == 0
                speedVec = repmat(adjustedStartSpeed, 1, nSteps);
            else
                speedVec = adjustedStartSpeed + acceleration * timeVec;
            end
            
            distanceVec = (speedVec + adjustedStartSpeed) / 2 .* timeVec;
            
            track = [(cos(obj.angle) * distanceVec + obj.startNode.position(1));
                     (sin(obj.angle) * distanceVec + obj.startNode.position(2));
                     speedVec;
                     repmat(obj.angle, 1, nSteps)];
        end
                        
        
        function track = rampUpDown(obj) 
            
            speed = obj.MAX_SPEED;
            
            tUp = (speed - obj.startNode.speed) / obj.MAX_ACCELERATION;
            tDown = (speed - obj.endNode.speed) / obj.MAX_ACCELERATION;
            
            rampUpDistance = obj.startNode.speed * tUp +  ...
                obj.MAX_ACCELERATION * tUp^2;
            
            rampDownDistance = obj.endNode.speed * tDown +  ...
                obj.MAX_ACCELERATION * tDown^2;
                     
            if rampUpDistance > obj.length - rampDownDistance
                rampUpDistance = rampUpDistance - (rampUpDistance - (obj.length - rampDownDistance)) / 2;
                rampDownDistance = obj.length - rampUpDistance;
                
                speed = 0.5 * speed;
                
                %tIntersect = (obj.endNode.speed - obj.startNode.speed) / (2 * obj.MAX_ACCELERATION);
            end
            
            maxNode = TrackNode(obj.positionFromStart(rampUpDistance), speed);
            maxNode.plot();
            
            minNode = TrackNode(obj.positionFromEnd(rampDownDistance), speed);
            minNode.plot();
            
            rampUpLine = obj.startNode:maxNode;
            constantLine = maxNode:minNode;
            rampDownLine = minNode:obj.endNode;
            
            track = [rampUpLine.ramp constantLine.ramp rampDownLine.ramp];
        end
    end
    
end

