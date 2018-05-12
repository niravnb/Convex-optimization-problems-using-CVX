clc; clear all; close all;

%% Loading data from xlsx file

data_C1 = xlsread('Q5Data_Classification', 'Data1'); % Class 1 data
data_C2 = xlsread('Q5Data_Classification', 'Data2'); % Class 2 data

n = 2; % Dimension
N = length(data_C1); % Class 1: Number of data points
M = length(data_C2); % Class 2: Number of data points

%% Setting range of gamma's from 0 to 2 with step size of 0.05 
g = [0:0.05:2];

F1 = zeros(length(g),1); % for storing norm(a) for all values of gamma
F2 = zeros(length(g),1); % for storing 1'*u + 1'*v for all values of gamma
optimal_values = zeros(length(g),1); % for storing optimal values for all values of gamma

%% Solution via CVX
for l = 1:length(g) % Running for all values of gamma
    cvx_begin
        variables a(n) b(1) u(N) v(M)
        minimize (norm(a) + g(l)*(ones(1,N)*u + ones(1,M)*v)) % Minimizing |a||_2 + gamma*(1'*u + 1'*v)
        data_C1*a - b >= 1 - u;
        data_C2*a - b <= -(1 - v);
        u >= 0;
        v >= 0;
    cvx_end
    F1(l) = norm(a); % Storing norm(a) for current gamma
    F2(l) = (ones(1,N)*u + ones(1,M)*v); % storing 1'*u + 1'*v for current gamma
    optimal_values(l) = cvx_optval; % storing optimal value for current gamma
end

[sorted,ind] = sort(optimal_values);

%% Plotting optimal trade-off curve (pareto frontier)
figure
plot(F1,F2,'LineWidth',2); % Plotting norm(a) vs. 1'*u + 1'*v
title('Optimal Trade-off Curve (pareto frontier)');
xlabel('F1: Norm(a)');
ylabel('F2: 1*u + 1*v');
hold on;
scatter(F1(3),F2(3),'r','filled'); % highlighting chosen optimal trade-off point
str = ['Chosen optimal trade-off point at F1 = ',num2str(F1(3)),' F2 = ',num2str(F2(3)),' for \gamma = 0.1'];
dim = [0.2 0.4 0.4 0.4];
annotation('textbox',dim,'String',str,'FitBoxToText','on'); % Placing text box on plot
print('-djpeg','trade-off.jpg', '-r300'); % Saving image
close all;

%% Choosing g = 0.1 as optimal trade-off by observing from the above plot and finding optimal variables
g = 0.1;
cvx_begin
    variables a(n) b(1) u(N) v(M)
    minimize (norm(a) + g*(ones(1,N)*u + ones(1,M)*v))
    data_C1*a - b >= 1 - u;
    data_C2*a - b <= -(1 - v);
    u >= 0;
    v >= 0;
cvx_end

%% Displaying results
t_min = min([data_C1(:,1);data_C2(:,1)]); % Finding min of x-axis
t_max = max([data_C1(:,1);data_C2(:,1)]); % Finding max of x-axis
tt = linspace(t_min-1,t_max+1,100);
p = -a(1)*tt/a(2) + b/a(2); % Finding linear discriminator
p1 = -a(1)*tt/a(2) + (b+1)/a(2); % Finding linear slab for class 1
p2 = -a(1)*tt/a(2) + (b-1)/a(2); % Finding linear slab for class 2

figure
scatter(data_C1(:,1),data_C1(:,2), 'b', 'filled'); % Plotting class 1 data
hold on;
scatter(data_C2(:,1), data_C2(:,2), 'r','filled'); % Plotting class 2 data

plot(tt,p, '-k', tt,p1, '--k', tt,p2, '--k','LineWidth',2); % Plotting linear discriminator
title('Support Vector Classifier for \gamma = 0.1');
xlabel('X');
ylabel('Y');
print('-djpeg','SVM.jpg', '-r300'); % Saving image
close all;
