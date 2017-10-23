function [z] = find_max(x, y, Image_matrix,window_size)
    if (y-window_size < 1 || y+window_size > size(Image_matrix,1) || x-window_size < 1 || x+window_size > size(Image_matrix,2))
        z = 0;
    else
        window = zeros(window_size*2+1,window_size*2+1,size(Image_matrix,3));
        window(:,:,:)  = Image_matrix(y-window_size:y+window_size,x-window_size:x+window_size,:);
        
        [maxx, i] = max(window(:));        
        [minn, i_min] = min(window(:));
        [x_max,y_max,z_max] = ind2sub(size(window),i);        
        [x_min,y_min,z_min] = ind2sub(size(window),i_min);
        if(x_max == window_size+1 && y_max == window_size+1 && Image_matrix(y,x,z_max)>70)
            z = z_max;
        elseif(x_min == window_size+1 && y_min == window_size+1 && Image_matrix(y,x,z_min)< -50)
            z = z_min;
        else
            z = 0 ;
         %   result_binary = 0;
        end
    end