function [ tv, df ] = tv( im,rs )

%% Total variation
im = reshape(im, rs);

zVec1 = zeros(size(im,1),1);
im1 = [zVec1  im  zVec1];

zVec2 = zeros(1,size(im1,2));
im = [zVec2;  im1;  zVec2];

df1 = conv2(im,[1 -1],'valid');
df2 = conv2(im,[1; -1],'valid');
tv = sum(abs(df1(:))) + sum(abs(df2(:)));

end