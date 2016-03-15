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
%     'gmm':
%     'watersheds':
%     'hierarchical':
% NC (Optional): Number of clusters.
%     Number of clusters to be used in the segmentation
%     (5 by default)

%----------------------------------------------------------------%
% % Full nargin mode
% if nargin ~= 4
%     error('Not enough input arguments')
% end

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

% Outputs:
% my_segmentation

%temp = 0;
s=size(I);
[x,y]=meshgrid(1:s(2),1:s(1));

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
end

% if(strcmp(FS,'lab'))
%     I = rgb2lab(I);
% elseif(strcmp(FS,'hsv'))
%     I = rgb2hsv(I);
% elseif(strcmp(FS,'rgb+xy'))
%     temp = 1;
% elseif(strcmp(FS,'lab+xy'))
%     I = rgb2lab(I);
%     temp = 1;
% elseif(strcmp(FS,'hsv+xy'))
%     I = rgb2hsv(I);
%     temp = 1;
% end

% if(temp == 0)
%     DI = [reshape(I(:,:,1),[1 numel(I)]),reshape(I(:,:,2),[1 numel(I)]),...
%         reshape(I(:,:,3),[1 numel(I)])];
% else
%     x = repmat((1:size(I,1))',[size(I,2),1]);
%     for i=1:numel(I)
%         y(i,1) = temp;
%         if(mod(temp,size(I,1))==0)
%             temp = temp+1;
%         end
%     end
%     
%     DI = [reshape(I(:,:,1),[1 numel(I)]),reshape(I(:,:,2),[1 numel(I)]),...
%         reshape(I(:,:,3),[1 numel(I)]),x,y];
% end
s=size(I);
Ir=reshape(double(I),numel(I)/s(3),s(3));
switch CM
    case 'kmeans'
        id=kmeans(double(Ir),NC);
        Ir2=reshape(id,s(1),s(2));
    case 'gmm'
        gmodel=fitgmdist(Ir,5);
        id=cluster(gmodel,Ir);
        Ir2=reshape(id,s(1),s(2));

    case 'hierarchical'
        printf('Soon...');

    case 'watershed'
        printf('Soon...');
        
    otherwise
        error('Input argument not recognized')
       

end
    
my_segmentation=Ir2;
end

