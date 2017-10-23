

input_image = double(rgb2gray(imread( fullfile( './' , 'building.jpg' ))));
patch_size=11;
extend_range = (patch_size-1)/2;
imshow(imread( fullfile( './' , 'building.jpg' )));
for y = 1:size(input_image,1)
    for x = 1:size(input_image,2)
        if(y-extend_range >= 1 && y+extend_range <= size(input_image,1) && x-extend_range >= 1 && x+extend_range <= size(input_image,2))
            if(Harris_corner_detect(input_image(y-extend_range:y+extend_range,x-extend_range:x+extend_range)))
                drawnow
                viscircles([x y],5, 'color','b','linewidth',1)
            end
        end
    end
end
   

