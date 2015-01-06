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
                
                % Create list of map nodes
                for iMapVect = 1:nMapVect    
                    obj.addNode(MapNode(mapVect(1, iMapVect), mapVect(2, iMapVect)));
                end
                
                if nargin > 1
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
            mapLines = obj.MapNodes(1).getAllConnectedLines();
        end
        
        function node = getRandomNode(obj)
            node = obj.MapNodes(randi([1 size(obj.MapNodes, 2)]));
        end
        
        function plot(obj)
            clf;
            axis equal;
            obj.getMapLines().plot();
        end
    end
    
end

