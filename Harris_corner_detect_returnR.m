function [R] = Harris_corner_detect_returnR(I) 
    % pass in an image patch
    [Ix,Iy] = gradient(I);
    M = zeros(2,2);    
    sigma= 15;
    alpha = 0.249;
    
    for x = 1:size(I,2)
        for y = 1:size(I,1)
            ix = Ix(y,x);
            iy = Iy(y,x);
            M = M + Gaussian2d(x,y,sigma).*[ix.^2 ix*iy;ix*iy iy.^2];
        end
    end
    
    R = det(M)-alpha*trace(M).^2;
  
        