function [C, U, d, objhistory] = SquaredC(X, param, filestr)

SampleNum = size(X,2);

% Initializing X
xv = mean(X,2);
X = X - repmat(xv,1,SampleNum);
[U, D] = svd(X);%
d = diag(D)/sqrt(SampleNum-1);

if param.isrsvd %
    
    d2 = d.*d;
    dc = sqrt(cumsum(d2)./sum(d2));
    ind = find(dc<=param.rsvd);
    KX = length(ind);
    
    param.KA = KX;%
    
    X = diag(1./d(1:KX))*U(:,1:KX)'*X;%
else
    V = diag(1./d)*U';%
    X = V*X;%
end

KX = size(X,1);
param.KA = KX;

%% Main Loop

fprintf('Start update ...\n');

rng(param.seed,'twister');

C = randn(KX);%eye(KX);%
C = C./(ones(KX,1)*sqrt(sum(C.*C)));

t_start = clock;
[C, objhistory] = feval(str2func(param.Algorithm), C, X, param);%
Time = etime(clock, t_start)/60;

fprintf(['Elapsed time is %.3f minutes ...\n'],Time);
%% =======================================================================

fname = ['../results/', filestr,'.mat'];
fprintf(['Saving file: ' fname,'\n']);

save(fname,'param', 'C', 'U', 'd', 'objhistory', 'filestr', 'Time');

end


