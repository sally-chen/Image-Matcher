function [y] = Gaussian2d(x,y,sigma)
    y=1/(2*pi*sigma.^2)*exp(-(x.^2+y.^2)/sigma.^2);