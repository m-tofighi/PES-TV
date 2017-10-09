clear
close all
clc

% tic
sigmaT = 20;%[20, 30, 40, 50];%[0, 5, 10, 15];%[5, 10, 15, 20];%[30, 40, 50, 60, 70, 80];%[5, 10, 15, 20, 25, 30, 35, 40, 45, 50];
d = 0.05;%[0.3, 0.5, 0.7];
name = {'cameraman.bmp'};% {'cameraman.bmp', 'note.png', 'house.jpg', 'flower.png', 'lena.jpg', 'jetplane.jpg', 'lake.jpg', 'peppers.jpg', 'livingroom.jpg', 'mandril.jpg', 'pirate.jpg'};
b = 3;
s = (b-1)/2;
for j = 1:size(name, 2)
    for i = 1:size(sigmaT, 2)
        for dv = 1:size(d, 2)
            sigma = sigmaT(i);
            y = im2double(imread(name{j}));
            if strcmp(name{j}, 'note2.png')
                y(y==0) = y(y==0)+0.00001;
            end
            
            %% Adding noise
            %% e-contaminated noise
            % Noise = laplace_noise(size(y,1), size(y,2), 0.2);%epsContNoise(0.9, 5, sigma, size(y,1), size(y,2))/255;%(sigma/255)*randn(size(y));%
            % z = y + Noise;
            
            %% "salt & ppepper" + Gaussian noise
            zz1 = imnoise(y, 'salt & pepper', d(dv));
            zzInd = find((zz1~=0 & zz1~=1));
            zzGuas = zz1(zzInd)+ (sigma/255)*randn(size(zz1(zzInd)));
            zz1(zzInd) = zzGuas;
            zz = zz1;
            
            %% alpha-trimmed mean filtering
            zz = padarray(zz1,[s s], 'symmetric');
            zz(2, 2) = y(1, 1);
            for k = 1+s:size(zz, 1)-s
                for q = 1+s:size(zz, 2)-s
                    aa = zz(k-1:k+1, q-1:q+1);
                    if (zz(k, q)~=0 && zz(k, q)~=1)
                        zz(k, q) = zz(k, q);
                    elseif (zz(k, q)==0 || zz(k, q)==1)
                        zz(k, q) = mean(aa(aa~=0 & aa~=1));
                    end
                end
            end
            zz = zz(1+s:size(zz, 1)-s, 1+s:size(zz, 2)-s);
            
            %% Sigma estimation for impulsive noise
            n = 3;
            m = 3;
            z = medfilt2(zz, [n m]);
            noiseMat= zz-z;
            noiseVar = mean(var(noiseMat));
            sigmaEst = (noiseVar^0.5)*255;
            
            %% Denoising
            [SNR(j, i, dv), PSNR(j, i, dv), Y_EST] = BM3D_TV_R(y, zz, sigmaEst);
        end
    end
end
SNR = SNR
PSNR = PSNR
