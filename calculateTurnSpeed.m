function vTurn = calculateTurnSpeed( v, angle )
%CALCULATETURNSPEED Summary of this function goes here
%   Detailed explanation goes here

V_MIN = 0.1;

if angle < pi/2
    vTurn = (1 - 2 * angle / pi) * (v - V_MIN) + V_MIN;
else
    vTurn = V_MIN;
end
    
end

