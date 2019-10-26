# Ben-s-Portfolio

This is a repository for a few of my (Ben's) programming projects. All of the currently uploaded projects are MATLAB (.m) files. 
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
  -----------------------------------------------------------------------------------------------------------------------------              
                
Thanks for stopping by! Email me if you have any questions at: ben.thayer15@gmail.com.

-Ben
