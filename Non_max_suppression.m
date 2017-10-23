Radius = 10;
domain = fspecial('disk', Radius);
cornered_points_suppressed = ordfilt2(cornered_points,nnz(domain),domain);

figure;
imshow(imread('building.jpg'));

for y = 1:size(input_image,1)
    for x = 1:size(input_image,2)
        if(cornered_points_suppressed(y,x) > 0 && cornered_points_suppressed(y,x) <= cornered_points(y,x))
               drawnow
               viscircles([x y],5,'color','b');
        end
    end
end

