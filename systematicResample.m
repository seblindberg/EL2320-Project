% function S = systematic_resample(S_bar)
% This function performs systematic re-sampling
% Inputs:   
%           S_bar(t):       4XM
% Outputs:
%           S(t):           4XM
function S = systematicResample(S_bar)

M = size(S_bar, 2);

r_0 = rand() / M;

S = [zeros(3, M);
     repmat(1/M, 1, M)];

CDF = cumsum(S_bar(4,:));

i = 1;
for m = 1:M
    while CDF(i) < (m - 1) / M + r_0;
        i = i + 1;
    end
    
    S(1:3, m) = S_bar(1:3, i);
end

end