% 2b


%%%%%%%%%1. install sift
% download and compile: http://vision.ucla.edu/~vedaldi/assets/sift/binaries/
% many other implementations available

%%%%%%%%%2. read images
img1=double(rgb2gray(imread('./book.jpg')))/255;
img2=double(rgb2gray(imread('./findBook.jpg')))/255;

%%%%%%%%%3. compute sift
addpath(genpath('./sift'));
[f1,d1]=sift(img1);
[f2,d2]=sift(img2);

%%%%%%%%%4. plot sift
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

% for each key point in A - 1150, 
%    for each key point in B - 3927, 
%       compute pd(A,B), store in matirx 1150 * 3927   - each row is dis for each point in A
%       find max and sec max in each row, compute ratio, if bigger than
%       threshold, then match


% d2, img2,f2 -- findBook.jpg ; d1, img1,f1 -- book.jpg
match_matrix = zeros(size(d1,2),size(d2,2));
match_matrix(:,:) = pdist2(d1',d2');
max_two = zeros(size(match_matrix,1),2);
indeces_first_max = zeros(size(match_matrix,1),1); 

[max_two(:,1),indeces_first_max(:)] = min(match_matrix,[],2);
for i = 1:length(indeces_first_max)
    match_matrix(i,indeces_first_max(i)) = 1000;
end
max_two(:,2) = min(match_matrix,[],2);
ratio = max_two(:,1)./max_two(:,2);

threshold = 0.7;
indeces_matched = (ratio < threshold) & indeces_first_max;

img_to_show = zeros(size(img2,1),size(img2,2)+size(img1,2)+5);
img_to_show(1:size(img2,1),1:size(img2,2)) = img2(:,:);
img_to_show(1:size(img1,1),size(img2,2)+6:size(img2,2)+5+size(img1,2)) = img1(:,:);

imshow(img_to_show);
for i = 1:length(indeces_matched)
    if(indeces_matched(i)~=0)
        lineX = [ f2(1,indeces_first_max(i)),f1(1,i)+816+5 ] ;    
        lineY = [  f2(2,indeces_first_max(i)), f1(2,i)] ;
        drawnow
        line( lineX , lineY, 'Color', [0 0 1], 'LineWidth', 1 ) ;
        viscircles([lineX(1),lineY(1)],3, 'color','b','LineWidth', 1);
        viscircles([lineX(2),lineY(2)],3, 'color','r','LineWidth', 1);
    end
end
