function [height, width, newimgX, newimgY, imgX, imgY] = getNewSize(transform, h_warp, w_warp, h_unwarp, w_unwarp)
% Calculate the size of new image
% Input:
% transform - homography matrix
% h_unwarp - height of the unwarped image
% w_unwarp - width of the unwarped image
% h_warp - height of the warped image
% w_warp - width of the warped image
% Output:
% height - height of the new image
% width - width of the new image
% newimgX - new x coordate of lefttop corner of new image
% newimgY - new y coordate of lefttop corner of new image
% imgX - new x coordate of lefttop corner of unwarped image
% imgY - new y coordate of lefttop corner of unwarped image



[X,Y] = meshgrid(1:w_warp,1:h_warp);
newimage = ones(3,h_warp*w_warp);
newimage(1,:) = reshape(X,1,h_warp*w_warp);
newimage(2,:) = reshape(Y,1,h_warp*w_warp);

% DETERMINE THE FOUR CORNER OF NEW IMAGE
newimage = mldivide(transform,newimage);
left = fix(min([1,min(newimage(1,:)./newimage(3,:))]));
right = fix(max([w_unwarp,max(newimage(1,:)./newimage(3,:))]));
top = fix(min([1,min(newimage(2,:)./newimage(3,:))]));
bottom = fix(max([h_unwarp,max(newimage(2,:)./newimage(3,:))]));

newimgX = left;
newimgY = top;
imgX = 2-left;
imgY = 2-top;
height = bottom - top + 1;
width = right - left + 1;
