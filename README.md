# Ben-s-Portfolio

This is a repository for a few of my (Ben's) programming projects. Most of the currently uploaded projects are MATLAB (.m) files. 
An overview of each is given below.

------------------------------------------------------------------------------------------------------------------------------
Analytic_Continuation: This script was designed to numerically solve ordinary differential equations with singularities.
                       In such a situation, a simple forward or backward iteration method will not work, since the singularity
                       will ruin the accuracy. A clever solution is to analytically continue the IVP into the complex plane,
                       thereby circumventing the singularity--this is the code's functionality. This method still has some
                       drawbacks, but the code works just as well for analytic continuation of a known function along a path
                       or 2-D region of the complex plane. 

Ohio_Libraries:        This script was created to see how "connected" Ohio's public library system is, using a physical distance
                       metric taking into account the curvature of the Earth. We create a connectivity graph where edges
                       represent locations separated by less than some threshold distance. For an appropriate threshold choice,
                       the result is a graph which accurately represents the distribution of urban areas in Ohio. It is 
                       important that for anyone who wants to run this script in MATLAB, you will also need to download the png
                       file "OhioMap" uploaded here, and add its directory to the MATLAB file path for its data to be imported.

Curves_of_Pursuit:     This script has as its purpose the computation, plotting and (if desired) animation of mathematical 
                       pursuit problems. Specifically, it numerically solves the nonlinear differential equations arising from
                       the question of what the path of a "pursuer" looks like given a prescribed "fleeing" path through space.
                       Furthermore, it provides a way to determine if the pursuer caught the fleeing party within some fixed
                       time limit. There is ample room for exploration of different conditions/circumstances in this code, with
                       additional generalization pointed to in the comments.
                    
PolyInterp:            This script was created to demonstrate polynomial interpolation of a simple set of data points. It accomplishes
                       this by randomizing a set of data points and then solving a system of linear equations (a regression problem) 
                       and then graphing the result. One must be careful here, for although the mathematical technique is quite 
                       general, if two of the randomly chosen points are too close together relative to the size of the interval, the 
                       regression algorithm will diverge.
                       
Surface_Geodesics:     This code was created as an instructional supplement to a video on the topic of using the calculus of 
                       variations to find paths of extremal length (geodesics) on 2D surfaces in space. It utilizes a Taylor-series 
                       expansion to solve numerically a system of differential equations were explicitly obtained by hand as Euler-
                       Lagrange equations for the arc length integral. It then graphs the solution simultaneously with a spherical 
                       mesh to demonstrate visually that the geodesics of a 2-sphere are the arcs of great circles on the sphere.
                       
SpringGravity:         This script was designed to solve numerically a system of ODEs for a hypothetical mechanical system--a planet 
                       which has a spring (Hooke's law) force for gravity, instead of the usual Newtonian gravity. The question being
                       answered is, what do such "spring-gravity" orbits look like? By tuning the various parameters, one can get some
                       very interesting behavior here. The equations of motion were obtained by the Lagrangian method, and then the 
                       algorithm solves these equations through a simple (Euler) numerical scheme.
                       
Geometry-proof-code and
Proof__Dr_Gerlach-2:   A professor challenged our class to come up with a proof of a given statement involving the normal vectors to 
                       polygons/polyhedra as he could not figure out why it was true, and this is the proof I produced, written
                       up in TeX and edited in Overleaf, as a demonstration of basic LaTeX abilities. The "Proof__Dr_Gerlach-2" file 
                       is the .pdf version, and Geometry-proof-code is my code.
                      
  -----------------------------------------------------------------------------------------------------------------------------              
                
Thanks for stopping by! Email me if you have any questions at: ben.thayer15@gmail.com or thayer.80@osu.edu.

-Ben
