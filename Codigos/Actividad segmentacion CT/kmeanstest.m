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
% show left lung

% Using the data tips we find out the label of the left lung
LungLabel = 4;
imshow(labeled==LungLabel,[])
B = labeloverlay(f,labeled==LungLabel);
imshow(B)
title("Left Lung overlay")

seg1 = labeled==LungLabel;
edgemap = abs(conv2(seg1,dxp,'same'))+abs(conv2(seg1,dyp,'same'));
imshow(f+edgemap,[0,1]);
title("Left Lung Edges")

label_lung = imclose(seg1,diskse11);
imshow(label_lung)


%% Watershed

edgeC = edge(f,'Canny');
imshow(edgeC,[])
D = bwdist(edgeC);
imshow(D,[])
title('Distance Transform of Binary Image')
mesh(D)
L = watershed(D);

edgemap = abs(conv2(L,dxp,'same'))+abs(conv2(L,dyp,'same'));
imshow(f+edgemap,[0,1]);

imshow(L,[])
colormap('cool')

%The lung is made of several components. We must merge the labels
Leftlung = L==479 | L==459 | L==433 | L==578 | L == 719 | L==694 | L==710;

imshow(Leftlung,[])

Leftlung_close = imclose(Leftlung,diskse);
imshow(Leftlung_close)

B = labeloverlay(f,Leftlung_close);
imshow(B)
title("Left Lung overlay")

% remove false positives wiht imopen
label_lung = imopen(Leftlung_close,diskse11);
imshow(label_lung)

B = labeloverlay(f,label_lung);
imshow(B)
title("Final Left Lung overlay")