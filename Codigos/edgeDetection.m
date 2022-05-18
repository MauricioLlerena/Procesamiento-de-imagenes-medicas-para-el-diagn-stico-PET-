%%
%Ejemplo de edge detection V1.0
%Equipo PET
%Francisco Valadez Rojas
%Andrés Martín Vivanco Palacios
%Jesús Gabriel Leos Perales

%Cargar imagen
f=imread('radiograph1.jpg');
f=imresize(f,0.25);
f=double(f(:,:,1));
figure(1)
imshow(f,[])

%%
%Detectar orilas con una mascara de convolucion
edgex=[1,-1] 
g1=conv2(f,edgex,'same');
imshow(g1,[-10,10]);
title ('Derivada X')
%%
%Sobel Mask
edgey=[-1 -2 -1;0,0,0;1,2,1]/8
g2=conv2(f,edgey,'same');
imshow(g2,[-10,10])
figure(2)
subplot(1,2,1)
imshow(g1,[-10,10])
title("Dx")
subplot(1,2,2)
imshow(g2,[-10,10])
title("Dy")
%%
figure(3)
subplot(1,1,1)
%%
%Mascara de sobel dx y dy para gradiente
edgex=[1,0,-1;2,0,-2;1,0,-1]/8
gx=conv2(f,edgex,'same');
gy=conv2(f,edgey,'same');
%Gradiente de magnitud
mag=abs(gx)+abs(gy);
imshow(mag,[]);
title("Gradient Magnitude |dx|+|gy|")
%%
%Estimar el nivel de ruido
noisemask = [-1, 0 1];
noiseimage = conv2(f,noisemask,'same');
noisevariance = mean2(noiseimage.^2);
noisestd = sqrt(noisevariance/2);
edgedetection1 = mag > noisestd;
edgedetection2 = mag > 2*noisestd;
subplot(1,2,1)
imshow(edgedetection1,[]);
title("Edge detection at sigma")
subplot(1,2,2)
imshow(edgedetection2,[]);
title("Edge detection 2 at sigma")
figure(4)
subplot(1,1,1)
angle=atan2(gy,gx);
imshow(angle,[]);
title("Gradient orientation")
%%
edgcany=edge(f,'Canny');
imshow(edgcany,[]);
