function [path] = task_1(map, startPoint, stopPoint)
% Team 12
warning off
maptown = map(:,:,1);
speedLimitCost = map(:,:,2);
trafficIntensity = map(:,:,3);
obstacleCost = map(:,:,4);

cost = speedLimitCost.*trafficIntensity + obstacleCost;
%cost(cost >= 50) = 50;
cost = cost/100 + ~maptown;

mapcost = occupancyMap(cost);
planner = plannerAStarGrid(mapcost);
[path,~] = plan(planner,startPoint,stopPoint);

if isempty(path)
fprintf('BRAK DOJAZDU\n')
else
path = [path(:,2),path(:,1)];
end

end