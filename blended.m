function [blendedImage,cropMatrix] = blended(warped_image, unwarped_image, x, y)
% Blend two image using weighted method
% Input:
% warped_image - original image
% unwarped_image - the other image
% x - x coordinate of the lefttop corner of unwarped image
% y - y coordinate of the lefttop corner of unwarped image
% Output:
% blendedImage
%% make mask for two input image
warped_image(isnan(warped_image))=0; 
%find non-numerical numbers and change them to zero
maskA = (warped_image(:,:,1)>0 |warped_image(:,:,2)>0 | warped_image(:,:,3)>0);
blendedImage = zeros(size(warped_image));
blendedImage(y:y+size(unwarped_image,1)-1, x: x+size(unwarped_image,2)-1,:) = unwarped_image;
mask = (blendedImage(:,:,1)>0 | blendedImage(:,:,2)>0 | blendedImage(:,:,3)>0);
mask = and(maskA, mask); %Find if corresponding pixels in two images both have value
BlackPoints=find(mask==0);
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

blendedImage(:,:,1) = blendedImage(:,:,1).*mask;
blendedImage(:,:,2) = blendedImage(:,:,2).*mask;
blendedImage(:,:,3) = blendedImage(:,:,3).*mask;

blendedImage(:,:,1) = warped_image(:,:,1) + blendedImage(:,:,1);
blendedImage(:,:,2) = warped_image(:,:,2) + blendedImage(:,:,2);
blendedImage(:,:,3) = warped_image(:,:,3) + blendedImage(:,:,3);
[m,n,l] = size(blendedImage);
Middle = round(n/2);
firstLayer=blendedImage(:,:,1);
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
