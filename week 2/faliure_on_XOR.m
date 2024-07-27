% XOR input data
X = [0, 0; 0, 1; 1, 0; 1, 1];
Y = [0; 1; 1; 0];

% Plotting XOR data
figure;
hold on;
scatter(X(Y==0, 1), X(Y==0, 2), 'ro', 'filled');
scatter(X(Y==1, 1), X(Y==1, 2), 'bo', 'filled');
xlabel('Input 1');
ylabel('Input 2');
legend('Class 0', 'Class 1');
title('XOR Problem');