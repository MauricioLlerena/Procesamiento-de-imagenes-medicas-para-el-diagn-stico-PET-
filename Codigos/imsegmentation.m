
%Equipo PET
%Francisco Valadez Rojas

%24/05/22
%Version 2.0

f=imread('CT-abdomenal.jpg');
f=double(f(:,:,1));
f=f/max(max(f));
f=imresize(f,0.15);
figure(1)
imshow(f,[]);

title('Original')
%% Thresholding

seg1 = f > 0.5;
imshow(seg1,[])
imshow(seg1.*f,[])
seg1 = f < 0.75;
imshow(seg1,[])
imshow(seg1.*f,[])
seg1 = f == 0.62;
imshow(seg1,[])
imshow(seg1.*f,[])
title ("Imagen original")
%% Thresholding

seg1 = f > 0.5; 
imshow(seg1,[])
imshow(seg1.*f,[]) %segmentacion por la imagen 
seg1 = f < 0.75;
imshow(seg1,[])
imshow(seg1.*f,[])
figure 
imhist(f)
% Use a third threshold based on the histogram
%% 
%% Otsu method
thr = graythresh(f)
seg1 = f > thr;
imshow(seg1,[])
dxp=[0,1;-1,0];
dyp=[1,0;0,-1];

%analisis del histograma
thr = graythresh(f)
seg1 = f > thr;
imshow(seg1,[])
%Calculo de las orillas con pendiente de Roberts 
dxp=[0,1;-1,0]; %gradientes 
dyp=[1,0;0,-1];
%Mapa de orillas 
edgemap = abs(conv2(seg1,dxp,'same'))+abs(conv2(seg1,dyp,'same'));
imshow(f+edgemap,[0,1]);

% Compare the otsu provided threshold vs the one you selected in the
% preview step.
% Do you trust the Otsu treshold?
% Select your own image and compute the otsu threshold
%% Kmeans segmentation

f=imread("CT-abdomenal.jpg");
f=double(f(:,:,1));
f=f/max(max(f));
imshow(f)
%Robets Operator
dxp=[0,1;-1,0];
dyp=[1,0;0,-1];
% Disk for clossing labels
diskse= strel('disk',5);
diskse11= strel('disk',11);


%% Kmeans

% 6 class
[L,Centers] = imsegkmeans(uint8(255*f),4);
B = labeloverlay(f,L);
imshow(L,[])
colormap('hot')
title("Labeled Image")
Centers
%% Clean with morphology each class

%First label
subplot(1,1,1)
label_one = L == 1;
imshow(label_one)
% remove false negatives wiht imclose
label_close_one = imclose(label_one,diskse);
imshow(label_close_one)

%second label
label_two = L == 2;
% remove false negatives wiht imclose
label_close_two = imclose(label_two,diskse);
imshow(label_close_two)

%Third label
label_three = L == 3;
% remove false negatives wiht imclose
label_close_three = imclose(label_three,diskse);
imshow(label_close_three)

%Fourth label
label_four = L == 4;
% remove false negatives wiht imclose
label_close_four = imclose(label_four,diskse);
imshow(label_close_four)


%% Connected components of Label 3

cc = bwconncomp(label_close_three,4);
labeled = labelmatrix(cc);
imshow(labeled,[])
colormap('cool')

% show left hip
%%
% Using the data tips we find out the label of the left lung
HipLabel = 51;
imshow(labeled==HipLabel,[])
B = labeloverlay(f,labeled==HipLabel);
imshow(B)
title("Left Hip overlay")
%%
seg1 = labeled==LungLabel;
edgemap = abs(conv2(seg1,dxp,'same'))+abs(conv2(seg1,dyp,'same'));
imshow(f+edgemap,[0,1]);
title("Left Hip Edges")
%%
label_hip = imclose(seg1,diskse11);
imshow(label_hip)


%% Watershed

edgeC = edge(f,'Canny',0.2,2);
imshow(edgeC,[])
D = bwdist(edgeC);
imshow(D,[])
title('Distance Transform of Binary Image')
%%
mesh(D)
L = watershed(D);
%%
edgemap = abs(conv2(L,dxp,'same'))+abs(conv2(L,dyp,'same'));
imshow(f+edgemap,[0,1]);
%%
imshow(L,[])
colormap('cool')
%%
%The lung is made of several components. We must merge the labels
Leftlung = L==202 | L==197 | L==184 | L==178 | L==209;

imshow(Leftlung,[])
%%
Lefthip_close = imclose(Leftlung,diskse);
imshow(Lefthip_close)
%%
B = labeloverlay(f,Lefthip_close);
imshow(B)
title("Left Lung overlay")

% remove false positives wiht imopen
label_hip = imopen(Lefthip_close,diskse11);
imshow(label_hip)

B = labeloverlay(f,label_hip);
imshow(B)
title("Final Left Lung overlay")