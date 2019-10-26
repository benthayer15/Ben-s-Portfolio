%----------------
%General Comments: (Not Necessarily In Order Of Importance)
%----------------

    %1. For a single path, use the homotopy code with
        %both parameterizations set equal.
    
    %2. More terms of the Taylor series = more accurate. 
        %It should be easy to add more terms in: f5, f6, etc. in
        %the function defns. and simply adding appropriate terms to 
        %the algorithm section.
    
    %3. The function definitions and algorithm are already set up so that
        %you can have derivatives which are explicitly dependent on w, as
        %well as on x and v, i.e., it's set up to solve the general
        %2nd-order ODE, not just the autonomous case.
    
    %4. This was originally designed to solve the general 2nd-order
        %IVP y'' = f(z, y, y'), y = y(z) by analytically continuing the 
        %initial values into the complex plane and back to the real axis
        %at a later time, so as to avoid a singularity on the real axis
        %that we know about. However,it is difficult to know where
        %those singularities are in advance, given only the ODE.
        
        %In principle, however, it works and can be extended to any order
        %ODE by (i) the addition of terms in the Taylor series, (ii) the
        %addition of appropriate matrices for y'' for a 3rd-order ODE, y'''
        %for a 4th-order ODE, etc. in the algorithm, (iii) the addition
        %of initial values y'''(z0), etc., (iv) the modification of the
        %function definitions to pass more arguments (x'', x''', etc.) and
        %finally (v) the modification of the arguments of these functions
        %in their actual implementation in the algorithm.
    
        %That being said, it works great for simply analytically continuing
        %a known function, provided you avoid the singularities, near which
        %the whole Taylor series would be needed to get a remotely accurate
        %continuation.
        
    %5. The idea for this code was inspired by the discussion in Chapter 9
        %(Continuous Analytic Continuation) of the book "Introduction to
        %Nonlinear Differential and Integral Equations" by Harold T. Davis,
        %published originally in 1960 by the United States Atomic Energy
        %Commission and republished in 1962 by Dover Publications, Inc.
        %However, the code itself is original, and in addition to various
        %small generalizations, the author came up with the idea to use a 
        %homotopy of paths autonomously.
        
        %--Benjamin Thayer, 11-20-2018

%--------------------
%Function definitions (4th-order Taylor polynomial)
%--------------------

f2 = @(w, x, v) (-10*x - 5*v);          %fi is the ith derivative of x
f3 = @(w, x, v) (5*x);                  %x = x(w), v = x'(w)
f4 = @(w, x, v) (-0.2*v);

%--------------
%Initial Values:
%--------------

z0 = 0 + 1i*0;               %In general, initial values are complex
y0 = -1 + 1i*0;
y_dot0 = 5 + 1i*0;

%-------------------
%Parameterized Paths:
%-------------------

        %First a reference code for a few archetypal 
        %paths, and then a homotopy of paths.

%Path #1: Straight Line along real axis

        %t = 0:0.01:1;
        %z = z0 + (z_final - z0).'*t; 

%Path #2: Circular Arc With Radius R

        %t = pi:-0.001:0; 
        %R = (1/2)*(z_final - z0);
        %z = (1/2)*(z0 + z_final) + R*exp(1i*t);

%Path #3: Polygonal Path

        %t = 0:0.01:1;
        %pivot = [z0, 1-1i, 2-1i, z_final];      %Specify vertices in order

        %z = zeros(length(pivot) - 1, length(t));
        %for m = length(pivot):-1:2
         %   z((m-1),:) = pivot(m - 1) + (pivot(m) - pivot(m - 1))*t;
        %end
        %z = z.'; z = z(:)';

%-------------------
%A Homotopy Of Paths:
%-------------------

t_step = 0.002; 
t_max = 1; 
t = 0:t_step:t_max; 
tau = length(t);

s_step = 0.002; 
s = 0:s_step:1;                      %(s_max is always 1)
sigma = length(s);

         %Two Parameterizations:

zfinal = 2*pi;
pivot1 = [z0, pi+pi*exp(1i*(2/3)*pi), pi+pi*exp(1i*(1/3)*pi), zfinal];
pivot2 = [z0, pi+pi*exp(1i*(4/3)*pi), pi+pi*exp(1i*(5/3)*pi), zfinal];

z1 = zeros(length(pivot1) - 1, tau);
for m = length(pivot1):-1:2
    z1((m-1),:) = pivot1(m - 1) + (pivot1(m) - pivot1(m - 1))*t;
end
z1 = z1.'; z1 = z1(:).';

z2 = zeros(length(pivot2) - 1, tau);
for m = length(pivot2):-1:2
    z2((m-1),:) = pivot2(m - 1) + (pivot2(m) - pivot2(m - 1))*t;
end
z2 = z2.'; z2 = z2(:).';

t = [t t t];
tau = length(t);

         %The Homotopy Matrix:

H = (z1.')*ones(1, sigma) + ((z2 - z1).')*s;    
z_step = H(2:tau, :) - H(1:(tau - 1), :);


%-------------------------------
%Analytic Continuation Algorithm:
%-------------------------------

y = y0*ones(sigma, tau);
y_dot = y_dot0*ones(sigma, tau);

for k = 2:tau
    y(:, k) = y(:, k-1)  +  ((z_step(k-1, :)).').*y_dot(:, k-1) ... 
         +  (1/2)*((z_step(k-1, :).^2).').*((f2(H(k-1, :).', y(:, k-1), y_dot(:, k-1))).^2) ...
         +  (1/6)*((z_step(k-1, :).^3).').*((f3(H(k-1, :).', y(:, k-1), y_dot(:, k-1))).^3) ...
         +  (1/24)*((z_step(k-1, :).^4).').*((f4(H(k-1, :).', y(:, k-1), y_dot(:, k-1))).^4);
    
    y_dot(:, k) = y_dot(:, k-1)  +  (z_step(k-1, :).').*f2(H(k-1, :).', y(:, k-1), y_dot(:, k-1)) ...
         +  (1/2)*((z_step(k-1, :).^2).').*((f3(H(k-1, :).', y(:, k-1), y_dot(:, k-1))).^2) ...
         +  (1/6)*((z_step(k-1, :).^3).').*((f4(H(k-1, :).', y(:, k-1), y_dot(:, k-1))).^3);
end

%-----
%Plots:
%-----

%2D plot of along Re(z) axis:

        %plot(real(H(tau, :)), real(y(:, tau)));   
        %xlabel('Re(z)'); ylabel('Re(y)');
        %axis([min(real(H(tau, :))) max(real(H(tau, :))) ...
        %min(real(y(tau, :))) max(real(y(tau, :)))]);
        %shg

%3D plot of Re y[H(t,s)] above the real ts-plane:  
        
        %mesh(t, s, real(y));                       
        %xlabel('t'); ylabel('s'); zlabel('Re(y)');
        %axis([min(t) max(t) min(s) max(s) min(min(real(y))) ...
        %max(max(real(y))) min(min(real(y))) max(max(real(y)))]);
        %shg

%3D plot of Re y(z) above the complex z-plane:   
        
        mesh(real(H), imag(H), real(y).');   %NOTE: may need to transpose real(H)
                                             %and imag(H) or real(y) to get 
                                             %proper 3D orientation
        xlabel('Re(z)'); ylabel('Im(z)'); zlabel('Re(y)');
        axis([min(min(real(H)))-eps max(max(real(H)))+eps min(min(imag(H)))-eps ...
        max(max(imag(H)))+eps min(min(real(y))) max(max(real(y))) ...
        min(min(real(y))) max(max(real(y)))]);
        shg

%3D plot of Im y(z) above the complex z-plane:   
        
        %mesh(real(H).', imag(H).', imag(y));          
        %xlabel('Re(z)'); ylabel('Im(z)'); zlabel('Im(y)');
        %axis([min(min(real(H)))-eps max(max(real(H)))+eps min(min(imag(H)))-eps ...
        %max(max(imag(H)))+eps min(min(imag(y))) max(max(imag(y))) ...
        %min(min(imag(y))) max(max(imag(y)))]);
        %shg

