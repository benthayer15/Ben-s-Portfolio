%          -------------
%          Introduction:
%          -------------
%          
%    The purpose of this code is 
%          -------------------------------------------------------
%
%    x'' = f(x, x', y, y', t)
%    y'' = g(x, x', y, y', t)
%
%    Approach: Expand x, y in Taylor series up to O(t^2) to 
%    obtain a numerical algorithm.
%
%    For the purposes of the code, let a = x, b = y, c = x', and d = y'.
%    ...

%          --------------------
%          Function Definitions:
%          --------------------

f = @(A, B, C, D, T)((C - 4.*C.*D.*cos(B)).*((D.^2).*(csc(B))+((C.^2).*sin(B)))./(2*((D.^2) + (C.^2).*((sin(B)).^2))));
g = @(A, B, C, D, T)(((C.^2).*sin(B).*cos(B)) + (D./(2*((D.^2) + (C.^2).*(sin(B).^2)))));

%          --------------
%          Initial Values:
%          --------------

t_0 = 0;
t_final = 1;

a0 = pi;     %initial positions
b0 = pi/4;

c0 = 1;      %initial velocities
d0 = 1;



%          --------------
%          Discretization:
%          --------------

numPts = 10000;
t = linspace(t_0, t_final, numPts);
delta_t = (t_final - t_0)/(numPts - 1);
a = [a0, zeros(1, numPts - 1)];
b = [b0, zeros(1, numPts - 1)];
c = [c0, zeros(1, numPts - 1)];
d = [d0, zeros(1, numPts - 1)];

%          -------------------
%          Numerical Algorithm:
%          -------------------

for i = 1:(numPts - 1)
    a(i + 1) = a(i) + c(i)*delta_t + (1/2)*(delta_t^2)*f(a(i), b(i), c(i), d(i), t(i));
    b(i + 1) = b(i) + d(i)*delta_t + (1/2)*(delta_t^2)*g(a(i), b(i), c(i), d(i), t(i));
    c(i + 1) = c(i) + delta_t*f(a(i), b(i), c(i), d(i), t(i));
    d(i + 1) = d(i) + delta_t*g(a(i), b(i), c(i), d(i), t(i));
end

%     ASIDE: Graphing the Solution.
%
%     Now suppose the surface parameterization is given by:
%
%           X = F(x, y), Y = G(x, y), Z = H(x, y),
%
%     where F, G, H are functions we will soon define. Then we want to
%     graph both the surface and the geodesic curve that has been 
%     calculated (at least parametrically). Thus we need a 2D
%     discretization in terms of variables u and v for the surface, and 
%     then we will use F, G, H to plot both the surface and the geodesic.


%          -----------------------------------------
%          Surface Parameterization & Discretization:
%          -----------------------------------------

surface_pts = 200;

F = @(M, N)((cos(M)')*sin(N));     %Parametric definition of surface for matrices
G = @(M, N)((sin(M)')*sin(N));
H = @(M, N)((ones(surface_pts, 1))*cos(N));

F2 = @(m, n)(cos(m).*sin(n));
G2 = @(m, n)(sin(m).*sin(n));
H2 = @(m, n)(cos(n));

u0 = 0; u_final = 2*pi;       %Parameter domains
v0 = 0; v_final = pi;

u = linspace(u0, u_final, surface_pts);
v = linspace(v0, v_final, surface_pts);

%          -----------
%          Final Plots:
%          -----------

X = F(u, v);
Y = G(u, v);
Z = H(u, v);

Gx = F2(a, b);
Gy = G2(a, b);
Gz = H2(a, b);

mesh(X, Y, Z), hold on
axis equal
grid off
axis off
plot3(Gx, Gy, Gz, 'LineWidth', 2);







