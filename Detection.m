clear all
close all

RGB = imread('señal2.jpg');
figure
imshow(RGB);
title('Original image')

hsvRed=createMask(RGB);   %red filtering mask     
hsvBlue=hsvRed|createMask2(RGB); %red filtering mask and blue filtering mask
hsv2 = medfilt2(hsvBlue);    %medium filter to eliminate impulsive image noise
figure
imshow(hsv2);
title('Filtered image with edge detection')
hold on

% HERE THE PART OF THE SEGMENTATION OF THE IMAGE WITH BOUNDINGBOX WITH THE
% FUNCTION CrearCajas
[cajas1,hsv2]=CrearCaja(hsv2);

% MY GREAT FUNCTION recursively
% function to eliminate the row with fewer elements (where is the separation between images)
for n=1:size(cajas1,1)
   if((cajas1(n).BoundingBox(3))/(cajas1(n).BoundingBox(4))>1.2 || (cajas1(n).BoundingBox(3))/(cajas1(n).BoundingBox(4))<0.83)
       [FilDel,BordeDer,BordeIzq]=separar(cajas1(n),hsv2);  %Here I look for the line for all the bounding box that meet the condition of elongation
       for j=BordeIzq+1:BordeDer-1
         hsv2(FilDel,j)=0;    %Here I delete the row inside the boundingbox
       end
    end
end

% I recalculate the BoundingBox once the signals are separated
% If you have not had to separate the signals will be the same as the previous one
figure
imshow(hsv2);
title('Filtered image with edge detection')
hold on
[cajas2,hsv2] = CrearCaja(hsv2);
figure
imshow(hsv2);
title('Final filtered image with edge detection')
for n=1:size(cajas2,1)
    rectangle('Position',cajas2(n).BoundingBox,'EdgeColor','g','LineWidth',2)
end

final=zeros(240,240,3,n);  %fixed size storage array equal to the dimensions of the output image

HSV=rgb2hsv(RGB);   %we convert the image to hsv to work with it (then we will convert it back to RGB)

%We trim the images according to their bounding box
%we compare them by multiplication (same as doing AND)

for n=1:size(cajas2,1)
    recorte1= imcrop(HSV,cajas2(n).BoundingBox);
    recorte2= imcrop(hsv2,cajas2(n).BoundingBox);
    se = strel('disk',30);              %create a disk-shaped structuring element
    recorte2=imclose(recorte2,se);      % to fill the image
    relleno = imfill(recorte2,'holes');
    CompH=recorte1(:,:,1).*relleno;     %we multiply the clipping by all HSV components 
    CompS=recorte1(:,:,2).*relleno;     %to eliminate what we are not interested in
    CompV=recorte1(:,:,3).*relleno;
    recorte1(:,:,1)=CompH;
    recorte1(:,:,2)=CompS;
    recorte1(:,:,3)=CompV;   
    YaCasi=hsv2rgb(recorte1);
    final(:,:,:,n)=imresize(YaCasi,[240 240]);
end
 for n=1:size(final,4)
    %subplot(3,2,n);      %another way to print
    figure;
    imshow(final(:,:,:,n))
    title('Final Result')
    name = sprintf('Imagen_%d.jpg ',n)
    print('-djpeg','-r150',name)
    
 end
% 
 for n=1:size(final,4)
    name = sprintf('Imagen_%d.jpg ',n)
    figure(n+4)
    print('-djpeg','-r150',name)
end
