
%% Mathematical Morphology
%Francisco Valadez Rojas
%Andres Martín Vivanco Palacios 
%Edio Mauricio Llerena Mancías
%Jesús Gabriel Leos Perales


f=imread('radiograph1.jpg');
f=double(f(:,:,1));
f=f/max(max(f));
f=imresize(f,0.25);
figure(1)
imshow(f,[]),title('Original')
% Se despliga la imagen original 
%% Dilatation

se = strel('disk',5);
BW2 = imdilate(f,se);
imshow(BW2), title('Dilated')
% Use different disk size
% Utilizando esta funcion disminuyen los colores negros 
%por lo que entre mayor sea el disco mayor cantidad de color blanco habra .
%% Erosion

se = strel('disk',5);
BW3 = imerode(f,se);
imshow(BW3), title('Eroded')
% Use different disk size
figure 
imshowpair(BW2,BW3,'montage');title ('Montaje')
%Se utiliza la funciones imerode lo que tiene el efecto contrario del anterior disminuyendo los
%colores blancos.
%% Opening

se = strel('disk',10);
BW2 = imopen(f,se);
imshow(BW2), title('Opening')
% Use different disk size
% Combina la erosion seguida de una dilatacion 
% desapareciendo elementos pequeños.
%% Closing

se = strel('disk',7);
BW2 = imclose(f,se);
imshow(BW2), title('Closing')
% Use different disk size
% Esta función combian el efecto de la dilatacion y la erosion 
%en ese orden especifico cerrando los espacios de la imagen 
%% Gradient
% Deteccion de orillas, entre más grane sea el disco más notorias estas
% serán
se = strel('disk',3);
BW1 = imdilate(f,se) - imerode(f,se);
imshow(BW1), title('Gradient')
% Use different disk size
%% Preprocess the Image The Rice Matlab Example
% Read an image into the workspace.
%Imagen aleatoria original, esta se muestra con el comando imshow,
%agregando un título.
I = imread('rice.png');
imshow(I)
title("Imagen original")
%% 
% The background illumination is brighter in the center of the image than at 
% the bottom. Preprocess the image to make the background illumination more uniform.
% 
% As a first step, remove all of the foreground (rice grains) using morphological 
% opening. The opening operation removes small objects that cannot completely 
% contain the structuring element. Define a disk-shaped structuring element with 
% a radius of 15, which fits entirely inside a single grain of rice.

se = strel('disk',15);
% Con esta línea de código, se crea el componente estructural con forma de
% disco, de tamaño de radio 15, la cual hace que todo arroz quepa dentro
% del disco.
%% 
% To perform the morphological opening, use |imopen| with the structuring element.

background = imopen(I,se);
imshow(background)
title('Fondo de la imagen')
% Lo que se está realizando en esta sección es modificar el fondo con la
% abertura morfológica, utilizando el elemento que se creó en la sección
% anterior. Lo que vamos a mostrar va a ser el fondo sin los componentes de
% arroz.
%% 
% Subtract the background approximation image, |background|, from the original 
% image, |I|, and view the resulting image. After subtracting the adjusted background 
% image from the original image, the resulting image has a uniform background 
% but is now a bit dark for analysis.
% Se ajuasta contraste 
I2 = I - background;
imshow(I2)
title('Imagen con fondo uniforme')

% En esta sección se elimina el fondo que es desigual, para resultar en una
% imagen que solo contenga arroz con un fondo negro uniforme.
%% 
% Use |imadjust| to increase the contrast of the processed image |I2| by saturating 
% 1% of the data at both low and high intensities and by stretching the intensity 
% values to fill the |uint8| dynamic range.

I3 = imadjust(I2);
imshow(I3)
title('Contraste ajustado')

% Para incrementar un poco el contraste de la imagen con fondo uniforme,
% deben de saturarse los valores de intensidad al 1% en las bajas y altas
% intensidades. Para lograr lo anterior, solo se tiene que introducir el
% como argumento la imagen en la función IMADJUST, ya que el valor del 1%
% es el predeterminado cuando no se especifica un rango.
%% 
% Note that the prior two steps could be replaced by a single step using |imtophat| 
% which first calculates the morphological opening and then subtracts it from 
% the original image.
% 
%I21 = imtophat(I,strel('disk',15));|
%% 
% Create a binary version of the processed image so you can use toolbox functions 
% for analysis. Use the |imbinarize| function to convert the grayscale image into 
% a binary image. Remove background noise from the image with the |bwareaopen| 
% function.


bw = imbinarize(I3);
bw = bwareaopen(bw,50);
imshow(bw)
title('Imagen binaria')

% En esta sección se está convirtiendo la imagen a un formato binario para
% poder utilizar funciones específicas de toolbox para análisis. Con la
% función BWAREAOPEN se eliminan objetos pequeños de imágenes binarias.

%% Skeletonize 2-D Grayscale Image
% Read a 2-D grayscale image into the workspace. Display the image. Objects 
% of interest are dark threads against a light background.

I = imread('threads.png');
imshow(I)
%% 
% Skeletonization requires a binary image in which foreground pixels are |1| 
% (white) and the background is |0| (black). To make the original image suitable 
% for skeletonization, take the complement of the image so that the objects are 
% light and the background is dark. Then, binarize the result.

Icomplement = imcomplement(I);
BW = imbinarize(Icomplement);
imshow(BW)
%% 
% Perform skeletonization of the binary image using |bwskel|.

out = bwskel(BW);
%% 
% Display the skeleton over the original image by using the |labeloverlay| function. 
% The skeleton appears as a 1-pixel wide blue line over the dark threads.

imshow(labeloverlay(I,out,'Transparency',0))
%% 
% Prune small spurs that appear on the skeleton and view the result. One short 
% branch is pruned from a thread near the center of the image.

out2 = bwskel(BW,'MinBranchLength',15);
imshow(labeloverlay(I,out2,'Transparency',0))
%Play with the size of Min Branch Lenght

%% The alternative method with bwmorph
% Get rid of the original image and replace it with the 1-pixel wide white line
% representing the small spurs in a black background 

BW3 = bwmorph(BW,'skel',Inf);
figure
imshow(BW3)
% encuentra las orillas 
%% Lets play with the x-ray

% Display the original image with a 1-pixel wide blue line over the bones 

se = strel('disk',7);
BW3 = f-imopen(f,se);
imshow(BW3,[])
bw = imbinarize(BW3);
imshow(bw,[])
bw = imopen(bw,strel('disk',1));
bw = imclose(bw,strel('disk',3));
imshow(bw,[])
bw = bwareaopen(bw,50);
imshow(bw,[])
BW3 = bwmorph(bw,'skel',Inf);
imshow(BW3)
imshow(labeloverlay(f,BW3,'Transparency',0))

% Do the same with your own image