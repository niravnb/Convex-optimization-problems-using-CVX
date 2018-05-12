clc; clear all;
%% Initializing A & B
A = [-0.94, 1.19; -1.67,1.19; 0.13,-0.04; 0.29,0.33; -1.15,0.18];
B = [-0.19;0.72;-0.59;2.18;-0.14];
m = length(A);
%% a) Using norm.

fprintf('Solving Part (a): \n');

cvx_begin
      variables x(2,1)
        minimize(norm(A*x-B,3/2)); % Minimizing objective 
cvx_end



%% b) Formulate this problem as an SDP.

fprintf('Solving Part (b): \n');

cvx_begin sdp
      variables x(2) t(m,1) u(m,1) s(m,1)
      minimize(sum(t)); % Minimizing objective
      
      A*x - B <= s; % LMI Constraints
      A*x - B >= -s;
      
      
      for i = 1:m
          [u(i) s(i); s(i) t(i)] >= 0; % PSD Constraints
          u(i) <= sqrt(s(i));
      end
      
cvx_end