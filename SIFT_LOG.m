% from feature.m in tutorial 3
%or load a real image
img = double(imread('building.jpg'));
img = mean(img,3);
%perform base-level smoothing to supress noise
imgS = img;
cnt = 1;
k = 1.1;
sigma = 2.0;
%s = k.^(8:3:96)*sigma; % 30 diff scales
s = k.^(1:2:80)*sigma; % 30 diff scales
responseLoG = zeros(size(img,1),size(img,2),length(s));
%% Filter over a set of scales
for si = 1:length(s)
    sL = s(si); % sL is sigma for each scale
    hs= max(25,min(floor(sL*3),128));
    HL = fspecial('log',[hs hs],sL); 
    imgFiltL = conv2(imgS,HL,'same');
    %Compute the LoG
    responseLoG(:,:,si)  = (sL^2)*imgFiltL;
end
% code from feature.m finishes here

imshow('building.jpg');
for x = 1:size(responseLoG,2)
    for y = 1:size(responseLoG,1)
        z_m = find_max(x,y,responseLoG,1);
        if( z_m ~= 0)
                drawnow
                viscircles([x y],s(z_m), 'color','b','linewidth',1);
                key_point = vertcat(key_point,[x, y, z_m]);
        end
    end
end


