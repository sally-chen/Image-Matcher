%%%%%%%%%%1. install sift
%download and compile: http://vision.ucla.edu/~vedaldi/assets/sift/binaries/
%many other implementations available

%%%%%%%%%%2. read images
img1=double(rgb2gray(imread('./sift/data/img3.jpg')))/255;
img2=double(rgb2gray(imread('./sift/data/img5.jpg')))/255;

%%%%%%%%%%3. compute sift
addpath(genpath('./sift'));
[f1,d1]=sift(img1);
[f2,d2]=sift(img2);

%%%%%%%%%%4. plot sift
figure;
imshow(img1);
hold on;
%only plot 1000 for better visualization
plotsiftframe(f1(:,1:1000));
hold off;
figure;
imshow(img2);
hold on;
%only plot 1000 for better visualization
plotsiftframe(f2(:,1:1000));
hold off;

%%%%%%%%%%5. match features
matches=siftmatch(d1,d2);

%%%%%%%%%%6. plot matches
figure;
%only plot 1 for better visualization
plotmatches(img1,img2,f1(1:2,:),f2(1:2,:),matches(:,500));