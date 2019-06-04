function [] = drawFeatures( img, loc,qwe )
% Function: Draw sift feature points
figure;
imshow(img);
hold on;
loc=loc(qwe,:);
plot(loc(:,1),loc(:,2),'+g');
end
