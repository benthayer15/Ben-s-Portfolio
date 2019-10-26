%-------------
%Introduction:
%-------------

%   The purpose of this script is to present one answer to the question,
%   "How connected are Ohio's public libraries?" Geographical distance is
%   the measure here of connectivity--in fact, a spherical metric based on
%   geodesics on the Earth's surface is employed rather than Euclidean
%   distance, making it more accurate. The question is answered rather
%   effectively, and presents a fairly accurate characterization of the 
%   urban areas in Ohio. 
%
%   The data included below is the set of coordinates for all Ohio public
%   libraries, obtained from a state directory. Since it was raw and not in
%   a usable form originally, I have (for simplicity) included the data
%   here in the script.
%
%   The basic idea of the code is to create a connectivity graph. We first
%   plot the locations of all the libraries (superimposed on an Ohio map)
%   and then we draw edges between vertices whenever the distance between
%   them is below some fixed threshold distance (called "N" in the code).
%   As stated above, with the right choice of such a threshold value, one
%   can infer which areas are urban centers simply from how separated the
%   libraries are.
%   
%   The only tricky part is correctly calibrating the image background (the
%   Ohio map) as explained in the footnotes.
%   -B. Thayer (2019)


%-----
%Data:
%-----

GPS_degrees = [40.772973	,	-83.823024	; %GPS Coordinates in degrees
38.950723	,	-83.406635	;
41.083343	,	-81.516442	;
40.090084	,	-82.613707	;
40.707113	,	-83.84405	;
41.397595	,	-82.222446	;
41.60729	,	-80.573075	;
39.992106	,	-84.554205	;
41.521252	,	-84.308219	;
40.867383	,	-82.318591	;
41.868178	,	-80.783091	;
39.460942	,	-82.233646	;
40.568726	,	-84.195016	;
41.509882	,	-82.013362	;
41.013616	,	-81.611602	;
39.986795	,	-81.173212	;
40.01399	,	-80.743731	;
40.507092	,	-83.752697	;
41.273165	,	-82.838287	;
40.117231	,	-80.758087	;
41.245911	,	-83.235506	;
39.956869	,	-82.934384	;
41.346369	,	-83.115583	;
39.293629	,	-83.988744	;
41.051742	,	-83.015534	;
40.892239	,	-83.893133	;
40.426359	,	-81.190019	;
40.132183	,	-84.429869	;
38.534021	,	-82.682493	;
41.387219	,	-80.867649	;
39.057857	,	-83.913915	;
39.845732	,	-84.53994	;
40.869708	,	-84.584884	;
40.808812	,	-82.97399	;
41.471657	,	-81.146437	;
39.748532	,	-81.517935	;
40.890739	,	-81.597883	;
40.500567	,	-82.893216	;
40.617673	,	-80.577717	;
39.536529	,	-83.436961	;
40.572854	,	-81.0846	;
40.304982	,	-82.695067	;
40.105035	,	-83.725504	;
39.329854	,	-82.98132	;
39.922072	,	-83.81064	;
40.391491	,	-81.34444	;
39.193528	,	-84.219677	;
41.501106	,	-81.691696	;
41.304024	,	-82.977759	;
40.479629	,	-84.631284	;
40.89359	,	-80.696623	;
39.961185	,	-82.990036	;
40.24288	,	-82.862975	;
41.945301	,	-80.557263	;
40.273091	,	-81.85982	;
40.787068	,	-82.738211	;
41.403396	,	-81.69747	;
41.135051	,	-81.485704	;
39.760419	,	-84.187706	;
41.287697	,	-84.358436	;
40.299554	,	-83.064756	;
40.84361	,	-84.34285	;
41.573592	,	-84.00587	;
40.952159	,	-83.379568	;
40.523685	,	-81.480297	;
40.337834	,	-83.677027	;
38.810926	,	-82.198681	;
41.528407	,	-81.584693	;
40.836853	,	-80.540038	;
41.367141	,	-82.104235	;
41.597906	,	-81.525784	;
41.710558	,	-83.911126	;
39.715863	,	-82.602014	;
41.754207	,	-81.271916	;
41.03981	,	-83.651244	;
40.801897	,	-83.512049	;
40.413527	,	-84.779698	;
39.559245	,	-84.303037	;
40.734873	,	-82.78928	;
39.127105	,	-82.985834	;
41.507864	,	-81.183029	;
39.625806	,	-84.372213	;
41.157752	,	-80.702289	;
40.359496	,	-81.436436	;
41.272761	,	-82.055487	;
41.535377	,	-80.866417	;
39.981921	,	-83.049844	;
40.067601	,	-82.517965	;
39.686312	,	-83.928739	;
40.099305	,	-84.632379	;
40.025998	,	-81.589879	;
41.899515	,	-80.805327	;
40.788867	,	-83.643577	;
41.474979	,	-83.293732	;
41.495531	,	-81.564663	;
41.738134	,	-80.766838	;
39.247554	,	-82.478695	;
41.168701	,	-82.216734	;
39.203547	,	-83.620818	;
41.250014	,	-84.131313	;
40.545238	,	-81.911012	;
40.132821	,	-82.561556	;
41.156528	,	-80.577233	;
41.241634	,	-81.443184	;
41.055236	,	-82.726214	;
41.393737	,	-82.557022	;
39.938899	,	-83.273886	;
41.51038	,	-82.94126	;
40.116756	,	-84.353164	;
39.049006	,	-82.640908	;
39.648439	,	-81.849164	;
41.160959	,	-83.415944	;
41.15364	,	-81.361618	;
41.89039	,	-80.675141	;
41.448169	,	-80.587905	;
41.61887	,	-81.357801	;
41.484757	,	-81.804493	;
39.402777	,	-84.558448	;
39.435669	,	-84.208135	;
40.881892	,	-80.760287	;
40.772272	,	-80.764202	;
41.444283	,	-84.007598	;
40.056096	,	-82.405825	;
40.740132	,	-84.114795	;
40.363796	,	-83.759263	;
39.539992	,	-82.404542	;
39.885401	,	-83.44543	;
41.464258	,	-82.17783	;
40.635446	,	-82.232569	;
40.840337	,	-81.254948	;
41.788692	,	-81.070131	;
40.759712	,	-82.517174	;
39.648602	,	-84.527616	;
40.587481	,	-83.119756	;
40.882826	,	-82.662362	;
39.535464	,	-84.085834	;
40.648199	,	-83.604703	;
40.23447	,	-83.366037	;
39.35935	,	-84.312598	;
40.79744	,	-81.520062	;
41.106881	,	-83.791454	;
41.181078	,	-80.765354	;
40.070647	,	-83.554223	;
41.137679	,	-81.862416	;
39.025802	,	-82.036678	;
41.664843	,	-81.346822	;
40.551203	,	-84.57099	;
39.514207	,	-84.405039	;
41.297894	,	-82.604914	;
39.955575	,	-84.32661	;
40.731388	,	-81.096573	;
40.948414	,	-83.169818	;
39.760886	,	-81.108709	;
41.243514	,	-82.695859	;
41.586301	,	-84.605164	;
41.727691	,	-81.243302	;
40.548859	,	-82.826774	;
39.718497	,	-83.266541	;
39.944111	,	-82.006033	;
41.391371	,	-84.128996	;
39.940841	,	-84.023309	;
41.083849	,	-82.39859	;
39.967095	,	-84.710679	;
39.577535	,	-82.236703	;
40.27575	,	-81.605505	;
41.186674	,	-80.979764	;
41.676656	,	-84.325565	;
41.183923	,	-83.678192	;
40.877278	,	-81.402596	;
41.241603	,	-82.617341	;
41.508689	,	-83.14666	;
38.892466	,	-82.573946	;
41.290313	,	-82.215992	;
40.842138	,	-81.764106	;
39.999998	,	-82.677965	;
41.207505	,	-83.898729	;
41.136125	,	-84.579393	;
41.412356	,	-83.456449	;
41.239946	,	-81.554758	;
40.614239	,	-82.661938	;
39.71404	,	-82.206114	;
41.764625	,	-81.152504	;
39.619158	,	-82.939141	;
39.874357	,	-82.75711	;
40.148836	,	-84.240184	;
40.10797	,	-83.269628	;
41.277461	,	-81.098421	;
38.734645	,	-82.988704	;
39.7388	,	-84.636279	;
39.104912	,	-84.513687	;
40.395882	,	-82.486587	;
40.355133	,	-80.617927	;
41.102938	,	-80.646444	;
40.271404	,	-80.995635	;
41.034352	,	-84.048968	;
41.157687	,	-81.239373	;
40.426427	,	-83.296239	;
40.534499	,	-83.519958	;
41.42217	,	-82.367529	;
41.662106	,	-80.857978	;
40.690905	,	-84.646221	;
41.476845	,	-81.841524	;
40.919066	,	-81.102203	;
41.609023	,	-83.560404	;
39.490114	,	-83.636213	;
40.900829	,	-80.849364	;
39.355706	,	-84.121946	;
41.45347	,	-82.710668	;
40.480352	,	-82.684013	;
41.065311	,	-82.88741	;
41.465918	,	-81.566452	;
40.287011	,	-84.15395	;
39.881347	,	-83.092862	;
40.179184	,	-80.99632	;
40.543236	,	-84.38536	;
40.128221	,	-83.958205	;
40.803633	,	-81.373265	;
41.161652	,	-81.441098	;
41.589027	,	-83.885586	;
39.121763	,	-82.533534	;
41.115494	,	-83.17489	;
39.961344	,	-84.170809	;
41.654225	,	-83.539479	;
40.041734	,	-84.207854	;
40.491684	,	-81.445934	;
41.317539	,	-81.44797	;
38.745343	,	-83.845617	;
40.012874	,	-83.067597	;
40.830413	,	-83.281176	;
41.025739	,	-81.728309	;
39.801839	,	-82.805554	;
41.240216	,	-80.823242	;
39.424445	,	-81.457704	;
39.613708	,	-84.163913	;
41.549462	,	-84.140792	;
41.557493	,	-83.627407	;
40.797736	,	-81.941994	;
41.300758	,	-83.472196	;
40.604193	,	-80.646543	;
40.129175	,	-82.931854	;
41.44773	,	-81.924514	;
41.343989	,	-83.795831	;
41.604195	,	-81.474192	;
41.47474	,	-84.550205	;
41.660942	,	-81.436324	;
39.449077	,	-83.828227	;
41.376496	,	-83.650606	;
40.214619	,	-84.484197	;
40.409198	,	-82.951752	;
40.090602	,	-83.01696	;
39.715584	,	-84.171195	];

