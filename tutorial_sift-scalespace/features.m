%% Tutorial for scale-space feature selection written by Chris McIntosh (chris.mcintosh@rmp.uhn.on.ca)

%% Build a synethic image
close all;
imSize = 256;
img = zeros(imSize,imSize);
[x,y] = meshgrid(1:imSize,1:imSize);
c = [mean(x(:)) mean(y(:))];
dst = sqrt(((x-c(1)).^2+(y-c(2)).^2));
img = double(dst<25);
img(img<0)=0;
img = img+0.25*sin(0.5+15*pi*dst/max(dst(:)));
figure;imagesc(img);


%or load a real image
% img = imread('peppers.png');
% img = double(img);
% img = mean(img,3);

%perform base-level smoothing to supress noise
imgS = img;
cnt = 1;
clear responseDoG responseLoG
k = 1.1;
sigma = 2.0;
s = k.^(2:2:60)*sigma;
responseDoG = zeros(size(img,1),size(img,2),length(s));
responseLoG = zeros(size(img,1),size(img,2),length(s));
imG = zeros(size(img,1),size(img,2),length(s));

%% Filter over a set of scales
for si = 1:length(s)
    sL = s(si);
    hs= max(25,min(floor(sL*3),128));
    HL = fspecial('log',[hs hs],sL);
    H = fspecial('Gaussian',[hs hs],sL);
    if(si<length(s))
        Hs = fspecial('Gaussian',[hs hs],s(si+1));
    else
        Hs = fspecial('Gaussian',[hs hs],sigma*k^(si+1));
    end
    imgFiltL = conv2(imgS,HL,'same');
    imgFilt = conv2(imgS,H,'same');
    imG(:,:,si) = imgFilt;
    imgFilt2 = conv2(imgS,Hs,'same');
    %Compute the DoG
    responseDoG(:,:,si)  = (imgFilt2-imgFilt);
    %Compute the LoG
    responseLoG(:,:,si)  = (sL^2)*imgFiltL;
end
%Why do responseDoG and responseLoG look different for larger k?

%% Explore the scale space
t = 1;
DESC = 1;
while(t)
    fg = figure;imagesc(img);axis image;hold on;colormap gray;
    drawnow;
    [x,y] = ginput(1);
    x= round(x);
    y = round(y);    
    
    if(isempty(x))
        t = 0;
    else
        plot(x,y,'r.');
        figure;plot(s,squeeze(responseDoG(y,x,:)));
        title('DoG');grid on;
        LoG = figure;plot(s,squeeze(responseLoG(y,x,:)));
        title('LoG');grid on;hold on;
        
        %Get the maxima/minima over scale
        f = squeeze(responseLoG(y,x,:));
        [fMax,fmaxLocs] = findpeaks(f);%maxima
        [fMin,fminLocs] = findpeaks(-f);%minima
        for i = 1:numel(fmaxLocs)
            sc = s(fmaxLocs(i));
            figure(LoG);
            line([sc sc],[min(f) max(f)],'color',[1 0 0]);
            %Draw a circle
            figure(fg);
            xc = sc*sin(0:0.1:2*pi)+x;
            yc = sc*cos(0:0.1:2*pi)+y;
            plot(xc,yc,'r');
            
            %% Is it also a spatial maxima/minima?
            [nx,ny,nz] = meshgrid(x-1:x+1,y-1:y+1,fmaxLocs(i));
            inds = sub2ind(size(responseLoG),ny,nx,nz);
            df = responseLoG(inds(5))-responseLoG(inds);
            df(5)=[];%don't compare to itself
            if(min(df)>=0)
                plot(xc,yc,'r-o');
            end
            
        end
        for i = 1:numel(fminLocs)
            
            sc = s(fminLocs(i));
            figure(LoG);
            line([sc sc],[min(f) max(f)],'color',[0 1 0]);
            %Draw a circle
            figure(fg);
            xc = sc*sin(0:0.1:2*pi)+x;
            yc = sc*cos(0:0.1:2*pi)+y;
            plot(xc,yc,'g');
            
            %% Is it also a spatial maxima/minima?
            [nx,ny,nz] = meshgrid(x-1:x+1,y-1:y+1,fminLocs(i));
            inds = sub2ind(size(responseLoG),ny,nx,nz);
            df = responseLoG(inds(5))-responseLoG(inds);
            df(5)=[];%don't compare to itself
            if(max(df)<=0)
                plot(xc,yc,'g-o');
            end
        end
        if(DESC)
            
            %%Pick one and a calculate a feature box
            %I just picked the largest magnitude, SIFT uses many
            [fMax,fmaxLocs] = findpeaks(f);
            [fMin,fminLocs] = findpeaks(-f);
            locs = [fmaxLocs' fminLocs'];
            extrema = [fMax' fMin'];
            [~,idx] = max(abs(extrema));
            sc = s(locs(idx));
            
            %Build a search grid
            [xG,yG] = meshgrid([-1.5*sc:1.5*sc]+x,[-1.5*sc:1.5*sc]+y);
            
            %Compute the orientation - simplfied version doesn't use Gaussian weighting
            %scheme
            [gx,gy] = gradient(imG(:,:,locs(idx)));
            theta = rad2deg(atan2(gy,gx));
            theta(theta<0) = 180+abs(theta(theta<0));%Map orientation to 0,360
            binDegs = 0:10:360;
            ht = histc(interp2(theta,xG(:),yG(:)),binDegs);
            figure;bar(binDegs,ht);
            
            [~,orientationIdx] = max(ht);
            orientation = binDegs(orientationIdx);
            
            %%Rotate the patch (We'll cover this concept later)
            R = [cos(orientation) -sin(orientation) 0; sin(orientation) cos(orientation) 0; 0 0 1];
            T = [1 0 -x; 0 1 -y; 0 0 1];
            M = inv(T)*R*T;
            gR = M*[xG(:) yG(:) ones(numel(xG(:)),1)]';
            
            %%Display the patch;
            figure;imagesc(img);hold on;grid on;axis image;
            plot(gR(1,:),gR(2,:),'.');
            title('Patch overlay');
            
            figure;imagesc(reshape(interp2(img,gR(1,:),gR(2,:)),size(xG)));
            title('Patch image');
            
            %%calculate the patch histogram in the rotated space (simplfied
            %%version doesn't use sub-binning)
            thetaR = theta-orientation;
            thetaR(thetaR<0) = 180+abs(thetaR(thetaR<0));
            pht = histc(interp2(thetaR,gR(1,:),gR(2,:)),binDegs);
            figure;bar(binDegs,pht);
        end
    end
    pause;
    close all;
    drawnow;
end

