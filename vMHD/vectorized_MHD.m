% Vectorized implementation of the Modified Hausdorff Distance (MHD) 
%   as described by Dubuisson and Jain in:
% 
% M. P. Dubuisson and A. K. Jain. A Modified Hausdorff distance for object 
% matching. In ICPR94, pages A:566-568, Jerusalem, Israel, 1994.
% http://ieeexplore.ieee.org/xpls/abs_all.jsp?arnumber=576361
% 
% Function description:
% mhd = vectorized_MHD (setA,setB)
%  it takes as inputs two sets of n-dimensional points (#samples, #dimensions)
%  and returns the MHD between the two sets.
% 
% The vectorized implementation is computationally more efficient than the 
% for-loop version at the cost of ram memory.
% 
% Author: Alberto Gonzalez Olmos, 2018
% UPDATE: May 2022, 
%   Spencer Chen improved memory efficiency and garbage
%       collection time
function mhd = vectorized_MHD (setA,setB)
    %% forward directed distance A -> B
    distanceAB = MHD_directedDistance(setA,setB);
    % reverse directed distance B -> A
    distanceBA = MHD_directedDistance(setB,setA);
    
    %% undirected distance function (f2, from Dubuisson)
    mhd = max(distanceAB,distanceBA); clear setB setA;
end
function distances = MHD_directedDistance(set1,set2)
  %% prepare set2 for vectorization:
  distances = repmat(set2, [1 1 size(set1,1)]);
  distances = permute(distances,[3 2 1]);
  %% directed distance (d6, from Dubuisson) between the two sets:
  distances = bsxfun(@minus,distances,set1);
  distances = mean(sqrt(min(sum(distances.^2,2),[],3)));
end