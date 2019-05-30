function img=projection(A,angleParameter)
%Input: image
%Output: the image projected to the cylinder
[H,W,k]=size(A);
f=W/(2*tan(deg2rad(angleParameter))); %%% assume the camera's FOV 180/6
C=zeros(H,W);
nn=0;
for i=1:H
    for j=1:W
        yy=f*tan((j-W/2)/f)+W/2;
        xx=(i-H/2)*sqrt((j-W/2)^2+f^2)/f+H/2;
        xx=round(xx);
        yy=round(yy);
            if(xx<1||yy<1||xx>H||yy>W)
                nn=nn+1;
                continue;
            end
        C(i,j,1)=A(xx,yy,1);
        C(i,j,2)=A(xx,yy,2);
        C(i,j,3)=A(xx,yy,3);
    end
end
img = uint8(C);
end
