function [ S_bar ] = predict( S, v, deltaOmega, deltaT, R )
%UPDATE Summary of this function goes here
%   Detailed explanation goes here

M = size(S, 2);

S_omega = S(3,:) + deltaOmega;

noise = randn(M, 2) * R;

%vNoise = S(4,:) + (a + noise(:,1))' * deltaT;
vNoise = noise(:,1)' + v;

inovation = [deltaT * vNoise .* cos(S_omega);
             deltaT * vNoise .* sin(S_omega);
             deltaOmega + noise(:,2)';
             repmat(v, 1, M);
             zeros(1, M)];
         
S_bar = S + inovation;
     
end

