function [ S_bar ] = predict( S, v, deltaOmega, deltaT, R )
%UPDATE Summary of this function goes here
%   Detailed explanation goes here

M = size(S, 2);

S_omega = S(3,:) + deltaOmega;

inovation = [v * deltaT * cos(S_omega);
             v * deltaT * sin(S_omega);
             repmat(deltaOmega, 1, M);
             zeros(1, M)];
         
noise = [R * randn(3, M);
         zeros(1, M)];

S_bar = S + inovation + noise;
     
end

