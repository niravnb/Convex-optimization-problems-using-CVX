clc; clear all;

%% Initializing A's

A0 = [0.16, 0.43, 0.36, 0.37; 0.43, 1.60, 1.07, 0.84; 0.36,  1.07, 0.87, 0.65; 0.37, 0.84, 0.65, 1.19];
A1 = [1.88, 1.36, 0.57,1.84; 1.36, 1.26, 0.39, 1.23; 0.57, 0.39, 0.82, 1.14; 1.84, 1.23, 1.14, 2.43];
A2 = [1.38,1.24, 1.10,1.17; 1.24, 1.49, 1.22, 1.20; 1.10, 1.22, 1.38, 1.17; 1.17, 1.20, 1.17, 1.15];

%% a) Minimize the maximum eigenvalue lambda_1(x)

fprintf('Solving Part (a): \n');

cvx_begin sdp
      variables x(2) t
      minimize(t); % Minimizing objective
      A0 + x(1)*A1 + x(2)*A2 <= t*eye(4); % constraints
cvx_end

%% b) Minimize the spread of the eigenvalues, lambda_1(x) - lambda_m(x)

fprintf('Solving Part (b): \n');

cvx_begin sdp
      variables x(2) t1 t2
      minimize(t1 - t2); % Minimizing objective
      A0 + x(1)*A1 + x(2)*A2 <= t1*eye(4);
      A0 + x(1)*A1 + x(2)*A2 >= t2*eye(4);
cvx_end

%% c)Minimize the condition number of A(x), subject to A(x) > 0. 


fprintf('Solving Part (c): \n');

cvx_begin sdp
      variables y(2) t s
      minimize(t); % Minimizing objective
      s*A0 + y(1)*A1 + y(2)*A2 <= t*eye(4);
      s*A0 + y(1)*A1 + y(2)*A2 >= eye(4);
      s>=0;
cvx_end

%% d) Minimize the sum of the absolute values of the eigenvalues.

fprintf('Solving Part (d): \n');

cvx_begin sdp
      variables x(2) 
      variable A_plus(4,4) symmetric 
      variable A_minus(4,4) symmetric
      minimize(trace(A_plus) + trace(A_minus)); % Minimizing objective
      A0 + x(1)*A1 + x(2)*A2 == A_plus - A_minus;
      A_plus >= 0;
      A_minus >= 0;
cvx_end