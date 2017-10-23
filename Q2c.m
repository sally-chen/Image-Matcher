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

%%%%%%%%%%4. plot sift
figure;
imshow(img1);
hold on;
%only plot 1000 for better visualization
plotsiftframe(f1(:,1:500));
hold off;
figure;
imshow(img2);
hold on;
%only plot 1000 for better visualization
plotsiftframe(f2(:,1000:2000));
hold off;


% 2 c, finding affine transform
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

indices_picone = linspace(1,length(indeces_first_max),length(indeces_first_max))';
A = sortrows([ratio indeces_first_max indices_picone]);
ratio = A(:,1);
indeces_first_max = A(:,2);
indices_picone = A(:,3);

threshold = 0.8;
indeces_matched = (ratio < threshold) & indeces_first_max;

img_to_show = zeros(size(img2,1),size(img2,2)+size(img1,2)+5);
img_to_show(1:size(img2,1),1:size(img2,2)) = img2(:,:);
img_to_show(1:size(img1,1),size(img2,2)+6:size(img2,2)+5+size(img1,2)) = img1(:,:);
figure;
imshow(img_to_show);

K=30;

P_prime = zeros(2*K,1);
P = zeros(2*K,6);

for i = 1:K
    if(indeces_matched(i)~=0)        
        P_prime(i*2-1) = f2(1,indeces_first_max(i));  % x'       
        P_prime(i*2) = f2(2,indeces_first_max(i)); % y'
        
        P(i*2-1:i*2,:) = [f1(1,indices_picone(i)) f1(2,indices_picone(i)) 0 0 1 0;
                            0 0 f1(1,indices_picone(i)) f1(2,indices_picone(i)) 0 1];        
    end
end

a = pinv(P'*P)*P'*P_prime;

% 2 d, testing transform
test_points_img1 = [1 1; 1 320;499 320;499 1]; % y x
new_P = zeros(size(test_points_img1,1),6);
for i = 1:size(test_points_img1)
    new_P(i*2-1:i*2,:) = [test_points_img1(i,2) test_points_img1(i,1) 0 0 1 0;
                            0 0 test_points_img1(i,2) test_points_img1(i,1) 0 1];    
end

matched_P = new_P*a;
for i=1:4
    viscircles([matched_P(2*i-1) matched_P(2*i)],5, 'color','b');    
    if(i<4)
        lineX = [ matched_P(2*i-1),matched_P(2*(i+1)-1)];
        lineY = [  matched_P(2*i), matched_P(2*(i+1))] ;        
    else
        lineX = [ matched_P(2*i-1),matched_P(1)];
        lineY = [  matched_P(2*i), matched_P(2)] ;
    end
    
    drawnow
        line( lineX , lineY, 'Color', [0 0 1], 'LineWidth', 1 ) ;        
end




