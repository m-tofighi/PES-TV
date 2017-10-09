function [out] = NoLambda_natural(imgName, org)

if ischar(imgName)
    imOrj = imread(imgName);
else
    imOrj = imgName;
end
if size(imOrj,3)>1
    imOrj = rgb2gray(imOrj);
end
im = im2double(imOrj);

% [FH,FL] = DiffFilters(1);
% sz = size(im);
% HImg = zeros([sz,size(FH,3)]);
% LImg = HImg;
% for h = 1:size(FH,3)
%     HImg(:,:,h) = imfilter((im),FH(:,:,h),'replicate');
%     LImg(:,:,h) = imfilter((im),FL(:,:,h),'replicate');
% end
h = fspecial('gaussian',20,2);
edgeMap = edge(im,'canny',0.5,2);%imdilate(edge(im,'canny',0.1,3),strel('disk',2));%edge(im,'canny');
edgeMap = 1 - double(edgeMap);
% edgeMap = rescale(imfilter(double(edgeMap),h));
% edgeMap = min(max(0.8-edgeMap,0)+0.2,1);
% edgeMap = ones(size(edgeMap));

% im = mean(HImg,3);
% edgeMap = double(sum(abs(HImg)>0.05,3)>3);
% edgeMap = min(~edgeMap+0.8,1);
im = double(im);
[ny nx] = size(im);

iter = 3000;
y0 = im(:);

x = [im(:); 0 ];
costt(1) = costNorm(y0, x(1:end-1), ny);
j =10;
yy0 = [y0; 0];
% snr_oi(1) = -inf;
for i = 2:iter
    
    cost0 = costNorm(y0, x(1:end-1), ny);
    
    x1 = [x(1:end-1); 0];
    x2 = [x(1:end-1); tv_adap(x(1:end-1), ny,edgeMap)];
    x3 = proj_adap(y0, x1, x2, ny,edgeMap);%proj(y0, x1, x2, ny);
    
    cost1 = costNorm(y0, x3(1:end-1), ny);
    
    if (cost1 > cost0)
        xLeft = [x3(1:end-1); tv_adap(x3(1:end-1), ny,edgeMap)];
        xRight = x2;
        x3 = (xLeft + (1*i)*xRight)/(1*i+1);
        x3(end) = 0;
    else
        xLeft = [x3(1:end-1); tv_adap(x3(1:end-1), ny,edgeMap)];%cost(y0, x3(1:end-1), ny)]; %cost=tv
        xRight = x2;
        x3 = ((1*i)*xLeft + xRight)/(1*i+1);
        x3(end) = 0;
    end
    
    x = x3;
    
    snr_oi(i) = snr(org(:),x(1:end-1));
    if (abs(snr_oi(i)-snr_oi(i-1))<0.0001)%(snr_oi(i)<snr_oi(i-1))
        break
    end
end

xx = x(1:end-1);
xx = reshape(xx,ny,nx);

xx1 = xx;

[nx, ny] = size(xx);
% im1 = padarray(xx, [1 1], 'symmetric');

for k = 1:1
    im1 = padarray(xx1, [1 1], 'symmetric');
    k;
    for i = 1:size(im1, 1)
        for j = 2:size(im1, 2)
            im = padarray(im1(i, j-1:j), [0 1]);
            
            h = [-1 1 -1];
            
            dif = conv2(im, h, 'same');
            dif = dif(2:end-1);
            if dif(2)<30 && dif(1)<30 && dif(2)>5
                hyp = [sign(dif) -1];
                
                %% Project im onto hyp
                xxp = [im(2:end-1) 0];
                x_in = 5 - (xxp*hyp')/numel(xxp);
                x_p = xxp + x_in.*hyp;
                %             im_den(i:i+1, j) = x_p(1:2, 1);
                im_den(i, j) = x_p(1, 2);
                %             elseif dif(2)>=30 && dif(1)>=30
            else
                im_den(i, j) = im1(i, j);
            end
        end
    end
    xx1 = im_den(2:end-1, 2:end-1);
end

out = xx1;