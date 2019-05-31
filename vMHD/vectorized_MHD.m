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
% for-loop version at the cost of ram memory but if the tow sets of points 
% are too large and ram memory is depleted, then the for-loop version is 
% more efficient.
% 
% Author: Alberto Gonzalez Olmos, PhD student in HCI
% University of Glasgow, 2018

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
    size2 = [size(set2) size(set1,1)];
    set2_expandedSpace = ones(size2); clear size2;
    set2_expandedSpace = bsxfun(@times,set2_expandedSpace,set2); clear set2;
    permute_set2_expSpc = permute(set2_expandedSpace,[3 2 1]); clear set2_expandedSpace;
    
    %% directed distance (d6, from Dubuisson) between the two sets:
    diff_sets = bsxfun(@minus,permute_set2_expSpc,set1); clear permute_set2_expSpc set1;
    distances = mean(min(sqrt(sum(diff_sets.^2,2)),[],3)); clear diff_sets;
end