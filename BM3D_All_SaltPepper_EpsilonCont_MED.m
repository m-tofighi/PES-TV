clear
close all
clc

sigmaT = 50;%[20, 30, 40, 50];%[30, 40, 50, 60, 70, 80];%
d = 0.02;
name = {'cameraman.bmp', 'note.png', 'house.jpg', 'flower.png', 'lena.jpg', 'jetplane.jpg', 'lake.jpg', 'peppers.jpg', 'livingroom.jpg', 'mandril.jpg', 'pirate.jpg'};
for j = 1:size(name, 2)
    for i = 1:size(sigmaT, 2)
        sigma = sigmaT(i);
        y = im2double(imread(name{j}));
        randn('seed', 0);
        %% Adding noise
        %% e-contaminated noise
        %         Noise = epsContNoise(0.9, 5, sigma, size(y,1), size(y,2))/255;
        %         zz = y + Noise;
        %% "salt & ppepper" + Gaussian noise
        zz = imnoise(y, 'salt & pepper', d);
        zz = zz + (sigma/255)*randn(size(y));
        
        %% Sigma estimation for Gaussian noise
        %                 N_est_S = mean(estimatenoise(zz));
        %                 sigmaEst = (N_est_S^0.5)*255;
        
        %% Sigma estimation for impulsive noise
        n = 3;
        m = 3;
        z = medfilt2(zz, [n m]);
        noiseMat= zz-z;
        noiseVar = mean(var(noiseMat));
        sigmaEst = (noiseVar^0.5)*255;
        
        %% Denoising
        [SNR(j, i), PSNR(j, i), Y_EST] = BM3D_R(y, zz, sigmaEst, 'np');
    end
end
SNR = SNR
PSNR = PSNR