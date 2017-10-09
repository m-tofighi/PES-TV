function [FH,FL] = DiffFilters(Rad)

FH = zeros([(2*Rad)+1,(2*Rad)+1,8*Rad]);

FH(Rad+1,Rad+1,:) = 1;
FH(1,1,1) = -1;
FH((2*Rad)+1,(2*Rad)+1,2) = -1;
k=3;
for i=2:(2*Rad)+1
    FH(i,1,k) = -1;
    k = k+1;
    FH(1,i,k) = -1;
    k=k+1;
end

for i = 2:(2*Rad)
    FH((2*Rad)+1,i,k) = -1;
    k=k+1;
    FH(i,(2*Rad)+1,k) = -1;
    k=k+1;
end

FL = abs(FH)/2;
