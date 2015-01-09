classdef Map < handle
    %MAP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        MapNodes = MapNode.empty
    end
    
    methods
        function obj = Map(mapVect, connections)
            if nargin > 0
                nMapVect = size(mapVect, 2);
                
                if nargin < 2
                    for iMapVect = 1:nMapVect
                        obj.addNode(mapVect(iMapVect));
                    end
                else
                    % Create list of map nodes
                    for iMapVect = 1:nMapVect    
                        obj.addNode(MapNode(mapVect(1, iMapVect), mapVect(2, iMapVect)));
                    end

                    nConnections = size(connections, 2);
                    % Connect nodes
                    for iConnection = 1:nConnections
                        pair = connections(:,iConnection);
                        obj.MapNodes(pair(1)).addRelation(obj.MapNodes(pair(2)));
                    end
                end
            end
        end
        
        function addNode(obj, node)
            if ~any(obj.MapNodes == node)
                obj.MapNodes = [obj.MapNodes node];
            end
        end
        
        function mapLines = getMapLines(obj)
            mapLines = [];
            lines = obj.MapNodes(1).getAllConnectedLines();
            nLines = size(lines, 2);
            
            for iLine = 1:nLines
                line = lines(iLine);
                if ~any(mapLines == line)
                    mapLines = [mapLines line];
                end
            end
        end
        
        function node = getRandomNode(obj)
            node = obj.MapNodes(randi([1 size(obj.MapNodes, 2)]));
        end
        
        function deforme(obj, covariance)
            nMapNodes = size(obj.MapNodes, 2);
            nodePositionNoise = covariance * randn(2, nMapNodes);
            
            for iMapNode = 1:nMapNodes
                mapNode = obj.MapNodes(iMapNode);
                
                mapNode.position = [mapNode.x + nodePositionNoise(1, iMapNode);
                                    mapNode.y + nodePositionNoise(2, iMapNode)];
            end
            
        end
        
        function [xMin, xMax, yMin, yMax] = getBounds(obj)
            xMin = min(obj.MapNodes.x);
            xMax = max(obj.MapNodes.x);
            yMin = min(obj.MapNodes.y);
            yMax = max(obj.MapNodes.y);
        end
        
        function plot(obj, margin, color)
            if nargin < 3
                color = 'b';
                if nargin < 2
                    margin = 1;
                end
            end
            clf;
            % Get map bounds and add a margin to them
            [xmin, xmax, ymin, ymax] = obj.getBounds();
            axis([xmin-margin, xmax+margin, ymin-margin, ymax+margin]);
            
            axis equal;
            
            obj.getMapLines().plot(color);
            
            % Freeze axis limits
            axis manual;
        end
    end
    
end

