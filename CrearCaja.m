function [cajas2,imag] = CrearCaja(imag)
cajas = regionprops(imag);
%Edges detection
for n=1:size(cajas,1)
    rectangle('Position',cajas(n).BoundingBox,'EdgeColor','g','LineWidth',2)
end

% Search areas under 500
s=find([cajas.Area]<500);

% Mark less than 500 areas
for n=1:size(s,2)
    rectangle('Position',cajas(s(n)).BoundingBox,'EdgeColor','r','LineWidth',2)
end
% Eliminate areas under 500
for n=1:size(s,2)
    d=round(cajas(s(n)).BoundingBox);
    imag(d(2):d(2)+d(4),d(1):d(1)+d(3))=0;
end


%We have already removed the small areas
%We make boundingbox again with the rest of the figures in the image
cajas2 = regionprops(imag);

end