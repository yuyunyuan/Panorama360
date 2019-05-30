function [] = drawMatched( matched, img1, img2, loc1, loc2 )
% Function: Draw matched points
% Create a new image showing the two images side by side.
img3 = appendimages(img1,img2);

loc1=loc1(matched,:);
loc2=loc2(matched,:);
% Show a figure with lines joining the accepted matches.
figure('Position', [100 100 size(img3,2) size(img3,1)]);
colormap gray;
imagesc(img3);
hold on;
cols1 = size(img1,2);
n = size(loc1,1);
colors = ['c','m','y'];
colors_n = length(colors);

plot(loc1(:,1),loc1(:,2),'+g');
plot(loc2(:,1)+cols1,loc2(:,2),'+g');
for i = 1: n
%   if (matched(i) > 0)
    color = colors(randi(colors_n));
    line([loc1(i,1) loc2(i,1)+cols1], ...
         [loc1(i,2) loc2(i,2)], 'Color', color);
%   end
end
hold off;
% num = sum(matched > 0);
% fprintf('Found %d matches.\n', num);

end

