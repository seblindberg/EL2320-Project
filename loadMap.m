function [ map, relations ] = loadMap()
%LOADMAP Load a map and declare all relations within it
%   Load a set of coordinates and a list of coordinate pairs and convert
%   those into an array of ...

    map = [1 1;
           2 2;
           3 3;
           3 1;
           3 5;
           2 5;
           1 3]';

    connections = [1 2;
                   1 7;
                   2 3; 
                   2 4;
                   2 6;
                   3 5;
                   5 6;
                   1 4;
                   3 4;
                   6 7;
                   7 2]';

    nMap = size(map, 2);
    nConnections = size(connections, 2);

    relations = cell(nMap, 1);

    for iConnections = 1:nConnections
        connection = connections(:, iConnections);
        fromIndex = connection(1);
        toIndex = connection(2);

        relations{fromIndex} = [relations{fromIndex} toIndex];
        relations{toIndex}   = [relations{toIndex} fromIndex];
    end

end

