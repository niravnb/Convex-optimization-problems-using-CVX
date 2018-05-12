clc; clear all; close all;
%% Loading data from file
veh_speed_sched_data

%% Sloving using CVX
   cvx_begin
       variable t(n) % Transit times of the segments (doing change of variables)
       minimize(sum(a*d.^2.*inv_pos(t)+b*d+c*t)) % Minimize transformed objective
       t<=d./smin;
       t>=d./smax;
       tau_min<=cumsum(t);
       tau_max>=cumsum(t);
   cvx_end
   
%% Ploting graph of Optimal Speed vs Segment
   s=d./t; % optimal speed
   stairs(s,'LineWidth',2); % Using stairs to show constant speed over the segments
   title('Optimal Speed vs Segment');
   xlabel('Segment i');
   ylabel('Optimal Speed s_i');
   print('-djpeg','speed.jpg', '-r300'); % Saving image
   close all;
