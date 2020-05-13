s = [1 4 7 10; 2 5 8 11; 3 6 9 12];
D = 3;
N = 3;
Nu = 3;
lambda = 1;
Umin = [0;0];
Umax = [100; 100];
% 
dmc = DMCRegMIMO(s, D, N, Nu, lambda, Umin, Umax);
s1 = [1,2,3];
s2 = [4,5,6];
s3 = [7,8,9];
s4 = [10,11,12];
S = zeros(ny,nu,D);
for i = 1:D
    
    S(1:ny,1:nu,i) = [ s1(i) s2(i);
        s3(i) s4(i)];
end

M=zeros(N*ny,Nu*nu);
j = 0;
for i=1:nu:Nu*nu
    j = j+1;
    M(i:N*ny,i:i+nu-1)=reshape(S(:,:,1:N-j+1),2,(N-j+1)*ny)';
end

% macierz Mp
Mp=zeros(N*ny,(D-1)*nu);
ii = 0;

for i=1:ny:N*ny
    ii = ii+1;
    jj = 0;
    for j=1:nu:(D-1)*nu
        jj = jj+1;
        if ii+jj<=D
            Mp(i:i+ny-1,j:j+nu-1)= squeeze(S(:,:,ii+jj)-S(:,:,jj));
            
        else
            Mp(i:i+ny-1,j:j+nu-1)= squeeze(S(:,:,D)-S(:,:,jj));
        end
    end
end


            yk=ones(N * 2,1);
            for i = 1:2: N *2
                yk(i) = yk(i) * y(1);
                yk(i+1) = yk(i+1) *y(2);
            end
            
            Yzad = ones(N * 2, 1);
            for i = 1:2: N *2
                Yzad(i) = yzad(1);
                Yzad(i+1) = yzad(2);
            end
            
    measurements = readMeasurements([1,3]);
    y(i, :) = measurements;
    m = dmc.countValue(y(i, :))
    u(i, :) = m;
    
deltaup=[deltauk(1:2); deltaup(1:end-2)]
