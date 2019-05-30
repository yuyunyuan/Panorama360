function outimg=image_crop(img,percentage)
cutl=1;
cutr=size(img,2);
cutb=1;
cutt=size(img,1);
for i=size(img,1):-3:1
    if (sum(sum(img(i,:,:)==0))/3)<(percentage*size(img,2))
        cutb=i;
        break
    end
end
for i=1:3:size(img,1)
    if (sum(sum(img(i,:,:)==0))/3)<(percentage*size(img,2))
        cutt=i;
        break
    end
end
for i=1:3:size(img,2)
    if sum(sum(img(:,i,:)==0))<(percentage*size(img,1))
        cutl=i;
        disp(sum(sum(img(:,i,:)==0)));
        break
    end
end
for i=size(img,2):-3:1
    if sum(sum(img(:,i,:)==0))<(percentage*size(img,1))
        cutr=i;
        disp(sum(sum(img(:,i,:)==0)));
        break
    end
end
outimg=img(cutt:cutb,cutl:cutr,:);
end
