
%Define physical parameters/initial values:
k = 20;
m = 20;
omegasqr = k/m;
r_tilda = 0;
init_r = 1000;
init_rdot = 0;
init_theta = pi/2;
init_thetadot = 1;

%Initialize vectors:
t_step = 0.0001;
t_max = 100;
t = 0:t_step:t_max;
n = length(t);

x1 = zeros(1, n);
x2 = x1;
x3 = x1;
x4 = x1;
X = x1;
Y = x1;

x1(1) = init_r;
x2(1) = init_rdot;
x3(1) = init_theta;
x4(1) = init_thetadot;

%Initialize functions
f = @(a, b, c, d)(a.*(d).^2 - (omegasqr).*a + (omegasqr).*r_tilda);
g = @(a, b, c, d)(-2*(b.*d)./a);

for i=1:n-1
    x1(i+1) = x1(i) + x2(i)*t_step;
    x2(i+1) = x2(i) + f(x1(i), x2(i), x3(i), x4(i))*t_step;
    x3(i+1) = x3(i) + x4(i)*t_step;
    x4(i+1) = x4(i) + g(x1(i), x2(i), x3(i), x4(i))*t_step;
end

X = x1.*(cos(x3));
Y = x1.*(sin(x3));


hold on
axis([min(X) max(X) min(Y) max(Y)]);
plot(X, Y);
plot(0, 0, 'o');
shg















