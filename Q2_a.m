img1=double(rgb2gray(imread('./book.jpg')))/255;
img2=double(rgb2gray(imread('./findBook.jpg')))/255;

addpath(genpath('./sift'));
[f1,d1]=sift(img1);
[f2,d2]=sift(img2,'Threshold',0.02);

figure;
imshow(img1);
hold on;
plotsiftframe(f1(:,1:500));
hold off;
figure;
imshow(img2);
hold on;

plotsiftframe(f2(:,1:500));
hold off;