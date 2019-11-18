clear all
close all
clc

load('OD_workspace')
% Destinations that are below CGD1 
Dest_no=Destinatio(Latitude<3342312);
% ID of these destinations below CGD1
unique_Dest=unique(Dest_no);
% transportation cost at destination i and 
cost=zeros(1,length(unique_Dest))';
% for all the destinations below CGD 1
for i=1:length(unique_Dest) 
    i
    % origins that go to each destination 
    Origins=OriginID(Destinatio==unique_Dest(i));
    % Straw available at these origins
    Straw_i=straw_amt(Origins);
    % Travelling distance to each of these destinations from each origins 
    Distance=Dist(Destinatio==unique_Dest(i));
    % cost_per_kg at each origins
    cost_per_kg=(1/6000)*((2*Distance/40000)*0.74+(2*Distance/1000)*(30/100)*0.97);
    straw_total=0;
    cost_j=0;
    origins_j=zeros(1,length(Origins));
    
    
   for j=1:length(Origins)
        if straw_total<2.9579*10^7
            [C,R]=min(cost_per_kg);
            origins_j(j)=Origins(R);
            straw_total=straw_total+straw_amt(Origins(R));
            cost_j=cost_j+cost_per_kg(R)*straw_amt(Origins(R));
            cost_per_kg(R)=NaN;   
        else
            break
        end
   end
    origins_j=origins_j(all(origins_j,2));
    last_cost_per_kg=(1/6000)*((2*Distance(Origins==origins_j(end))/40000)*0.74+(2*Distance/1000)*(30/100)*0.97);
    cost(i)=cost_j-(straw_total-2.9579*10^7)*
end


[C1,R1]=min(cost);
% 
% % origins to the destinations 
% Origins=OriginID(Destinatio==unique_Dest(R1));
%     % Straw available at these origins
%     Straw_i=straw_amt(Origins);
%     % Travelling distance to each of these destinations from each origins 
%     Distance=Dist(Destinatio==unique_Dest(R1));
%     % cost_per_kg at each origins
%     cost_per_kg=(1/6000)*((2*Distance/40000)*0.74+(2*Distance/1000)*(30/100)*0.97);
%     straw_total=0;
%     cost_j=0;
%     origins_j=zeros(1,length(Origins))';
%     
%     for j=1:length(Origins)
%         if straw_total<2.9579*10^7
%             [C,R]=min(cost_per_kg);
%             origins_j(j)=Origins(R);
%             straw_total=straw_total+straw_amt(Origins(R);
%             cost_j=cost_j+cost_per_kg(R)*straw_amt(Origins(R));
%             cost_per_kg(R)=NaN;
%         else
%             break
%         end
%     end
