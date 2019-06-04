clc
clear
%% Read Frames
shuttleVideo = VideoReader('TestVideo/Test1.mp4');
vidHeight=shuttleVideo.Height;
vidWidth=shuttleVideo.Width;
angle=30; %Projection to cylindor angle
numberOfFrames=round(shuttleVideo.FrameRate* shuttleVideo.duration);
framesToRead = 1:10:numberOfFrames;
% initialize a matrix for all frames to be read
allFrames = zeros(vidHeight, vidWidth, 3, length(framesToRead));
% read in the frames
for k=1:length(framesToRead)
    frameIdx = framesToRead(k);
    currentFrame   = read(shuttleVideo,frameIdx);
    combinedString = sprintf('%d.jpg',k-1);
%    imwrite(currentFrame,combinedString);
    if k==1
% cast the all frames matrix appropriately
        allFrames = cast(allFrames, class(currentFrame));
    end
    allFrames(:,:,:,k) = currentFrame;
end
%{ 
%% Stitching 
disp(size(allFrames,4));
finalimage=projection(allFrames(:,:,:,1),angle);

middle=size(allFrames,4)/2;
C={};
cc=0;
for k=2:size(allFrames,4)
    disp(k);
    img1=projection(allFrames(:,:,:,k),angle);
    if k>middle
    	finalimage=image_stitching(img1,finalimage); 
    else
        finalimage=image_stitching(finalimage,img1);    
    end
    if size(finalimage,2)>3000
        cc=cc+1;
        C{cc}=finalimage(:,1:2000,:);
        finalimage=finalimage(:,2000:end,:);
    end
    if mod(k,10)==0
        finalimage=image_crop(finalimage,1);
% finalimage=straightening(finalimage,200,544);
    end
end
%% Crop
finalimage=straightening(finalimage,0,544);
imshow(finalimage);
%%
if cc>0 
    pimage=C{1};
    for i=2:cc
        pimage=cat(2,pimage,C{i});
    end
    pimage=straightening(pimage,200,544);
    straightened =cat(2,pimage,finalimage);
    figure;
    imgCrop=image_crop(straightened,1);
    imshow(imgCrop);
else
    st=straightening(finalimage,200,544);
    figure;
    imshow(image_crop(st,1));
end
%%
% fimage=cat(2,C{1},finalimage);
% finalimage=image_stitching(allFrames(:,:,:,1),allFrames(:,:,:,2));
% i1=imread('1s.jpg');
% i2=imread('2s.jpg');
% qq=image_stitching(i1,i2);
%%
%img = projection(finalimage,9);
%imshow(img);
%%
% subplot(1,2,1),imshow(finalimage);
% subplot(1,2,2),imshow(qqqqq);

%%
%out=image_stitching(img1,img2);
%%

% figure('Name','');
% subplot(3,1,1),imshow(finalimage);
% I2 = lensdistort(finalimage, -0.05); 
% I2 = lensdistort(I2, -0.05); 
% I2 = lensdistort(I2, -0.05); 
% I2 = lensdistort(I2, -0.05); 
% subplot(3,1,2),imshow(I2);
% finalimage=I2;

% 
% subplot(3,1,2),imshow(finalimage(cutt:cutb,cutl:cutr,:));
%}
%%
disp(size(allFrames,4));
s=size(allFrames,4);
l=floor(s/2);
%lefthalf
try
    finalimage=projection(allFrames(:,:,:,floor(s/2)),angle);
    for k=1:floor(s/2)-1
        i=floor(s/2)-k;
        disp(i)
        img1=projection(allFrames(:,:,:,i),angle);
        finalimage=image_stitching(img1,finalimage);
    end
    %righthalf
    finalimage2=projection(allFrames(:,:,:,floor(s/2)+1),angle);
    for k=floor(s/2)+2:s
        disp(k);
        img1=projection(allFrames(:,:,:,k),angle);
        finalimage2=image_stitching(img1,finalimage2);
    end
catch
    disp('Already stitch part of video, please input a better video for better result')
end
%
f=image_stitching(finalimage,finalimage2);
%imshow(f);
%%
st=lensdistort(f,-0.2);
st=straightening(st,0,544);
imshow(st);
