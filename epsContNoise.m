function [ epsContNoise ] = epsContNoise( ep, sig1, sig2, nx, ny )

a = rand(nx,ny);
a = a(:);

for i = 1:size(a(:))
    if (a(i)<ep)
        epsContN = sig1*randn(1);
    elseif (a(i)>ep)
        epsContN = sig2*randn(1);
    end
    epsContNoise(i) = epsContN;
end

epsContNoise = reshape(epsContNoise,nx,ny);

end

