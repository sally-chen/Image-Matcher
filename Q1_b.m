;

input_image = double(rgb2gray(imread('building.jpg')));

patch_size=11;
extend_range = (patch_size-1)/2;
cornered_points = zeros(size(input_image));
for y = 1:size(input_image,1)
    for x = 1:size(input_image,2)
        if(y-extend_range >= 1 && y+extend_range <= size(input_image,1) && x-extend_range >= 1 && x+extend_range <= size(input_image,2))
            cornered_points(y,x) = Harris_corner_detect_returnR(input_image(y-extend_range:y+extend_range,x-extend_range:x+extend_range));
        end
    end
end



% function out = nonMaximalSuppression(im, radius)
%     domain=fspecial('disk',radius);
%     out = ordfilt2(im, round(numel(find(domain))), domain);
%     [M, N] = size(im);
%     for i=1:M
%         for j=1:N
%             if out(i,j) > im(i,j)
%                 out(i,j) = 0;
%             end
%         end
%     end     
% end
        