%----------
%Main Code:
%----------

GPS_radians = GPS_degrees*(pi/180);

R = 3958.8;   %Radius of the earth, in miles
dist = zeros(251, 251);

for i = 1:251 %Calculates distance matrix
    for j = 1:251
        lat_Diff = GPS_radians(j, 1) - GPS_radians(i, 1);
        long_Diff = GPS_radians(j, 2) - GPS_radians(i, 2);
        c_Angle = 2*asin(sqrt((sin((1/2)*lat_Diff))^2 + ...
            cos(GPS_radians(i, 1))*cos(GPS_radians(j, 1))*(sin((1/2)*long_Diff))^2));
        dist(i, j) = R*c_Angle;
    end
end

N = [0, 15];  %Threshold "connectivity distance," in miles; initialized as
              %a vector so that the code could easily be modified to produce
              %several subplots for various threshold values
fg1 = figure();
Ohio = imread('OhioMap.png'); %Imports background image; See footnotes

for m = 1:(length(N)-1)       %Determines and plots connectivity graph
    hold on
    image('CData', Ohio, 'XData', [-85.09, -80.354], 'YData', [41.96, 38.481]);
    axis([-85.12, -80.36, 38.42, 41.98]); %See Footnotes for image/axis comments
    for i = 1:251
        for j = 1:251
            if ((dist(i, j) < N(m+1)) & (dist(i, j) > N(m)))
                plot([GPS_degrees(i, 2); GPS_degrees(j, 2)], ...
                    [GPS_degrees(i, 1); GPS_degrees(j, 1)], 'LineWidth', 2);
            end
        end
        scatter(GPS_degrees(i, 2), GPS_degrees(i, 1));
        xlabel('Longitude (°)')
        ylabel('Latitude (°)')
        title(['Edge <=> Distance Is Less Than ', num2str(N(m+1)), ' miles.']);
    end
    hold off
end

%----------
%Footnotes:
%----------

%   1. It is of vital importance to the reader who wishes to the run this
%   code "as is" that he/she have this file downloaded AND added to
%   MATLAB's file path. To do this, download the file, and in the MATLAB
%   workspace, add the directory containing the image file to the file
%   path. Moreover, make sure the png file has not changed names.
%
%   2. The reader may ask, "Where did these numbers come from?" in the
%   "image" and "axis" commands. The latter came from tailoring the plot
%   boundaries to the size (in pixels) of the specific background image
%   employed. The former is more complicated; the image needed to be
%   rescaled and shifted to allow the data to be superimposed on it. The 
%   author used the known GPS coordinates and pixel locations of two Ohio
%   cities to determine the appropriate linear transformation needed to
%   adjust the picture to fit the data. While the computation is not shown
%   here explicitly, care was taken in this endeavor, as the accuracy of 
%   the rest of the plot rests on this calibration. 





