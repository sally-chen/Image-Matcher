function [result_binary] = find_max(x, y, Image_matrix,window_size)
    if (y-window_size < 1 || y+window_size > size(Image_matrix,1) || x-window_size < 1 || x+window_size > size(Image_matrix,2))
        result_binary = 0;
    else
        window = zeros(window_size*2+1,window_size*2+1,size(Image_matrix,3));
        window(:,:,:)  = Image_matrix(y-window_size:y+window_size,x-window_size:x+window_size,:);
        maxx, i = max(window(:));
        if(Image_matrix(y,x,z)==(ind2sub(size(A),i))
            result_binary = 1;
        else
            result_binary = 0;
        end
    end