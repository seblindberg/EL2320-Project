classdef Map < handle
    %MAP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mapNodes = mapNode.empty
    end
    
    methods
        function obj = Map(mapVect, connections)
            if nargin > 0
                nMapVect = size(mapVect, 2);
                
                % Create list of map nodes
                for iMapVect = 1:nMapVect    
                    obj.addNode(mapNode(mapVect(1, iMapVect), mapVect(2, iMapVect)));
                end
                
                if nargin > 1
                    nConnections = size(connections, 2);
                    % Connect nodes
                    for iConnection = 1:nConnections
                        pair = connections(:,iConnection);
                        obj.mapNodes(pair(1)).addRelation(obj.mapNodes(pair(2)));
                    end
                end
            end
            
        end
        
        function addNode(obj, node)
            if ~any(obj.mapNodes == node)
                obj.mapNodes = [obj.mapNodes node];
            end
        end
        
        function node = getRandomNode(obj)
            node = obj.mapNodes(randi([1 size(obj.mapNodes, 2)]));
        end
        
        function plot(obj)
            clf;
            axis equal;
            hold on;
            obj.mapNodes(1).plotRecursivly();
            hold off;
        end
    end
    
end

