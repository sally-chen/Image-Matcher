%%%%%%%%%1. install sift
% download and compile: http://vision.ucla.edu/~vedaldi/assets/sift/binaries/
% many other implementations available

%%%%%%%%%2. read images


img1=double(imread('colourTemplate.png'))/255;
img2=double(imread('colourSearch.png'))/255;

addpath(genpath('./sift'));
[f1_r,d1_r]=sift(img1(:,:,1));
[f1_g,d1_g]=sift(img1(:,:,2));
[f1_b,d1_b]=sift(img1(:,:,3));

[f2_r,d2_r]=sift(img2(:,:,1));
[f2_g,d2_g]=sift(img2(:,:,2));
[f2_b,d2_b]=sift(img2(:,:,3));

f1 = [f1_r f1_g f1_b];
f2 = [f2_r f2_g f2_b];

d1 = [d1_r d1_g d1_b];
d2 = [d2_r d2_g d2_b];

% f1 = [ 0;0];
% d1 = zeros(128*3,1);
% 
% f2 = [0;0];
% d2 = zeros(128*3,1);
% 
% for x = 1:size(f1_r,2)
%     if(nnz(ismember(f1_g(1:2,:)',f1_r(1:2,x)','rows')) && nnz(ismember(f1_b(1:2,:)',f1_r(1:2,x)','rows')))
%         f1 = [f1 f1_r(1:2,x)];
%         d = [d1_r(:,x);d1_g(:,x);d1_b(:,x)];
%         d1 = [d1 d];
%     end
%     
% end
% 
% for x = 1:size(f2_r,2)
%     if(nnz(ismember(f2_g(1:2,:)',f2_r(1:2,x)','rows')) && nnz(ismember(f2_b(1:2,:)',f2_r(1:2,x)','rows')))
%         f2 = [f2 f2_r(1:2,x)];
%         d = [d2_r(:,x);d2_g(:,x);d2_b(:,x)];
%         d2 = [d2 d];
%     end
% end
% 
% f1 = f1(:,2:size(f1,2));
% f2 = f2(:,2:size(f2,2));
% d1 = d1(:,2:size(d1,2));
% d2 = d2(:,2:size(d2,2));
%         

match_matrix = zeros(size(d1,2),size(d2,2));% 3927 *1150 

% for i =  1:size(d1,2)
%     for j = 1:size(d2,2)
%         match_matrix(j,i) = pdist2(d1(:,i)',d2(:,j)');
%     end
% end
match_matrix(:,:) = pdist2(d1',d2');
max_two = zeros(size(match_matrix,1),2); %3927 * 2
indeces_first_max = zeros(size(match_matrix,1),1); %1150 * 2

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


img_to_show = zeros(size(img2,1),size(img2,2)+size(img1,2)+5,3);

img_to_show(1:size(img2,1),1:size(img2,2),:) = img2(:,:,:);
img_to_show(1:size(img1,1),size(img2,2)+6:size(img2,2)+5+size(img1,2),:) = img1(:,:,:);



mathced_points = zeros(nnz(indeces_matched),4); % x,y,x',y'

figure;
imshow(img_to_show);
counter = 1;

K=10;

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



test_points_img1 = [1 1; 1 256;256 256;256 1]; % y x
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


clc