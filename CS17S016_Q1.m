clc; clear all; close all;
%% Initialization
n = 100;
network = rand(n,2); % Generating a network with 100 nodes
l = 0; % lower bound

cost = zeros(n,n);
for i = 1:n
    for j=1:n
        cost(i,j) = norm(network(i) - network(j))/sqrt(2); % Computing cost matrix
    end
end

b = zeros(n,1); % external supply 
b(1:n) = 200;
b(n/2 + 1:end) = -200;

%% Solving using CVX for different values of u_ij

U_ranges = [5,10,30,50,100]; % ranges of u_ij upper bound
cost_function_trend = zeros(length(U_ranges),1);
itr = 1;

for u = U_ranges
    cvx_begin
          variables x(n,n)
          minimize(sum(sum(cost.*x))); % Minimizing total cost across the network
          
          for i = 1:n
             b(i) +  sum(x(:,i)) - sum(x(i,:)) == 0; % conservation of flow
          end

          for i = 1:n
              for j = 1:n
                  x(i,j) >= l; % lower bound
                  x(i,j) <= u; % upper bound
              end
          end


%       Other method to specify constraints  
%           b + sum(x,1)' - sum(x,2) == zeros(n,1); % conservation of flow
%           
%           x(:)>=l*ones(n*n,1); % lower bound
%           x(:)<=u*ones(n*n,1); % upper bound
    
    cvx_end
    
    cost_function_trend(itr) = cvx_optval;
    itr = itr+1;
end

%% Plotting Total Cost vs Upper Bound u_ij

plot(U_ranges,cost_function_trend,'LineWidth',2);
title('Total Cost vs Upper Bound u_{ij}');
xlabel('Upper Bound u_{ij}');
ylabel('Total Cost');
print('-djpeg','Plot_Q1.jpg', '-r300'); % Saving image
close all;