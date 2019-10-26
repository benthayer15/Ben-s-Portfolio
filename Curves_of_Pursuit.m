%--------
%Preface:
%--------

%   This script numerically solves the problem of determining curves of
%   pursuit, i.e., solutions to the question, "If a fleeing party takes a
%   prescribed path through space while being pursued by another party,
%   what is the path of the pursuing party?"
%
%   The most important assumptions in the formulation of this problem are
%   (1) the fleeing party has no knowledge of its being pursued and simply
%   takes a prescribed path, and (2) the pursuer is always traveling
%   directly toward the fleeing party. Fixed velocities for both parties
%   are assumed as well, although the code can be easily modified to
%   accommodate variable speeds. To do this, one would simply replace the
%   fixed ratio of velocities, "k" below, with a vector of length "n"
%   containing variable ratios according to some function k(t). 
%
%   The motivation for simulating this problem numerically is that, even
%   with its relatively simple assumptions, it leads to nonlinear
%   differential equations which are in general not solvable analytically.
%   For this reason also, the code will not be stable for small "n" values.
%   The author suggests experimenting with different values of parameters
%   to produce a great variety of pursuit curves. In particular, change 
%   "k," the functions a, b, and c, and the starting positions of the
%   pursuer. Don't forget to adjust the "axis" and "view" commands as
%   necessary or as desired.
%
%   Extra features include a tolerance below which the code will halt and
%   the pursuing party will be said to have caught the fleeing party, and a
%   few lines explaining how to create a video file depicting the plotted
%   pursuit. Additional explanatory comments are included throughout.
%   -B. Thayer, author (2019).

%----------
%Main Code:
%----------

n = 3000;                  %Number of points in discretization
t = linspace(0, 10, n);    %Parameterization variable & range
k = 0.75;                  %Ratio of pursuing velocity to fleeing velocity

a = @(s) (cos(s));         %Parametric path of fleeing curve
b = @(s) (sin(s));         %Starts at a(0), b(0), c(0)
c = @(s) (sin(2*s));

fl_x = a(t);               %Discretized parameterization of fleeing curve
fl_y = b(t);               %in terms of a common index i
fl_z = c(t);

x = zeros(1,n);            %Coordinates of pursuer with
x(1) = -1;                 %starting location (x(1), y(1), z(1))
y = zeros(1,n);
y(1) = 0;
z = zeros(1,n);
z(1) = 0.5;

for i = 1:n-1              %Computes the path of the pursuer
    sigma = sqrt((fl_x(i+1) - fl_x(i)).^2 + (fl_y(i+1) - fl_y(i)).^2 ...
        + (fl_z(i+1) - fl_z(i)).^2);    %arc length of fleeing curve
    delta_s = k*sigma;                  %arc length of pursuing curve
    dist_apt = 1./(sqrt((fl_x(i) - x(i)).^2 + (fl_y(i) - y(i)).^2) ...
        + (fl_z(i) - z(i)).^2);
    x(i+1) = x(i) + delta_s*dist_apt*(fl_x(i) - x(i));
    y(i+1) = y(i) + delta_s*dist_apt*(fl_y(i) - y(i));
    z(i+1) = z(i) + delta_s*dist_apt*(fl_z(i) - z(i));
end

fg1 = figure();            %Figure properties & aesthetics
axis([-1.5 1.5 -1.5 1.5 -1.5 1.5 -1 1]);
axis equal;
fg1.OuterPosition = [0 0 1080 1920];
grid off;
fleeing_curve = animatedline('Color', 'r', 'LineWidth', 2);
pursuit_curve = animatedline('Color', 'b', 'LineWidth', 2);
hold on
P2 = plot3(fl_x(1), fl_y(1), fl_z(1), 'x', 'MarkerEdgeColor', 'r');
P1 = plot3(x(1), y(1), z(1), 'o', 'MarkerEdgeColor', 'b');
hold off
xticks = []; yticks = []; zticks = [];
xticklabels([]); yticklabels([]); zticklabels([]);
legend('Path Traced While Fleeing', 'Path Traced While Pursuing', ...
    'Fleeing Party','Pursuing Party');
view(45, 45);
axis off;


disp_Rate = 25;
N = newline;

for i = 1:floor(n/disp_Rate)  %Dynamically plots the pursuit
   addpoints(fleeing_curve, fl_x(disp_Rate*i), fl_y(disp_Rate*i), ...
       fl_z(disp_Rate*i));
   addpoints(pursuit_curve, x(disp_Rate*i), y(disp_Rate*i), ...
       z(disp_Rate*i));
   
   P1.XData = x(disp_Rate*i);   P2.XData = fl_x(disp_Rate*i);
   P1.YData = y(disp_Rate*i);   P2.YData = fl_y(disp_Rate*i);
   P1.ZData = z(disp_Rate*i);   P2.ZData = fl_z(disp_Rate*i);
   
   drawnow limitrate nocallbacks;
 
   if (sqrt((fl_x(disp_Rate*i) - x(disp_Rate*i))^2 ...
           + (fl_y(disp_Rate*i) - y(disp_Rate*i))^2 ...
           + (fl_z(disp_Rate*i) - z(disp_Rate*i))^2) < 0.001)
                %Note: "Caught" Tolerance is 0.001
       time_elapsed = t(disp_Rate*i);
       disp([N, N, N, N, 'The pursuit is over; the fleeing ', ...
           'party has been caught.', N, N, 'Total time elapsed is ', ...
           num2str(time_elapsed), ' seconds.', N, N, N, N]);
       break
   end
   
  %M(i) = getframe(fg1);     %Collects frames in order to write video file
  pause(0.01);               %Regulates plotting/video speed
end

%------------
%Video Files:
%------------

%Copy and paste into command window to write video file, one ...
% ... line at a time:

        %vid1 = VideoWriter('INSERT NAME', 'MPEG-4');
        %open(vid1);
        %writeVideo(vid1, M);
        %close(vid1);      (Video is saved under: "fileName.mp4")

