classdef MapNode < handle
    %MAPNODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        position % Coordinates in the global map
        index    % Node index in the map
        relations = MapNode.empty()
    end
    
    methods (Static)
        function index = getNextIndex()
            persistent currentIndex;
            
            if isempty(currentIndex)
                currentIndex = 1;
            else
                currentIndex = currentIndex + 1;
            end
            
            index = currentIndex;
        end
    end
    
    methods
        % Initializer
        function obj = MapNode(x, y)
            if nargin == 0
                return
            end
            
            if nargin == 1
                obj.position = [x(1); x(2)];
            else
                obj.position = [x; y];
            end
            
            obj.index = MapNode.getNextIndex();
        end
        

        function addRelation(obj, relatedNode)
            % Add a related node
            if ~any(obj.relations == relatedNode) && obj ~= relatedNode
                
%                  fprintf('Adding (%.1f, %.1f) to (%.1f, %.1f)\n', ...
%                 relatedNode.position(1), relatedNode.position(2), ...
%                 obj.position(1), obj.position(2));
                
                obj.relations = [obj.relations relatedNode];
                relatedNode.addRelation(obj);
            end
        end
        
        
        function relations = getRelations(obj)
            relations = obj.relations;
        end
        
        
        function connections = getConnections(obj)
            nRelations = size(obj.relations, 2);
            connections = MapLine.empty(0, nRelations);
            
            for iRelation = 1:nRelations
                connections(iRelation) = MapLine(obj, obj.relations(iRelation));
            end
        end
        
        
        function node = getRelation(obj, index)
            node = obj.relations(index);
        end
        
        
        function node = getRandomRelatedNode(obj, ignoreNode)
            % Randomly pick a related node. Optionally one or many nodes
            % can be ignored
            nRelations = size(obj.relations, 2);
            
            if nargin == 2
                nRelations = nRelations - 1;
            end
            
            if nRelations > 1
                iRelation = randi([1 (nRelations)]);
                
                if nargin == 2 && obj.relations(iRelation) == ignoreNode
                    iRelation = iRelation + 1;
                end
                
            elseif nRelations == 1
                iRelation = 1;
            else
                error('Not enough relations to node');
            end
            
            node = obj.relations(iRelation);
        end
        
        
        function newNode = plus(obj, bNode)
            if isprop(bNode, 'position')
                newNode = MapNode(obj.position + bNode.position);
            else
                newNode = MapNode(obj.position + bNode(:));
            end
        end
        
        
        function difference = minus(obj, bNode)
            % Calculates the difference in position
            difference = obj.position - bNode.position;
        end
        
        
        function ml = colon(obj, toNode)
            % Creates a map line from two map points
            ml = MapLine(obj, toNode);
        end
        
        
        function isequal = eq(obj, otherNode)
            if isempty(obj)
                isequal = false;
                return
            end
            
            % Two nodes are equal when their positions are the same
            isequal = prod(bsxfun(@eq, [obj.position], otherNode.position), 1);
        end
        
        
        function h = plot(obj)
            h = plot(obj.position(1), obj.position(2), 'o');
        end
        
        
        function h = plotRecursivly(obj)
            nRelations = size(obj.relations, 2);
            for iRelation = 1:nRelations
                relatedNode = obj.relations(iRelation);
                if relatedNode.index > obj.index
                    plot([obj.position(1) relatedNode.position(1)], ...
                         [obj.position(2) relatedNode.position(2)]);
                     
                    relatedNode.plotRecursivly();
                end
            end
        end
    end
end
