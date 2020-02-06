function [I, BordeDer, BordeIzq] = separar(caja,imag)

%SACAMOS PARAMETROS QUE NOS INTERESAN
[numFilIm,numColIm,dimIm]=size(imag);
ancho=round(caja.BoundingBox(3));
alto=round(caja.BoundingBox(4));
centro= round(caja.Centroid);

BordeIzq=round(centro(1)-(ancho/2));
BordeDer=round(centro(1)+(ancho/2));
BordeUp=round(centro(2)-(alto/2));
BordeDown=round(centro(2)+(alto/2));


%conditions not to overflow
if(BordeIzq<0)
    BordeIzq=0;
end
if(BordeDer>numColIm)
    BordeDer=numColIm;
end
if(BordeUp<0)
    BordeUp=0;
end
if(BordeDown>numFilIm)
    BordeDown=numFilIm;
end

%INTIALIZATION OF VARIABLES
zona=round(alto/3);
Dist=zeros(1,zona);

%LOOP START
for i=1:zona
    for j=1:ancho-1
        
    Dist(i)=Dist(i)+imag(BordeUp+zona+i,BordeIzq+j);
    
    end
end
[M,I] = min(Dist);   
I=BordeUp+zona+I;
end 