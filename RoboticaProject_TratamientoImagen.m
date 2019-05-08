function [A,Start,End,ImgObstaculos] = RoboticaProject_TratamientoImagen(imgfile,Escala)
ImagenOriginal=imread(imgfile);
Imagen=imresize(ImagenOriginal,Escala);
%Punto de Inicio
TamanoImagen=size(Imagen);
TamanoOriginal=size(ImagenOriginal);

ImgInicio=zeros(TamanoImagen(1),TamanoImagen(2));
ImgFinal=zeros(TamanoImagen(1),TamanoImagen(2));
ImgObstaculos=zeros(TamanoOriginal(1),TamanoOriginal(2));

for i=1:TamanoImagen(1)
    for j=1:TamanoImagen(2)
        if Imagen(i,j,1)>200 && Imagen(i,j,2)<40 && Imagen(i,j,3)<40
            ImgInicio(i,j)=1;
        end
    end
end

Start= cell2mat(struct2cell(regionprops(ImgInicio, 'centroid')));

for i=1:TamanoImagen(1)
    for j=1:TamanoImagen(2)
        if Imagen(i,j,1)<40 && Imagen(i,j,2)<40 && Imagen(i,j,3)>200
            ImgFinal(i,j)=1;
        end
    end
end

End= cell2mat(struct2cell(regionprops(ImgFinal, 'centroid')));


for i=1:TamanoOriginal(1)
    for j=1:TamanoOriginal(2)
        if ImagenOriginal(i,j,1)<40 && ImagenOriginal(i,j,2)<40 && ImagenOriginal(i,j,3)<40
            ImgObstaculos(i,j)=1;
        end
    end
end

R=uint16(TamanoOriginal(2)*0.0375);
R=double(R);
SE=strel('disk',R,4);
ImgObstaculos2=imdilate(ImgObstaculos,SE);
imshow(ImgObstaculos2)
A=double(uint16(imresize(ImgObstaculos2,Escala)));
Start=uint16(Start);
End=uint16(End);
Start=fliplr(double(Start));
End=fliplr(double(End));
end


% SE=strel(ImgObstaculos);
% ImgObstaculos=imerode(ImgObstaculos,SE);
% 
% ImgObstaculos=imdilate(ImgObstaculos,SE);
% ImgObstaculos=imdilate(ImgObstaculos,SE);
% ImgObstaculos=imdilate(ImgObstaculos,SE);


