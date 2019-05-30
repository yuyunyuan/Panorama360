
function qqqqq=straightening(finalimage,threshold,row)
gray=rgb2gray(finalimage);
qqqqq=zeros(row,size(finalimage,2),size(finalimage,3));
qqqqq=uint8(qqqqq);
% row=size(finalimage,1);
for i=1:size(gray,2)
    r=finalimage(:,i,1);
    g=finalimage(:,i,2);
    b=finalimage(:,i,3);
    if sum(gray(:,i)>0)>threshold
        qqqqq(:,i,1)=imresize(r(gray(:,i)>0),[row 1]);
        qqqqq(:,i,2)=imresize(g(gray(:,i)>0),[row 1]);
        qqqqq(:,i,3)=imresize(b(gray(:,i)>0),[row 1]);
    end
end
end