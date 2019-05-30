function [newImage,cropMatrix] = blend(warped_image, unwarped_image, x, y)
% Blend two image by using cross dissolve
% Input:
% warped_image - original image
% unwarped_image - the other image
% x - x coordinate of the lefttop corner of unwarped image
% y - y coordinate of the lefttop corner of unwarped image
% Output:
% newImage
% MAKE MASKS FOR BOTH IMAGES
warped_image(isnan(warped_image))=0;
maskA = (warped_image(:,:,1)>0 |warped_image(:,:,2)>0 | warped_image(:,:,3)>0);
newImage = zeros(size(warped_image));
newImage(y:y+size(unwarped_image,1)-1, x: x+size(unwarped_image,2)-1,:) = unwarped_image;
mask = (newImage(:,:,1)>0 | newImage(:,:,2)>0 | newImage(:,:,3)>0);
mask = and(maskA, mask); %Find if corresponding pixels in two images both have value
BlackPoints=find(~mask);
[i1,i2,i3] = ind2sub(size(mask),BlackPoints);
i2Length = size(i2,1);
% GET THE OVERLAID REGION
[~,col] = find(mask);
left = min(col);
right = max(col);
mask = ones(size(mask));
if( x<2)
mask(:,left:right) = repmat(linspace(0,1,right-left+1),size(mask,1),1);
else
mask(:,left:right) = repmat(linspace(1,0,right-left+1),size(mask,1),1);
end
% BLEND EACH CHANNEL
for i=1:i2Length
mask(i1(i),i2(i),i3(i))=1; %If not both have value, keep value in both of them.
end
warped_image(:,:,1) = warped_image(:,:,1).*mask;
warped_image(:,:,2) = warped_image(:,:,2).*mask;
warped_image(:,:,3) = warped_image(:,:,3).*mask;

% REVERSE THE ALPHA VALUE
if( x<2)
mask(:,left:right) = repmat(linspace(1,0,right-left+1),size(mask,1),1);
else
mask(:,left:right) = repmat(linspace(0,1,right-left+1),size(mask,1),1);
end

for i=1:i2Length
mask(i1(i),i2(i),i3(i))=1;
end

newImage(:,:,1) = newImage(:,:,1).*mask;
newImage(:,:,2) = newImage(:,:,2).*mask;
newImage(:,:,3) = newImage(:,:,3).*mask;

newImage(:,:,1) = warped_image(:,:,1) + newImage(:,:,1);
newImage(:,:,2) = warped_image(:,:,2) + newImage(:,:,2);
newImage(:,:,3) = warped_image(:,:,3) + newImage(:,:,3);
[m,n,l] = size(newImage);
Middle = round(n/2);
firstLayer=newImage(:,:,1);
firstLayer=firstLayer(:,Middle);
y1=0;y2=0;
for i=3:m-2
if firstLayer(i-1)==0&&firstLayer(i-2)==0&&firstLayer(i+2)>0&&firstLayer(i+1)>0
y1=i;
elseif firstLayer(i+1)==0&&firstLayer(i+2)==0&&firstLayer(i-2)>0&&firstLayer(i-1)>0
y2=i;
end
end
cropMatrix=[1,y1,n-1,y2-y1-1];
end
