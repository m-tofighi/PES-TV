function u = laplace_noise(n,m,sigma)
x=rand(n,m);
j=find(x<1/2);
k=find(x>=1/2);
u(j)=(sigma/sqrt(2)).*log(2.*x(j));
u(k)=-(sigma/sqrt(2)).*log(2.*(1-x(k)));
u=reshape(u,n,m);