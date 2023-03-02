
n = 10; %number of points
maxVal = 10;
A = ones(n, n); %initialize coefficient matrix


    X = 2*maxVal*rand(2, n) - maxVal; % pick n random points with x,y 
                                      % between -maxVal and maxVal                                  
    for i = 2:n
       A(:, i) = A(:, i-1).*X(1,:)';
    end

B = A\X(2,:)'; %solve for polynomial coefficients

t = -maxVal:0.02:maxVal;
C = ones(length(t), n);
for i = 2:n
    C(:, i) = C(:, i-1).*t';
end

Poly = C*B; %compute polynomial outputs
hold on
axis([-maxVal maxVal -maxVal maxVal]);
plot(t', Poly); %graph
scatter(X(1,:), X(2,:));
shg