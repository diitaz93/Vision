function my_segmentation = segment_by_clustering(I,FS,CM,NC)

% my_segmentation = segment_by_clustering(I) performs clustering
% segmentation over the RGB image I. The output is an image 
% where each pixel has a cluster label. 
% By default, the function will use k-means segmentation 
% in the RGB space using 5 clusters.

% Input Arguments:
% I : RGB image to be segmented
% FS (Optional): Feature space to be used in the segmentation.
%     'rgb' (by default): perform segmentation in the RGB space
%     'hsv': perform segmentation in the HSV space
%     'lab': perform segmentation in the Lab space
%     'rgb+xy': perform segmentation in the RGB space taking
%               into account the x and y coordinates.
%     'hsv+xy': perform segmentation in the HSV space taking
%               into account the x and y coordinates.
%     'lab+xy': perform segmentation in the Lab space taking
%               into account the x and y coordinates.
% CM (Optional): Clustering method to be used.
%     'kmeans' (by default): Uses matlab function kmeans to 
%                            segment the image
%     'gmm': Uses mixture of gaussian distributions to fit the
%            the clusters of pixels
%     'watersheds':
% NC (Optional): Number of clusters.
%     Number of clusters to be used in the segmentation
%     (5 by default). If 'watersheds' method is chosen, this
%     parameter will be used as the h-minimum value used in the
%     watershed segmentation.

%----------------------------------------------------------------%
% By default mode
switch nargin
    case 3
        NC=5;
    case 2
        NC=5;
        CM='kmeans';
    case 1
        NC=5;
        CM='kmeans';
        FS='rgb';
    case 0
        error('Not enough input arguments')
end
%------------------------------------------------------------------%
% Size of the image
s=size(I);
% Matrices with x and y positions of pixels
[x,y]=meshgrid(1:s(2),1:s(1));
% Set the space to be used in the segmentation
switch FS
    case 'lab'
        I = rgb2lab(I);
    case 'hsv'
        I = rgb2hsv(I);
    case 'rgb+xy'
        I=cat(3,I,x,y);
    case 'lab+xy'
        I = rgb2lab(I);
        I=cat(3,I,x,y);
    case 'hsv+xy'
        I = rgb2hsv(I);
        I=cat(3,I,x,y);
    case 'rgb'
        ;
    otherwise
        error('Input argument not recognized')
end
%------------------------------------------------------------------%
% New size of the image (due to adition of x and y coordinates)
s=size(I);
% List of pixels as data
Ir=reshape(double(I),numel(I)/s(3),s(3));

switch CM
    case 'kmeans'
        id=kmeans(double(Ir),NC);
        Ir2=reshape(id,s(1),s(2));
    case 'gmm'
        gmodel=fitgmdist(Ir,5);
        id=cluster(gmodel,Ir);
        Ir2=reshape(id,s(1),s(2));
    case 'watershed'
       I=rgb2gray(I(:,:,1:3));
       se=strel('disk',3);
       Id=imdilate(I,se);
       Ie=imerode(I,se);
       grad=Id-Ie;
       min=imextendedmin(grad,NC);
       min=imimposemin(grad,min);
       Ir2=watershed(min);
    otherwise
        error('Input argument not recognized')
end
%------------------------------------------------------------------%
% Asign answer
my_segmentation=Ir2;
end

