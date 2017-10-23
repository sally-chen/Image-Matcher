function [result_binary] = isLocalMaximum(x, y, thisCorr)
    if (x==1 || y ==1 || x==size(thisCorr,2) || y == size(thisCorr,1))
        result_binary = 0;
    else
        window = zeros(3,3);
        window(:,:)  = thisCorr(y-1:y+1,x-1:x+1);
        if(thisCorr(y,x)==max(window(:)))
            result_binary = 1;
        else
            result_binary = 0;
        end
    end