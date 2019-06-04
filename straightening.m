
function outimage=straightening(finalimage,threshold,row)
% Straighten image column by column
% Input:
% finalimage - Image with distortion
% threshold - if the effective pixel is too little then ignore the column
% row - new image width
% output - straighten image

gray=rgb2gray(finalimage);
outimage=zeros(row,size(finalimage,2),size(finalimage,3));
outimage=uint8(outimage);
% row=size(finalimage,1);
for i=1:size(gray,2)
    r=finalimage(:,i,1);
    g=finalimage(:,i,2);
    b=finalimage(:,i,3);
    if sum(gray(:,i)>0)>threshold
	% Substract pixel that is non zero in the gray image, and resize into the width of original image
        outimage(:,i,1)=imresize(r(gray(:,i)>0),[row 1]);
        outimage(:,i,2)=imresize(g(gray(:,i)>0),[row 1]);
        outimage(:,i,3)=imresize(b(gray(:,i)>0),[row 1]);
    end
end
end